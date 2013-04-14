//
//  JAWeakProxy.m
//  JALib
//
//  Created by Jay on 2012-12-08.
//  Copyright (c) 2012 Jay Abbott. All rights reserved.
//

#import "JAWeakProxy.h"



@implementation JAWeakProxy

+ (JAWeakProxy*)weakProxyWithTarget:(id)target
{
	JAWeakProxy* newObj = [self new];
	newObj.target = target;
	return newObj;
}

- (BOOL)respondsToSelector:(SEL)sel
{
	return [_target respondsToSelector:sel];
}

- (id)forwardingTargetForSelector:(SEL)sel
{
	return _target;
}

@end
