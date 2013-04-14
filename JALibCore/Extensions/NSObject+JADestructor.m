//
//  NSObject+JADestructor.m
//  JALib
//
//  Created by Jay on 2012-08-21.
//  Copyright (c) 2012 Jay Abbott. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+JADestructor.h"



#pragma mark -
#pragma mark Private helper class

@interface JADestructor : NSObject

@property (strong, nonatomic, readonly)	NSMutableArray*		destructorBlocks;

@end

@implementation JADestructor

// Property is readonly, so iVar isn't automatically synthesized
@synthesize destructorBlocks	= _destructorBlocks;
- (NSMutableArray*)destructorBlocks
{
	if(_destructorBlocks == nil)
	{
		_destructorBlocks = [NSMutableArray array];
	}
	return _destructorBlocks;
}

- (void)dealloc
{
	if(_destructorBlocks != nil)
	{
		// For each block that was added...
		for(dispatch_block_t block in _destructorBlocks)
		{
			// Execute the destructor block
			block();
		}
	}
}

@end



#pragma mark -
#pragma mark JADestructor category

@implementation NSObject (JADestructor)

- (void)addDestructorBlock:(dispatch_block_t)blk
{
#define kKeyJADestructorObject	@"JADestructor_AssociatedJADestructorObject"
	JADestructor* destructor = objc_getAssociatedObject(self, kKeyJADestructorObject);
	if(destructor == nil)
	{
		// Create the destructor object and add it to self
		destructor = [JADestructor new];
		objc_setAssociatedObject(self, kKeyJADestructorObject, destructor, OBJC_ASSOCIATION_RETAIN);
	}
	// Add the block to the destructor object
	[destructor.destructorBlocks addObject:blk];
}

@end
