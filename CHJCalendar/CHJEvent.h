//
//  CHJEvent.h
//  CHJCalendar
//
//  Created by Vivian L on 14-9-19.
//  Copyright (c) 2014年 Vivian L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CHJEvent : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;

@property (nonatomic, retain) NSDate * startDateTime;
@property (nonatomic, retain) NSDate * endDateTime;

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * eventId;

+(NSDictionary *)arrayToWeekDayDict:(NSArray *)data;
// +(NSMutableArray *)createTestData;


@end
