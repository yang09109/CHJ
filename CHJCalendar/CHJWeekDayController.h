//
//  CHJWeekDayController.h
//  CHJCalendar
//
//  Created by Vivian L on 14-8-11.
//  Copyright (c) 2014年 Vivian L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHJWeekDayController : UITableViewController

@property (nonatomic) NSDate *now;
@property (nonatomic) NSDateComponents *nowComps;

- (void)addEntryAction:(id)sender;
- (void)moreAction:(id)sender;
- (void)toCurrentDayAction:(id)sender;

@end
