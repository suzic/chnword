//
//  DataUtil.h
//  Chnword
//
//  Created by khtc on 15/5/17.
//  Copyright (c) 2015年 chnword. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataUtil : NSObject

/**
 *  @abstract 判断应用是否首次开启
 */
+ (BOOL)isFirstLogin;

/**
 *  添加一个用户
 */
+ (void)addUser:(NSString *)userCode;

/**
 *  @abstract 默认用户或者其他
 */
+ (void)setDefaultUser:(NSString *)serCode;
+ (NSString *)getDefaultUser;

/**
 *  用户相关的解锁的条目
 */
+ (void)setUnlockModel:(NSString *) userCode models:(NSArray *)models;
+ (NSArray *)getUnlockModel:(NSString *)userCode;

/**
 *  用户解锁全部
 */
+ (BOOL)isUnlockAllForUser:(NSString *)userCode;
+ (void)setUnlockAllModelsForUser:(NSString *)userCode;

/**
 *  默认模块
 */
+ (void)setDefaultModule:(NSArray *)modules;
+ (NSArray *)getDefaultModule;

/**
 * 模块中的默认字
 */
+ (void)setDefaultWord:(NSArray *)word forModule:(NSString *) moduleCode;
+ (NSArray *)getDefaultWord:(NSString *)moduleCode;

/**
 *  用户的默认模块
 */
+ (void) setDefaultModule:(NSArray *)modules forUser:(NSString *)userCode;
+ (NSArray *) getDefaultModule:(NSString *)userCode;

/**
 *  用户模块中的默认字
 */
+ (void) setDefaultWord:(NSArray *) word forModule:(NSString *) moduleCode andUser:(NSString *)userCode;
+ (NSArray *) getDefaultWord:(NSString *) moduleCode forUser:(NSString *)userCode;

/**
 *  判断
 */
+ (BOOL)isContain:(NSArray *)arr object:(NSString *)str;

@end
