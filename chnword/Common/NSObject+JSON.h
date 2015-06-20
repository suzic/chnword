//
//  NSObject+JSON.h
//  Chnword
//
//  Created by khtc on 15/5/17.
//  Copyright (c) 2015年 chnword. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JSON)
/*!
 json encode
 */
- (NSString *)jsonString;

- (NSData *)jsonData;

/*!
 json decode
 */
- (id)jsonValue;


@end
