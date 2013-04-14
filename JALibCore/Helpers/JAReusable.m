//
//  JAReusable.m
//  JALib
//
//  Created by Jay Abbott on 2012-07-08.
//  Copyright (c) 2012 Jay Abbott. All rights reserved.
//

#import <objc/runtime.h>

#import "JAReusable.h"
#import "JADynamicProperties.h"



void JAReusable_AdoptProtocolInClass(Class cls)
{
	// Check if the class already conforms to JAReusable
	if(![cls conformsToProtocol:@protocol(JAReusable)])
	{
		// Add the reuseIdentifier property to the class
		// TODO: The dynamic property is 'strong' but it should be 'copy' - make it 'copy' when JADynamicProperties supports it.
		[JADynamicProperties addPropertyOfType:'@' withGetter:@selector(reuseIdentifier) andSetter:@selector(setReuseIdentifier:) toClass:cls];
		// Indicate that the class now conforms to the JAReusable protocol
		class_addProtocol(cls, @protocol(JAReusable));
	}
}
