//
//  DataManager.m
//  chnword
//
//  Created by khtc on 15/6/23.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "DataManager.h"


static NSString *const CoreDataModelFileName = @"chnword";


@interface DataManager ()

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *defaultPrivateQueueContext;

@end



@implementation DataManager


- (id) init
{
    if (self = [super init])
    {
        // NO default NOW!
        //[self addDefalutData];
        
        // 监听程序进入前后台
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterbackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)applicationWillEnterbackground:(NSNotification *)notification
{
    [self saveContext];
}

// 存储当前的数据
- (void)saveContext
{
    NSError *error = nil;
    if (self.defaultPrivateQueueContext)
    {
        if ([self.defaultPrivateQueueContext hasChanges] && ![self.defaultPrivateQueueContext save:&error]) {
            NSAssert(nil, @"failed to saveContext. error:%@", error);
        }
    }
}

+ (instancetype)defaultInstance
{
    static DataManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

#pragma mark - Singleton Access

+ (NSManagedObjectContext *)newMainQueueContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.parentContext = [self defaultPrivateQueueContext];
    
    return context;
}

+ (NSManagedObjectContext *)newPrivateQueueContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.parentContext = [self defaultPrivateQueueContext];
    
    return context;
}

+ (NSManagedObjectContext *)defaultPrivateQueueContext
{
    return [[self defaultInstance] defaultPrivateQueueContext];
}

+ (NSManagedObjectID *)managedObjectIDFromString:(NSString *)managedObjectIDString
{
    return [[[self defaultInstance] persistentStoreCoordinator] managedObjectIDForURIRepresentation:[NSURL URLWithString:managedObjectIDString]];
}


/**
 *  @abstract 返回在默认Context的obj对象
 */
+ (NSManagedObject *) existObjextOnDefaultContext:(NSManagedObject *) obj
{
    NSManagedObject *ano = [[self defaultPrivateQueueContext] existingObjectWithID:obj.objectID error:nil];
    return ano;
}

/**
 *  @abstract 返回在默认Context的obj对象
 *  @param arr 集合对象
 *  @return 默认Context上对象的集合
 */
+ (NSArray *) existObjectsOnDefaultContext:(NSArray *) arr
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:arr.count];
    NSManagedObjectContext *context = [self defaultPrivateQueueContext];
    
    for (NSManagedObject *obj  in arr) {
        [array addObject:[context existingObjectWithID:obj.objectID error:nil]];
    }
    return array;
}

/**
 *  @abstract
 *  @param arr  NSManagedObject对象
 *  @param context 指定的context对象
 *  @return context上的对象
 */
+ (NSManagedObject *) existObjext:(NSManagedObject *) obj onContext:(NSManagedObjectContext *) context
{
    NSManagedObject *ano = [context existingObjectWithID:obj.objectID error:nil];
    return ano;
}

/**
 *  @abstract
 *  @param arr NSManagedObject对象集合
 *  @param context 指定的context对象
 *  @return context上对象的集合
 */
+ (NSArray *) existObjects:(NSArray *) arr onContext:(NSManagedObjectContext *) context
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:arr.count];
    for (NSManagedObject *obj in arr) {
        [array addObject:[context existingObjectWithID:obj.objectID error:nil]];
    }
    return array;
}


#pragma mark - Getters

- (NSManagedObjectContext *)defaultPrivateQueueContext
{
    if (!_defaultPrivateQueueContext)
    {
        _defaultPrivateQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _defaultPrivateQueueContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    return _defaultPrivateQueueContext;
}

#pragma mark - Stack Setup

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator)
    {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSError *error = nil;
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:[self persistentStoreURL]
                                                             options:[self persistentStoreOptions]
                                                               error:&error])
        {
            NSLog(@"Error adding persistent store. %@, %@", error, error.userInfo);
        }
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel)
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:CoreDataModelFileName withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}

- (NSURL *)persistentStoreURL
{
    NSString *appName = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    appName = [appName stringByAppendingString:@".sqlite"];
    
    return [[self appLibraryDirectory] URLByAppendingPathComponent:appName];
}

- (NSDictionary *)persistentStoreOptions
{
    //    //处理部分数据保存，用以保证所有的数据都会被保存。是以sqlite方式存储的必备形式
    //    NSMutableDictionary *pragmaOptions = [NSMutableDictionary dictionary];
    //    [pragmaOptions setObject:@"NORMAL" forKey:@"synchronous"];
    //    [pragmaOptions setObject:@"1" forKey:@"fullfsync"];
    //    NSDictionary *storeOptions = [NSDictionary dictionaryWithObject:pragmaOptions forKey:NSSQLitePragmasOption];
    //    return storeOptions;
    //    return @{NSInferMappingModelAutomaticallyOption: @YES, NSMigratePersistentStoresAutomaticallyOption: @YES, NSSQLitePragmasOption: @{@"synchronous": @"OFF"}};
    return @{NSInferMappingModelAutomaticallyOption: @YES, NSMigratePersistentStoresAutomaticallyOption: @YES, NSSQLitePragmasOption: @{@"synchronous": @"ON"}};
}

- (NSURL *)appLibraryDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
