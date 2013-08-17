//
//  NSObject+JAActionBlock.h
//  JALib
//
//  Created by Jay on 2013-01-05.
//  Copyright (c) 2013 Jay Abbott. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSObject (JAActionBlock)

/**
 Adds a block to the receiver that can be executed using performActionBlockForKey:
 The block will be retained in an associated object as long as the receiver is alive.
 Therefore you must pay close attention to what objects will be retained by the block,
 in particular you must only use weak references to the receiver because:
 a) a strong reference will prevent the receiver from ever being deallocated;
 b) an __unsafe_unretained reference in the block may try to access the receiver after it has been deallocated;
 c) a weak reference is ok, but may be nil so be careful.
 @param blk		The block to execute when performActionBlockForKey: is sent to the receiver. If nil, any existing action block associated with the key is removed.
 @param key		The key used to identify the action block.
 */
- (void)setActionBlock:(dispatch_block_t)blk forKey:(id<NSCopying>)key;

/**
 Performs the action block identified by the key.
 */
- (void)performActionBlockForKey:(id<NSCopying>)key;

/**
 Convenience method, equivalent to setActionBlock:forKey: with the empty string @"" as the key.
 */
- (void)setActionBlock:(dispatch_block_t)blk;

/**
 Convenience method, equivalent to performActionBlockForKey: with the empty string @"" as the key.
 */
- (void)performActionBlock;

/**
 Convenience method, equivalent to setActionBlock:forKey: with nil as the block and the same key.
 */
- (void)removeActionBlockForKey:(id<NSCopying>)key;

/**
 Convenience method, equivalent to setActionBlock:forKey: with nil as the block and the empty string @"" as the key.
 */
- (void)removeActionBlock;

@end
