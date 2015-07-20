//
//  Util.h
//  Chnword
//
//  Created by khtc on 15/5/13.
//  Copyright (c) 2015年 chnword. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (NSString *) generateUuid;

+ (NSString *) getUdid;

/**
 *  验证码接口，未验证
 */
+(NSString *) phoneNumber;

@end
