//
//  JARecycler.m
//  JALib
//
//  Created by Jay Abbott on 2011-11-21.
//  Copyright (c) 2011 Jay Abbott. All rights reserved.
//

#import "JARecycler.h"



@interface JARecycler ()

@property (strong, nonatomic)	NSMutableDictionary*	reusables;

@end



@implementation JARecycler



#pragma mark -
#pragma mark Property Accessors

@synthesize reusables	= _reusables;



#pragma mark -
#pragma mark Public API implementation

- (void)enqueueReusableObject:(NSObject<JAReusable>*)reusableObject
{
	// Create the reusable objects dictionary if it doesn't already exist
	if(_reusables == nil)
	{
		self.reusables = [NSMutableDictionary dictionary];
	}
	// Get or create the array of objects for this reuse identifier
	NSMutableArray* roArray = [_reusables objectForKey:reusableObject.reuseIdentifier];
	if(roArray == nil)
	{
		roArray = [NSMutableArray array];
		[_reusables setObject:roArray forKey:reusableObject.reuseIdentifier];
	}
	// Put the reusable object into the array
	[roArray addObject:reusableObject];
}

- (NSObject<JAReusable>*)dequeueReusableObjectWithIdentifier:(NSString*)reuseIdentifier
{
	// If the reusable dictionary does not exist yet, or the array for this reuse
	// identifier does not exist, then there is no object waiting to be reused.
	if(_reusables == nil)
	{
		return nil;
	}
	NSMutableArray* roArray = [_reusables objectForKey:reuseIdentifier];
	if((roArray == nil) || ([roArray count] == 0))
	{
		return nil;
	}
	// Pop and return the last reusable object from the array
	NSObject<JAReusable>* dequeuedObject = [roArray lastObject];
	[roArray removeLastObject];
	return dequeuedObject;
}

@end
