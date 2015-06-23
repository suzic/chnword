//
//  NetWorkManager.h
//  chnword
//
//  Created by khtc on 15/6/23.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkManager : NSObject

+ (void) postRequest:(NSString *) url param:(NSDictionary *) param success:(void (^)(id jsonObject)) success fail:(void (^)(void)) fail;


@end
