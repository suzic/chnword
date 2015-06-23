//
//  DataManager.h
//  chnword
//
//  Created by khtc on 15/6/23.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ENTITY_NAME_        @""

@interface DataManager : NSObject

+ (instancetype)defaultInstance;

+ (NSManagedObjectContext *)newMainQueueContext;
+ (NSManagedObjectContext *)defaultPrivateQueueContext;
+ (NSManagedObjectContext *)newPrivateQueueContext;

- (void)saveContext;

/**
 *  @abstract 返回在默认Context的obj对象
 */
+ (NSManagedObject *) existObjextOnDefaultContext:(NSManagedObject *) obj;

/**
 *  @abstract 返回在默认Context的obj对象
 *  @param arr 集合对象
 *  @return 默认Context上对象的集合
 */
+ (NSArray *) existObjectsOnDefaultContext:(NSArray *) arr;

/**
 *  @abstract
 *  @param arr  NSManagedObject对象
 *  @param context 指定的context对象
 *  @return context上的对象
 */
+ (NSManagedObject *) existObjext:(NSManagedObject *) obj onContext:(NSManagedObjectContext *) context;

/**
 *  @abstract
 *  @param arr NSManagedObject对象集合
 *  @param context 指定的context对象
 *  @return context上对象的集合
 */
+ (NSArray *) existObjects:(NSArray *) arr onContext:(NSManagedObjectContext *) context;


@end
