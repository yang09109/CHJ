//
//  CHJUIUtility.h
//  CHJCalendar
//
//  Created by Vivian L on 14-8-6.
//  Copyright (c) 2014年 Vivian L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHJUIUtility : NSObject

+ (UIButton *)makeTitleButton:(NSString *)title subtitle:(NSString *)subtitle actionTarget:(id)target action:(SEL)action;
+ (NSString *)integerToCNString:(NSInteger) integer;

+ (UIView *)createOverlayForDayHour:(NSString *)title startTime:(NSDate *)start endTime:(NSDate *)end indent:(NSInteger)indent;
+ (UIView *)createOverlayForWeekDay:(NSString *)title startDateTime:(NSDate *)start endDateTime:(NSDate *)end indent:(int)indent;

+ (NSDateComponents *)getDateComponents:(NSDate *)date;

+ (void)exitApplication:(UIView *)view;
+ (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end
