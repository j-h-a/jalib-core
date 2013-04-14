//
//  JAAnimation.h
//  JALib
//
//  Created by Jay on 2012-12-08.
//  Copyright (c) 2012 Jay Abbott. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>



@protocol JAAnimatable <NSObject>

- (void)updateWithTimeInterval:(CGFloat)timeDelta;

@end

typedef BOOL (^JAAnimationUpdateBlock_t)(CGFloat progress);
typedef void (^JAAnimationCompletionBlock_t)(BOOL finished);



@interface JAAnimation : NSObject

/**
 Add an animatable object to be updated every tick.
 Adding an object causes it to immediately start receiving updates through the JAAnimatable
 interface. Updates will continue in sync with the display-update until the object is removed.
 The animatable object is not retained, if it is deallocated it will be removed automatically.
 */
+ (void)addAnimatable:(id<JAAnimatable>)animatable;

/**
 Remove an animatable object.
 */
+ (void)removeAnimatable:(id<JAAnimatable>)animatable;

/**
 Trigger an animation with an update block and a completion block.
 The update block will always get called at least once with progress 0.0 and will then be called
 repeatedly with increasing values for progress up to 1.0 when the animation has ended.
 If the animation completes it will be called with progress 1.0 before the completion block is called.
 Return YES from the update block to let the animation continue.
 Returning NO will cause the animation to be cancelled and the completion block will be called immediately
 with the finished flag set to NO.
 Note that when progress is 1.0 and the animation has actually completed, the completion block will be called with
 the finished flag set to YES even if the update block returns NO.
 */
+ (void)animateWithIdentifier:(NSString*)identifier forDuration:(CGFloat)duration update:(JAAnimationUpdateBlock_t)updateBlock completion:(JAAnimationCompletionBlock_t)completionBlock;

/**
 Convenience method which simply calls animateWithIdentifier:forDuration:update:completion: with a nil completion block.
 */
+ (void)animateWithIdentifier:(NSString*)identifier forDuration:(CGFloat)duration update:(JAAnimationUpdateBlock_t)updateBlock;

/**
 Cancel an animation by its identifier.
 */
+ (void)cancelAnimationWithIdentifier:(NSString*)identifier;

@end
