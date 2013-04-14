//
//  CGPoint+Vector.m
//  JALib
//
//  Created by Jay Abbott on 2012-05-27.
//  Copyright (c) 2012 Jay Abbott. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CGPoint+Vector.h"



CGPoint CGPointScale(CGPoint p, CGFloat s)
{
	return CGPointMake(p.x * s, p.y * s);
}

CGPoint CGPointAdd(CGPoint a, CGPoint b)
{
	return CGPointMake(a.x + b.x, a.y + b.y);
}

CGPoint CGPointSubtract(CGPoint a, CGPoint b)
{
	return CGPointMake(a.x - b.x, a.y - b.y);
}

CGFloat CGPointCrossProduct(CGPoint a, CGPoint b)
{
	return (a.x * b.y) - (b.x * a.y);
}

CGFloat CGPointDotProduct(CGPoint a, CGPoint b)
{
	return (a.x * b.x) + (a.y * b.y);
}

CGFloat CGPointLength(CGPoint p)
{
	return sqrtf((p.x * p.x) + (p.y * p.y));
}

CGPoint CGPointNormalize(CGPoint p)
{
	return CGPointScale(p, 1.0f / CGPointLength(p));
}
