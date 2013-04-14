//
//  NSObject+JADestructor.h
//  JALib
//
//  Created by Jay on 2012-08-21.
//  Copyright (c) 2012 Jay Abbott. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSObject (JADestructor)

/**
 Adds a block to the receiver that will be called after the receiver is deallocated.
 @warning	The block is executed after the receiver is dealloced so must not reference or try to access the receiver at all.
 The block will be retained in an associated object as long as the receiver is alive.
 After the receiver is deallocated the block will be executed and then released when
 the associated object is deallocated.
 Therefore you must pay close attention to what objects will be retained by the block,
 in particular you must not reference the receiver because:
 a) a strong reference will prevent the receiver from ever being deallocated;
 b) a weak or __unsafe_unretained reference in the block will try to access the receiver after it has been deallocated.
 @param blk		The block to execute.
 */
- (void)addDestructorBlock:(dispatch_block_t)blk;

@end
