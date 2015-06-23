//
//  NetWorkManager.m
//  chnword
//
//  Created by khtc on 15/6/23.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "NetWorkManager.h"
#import "AFNetworking.h"

@implementation NetWorkManager

+ (void) postRequest:(NSString *) url param:(NSDictionary *) param success:(void (^)(id jsonObject)) success fail:(void (^)(void)) fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//用于调试
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog ( @"operation: %@" , operation.responseString);
        if (success) {
            success(responseObject);
            //            调试使用
            //            success(dict);
        } else {
            if (fail) {
                fail();
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (fail) {
            fail();
        }
    }];
}

@end
