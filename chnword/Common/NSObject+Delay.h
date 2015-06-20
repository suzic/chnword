//
//  NSObject+Delay.h
//  Chnword
//
//  Created by khtc on 15/4/27.
//  Copyright (c) 2015年 chnword. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Delay)

- (void) performBlock:(void(^)(void)) block afterDelay:(NSTimeInterval) delay;

@end
