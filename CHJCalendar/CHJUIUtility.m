//
//  CHJUIUtility.m
//  CHJCalendar
//
//  Created by Vivian L on 14-8-6.
//  Copyright (c) 2014年 Vivian L. All rights reserved.
//

#import "CHJUIUtility.h"

@implementation CHJUIUtility

static NSCalendar *calendar;

const static int ROW_HEIGHT = 60;

+ (NSCalendar *)getCalendar {
    if (!calendar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    return calendar;
}

+ (NSDateComponents *)getDateComponents:(NSDate *)date {
    NSCalendar *calendar = [self getCalendar];
    NSInteger unitFlags = NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    return comps;
}

+ (UIButton *)makeTitleButton:(NSString *)title subtitle:(NSString *)subtitle actionTarget:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 120, 31)];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
    [label1 setFont:[UIFont fontWithName:@"Arial" size:15]];
    [label1 setText:title];
    [label1 setTextAlignment:NSTextAlignmentLeft];
    [label1 setTextColor:[UIColor blackColor]];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [button addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, 50, 20)];
    [label2 setFont:[UIFont fontWithName:@"Arial" size:10]];
    [label2 setText:subtitle];
    [label2 setTextAlignment:NSTextAlignmentLeft];
    [label2 setTextColor:[UIColor blackColor]];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [button addSubview:label2];
    
    return button;
}

+ (UIView *)createOverlayForDayHour:(NSString *)title startTime:(NSDate *)start endTime:(NSDate *)end indent:(NSInteger)indent {
//    NSLog(@"start date: %@; end date: %@", start, end);
    
    NSDateComponents *startTimeComps = [self getDateComponents:start];
    int startHour = [startTimeComps hour];
    int startMinute = [startTimeComps minute];
    
    NSDateComponents *endTimeComps = [self getDateComponents:end];
    int endHour = [endTimeComps hour];
    int endMinute = [endTimeComps minute];
    
    CGFloat startPoint = (startHour + startMinute/60.0) * ROW_HEIGHT;
    CGFloat length = ((endHour - startHour) + (endMinute - startMinute)/60.0) * ROW_HEIGHT;
    
//    NSLog(@"Start from %2d:%2d to %2d:%2d, CGRect: %0.2f for %0.2f",
//          startHour, startMinute,
//          endHour, endMinute,
//          startPoint, length);
    
    CGRect overlayFrame = CGRectMake(60 + 65*indent, startPoint, 60, length);
    UIView *overlay = [[UIView alloc] initWithFrame:(overlayFrame)];
    overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:13]];
    titleLabel.text = title;
    
    [overlay addSubview:titleLabel];
    
    return overlay;
}

+ (UIView *)createOverlayForWeekDay:(NSString *)title startDateTime:(NSDate *)start endDateTime:(NSDate *)end indent:(int)indent {
//    NSLog(@"overlay for week day date: %@; end date: %@", start, end);
    
    NSDateComponents *startTimeComps = [self getDateComponents:start];
    int startHour = [startTimeComps hour];
    int startMinute = [startTimeComps minute];
    
    NSDateComponents *endTimeComps = [self getDateComponents:end];
    int endHour = [endTimeComps hour];
    int endMinute = [endTimeComps minute];
    
/*    NSLog(@"Start from %2d:%2d to %2d:%2d",
          startHour, startMinute,
          endHour, endMinute);*/
    
    CGRect overlayFrame = CGRectMake(60 + 65*indent, 0, 60, 60);
    UIView *overlay = [[UIView alloc] initWithFrame:(overlayFrame)];
    overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:11]];
    titleLabel.text = title;
    
    UILabel *timeLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 60, 15)];
    [timeLabel1 setFont:[UIFont systemFontOfSize:9]];
    timeLabel1.text = [NSString stringWithFormat:@"起始：%02d:%02d", startHour, startMinute];
    
    UILabel *timeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 60, 15)];
    [timeLabel2 setFont:[UIFont systemFontOfSize:9]];
    timeLabel2.text = [NSString stringWithFormat:@"结束：%02d:%02d", endHour, endMinute];
    
    [overlay addSubview:titleLabel];
    [overlay addSubview:timeLabel1];
    [overlay addSubview:timeLabel2];
    
    return overlay;
}


static UIView *myOverlay;
static UIActivityIndicatorView *loading;
-(void)createLoadScreen:(UIView *)view {
    // return if the object is already created...
    if (myOverlay)
        return;
    
    // do the business otherwise
    CGRect screenRect = [view bounds];
    CGRect overlayFrame = CGRectMake(0.0, 0.0, screenRect.size.width / 2, screenRect.size.height / 2);
    myOverlay = [[UIView alloc] initWithFrame:overlayFrame];
    myOverlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    CGRect frame = CGRectMake(screenRect.size.width / 2 - 25.0, screenRect.size.height / 2 - 70, 25.0, 25.0);
    loading = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    [loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loading sizeToFit];
    loading.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                     UIViewAutoresizingFlexibleRightMargin |
                                     UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleBottomMargin);
    loading.hidesWhenStopped = YES;
    [myOverlay addSubview:loading];
}

+ (void)exitApplication:(UIView *)view {
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:view.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    view.window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

+ (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

-(void)showActivityIndicator:(UIView *)view {
    [view addSubview:myOverlay];
    [loading startAnimating];
}

-(void)removeActivityIndicator:(UIView *)view {
    [loading stopAnimating];
    [myOverlay removeFromSuperview];
}

+ (NSString *)integerToCNString:(NSInteger) integer {
    switch (integer) {
        case 2:
            return @"一";
        case 3:
            return @"二";
        case 4:
            return @"三";
        case 5:
            return @"四";
        case 6:
            return @"五";
        case 7:
            return @"六";
        case 1:
        default:
            return @"日";
    }
}



@end
