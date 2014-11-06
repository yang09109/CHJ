//
//  CHJEvent.m
//  CHJCalendar
//
//  Created by Vivian L on 14-9-19.
//  Copyright (c) 2014年 Vivian L. All rights reserved.
//

#import "CHJEvent.h"
#import "CHJUIUtility.h"

@implementation CHJEvent

@dynamic title;
@dynamic content;

@dynamic endDateTime;
@dynamic startDateTime;

@dynamic eventId;
@dynamic userId;

+(NSDictionary *)arrayToWeekDayDict:(NSArray *)data {
    NSMutableDictionary *res = [[NSMutableDictionary alloc] init];
    // init the map: for each key, there is an array
    for (int i = 1; i <= 7; i++) {
        NSNumber *key = [[NSNumber alloc] initWithInt:i];
        NSMutableArray *events = [[NSMutableArray alloc] init];
        [res setObject:events forKey:key];
    }
    // doing the real job..
    for (int i = 0; i < data.count; i++) {
        CHJEvent *item = data[i];
        NSDateComponents *comps = [CHJUIUtility getDateComponents:item.startDateTime];
        NSNumber *weekDay = [[NSNumber alloc] initWithInt:[comps weekday]];
        [[res objectForKey:weekDay] addObject:item];
//        NSLog(@"Adding entry for day: %d; size: %d.", [comps weekday], [[res objectForKey:weekDay] count]);
    }
    return res;
}
/*
+(NSMutableArray *)createTestData:(NSMutableArray *)titles startDateTimeArray:(NSMutableArray *)start endDateTimeArray:(NSMutableArray *)end {
    NSMutableArray *res = [[NSMutableArray alloc] init];
    for (int i = 0; i < titles.count; i++) {
        CHJEvent *item = [[CHJEvent alloc] initWithTitle:titles[i] content:@"Test Content" startDateTime:start[i] endDateTime:end[i]];
        [res addObject:item];
    }
    return res;
}
*/

/*
-(id)initWithTitle:(NSString *)_title content:(NSString *)_content
      startDateTime:(NSDate *)start endDateTime:(NSDate *)end {
    self.title = title;
    self.content = content;
    
    self.startDateTime = start;
    self.endDateTime = end;
    
    self.userId = 0;
    
    return self;
}
 */

-(NSString *)description {
    return [NSString stringWithFormat:@"%@: %@-%@", self.title, self.startDateTime, self.endDateTime];
}

/*
+(NSMutableArray *)createTestData {
    NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:
                              @"测试一", @"测试二", @"测试三", nil
                              ];
    
    NSDate *now = [NSDate date];
    NSDate *twoHoursAgo = [[NSDate alloc] initWithTimeInterval:-120*60 sinceDate:now];
    NSDate *halfHourLater = [[NSDate alloc] initWithTimeInterval:30*60 sinceDate:now];
    NSDate *halfHourAgo = [[NSDate alloc] initWithTimeInterval:-30*60 sinceDate:now];
    NSDate *yesterday = [[NSDate alloc] initWithTimeInterval:-24*60*60 sinceDate:now];
    NSDate *yesterdayLater = [[NSDate alloc] initWithTimeInterval:-23*60*60 sinceDate:now];
    
    NSMutableArray *startDateTime = [[NSMutableArray alloc]initWithObjects:
                                     twoHoursAgo, now, yesterday, nil];
    
    NSMutableArray *endDateTime = [[NSMutableArray alloc] initWithObjects:halfHourAgo, halfHourLater, yesterdayLater, nil];
    
    NSMutableArray *res = [self createTestData:titles startDateTimeArray:startDateTime endDateTimeArray:endDateTime];
    
    return res;
}
*/
@end
