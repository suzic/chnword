//
//  DataUtil.m
//  Chnword
//
//  Created by khtc on 15/5/17.
//  Copyright (c) 2015年 chnword. All rights reserved.
//

#import "DataUtil.h"

#define Submit_Code_Key         @"Submit_Code_Key"
#define Submit_Code_Zone        @"Submit_Code_Zone"
#define Submit_Code_ALL         @"Submit_Code_ALL"
#define Submit_Code_List        @"Submit_Code_List"

#define Submit_Code_None        @"Submit_Code_None"
#define Submit_Code_Till        @"Sbumit_Code_Till"

#define CHNWORD_DEFAULT_USER    @"CHNWORD_DEFAULT_USER"
#define CHNWORD_ISFIRST_LOGIN   @"CHNWORD_ISFIRST_LOGIN"

#define CHNWORD_UNLOCK_USER     @"CHNWORD_UNLOCK_USER"
#define CHNWORD_UNLOCK_ALL_USER @"CHNWORD_UNLOCK_ALL_USER"


@implementation DataUtil

// 是否第一次运行
+ (BOOL)isFirstLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *str = [defaults objectForKey:CHNWORD_ISFIRST_LOGIN];
    if (str && [str isEqualToString:CHNWORD_ISFIRST_LOGIN])
    {
        return false;
    }
    else
    {
        [defaults setObject:CHNWORD_ISFIRST_LOGIN forKey:CHNWORD_ISFIRST_LOGIN];
        [defaults synchronize];
    }
    
    return true;
}

+ (void)setDefaultUser:(NSString *) userCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:userCode forKey:CHNWORD_DEFAULT_USER];
    [defaults synchronize];
}

+ (NSString *)getDefaultUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:CHNWORD_DEFAULT_USER];
    return str ? str : @"0" ;
}

// 添加一个用户
+ (void)addUser:(NSString *)userCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *users = [defaults objectForKey:Submit_Code_Key];
    if (users)
    {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:users];
        [arr addObject:userCode];
        [defaults setObject:arr forKey:Submit_Code_Key];
    }
    else
    {
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:userCode, nil];
        [defaults setObject:arr forKey:Submit_Code_Key];
    }
    [defaults synchronize];
}

#pragma mark - Unlock operations

// 为用户设置解锁的条目
+ (void)setUnlockModel:(NSString *) userCode models:(NSArray *) models
{
    NSString *key = [NSString stringWithFormat:@"%@_%@", CHNWORD_UNLOCK_USER, userCode];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *hasSet = [self getUnlockModel:userCode];
    NSMutableArray *set = [NSMutableArray arrayWithArray:hasSet];
    
    for (NSString *modelIndex in models)
    {
        if ([self isContain:hasSet object:modelIndex])
        {
            [set addObject:modelIndex];
        }
    }
    
    [defaults setObject:set forKey:key];
    [defaults synchronize];
}

// 得到某用户解锁的条目
+ (NSArray *)getUnlockModel:(NSString *) userCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [NSMutableArray array];
    NSString *key = [NSString stringWithFormat:@"%@_%@", CHNWORD_UNLOCK_USER, userCode];
    
    NSArray *unlocked = [defaults objectForKey:key];
    if (unlocked)
        [arr addObjectsFromArray:unlocked];
    return arr;
}

// 是否一个用户解锁了全部
+ (BOOL)isUnlockAllForUser:(NSString *) userCode
{
    BOOL result = false;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%@_%@", CHNWORD_UNLOCK_ALL_USER, userCode];
    NSString *value = [defaults objectForKey:key];
    if (value && [@"unlock_all" isEqualToString:value])
        result = true;
    
    return result;
}

// 设置一个用户解锁了全部
+ (void)setUnlockAllModelsForUser:(NSString *) userCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%@_%@", CHNWORD_UNLOCK_ALL_USER, userCode];
    [defaults setObject:@"unlock_all" forKey:key];
    [defaults synchronize];
}

#pragma mark - Default modules and words
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ----- default
+ (void)setDefaultModule:(NSArray *) modules
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:modules forKey:@"DEFAULT_MODULE"];
    [defaults synchronize];
}

+ (NSArray *)getDefaultModule
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [defaults objectForKey:@"DEFAULT_MODULE"];
    if (arr) {
        return arr;
    }else {
        return [NSArray array];
    }
}

+ (void)setDefaultWord:(NSArray *) word forModule:(NSString *) moduleCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:word forKey:[NSString stringWithFormat:@"%@_DEFAULT_MODULE_WORDS", moduleCode]];
    [defaults synchronize];
}

+ (NSArray *)getDefaultWord:(NSString *) moduleCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *words = [defaults objectForKey:[NSString stringWithFormat:@"%@_DEFAULT_MODULE_WORDS", moduleCode]];
    if (words)
        return words;
    else
        return [NSArray array];
}

#pragma mark - Logined users' modules and words
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//----  users
+ (void)setDefaultModule:(NSArray *) modules forUser:(NSString *) userCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:modules forKey:[NSString stringWithFormat:@"%@_DEFAULT_MODULE", userCode]];
    [defaults synchronize];
}

+ (NSArray *)getDefaultModule:(NSString *) userCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *modules = [defaults objectForKey:[NSString stringWithFormat:@"%@_DEFAULT_MODULE", userCode]];
    if (modules)
        return modules;
    else
        return [NSArray array];
}

+ (void)setDefaultWord:(NSArray *) word forModule:(NSString *) moduleCode andUser:(NSString *) userCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:word forKey:[NSString stringWithFormat:@"%@_%@_MODULE_WORD", userCode, moduleCode]];
    [defaults synchronize];
}

+ (NSArray *)getDefaultWord:(NSString *) moduleCode forUser:(NSString *) userCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *words = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@_MODULE_WORD", userCode, moduleCode]];
    if (words)
        return words;
    else
        return [NSArray array];
}

#pragma mark - Helper functions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL) isContain:(NSArray *) arr object:(NSString *) str
{
    BOOL isContain = false;
    if (!str)
        return isContain;
    
    for (NSString *string in arr)
    {
        if (!string)
            continue;
        
        if (![@"" isEqualToString:str] && ![@"" isEqualToString:str] && [str isEqualToString:string])
        {
            isContain = true;
            break;
        }
    }
    
    return isContain;
}

@end
