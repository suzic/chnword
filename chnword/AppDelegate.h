//
//  AppDelegate.h
//  chnword
//
//  Created by 苏智 on 15/6/20.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// Core Data 数据成员
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 *  @abstract 当前是否登录
 */
@property (assign, nonatomic) BOOL isLogin;

/**
 *  @abstract 购买时直接进入购买套装的标记（区别商店有时需要直接跳转到套装界面）
 */
@property (assign, nonatomic) BOOL goSuit;

// 用于测试的静态数据
@property (strong, nonatomic) NSArray* cateNames;
@property (strong, nonatomic) NSArray* cateUnlocked;
@property (strong, nonatomic) NSArray* wordInTianWen;
@property (strong, nonatomic) NSArray* wordInTianWenDemo;

/**
 * @abstract 获取静态单例应用代理对象
 */
+ (AppDelegate *)sharedDelegate;

//- (NSURL *)applicationDocumentsDirectory;

@end

