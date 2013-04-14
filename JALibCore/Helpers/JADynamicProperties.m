//
//  JADynamicProperties.m
//  JALib
//
//  Created by Jay Abbott on 2012-06-19.
//  Copyright (c) 2012 Jay Abbott. All rights reserved.
//

#import <objc/runtime.h>

#import "JADynamicProperties.h"



#pragma mark -
#pragma mark Private functions

// Dynamic properties dictionary
NSMutableDictionary*	JADynamicProperties_getDictionaryForClass(Class cls);
// Dynamic properties accessors
id					JADynamicProperties_getObject(id self, SEL _cmd);
void				JADynamicProperties_setObject(id self, SEL _cmd, id value);
char				JADynamicProperties_getSignedChar(id self, SEL _cmd);
void				JADynamicProperties_setSignedChar(id self, SEL _cmd, char value);
unsigned char		JADynamicProperties_getUnsignedChar(id self, SEL _cmd);
void				JADynamicProperties_setUnsignedChar(id self, SEL _cmd, unsigned char value);
int					JADynamicProperties_getSignedInt(id self, SEL _cmd);
void				JADynamicProperties_setSignedInt(id self, SEL _cmd, int value);
unsigned int		JADynamicProperties_getUnsignedInt(id self, SEL _cmd);
void				JADynamicProperties_setUnsignedInt(id self, SEL _cmd, unsigned int value);
short				JADynamicProperties_getSignedShort(id self, SEL _cmd);
void				JADynamicProperties_setSignedShort(id self, SEL _cmd, short value);
unsigned short		JADynamicProperties_getUnsignedShort(id self, SEL _cmd);
void				JADynamicProperties_setUnsignedShort(id self, SEL _cmd, unsigned short value);
long				JADynamicProperties_getSignedLong(id self, SEL _cmd);
void				JADynamicProperties_setSignedLong(id self, SEL _cmd, long value);
unsigned long		JADynamicProperties_getUnsignedLong(id self, SEL _cmd);
void				JADynamicProperties_setUnsignedLong(id self, SEL _cmd, unsigned long value);
long long 			JADynamicProperties_getSignedLongLong(id self, SEL _cmd);
void				JADynamicProperties_setSignedLongLong(id self, SEL _cmd, long long value);
unsigned long long	JADynamicProperties_getUnsignedLongLong(id self, SEL _cmd);
void				JADynamicProperties_setUnsignedLongLong(id self, SEL _cmd, unsigned long long value);
float				JADynamicProperties_getFloat(id self, SEL _cmd);
void				JADynamicProperties_setFloat(id self, SEL _cmd, float value);
double				JADynamicProperties_getDouble(id self, SEL _cmd);
void				JADynamicProperties_setDouble(id self, SEL _cmd, double value);



#pragma mark -
#pragma mark Private functions implementation

// Get the dynamic properties dictionary or create it if it doesn't already exist
NSMutableDictionary* JADynamicProperties_getDictionaryForClass(Class cls)
{
#define kKeyDynamicProperties	@"JADynamicPropertiesDictionary"
	NSMutableDictionary* dynProps = objc_getAssociatedObject(cls, kKeyDynamicProperties);
	if(dynProps == nil)
	{
		// Create the dynamic properties dictionary and add it to the class object
		dynProps = [NSMutableDictionary dictionary];
		objc_setAssociatedObject(cls, kKeyDynamicProperties, dynProps, OBJC_ASSOCIATION_RETAIN);
	}
	return dynProps;
}

// Dynamic property accessors for objects (id) - also used by scalar accessors (with an NSNumber object)
id JADynamicProperties_getObject(id self, SEL _cmd)
{
	NSMutableDictionary* dynProps = JADynamicProperties_getDictionaryForClass([self class]);
	if(dynProps != nil)
	{
		NSString* iVarName = [dynProps objectForKey:NSStringFromSelector(_cmd)];
		if(iVarName != nil)
		{
			return [dynProps objectForKey:iVarName];
		}
	}
	return nil;
}

void JADynamicProperties_setObject(id self, SEL _cmd, id obj)
{
	NSMutableDictionary* dynProps = JADynamicProperties_getDictionaryForClass([self class]);
	if(dynProps != nil)
	{
		NSString* iVarName = [dynProps objectForKey:NSStringFromSelector(_cmd)];
		if(iVarName != nil)
		{
			[dynProps setObject:obj forKey:iVarName];
		}
	}
}

// Dyanmic property scalar accessors
char JADynamicProperties_getSignedChar(id self, SEL _cmd)
{
	return [(NSNumber*)JADynamicProperties_getObject(self, _cmd) charValue];
}

void JADynamicProperties_setSignedChar(id self, SEL _cmd, char value)
{
	JADynamicProperties_setObject(self, _cmd, [NSNumber numberWithChar:value]);
}

unsigned char JADynamicProperties_getUnsignedChar(id self, SEL _cmd)
{
	return [(NSNumber*)JADynamicProperties_getObject(self, _cmd) unsignedCharValue];
}

void JADynamicProperties_setUnsignedChar(id self, SEL _cmd, unsigned char value)
{
	JADynamicProperties_setObject(self, _cmd, [NSNumber numberWithUnsignedChar:value]);
}

int JADynamicProperties_getSignedInt(id self, SEL _cmd)
{
	return [(NSNumber*)JADynamicProperties_getObject(self, _cmd) intValue];
}

void JADynamicProperties_setSignedInt(id self, SEL _cmd, int value)
{
	JADynamicProperties_setObject(self, _cmd, [NSNumber numberWithInt:value]);
}

unsigned int JADynamicProperties_getUnsignedInt(id self, SEL _cmd)
{
	return [(NSNumber*)JADynamicProperties_getObject(self, _cmd) unsignedIntValue];
}

void JADynamicProperties_setUnsignedInt(id self, SEL _cmd, unsigned int value)
{
	JADynamicProperties_setObject(self, _cmd, [NSNumber numberWithUnsignedInt:value]);
}

short JADynamicProperties_getSignedShort(id self, SEL _cmd)
{
	return [(NSNumber*)JADynamicProperties_getObject(self, _cmd) shortValue];
}

void JADynamicProperties_setSignedShort(id self, SEL _cmd, short value)
{
	JADynamicProperties_setObject(self, _cmd, [NSNumber numberWithShort:value]);
}

unsigned short JADynamicProperties_getUnsignedShort(id self, SEL _cmd)
{
	return [(NSNumber*)JADynamicProperties_getObject(self, _cmd) unsignedShortValue];
}

void JADynamicProperties_setUnsignedShort(id self, SEL _cmd, unsigned short value)
{
	JADynamicProperties_setObject(self, _cmd, [NSNumber numberWithUnsignedShort:value]);
}

long JADynamicProperties_getSignedLong(id self, SEL _cmd)
{
	return [(NSNumber*)JADynamicProperties_getObject(self, _cmd) longValue];
}

void JADynamicProperties_setSignedLong(id self, SEL _cmd, long value)
{
	JADynamicProperties_setObject(self, _cmd, [NSNumber numberWithLong:value]);
}

unsigned long JADynamicProperties_getUnsignedLong(id self, SEL _cmd)
{
	return [(NSNumber*)JADynamicProperties_getObject(self, _cmd) unsignedLongValue];
}

void JADynamicProperties_setUnsignedLong(id self, SEL _cmd, unsigned long value)
{
	JADynamicProperties_setObject(self, _cmd, [NSNumber numberWithUnsignedLong:value]);
}

long long JADynamicProperties_getSignedLongLong(id self, SEL _cmd)
{
	return [(NSNumber*)JADynamicProperties_getObject(self, _cmd) longLongValue];
}

void JADynamicProperties_setSignedLongLong(id self, SEL _cmd, long long value)
{
	JADynamicProperties_setObject(self, _cmd, [NSNumber numberWithLongLong:value]);
}

unsigned long long JADynamicProperties_getUnsignedLongLong(id self, SEL _cmd)
{
	return [(NSNumber*)JADynamicProperties_getObject(self, _cmd) unsignedLongLongValue];
}

void JADynamicProperties_setUnsignedLongLong(id self, SEL _cmd, unsigned long long value)
{
	JADynamicProperties_setObject(self, _cmd, [NSNumber numberWithUnsignedLongLong:value]);
}

float JADynamicProperties_getFloat(id self, SEL _cmd)
{
	return [(NSNumber*)JADynamicProperties_getObject(self, _cmd) floatValue];
}

void JADynamicProperties_setFloat(id self, SEL _cmd, float value)
{
	JADynamicProperties_setObject(self, _cmd, [NSNumber numberWithFloat:value]);
}

double JADynamicProperties_getDouble(id self, SEL _cmd)
{
	return [(NSNumber*)JADynamicProperties_getObject(self, _cmd) doubleValue];
}

void JADynamicProperties_setDouble(id self, SEL _cmd, double value)
{
	JADynamicProperties_setObject(self, _cmd, [NSNumber numberWithDouble:value]);
}



#pragma mark -
#pragma mark Main class implementation

@implementation JADynamicProperties



#pragma mark -
#pragma mark Public interface implementation

+ (void)addPropertyOfType:(char)typ withGetter:(SEL)getter andSetter:(SEL)setter toClass:(Class)cls
{
	// Bail out if there's no getter
	if(getter == nil)
	{
		return;
	}
	// Get the dynamic properties dictionary
	NSMutableDictionary* dynProps = JADynamicProperties_getDictionaryForClass(cls);
	// Generate the iVar name and associate the selector names to the ivar
	NSString*	iVarName = [@"_JADynamicProperties_iVar_" stringByAppendingString:NSStringFromSelector(getter)];
	[dynProps setObject:iVarName forKey:NSStringFromSelector(getter)];
	if(setter != nil)
	{
		[dynProps setObject:iVarName forKey:NSStringFromSelector(setter)];
	}
	// Register the accessors
	switch(typ)
	{
			// id (also any object pointer)
		case '@':
			class_addMethod(cls, getter, (IMP)JADynamicProperties_getObject, "@@:");
			if(setter != nil)
			{
				class_addMethod(cls, setter, (IMP)JADynamicProperties_setObject, "v@:@");
			}
			break;
			// signed char (also used by BOOL)
		case 'c':
			class_addMethod(cls, getter, (IMP)JADynamicProperties_getSignedChar, "c@:");
			if(setter != nil)
			{
				class_addMethod(cls, setter, (IMP)JADynamicProperties_setSignedChar, "v@:c");
			}
			break;
			// signed int
		case 'i':
			class_addMethod(cls, getter, (IMP)JADynamicProperties_getSignedInt, "i@:");
			if(setter != nil)
			{
				class_addMethod(cls, setter, (IMP)JADynamicProperties_setSignedInt, "v@:i");
			}
			break;
			// signed short
		case 's':
			class_addMethod(cls, getter, (IMP)JADynamicProperties_getSignedShort, "s@:");
			if(setter != nil)
			{
				class_addMethod(cls, setter, (IMP)JADynamicProperties_setSignedShort, "v@:s");
			}
			break;
			// signed long
		case 'l':
			class_addMethod(cls, getter, (IMP)JADynamicProperties_getSignedLong, "l@:");
			if(setter != nil)
			{
				class_addMethod(cls, setter, (IMP)JADynamicProperties_setSignedLong, "v@:l");
			}
			break;
			// signed long long
		case 'q':
			class_addMethod(cls, getter, (IMP)JADynamicProperties_getSignedLongLong, "q@:");
			if(setter != nil)
			{
				class_addMethod(cls, setter, (IMP)JADynamicProperties_setSignedLongLong, "v@:q");
			}
			break;
			// unsigned char
		case 'C':
			class_addMethod(cls, getter, (IMP)JADynamicProperties_getUnsignedChar, "C@:");
			if(setter != nil)
			{
				class_addMethod(cls, setter, (IMP)JADynamicProperties_setUnsignedChar, "v@:C");
			}
			break;
			// unsigned int
		case 'I':
			class_addMethod(cls, getter, (IMP)JADynamicProperties_getUnsignedInt, "I@:");
			if(setter != nil)
			{
				class_addMethod(cls, setter, (IMP)JADynamicProperties_setUnsignedInt, "v@:I");
			}
			break;
			// unsigned short
		case 'S':
			class_addMethod(cls, getter, (IMP)JADynamicProperties_getUnsignedShort, "s@:");
			if(setter != nil)
			{
				class_addMethod(cls, setter, (IMP)JADynamicProperties_setUnsignedShort, "v@:s");
			}
			break;
			// unsigned long
		case 'L':
			class_addMethod(cls, getter, (IMP)JADynamicProperties_getUnsignedLong, "L@:");
			if(setter != nil)
			{
				class_addMethod(cls, setter, (IMP)JADynamicProperties_setUnsignedLong, "v@:L");
			}
			break;
			// unsigned long long
		case 'Q':
			class_addMethod(cls, getter, (IMP)JADynamicProperties_getUnsignedLongLong, "Q@:");
			if(setter != nil)
			{
				class_addMethod(cls, setter, (IMP)JADynamicProperties_setUnsignedLongLong, "v@:Q");
			}
			break;
			// float
		case 'f':
			class_addMethod(cls, getter, (IMP)JADynamicProperties_getFloat, "f@:");
			if(setter != nil)
			{
				class_addMethod(cls, setter, (IMP)JADynamicProperties_setFloat, "v@:f");
			}
			break;
			// double
		case 'd':
			class_addMethod(cls, getter, (IMP)JADynamicProperties_getDouble, "d@:");
			if(setter != nil)
			{
				class_addMethod(cls, setter, (IMP)JADynamicProperties_setDouble, "v@:d");
			}
			break;
		default:
			break;
	}
}

@end
