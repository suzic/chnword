//
//  Util.m
//  Chnword
//
//  Created by khtc on 15/5/13.
//  Copyright (c) 2015年 chnword. All rights reserved.
//

#import "Util.h"
#import "CHKeychain.h"

@implementation Util

+ (NSString *) generateUuid;
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    
    return uuidString;
}

+ (NSString *) getUdid
{
    static NSString *securyKey = @"com.chnword.chnword.SecuryKey";
    static NSString *securyKeyID = @"com.chnword.chnword.SecuryKey.DEVICEID";
    
    NSDictionary *dict = [CHKeychain load:securyKey];
    
    if (dict) {
        NSString *udid = [dict objectForKey:securyKey];
        if (udid) {
            return udid;
        }
    }
    NSString *udid = [self generateUuid];
    NSMutableDictionary *store = [NSMutableDictionary dictionary];
    [store setObject:udid forKey:securyKeyID];
    [CHKeychain save:securyKey data:store];
    
    
    return udid;
}
@end
