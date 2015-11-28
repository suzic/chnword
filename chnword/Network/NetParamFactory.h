//
//  NetParamFactory.h
//  chnword
//
//  Created by khtc on 15/6/23.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetParamFactory : NSObject

/**
 *  验证用户码接口
 */
+ (NSDictionary *)verifyParam:(NSString *) opid userid:(NSString *) userid device:(NSString *) deviceId code:(NSString *) code;

/**
 * 发送验证码请求
 */
+ (NSDictionary *)sendParam:(NSString *) opid userid:(NSString *) userid device:(NSString *) deviceId code:(NSString *) code;

/**
 *  一级模块接口
 */
+ (NSDictionary *)listParam:(NSString *) opid userid:(NSString *) userid device:(NSString *) deviceId page:(int) page size:(int) size;

/**
 *  @depressed
 */
+ (NSDictionary *)subListParam:(NSString *) opid userid:(NSString *) userid device:(NSString *) deviceId lists:(NSArray *) zoneList page:(int) page size:(int) size;

/**
 *  二级模块接口
 */
+ (NSDictionary *)subListParam:(NSString *) opid userid:(NSString *) userid device:(NSString *) deviceId zone:(NSString *) zoneList page:(int) page size:(int) size;

/**
 *  word接口
 */
+ (NSDictionary *)wordParam:(NSString *) opid userid:(NSString *) userid device:(NSString *) deviceId word:(NSString *) word;

/**
 *  show接口
 */
+ (NSDictionary *)showParam:(NSString *) opid userid:(NSString *) userid device:(NSString *) deviceId wordCode:(NSString *) wordCode;

/**
 *  登录接口
 */
+ (NSDictionary *)loginParam:(NSString *) opid userid:(NSString *) userid device:(NSString *) deviceId userCode:(NSString *) userCode deviceId:(NSString *) deviceId session:(NSString *) sessionId verify:(NSString *) verifyCode;

@end
