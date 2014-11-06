//
//  CHJMonthViewController.h
//  CHJCalendar
//
//  Created by Vivian L on 14-9-27.
//  Copyright (c) 2014年 Vivian L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSLCalendarView.h"

@interface CHJMonthViewController : UIViewController <DSLCalendarViewDelegate>

@property (weak, nonatomic) IBOutlet DSLCalendarView *calendarView;

@end
