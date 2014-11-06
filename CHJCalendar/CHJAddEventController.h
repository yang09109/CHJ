//
//  CHJAddEventController.h
//  CHJCalendar
//
//  Created by Vivian L on 14-8-11.
//  Copyright (c) 2014年 Vivian L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHJAppDelegate.h"

@interface CHJAddEventController : UIViewController<UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *endDate;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *startDate;

@property (weak, nonatomic) IBOutlet UIButton *endButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UIView *endDateView;
@property (weak, nonatomic) IBOutlet UIView *startDateView;

@property (weak, nonatomic) IBOutlet UITextField *eventTextField;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (weak, nonatomic) NSDate *startDateTime;
@property (weak, nonatomic) NSDate *endDateTime;

/*
@property (nonatomic) UIDatePicker *datepicker;
@property (nonatomic) UIPopoverController *popOverForDatePicker;
*/

@property (strong, nonatomic) CHJAppDelegate *myDelegate;

- (void)cancelEvent:(id)sender;
- (void)saveEvent:(id)sender;

- (void)startButtonEvent:(id)sender;
- (void)endButtonEvent:(id)sender;

-(void)dismissDatePicker:(id)sender;

@end
