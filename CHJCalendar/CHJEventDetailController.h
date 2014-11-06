//
//  CHJEventDetailController.h
//  CHJCalendar
//
//  Created by Vivian L on 14-9-27.
//  Copyright (c) 2014年 Vivian L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHJEvent.h"

@interface CHJEventDetailController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *eventEndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventStartTimeLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;

@property (nonatomic, weak) CHJEvent *event;

- (IBAction)deleteEventAction:(id)sender;

@end
