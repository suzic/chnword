//
//  NetParamFactory.m
//  chnword
//
//  Created by khtc on 15/6/23.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "NetParamFactory.h"

@implementation NetParamFactory

/**
 *  验证接口
 */
+ (NSDictionary *) verifyParam:(NSString *) opid userid:(NSString *) userid device:(NSString *) deviceId code:(NSString *) code user:(NSString *) user
{
    NSDictionary *dict = @{@"opid":opid,
                           @"userid": userid,
                           @"device": deviceId,
                           @"param": @{
                                   @"code": code,
                                   @"user": user}
                           };
    
    return dict;
}

/**
 *  一级模块接口
 */
+ (NSDictionary *) listParam:(NSString *) opid userid:(NSString *) userid device:(NSString *) deviceId page:(int) page size:(int) size
{
    NSDictionary *dict = @{@"opid":opid,
                           @"userid": userid,
                           @"device": deviceId,
                           @"param": @{
                                   @"page": [NSString stringWithFormat:@"%d", page],
                                   @"size": [NSString stringWithFormat:@"%d", size]}
                           };
    
    return dict;
}

/**
 *  @depressed
 *  二级模块接口
 */
+ (NSDictionary *) subListParam:(NSString *) opid userid:(NSString *) userid device:(NSString *) deviceId lists:(NSArray *) zoneList page:(int) page size:(int) size
{
    NSDictionary *dict = @{@"opid":opid,
                           @"userid": userid,
                           @"device": deviceId,
                           @"param": @{
                                   @"list": zoneList,
                                   @"page": [NSString stringWithFormat:@"%d", page],
                                   @"size": [NSString stringWithFormat:@"%d", size]}
                           };
    
    return dict;
}

/**
 *  二级模块接口
 */
+ (NSDictionary *) subListParam:(NSString *) opid userid:(NSString *) userid device:(NSString *) deviceId zone:(NSString *) zoneList page:(int) page size:(int) size
{
    NSDictionary *dict = @{@"opid":opid,
                           @"userid": userid,
                           @"device": deviceId,
                           @"param": @{
                                   @"list": zoneList,
                                   @"page": [NSString stringWithFormat:@"%d", page],
                                   @"size": [NSString stringWithFormat:@"%d", size]}
                           };
    
    return dict;
}

/**
 *  word接口
 */
+ (NSDictionary *) wordParam:(NSString *) opid userid:(NSString *) userid device:(NSString *) deviceId word:(NSString *) word
{
    NSDictionary *dict = @{@"opid":opid,
                           @"userid": userid,
                           @"device": deviceId,
                           @"param": @{
                                   @"word_code": word}
                           };
    
    return dict;
}

/**
 *  show接口
 */
+ (NSDictionary *) showParam:(NSString *) opid userid:(NSString *) userid device:(NSString *) deviceId wordCode:(NSString *) wordCode
{
    NSDictionary *dict = @{@"opid":opid,
                           @"userid": userid,
                           @"device": deviceId,
                           @"param": @{
                                   @"word_code": wordCode}
                           };
    
    return dict;
}

/**
 *  注册接口
 */
+ (NSDictionary *) registParam:(NSString *) opid userid:(NSString *) userid device:(NSString *) deviceId userCode:(NSString *) userCode deviceId:(NSString *) device session:(NSString *) sessionId verify:(NSString *) verifyCode
{
    NSDictionary *dict = @{@"opid":opid,
                           @"userid": userid,
                           @"device": deviceId,
                           @"param": @{
                                   @"usercode": userCode,
                                   @"deviceid": device,
                                   @"session": sessionId,
                                   @"verify": verifyCode}
                           };
    
    return dict;
}



@end
