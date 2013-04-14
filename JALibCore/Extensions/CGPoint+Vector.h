//
//  CGPoint+Vector.h
//  JALib
//
//  Created by Jay Abbott on 2012-05-27.
//  Copyright (c) 2012 Jay Abbott. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGPoint	CGPointScale(CGPoint v, CGFloat s);
extern CGPoint	CGPointAdd(CGPoint a, CGPoint b);
extern CGPoint	CGPointSubtract(CGPoint a, CGPoint b);
extern CGFloat	CGPointCrossProduct(CGPoint a, CGPoint b);
extern CGFloat	CGPointDotProduct(CGPoint a, CGPoint b);
extern CGFloat	CGPointLength(CGPoint v);
extern CGPoint	CGPointNormalize(CGPoint v);
