//
//  CHJDayHourController.h
//  CHJCalendar
//
//  Created by Vivian L on 14-8-11.
//  Copyright (c) 2014年 Vivian L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHJDayHourController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic) NSDate *forDay;
@property (nonatomic) int targetDay;
@property (nonatomic) BOOL needHourIndicator;
@property (nonatomic) int currentHour;
@property (nonatomic) NSDate *now;
@property (nonatomic) NSMutableArray *myOverlays;

- (void)addEntryAction:(id)sender;
- (void)moreAction:(id)sender;
- (void)titleAction:(id)sender;
- (IBAction)selectEventHandler:(UITapGestureRecognizer *)recognizer;

@end
