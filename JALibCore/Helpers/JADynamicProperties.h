//
//  JADynamicProperties.h
//  JALib
//
//  Created by Jay Abbott on 2012-06-19.
//  Copyright (c) 2012 Jay Abbott. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface JADynamicProperties : NSObject

/**
 Adds a property to a class at runtime.
 Scalar properties will automatically use 'assign'.
 For Objective-C objects properties can be 'strong', 'weak', or 'copy' but this class currently
 only supports 'strong' properties; 'weak' and 'copy' are not implemented yet.
 To make the property is 'readonly' specify nil for the setter selector.
 @param	typ		The type of the property:
 '@' - An Objective-C object (id or pointer).
 'c' - Signed char, also used for BOOL.
 'i' - Signed int.
 's' - Signed short.
 'l' - Signed long.
 'q' - Signed long long.
 'C' - Unsigned char.
 'I' - Unsigned int.
 'S' - Unsigned short.
 'L' - Unsigned long.
 'Q' - Unsigned long long.
 'f' - Single-precision floating point number.
 'd' - Double-precision floating point number.
 See \@encode() in the Apple documentation for more information.
 @param	getter	The selector for the getter, must not be nil.
 @param	setter	The selector for the setter, or nil if the property is read-only.
 @param	cls		The class object for the class that the property will be added to.
 */
+ (void)addPropertyOfType:(char)typ withGetter:(SEL)getter andSetter:(SEL)setter toClass:(Class)cls;

@end
