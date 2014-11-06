//
//  CHJAppDelegate.h
//  CHJCalendar
//
//  Created by Vivian L on 14-8-4.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "CHJEvent.h"

@interface CHJAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


//数据模型对象
@property(strong,nonatomic) NSManagedObjectModel *managedObjectModel;
//上下文对象
@property(strong,nonatomic) NSManagedObjectContext *managedObjectContext;
//持久性存储区
@property(strong,nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSArray *allEvents;
@property (strong, nonatomic) NSMutableDictionary *weekDayEvents;

//初始化Core Data使用的数据库
-(NSPersistentStoreCoordinator *)getPersistentStoreCoordinator;

//managedObjectModel的初始化赋值函数
-(NSManagedObjectModel *)getManagedObjectModel;

//managedObjectContext的初始化赋值函数
-(NSManagedObjectContext *)getManagedObjectContext;

-(void)prepareAllCHJEvents;
-(NSMutableDictionary *)getWeekDayEvents;

-(void)scheduleNotifications:(NSString *)text scheduleForDateTime:(NSDate *)datetime;

@end
