//
//  JARecycler.h
//  JALib
//
//  Created by Jay Abbott on 2011-11-21.
//  Copyright (c) 2011 Jay Abbott. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JAReusable.h"



@interface JARecycler : NSObject

- (void)enqueueReusableObject:(NSObject<JAReusable>*)reusableObject;
- (NSObject<JAReusable>*)dequeueReusableObjectWithIdentifier:(NSString*)reuseIdentifier;

@end
