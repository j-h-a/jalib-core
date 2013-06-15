//
//  JAAnimation.m
//  JALib
//
//  Created by Jay on 2012-12-08.
//  Copyright (c) 2012 Jay Abbott. All rights reserved.
//

#import "JAAnimation.h"
#import "JAWeakProxy.h"



#pragma mark -
#pragma mark Private interface

@interface JAAnimation ()

@property (strong, nonatomic)	NSMutableArray*			toAdd;
@property (strong, nonatomic)	NSMutableArray*			toRemove;
@property (strong, nonatomic)	NSMutableArray*			animatables;
@property (strong, nonatomic)	NSMutableDictionary*	blockAnimationItems;
@property (strong, nonatomic)	CADisplayLink*			displayLink;

- (void)displayLinkUpdate:(CADisplayLink*)dl;
- (void)updateBlockAnimationItems:(CGFloat)timeDelta;

@end



#pragma mark -
#pragma mark Private classes

@interface JAAnimation_animationItem : NSObject
{
@public
	CGFloat		_time;
	CGFloat		_endTime;
}

@property (copy, nonatomic)	JAAnimationUpdateBlock_t		updateBlock;
@property (copy, nonatomic)	JAAnimationCompletionBlock_t	completionBlock;

@end



@implementation JAAnimation_animationItem
@end



#pragma mark -
#pragma mark Main class implementation

@implementation JAAnimation



#pragma mark -
#pragma mark Object lifecycle (Singleton)

+ (JAAnimation*)sharedInstance
{
	static JAAnimation*		instance;
	static dispatch_once_t	onceToken;
	dispatch_once(&onceToken, ^
	{
		instance = [self new];
	});
	return instance;
}

- (id)init
{
	self = [super init];
	if(self == nil)
	{
		return nil;
	}

	// Create the collections used to store animations
	_toAdd = [NSMutableArray array];
	_toRemove = [NSMutableArray array];
	_animatables = [NSMutableArray array];
	_blockAnimationItems = [NSMutableDictionary dictionary];
	// Create the display-link object...
	// Note: A bug in iOS 6 means the display link doesn't retain its target, but in
	// this case it's ok because 'self' is a singleton anyway so will stay alive
	_displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkUpdate:)];
	_displayLink.paused = YES;
	_displayLink.frameInterval = 1;
	[_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];

	return self;
}



#pragma mark -
#pragma mark Private methods

- (void)displayLinkUpdate:(CADisplayLink*)dl
{
	// Calculate the time delta
	CGFloat timeDelta = (float)dl.duration * dl.frameInterval;

	// Update the block-based animations
	[self updateBlockAnimationItems:timeDelta];

	// Update animatables
	[self updateAnimatableItems:timeDelta];

	// Stop the animation updates if there are no current animations
	if((_toAdd.count + _animatables.count + _blockAnimationItems.count) == 0)
	{
		_displayLink.paused = YES;
	}
}

- (void)updateBlockAnimationItems:(CGFloat)timeDelta
{
	// The dictionary might be modified by the animation
	// blocks so enumerate in a way that allows mutation
	for(NSString* key in [_blockAnimationItems allKeys])
	{
		// Get the item and check if it is still present
		JAAnimation_animationItem*	item = [_blockAnimationItems objectForKey:key];
		if(item == nil)
		{
			continue;
		}

		BOOL	animComplete = NO;
		BOOL	animContinue = NO;
		// Increment the time
		item->_time += timeDelta;
		// Call the update block with the current progress of the animation
		if(item->_time >= item->_endTime)
		{
			item.updateBlock(1.0f);
			animComplete = YES;
		}
		else
		{
			animContinue = item.updateBlock(item->_time / item->_endTime);
		}
		// If the animation is finished...
		if(animComplete || !animContinue)
		{
			// Call the completion block
			if(item.completionBlock != nil)
			{
				item.completionBlock(animComplete);
			}
			// Remove the animation
			[_blockAnimationItems removeObjectForKey:key];
		}
	}
}

- (void)updateAnimatableItems:(CGFloat)timeDelta
{
	// First remove any empty objects or items removed since the last iteration
	[_animatables removeObjectsInArray:_toRemove];
	[_toRemove removeAllObjects];

	// Then add any new items added during or since the previous iteration
	[_animatables addObjectsFromArray:_toAdd];
	[_toAdd removeAllObjects];

	// Then iterate through the animatables
	for(JAWeakProxy* proxy in _animatables)
	{
		// Get the proxy target (the animatable)...
		id<JAAnimatable> animatable = proxy.target;
		if(animatable == nil)
		{
			// Remove the proxy if the target has gone away
			[_toRemove addObject:proxy];
		}
		else
		{
			// Update the animatable
			[animatable updateWithTimeInterval:timeDelta];
		}
	}
}



#pragma mark -
#pragma mark Public interface implementation

+ (void)addAnimatable:(id<JAAnimatable>)animatable
{
	JAAnimation*	instance = [self sharedInstance];
	// Add the animatable, wrapped in a weak proxy
	[instance.toAdd addObject:[JAWeakProxy weakProxyWithTarget:animatable]];
	instance.displayLink.paused = NO;
}

+ (void)removeAnimatable:(id<JAAnimatable>)animatable
{
	JAAnimation*	instance = [self sharedInstance];
	// Linear-search the animatables
	for(JAWeakProxy* proxy in instance.animatables)
	{
		// Find any matching object and remove it - also remove any nil ones
		if((proxy.target == nil) || (proxy.target == animatable))
		{
			[instance.toRemove addObject:proxy];
		}
	}
}

+ (void)animateWithIdentifier:(NSString*)identifier forDuration:(CGFloat)duration update:(JAAnimationUpdateBlock_t)updateBlock completion:(JAAnimationCompletionBlock_t)completionBlock
{
	// Update block and identifier must not be nil
	if((updateBlock == nil) || (identifier == nil))
	{
		return;
	}

	// Get the instance and cancel any existing animation for this identifier
	JAAnimation*				instance = [self sharedInstance];
	JAAnimation_animationItem*	item = [instance.blockAnimationItems objectForKey:identifier];
	// Cancel any existing animation for this identifier
	if(item != nil)
	{
		[instance.blockAnimationItems removeObjectForKey:identifier];
		if(item.completionBlock != nil)
		{
			item.completionBlock(NO);
		}
	}

	// Call the update block for the first time (with zero progress)
	BOOL animContinue = updateBlock(0.0f);
	if(!animContinue)
	{
		if(completionBlock != nil)
		{
			completionBlock(NO);
		}
		return;
	}

	// Add the new animation item
	item = [JAAnimation_animationItem new];
	item->_endTime = duration;
	item.updateBlock = updateBlock;
	item.completionBlock = completionBlock;
	[instance.blockAnimationItems setObject:item forKey:identifier];
	instance.displayLink.paused = NO;
}

+ (void)animateWithIdentifier:(NSString*)identifier forDuration:(CGFloat)duration update:(JAAnimationUpdateBlock_t)updateBlock
{
	[self animateWithIdentifier:identifier forDuration:duration update:updateBlock completion:nil];
}

+ (void)cancelAnimationWithIdentifier:(NSString*)identifier
{
	JAAnimation*				instance = [self sharedInstance];
	JAAnimation_animationItem*	item = [instance.blockAnimationItems objectForKey:identifier];
	[instance.blockAnimationItems removeObjectForKey:identifier];
	if(item.completionBlock != nil)
	{
		item.completionBlock(NO);
	}
}

@end
