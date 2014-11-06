//
//  CHJAppDelegate.m
//  CHJCalendar
//
//  Created by Vivian L on 14-8-4.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "CHJAppDelegate.h"

@implementation CHJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    // self.window.backgroundColor = [UIColor whiteColor];
    // [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //这个方法定义的是当应用程序退到后台时将执行的方法，按下home键执行（通知中心来调度）
    //实现此方法的目的是将托管对象上下文存储到数据存储区，防止程序退出时有未保存的数据
    NSError *error;
    if (self.managedObjectContext != nil) {
        //hasChanges方法是检查是否有未保存的上下文更改，如果有，则执行save方法保存上下文
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
            NSLog(@"Error: %@,%@",error,[error userInfo]);
            abort();
        }
    }
}

-(NSManagedObjectModel *)getManagedObjectModel
{
//    NSLog(@"Trying to get managedObjectModel");
    if (self.managedObjectModel != nil) {
//        NSLog(@"managedObjectModel is not nil");
        return self.managedObjectModel;
    }
//    NSLog(@"need to init mangedObjectModel");
    self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return self.managedObjectModel;
}

-(NSPersistentStoreCoordinator *)getPersistentStoreCoordinator
{
//    NSLog(@"Trying to get persisitentStoreCoordinator");
    if (self.persistentStoreCoordinator != nil) {
        return self.persistentStoreCoordinator;
    }
    
    //得到数据库的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //CoreData是建立在SQLite之上的，数据库名称需与Xcdatamodel文件同名
    NSURL *storeUrl = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"Main.xcdatamodeld"]];
    NSError *error = nil;
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self getManagedObjectModel]];
    
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    
    return self.persistentStoreCoordinator;
}

-(NSManagedObjectContext *)getManagedObjectContext {
//    NSLog(@"Tring to get managedObjectContext");
    if (self.managedObjectContext != nil) {
//        NSLog(@"managedObjectContext is not nil");
        return self.managedObjectContext;
    }
//    NSLog(@"need to init mangedObjectContext");
    NSPersistentStoreCoordinator *coordinator =[self getPersistentStoreCoordinator];
    
    if (coordinator != nil) {
        self.managedObjectContext = [[NSManagedObjectContext alloc]init];
        [self.managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return self.managedObjectContext;
}

-(void)prepareAllCHJEvents {
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CHJEvent"
                                              inManagedObjectContext:[self getManagedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    NSLog(@"Number of records: %d", [fetchedRecords count]);
    // Returning Fetched Records
    self.allEvents = fetchedRecords;
    
    [self prepareWeekDayEvents];
}

-(void)prepareWeekDayEvents {
    if (self.allEvents == nil) {
        [self prepareAllCHJEvents];
    }
    self.weekDayEvents = [CHJEvent arrayToWeekDayDict:self.allEvents];
}

-(NSMutableDictionary *)getWeekDayEvents {
    if (self.weekDayEvents == nil) {
        [self prepareWeekDayEvents];
    }
    return self.weekDayEvents;
}

-(void)scheduleNotifications:(NSString *)text scheduleForDateTime:(NSDate *)datetime {
    UILocalNotification* e = [[UILocalNotification alloc] init];
    e.fireDate = datetime;
    e.alertBody = text;
    e.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification: e];
}

@end
