//
//  JAMessageInterceptor.h
//  JALib
//
//  Created by Jay Abbott on 2011-11-21.
//  Copyright (c) 2011 Jay Abbott. All rights reserved.
//

#import "JAMessageInterceptor.h"



#pragma mark -
#pragma mark Main class implementation

@implementation JAMessageInterceptor



#pragma mark -
#pragma mark Property accessors

@synthesize target			= _target;
@synthesize interceptor		= _interceptor;



#pragma mark -
#pragma mark Private implementation

- (BOOL)respondsToSelector:(SEL)aSelector
{
	// If either the interceptor or the target objects respond to the selector then
	// we will pretend that we respond to it. Then when it is subsequently sent to
	// us and fails, the runtime will call forwardingTargetForSelector: to see if
	// there is a forwarding target and we will provide the correct target there.
	if([_interceptor respondsToSelector:aSelector] || [_target respondsToSelector:aSelector])
	{
		return YES;
	}
	return [super respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
	// If the interceptor responds to the selector then it takes
	// precedence and will be supplied as the forwarding target.
	if([_interceptor respondsToSelector:aSelector])
	{
		return _interceptor;
	}
	if([_target respondsToSelector:aSelector])
	{
		return _target;
	}
	return [super forwardingTargetForSelector:aSelector];
}

@end
