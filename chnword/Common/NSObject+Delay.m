//
//  NSObject+Delay.m
//  Chnword
//
//  Created by khtc on 15/4/27.
//  Copyright (c) 2015年 chnword. All rights reserved.
//

#import "NSObject+Delay.h"

@implementation NSObject (Delay)

- (void) performBlock:(void(^)(void)) block afterDelay:(NSTimeInterval) delay
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}
@end
