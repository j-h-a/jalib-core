//
//  UIColor+Helpers.h
//  JALib
//
//  Created by Jay Abbott on 2012-06-21.
//  Copyright (c) 2012 Jay Abbott. All rights reserved.
//

#import <UIkit/UIKit.h>



/**
 Supports strings in the following forms:
 
 Format       | Colour type       | Notes
 -------------+-------------------+--------------------------------
 #RGB         | RGB (opaque)      | Components are 4-bit hex numbers from 0-F
 #RRGGBB      | RGB (opaque)      | Components are 8-bit hex numbers from 00-FF
 #RRGGBBAA    | RGBA              | Components are 8-bit hex numbers from 00-FF
 {r, b, g, a} | RGBA              | Each component is a number from 0.0 to 1.0
 {g, a}       | Greyscale + Alpha | Each component is a number from 0.0 to 1.0
 #GA          | Greyscale + Alpha | Components are 4-bit hex numbers from 0-F
 #GGAA        | Greyscale + Alpha | Components are 8-bit hex numbers from 00-FF
 <image_file> | Pattern Image     | Image file loaded with [UIImage imageNamed:]
 
 */
UIColor*	UIColorFromString(NSString* str);

/**
 Creates a new UIColor by interpolating between two UIColor objects

 The UIColor objects must be in the RGB colorspace.
 */
UIColor* UIColorByInterpolatingColors(UIColor* c0, UIColor* c1, CGFloat alpha);
