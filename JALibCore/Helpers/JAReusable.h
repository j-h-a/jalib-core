//
//  JAReusable.h
//  JALib
//
//  Created by Jay Abbott on 2011-11-08.
//  Copyright (c) 2011 Jay Abbott. All rights reserved.
//

#import <UIKit/UIKit.h>



#pragma mark -
#pragma mark JAReusable protocol definition

@protocol JAReusable

@property (copy, nonatomic)		NSString*	reuseIdentifier;

@end



#pragma mark -
#pragma mark Helper functions

/**
 Use this to make any class adopt the JAReusable protocol.
 Call this function on any class object and that class will then implement JAReusable.
 The reuseIdentifier property will be dynamically added to the class and the class will
 be marked as conforming to the JAReusable protocol.
 If the class already conforms to JAReusable this will do nothing.
 */
void JAReusable_AdoptProtocolInClass(Class cls);
