//
//  CHKeychain.h
//  Chnword
//
//  Created by khtc on 15/5/27.
//  Copyright (c) 2015年 chnword. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface CHKeychain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteItem:(NSString *)service;


@end
