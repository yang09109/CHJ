//
//  CHJSettingController.h
//  CHJCalendar
//
//  Created by Vivian L on 14-8-18.
//  Copyright (c) 2014年 Vivian L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHJSettingController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *exitCell;

- (void)exitEvent:(id)sender;

@end
