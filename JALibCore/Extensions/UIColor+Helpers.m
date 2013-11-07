//
//  UIColor+Helpers.m
//  JALib
//
//  Created by Jay Abbott on 2012-06-21.
//  Copyright (c) 2012 Jay Abbott. All rights reserved.
//

#import "UIColor+Helpers.h"



#ifndef LERP
#define LERP(_a, _b, _alpha) ( ((_b) * (_alpha)) + ((_a) * (1.0f - (_alpha))) )
#endif



UIColor* UIColorFromString(NSString* string)
{
#define HEX_CHAR_TO_INT(_c)	( \
	(((_c) >= '0') && ((_c) <= '9')) ? (NSInteger)((_c) - '0') : \
	(((_c) >= 'A') && ((_c) <= 'F')) ? 10 + (NSInteger)((_c) - 'A') : \
	(((_c) >= 'a') && ((_c) <= 'f')) ? 10 + (NSInteger)((_c) - 'a') : \
	0)
	// Default is opaque black using RGBA format (not Greyscale)
	CGFloat	r = 0.0f;
	CGFloat	g = 0.0f;
	CGFloat	b = 0.0f;
	CGFloat	a = 1.0f;
	BOOL	rgba = YES;

	// Check for HTML-style format: #RGB, #RRGGBB, #RRGGBBAA, #GA, #GGAA
	if([string hasPrefix:@"#"])
	{
		switch(string.length)
		{
			case 3:	// #GA : 4-bit greyscale and alpha
				g = HEX_CHAR_TO_INT([string characterAtIndex:1]) / (float)0xF;
				a = HEX_CHAR_TO_INT([string characterAtIndex:2]) / (float)0xF;
				rgba = NO;
				break;
			case 5:	// #GGAA : 8-bit greyscale and alpha
				g =	((HEX_CHAR_TO_INT([string characterAtIndex:1]) << 4) |
					 (HEX_CHAR_TO_INT([string characterAtIndex:2]) << 0)) / (float)0xFF;
				a =	((HEX_CHAR_TO_INT([string characterAtIndex:3]) << 4) |
					 (HEX_CHAR_TO_INT([string characterAtIndex:4]) << 0)) / (float)0xFF;
				rgba = NO;
				break;
			case 4: // #RGB : 4-bit red-green-blue
				r = HEX_CHAR_TO_INT([string characterAtIndex:1]) / (float)0xF;
				g = HEX_CHAR_TO_INT([string characterAtIndex:2]) / (float)0xF;
				b = HEX_CHAR_TO_INT([string characterAtIndex:3]) / (float)0xF;
				break;
			case 9: // #RRGGBBAA : 8-bit red-green-blue-alpha (falls through to next case)
				a =	((HEX_CHAR_TO_INT([string characterAtIndex:7]) << 4) |
					 (HEX_CHAR_TO_INT([string characterAtIndex:8]) << 0)) / (float)0xFF;
			case 7: // #RRGGBB : 8-bit red-green-blue
				r =	((HEX_CHAR_TO_INT([string characterAtIndex:1]) << 4) |
					 (HEX_CHAR_TO_INT([string characterAtIndex:2]) << 0)) / (float)0xFF;
				g =	((HEX_CHAR_TO_INT([string characterAtIndex:3]) << 4) |
					 (HEX_CHAR_TO_INT([string characterAtIndex:4]) << 0)) / (float)0xFF;
				b =	((HEX_CHAR_TO_INT([string characterAtIndex:5]) << 4) |
					 (HEX_CHAR_TO_INT([string characterAtIndex:6]) << 0)) / (float)0xFF;
				break;
			default:
				break;
		}
	}
	// Otherwise check for CGxxxFromString-style format: {r, g, b, a} or {g, a}
	else if([string hasPrefix:@"{"] && [string hasSuffix:@"}"])
	{
		// Trim the curly brackets, separate into components by comma, and trim whitespace from the components
		NSString*		trimmed = [string substringWithRange:NSMakeRange(1, string.length - 2)];
		NSArray*		rawComp = [trimmed componentsSeparatedByString:@","];
		NSMutableArray*	components = [NSMutableArray arrayWithCapacity:rawComp.count];
		for(NSString* comp in rawComp)
		{
			[components addObject:[comp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
		}
		// Process the components to get GA or RGBA colour values
		if(components.count == 2)
		{
			// Read in the greyscale and alpha
			g = [(NSString*)[components objectAtIndex:0] floatValue];
			a = [(NSString*)[components objectAtIndex:1] floatValue];
			rgba = NO;
		}
		else if(components.count == 4)
		{
			// Read in the red, green, blue, and alpha
			r = [(NSString*)[components objectAtIndex:0] floatValue];
			g = [(NSString*)[components objectAtIndex:1] floatValue];
			b = [(NSString*)[components objectAtIndex:2] floatValue];
			a = [(NSString*)[components objectAtIndex:3] floatValue];
		}
	}
	// Otherwise check for pattern image format: <image_file>
	else if([string hasPrefix:@"<"] && [string hasSuffix:@">"])
	{
		// Trim the angle brackets and trim whitespace from the contents
		NSString* trimmed = [string substringWithRange:NSMakeRange(1, string.length - 2)];
		NSString* imgName = [trimmed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		// Try to load the image
		UIImage* image = [UIImage imageNamed:imgName];
		if(image != nil)
		{
			// Return pattern colour
			return [UIColor colorWithPatternImage:image];
		}
	}

	// Return the RGBA or Greyscale colour
	return rgba ? [UIColor colorWithRed:r green:g blue:b alpha:a] : [UIColor colorWithWhite:g alpha:a];
}

UIColor* UIColorByInterpolatingColors(UIColor* c0, UIColor* c1, CGFloat alpha)
{
	CGFloat rgba0[4];
	CGFloat rgba1[4];
	CGFloat rgbaOut[4];
	[c0 getRed:&rgba0[0] green:&rgba0[1] blue:&rgba0[2] alpha:&rgba0[3]];
	[c1 getRed:&rgba1[0] green:&rgba1[1] blue:&rgba1[2] alpha:&rgba1[3]];
	rgbaOut[0] = LERP(rgba0[0], rgba1[0], alpha);
	rgbaOut[1] = LERP(rgba0[1], rgba1[1], alpha);
	rgbaOut[2] = LERP(rgba0[2], rgba1[2], alpha);
	rgbaOut[3] = LERP(rgba0[3], rgba1[3], alpha);
	return [UIColor colorWithRed:rgbaOut[0] green:rgbaOut[1] blue:rgbaOut[2] alpha:rgbaOut[3]];
}
