//
//  JAWeakProxy.h
//  JALib
//
//  Created by Jay on 2012-12-08.
//  Copyright (c) 2012 Jay Abbott. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface JAWeakProxy : NSObject

@property (weak, nonatomic)	id	target;

+ (JAWeakProxy*)weakProxyWithTarget:(id)target;

@end
