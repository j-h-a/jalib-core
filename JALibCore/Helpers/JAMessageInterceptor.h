//
//  JAMessageInterceptor.h
//  JALib
//
//  Created by Jay Abbott on 2011-11-21.
//  Copyright (c) 2011 Jay Abbott. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface JAMessageInterceptor : NSObject

@property (weak, nonatomic)		id	target;
@property (weak, nonatomic)		id	interceptor;

@end
