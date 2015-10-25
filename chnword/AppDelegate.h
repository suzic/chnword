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

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (assign, nonatomic) BOOL isLogin;
@property (assign, nonatomic) BOOL goSuit;

/**
 * @abstract 获取静态单例应用代理对象
 */
+ (AppDelegate *)sharedDelegate;

//- (NSURL *)applicationDocumentsDirectory;

@end

