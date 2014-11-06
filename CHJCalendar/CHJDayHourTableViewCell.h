//
//  CHJDayHourTableViewCell.h
//  CHJCalendar
//
//  Created by Vivian L on 14-8-10.
//  Copyright (c) 2014年 Vivian L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHJDayHourTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *currentHourIndicator;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;

@end
