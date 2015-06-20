//
//  NSObject+JSON.m
//  Chnword
//
//  Created by khtc on 15/5/17.
//  Copyright (c) 2015年 chnword. All rights reserved.
//

#import "NSObject+JSON.h"

@implementation NSObject (JSON)

/*!
 json encode
 */
- (NSString *)jsonString {
    NSError *error = nil;
    NSData *body = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

- (NSData *)jsonData {
    NSError *error = nil;
    NSData *body = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        return nil;
    }
    
    return body;
}

/*!
 json decode
 */
- (id)jsonValue {
    NSData *_data = nil;
    if ([self isKindOfClass:[NSData class]]) {
        _data = (NSData *)self;
    } else if ([self isKindOfClass:[NSString class]]) {
        NSString *dataString = (NSString *)self;
        _data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    if (_data) {
        NSError *error = nil;
        id value = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:&error];
        
        if (error) {
            return nil;
        }
        
        return value;
    }
    
    return nil;
}

@end
