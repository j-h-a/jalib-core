//
//  NSObject+JAActionBlock.m
//  JALib
//
//  Created by Jay on 2013-01-05.
//  Copyright (c) 2013 Jay Abbott. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+JAActionBlock.h"



#pragma mark -
#pragma mark JAActionBlock category

@implementation NSObject (JAActionBlock)

#define kKeyJAActionBlockDictionary	@"JAActionBlock_ActionBlockDictionary"

- (void)setActionBlock:(dispatch_block_t)blk forKey:(id<NSCopying>)key
{
	// Get or create the action block dictionary
	NSMutableDictionary* actionBlockDict = objc_getAssociatedObject(self, kKeyJAActionBlockDictionary);
	if(actionBlockDict == nil)
	{
		// Create the action block dictionary and add it to self
		actionBlockDict = [NSMutableDictionary dictionary];
		objc_setAssociatedObject(self, kKeyJAActionBlockDictionary, actionBlockDict, OBJC_ASSOCIATION_RETAIN);
	}
	// Add the block to the action block dictionary
	[actionBlockDict setObject:blk forKey:key];
}

- (void)performActionBlockForKey:(id<NSCopying>)key
{
	// Get the action block dictionary
	NSMutableDictionary* actionBlockDict = objc_getAssociatedObject(self, kKeyJAActionBlockDictionary);
	if(actionBlockDict != nil)
	{
		dispatch_block_t	actionBlock = [actionBlockDict objectForKey:key];
		if(actionBlock != nil)
		{
			actionBlock();
		}
	}
}

- (void)setActionBlock:(dispatch_block_t)blk
{
	[self setActionBlock:blk forKey:@""];
}

- (void)performActionBlock
{
	[self performActionBlockForKey:@""];
}

@end
