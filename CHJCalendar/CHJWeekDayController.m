//
//  CHJWeekDayController.m
//  CHJCalendar
//
//  Created by Vivian L on 14-8-11.
//  Copyright (c) 2014年 Vivian L. All rights reserved.
//

#import "CHJWeekDayController.h"
#import "CHJUIUtility.h"
#import "CHJWeekDayTableViewCell.h"
#import "CHJDayHourController.h"
#import "CHJTabBarController.h"
#import "CHJAddEventController.h"
#import "CHJEvent.h"


@interface CHJWeekDayController ()

@property (strong, nonatomic) CHJAppDelegate *myDelegate;
@property (strong, nonatomic) NSMutableDictionary *eventToOverlay;
@property (strong, nonatomic) NSMutableDictionary *rowToOverlay;
@property (strong, nonatomic) NSMutableDictionary *rowToDate;

@end

@implementation CHJWeekDayController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.now = [NSDate date];
    self.nowComps = [CHJUIUtility getDateComponents:self.now];
    
    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    weekday.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [weekday setDateFormat: @"EEEE"];
    NSDateFormatter *yearday = [[NSDateFormatter alloc] init];
    [yearday setDateFormat: @"yyyy年MM月dd日"];
    
    UIButton *titleButton = [CHJUIUtility makeTitleButton:[yearday stringFromDate:self.now] subtitle:[weekday stringFromDate:self.now] actionTarget:self action:@selector(toCurrentDayAction:)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:titleButton];
    self.navigationItem.leftBarButtonItem = barButton;
    
    UIBarButtonItem *addEntryButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEntryAction:)];
    
    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(moreAction:)];
    
    NSArray *rightButtons = [[NSArray alloc] initWithObjects:addEntryButton, moreButton, nil];
    self.navigationItem.rightBarButtonItems = rightButtons;
    
    self.tableView.rowHeight = 60;
    self.myDelegate = (CHJAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.eventToOverlay = [[NSMutableDictionary alloc] init];
    self.rowToOverlay = [[NSMutableDictionary alloc] init];

    self.rowToDate = [[NSMutableDictionary alloc] init];
    int todayBias = [self.nowComps weekday];
    for (int i = 1; i <= 7; i++) {
        int thatDayInt = i - todayBias;
        NSDate *thatDay = [self.now dateByAddingTimeInterval:thatDayInt * 24 * 3600];
        NSNumber *dayRowIdx = [[NSNumber alloc] initWithInt:i];
        [self.rowToDate setObject:thatDay forKey:dayRowIdx];
//        NSLog(@"Day: %@: %@", dayRowIdx, thatDay);
    }
    
    // NSMutableArray *data = [CHJEvent createTestData];
    // self.data = [self.myDelegate getAllCHJEvents];
    // weekDayEvents = [CHJEvent arrayToWeekDayDict:self.data];
    
    [self.myDelegate scheduleNotifications:@"测试提醒" scheduleForDateTime:[NSDate dateWithTimeIntervalSinceNow:5]];
    NSLog(@"%d", self.navigationController.tabBarController.selectedIndex);
}

- (void)viewWillAppear:(BOOL)animated {
//    NSLog(@"Entering viewWillAppear for WeekDay");
    [super viewWillAppear:animated];
    
    for(id key in self.eventToOverlay) {
//        NSLog(@"Removing subview for key: %@", key);
        UIView *subview = [self.eventToOverlay objectForKey:key];
        [subview removeFromSuperview];
    }
    [self.eventToOverlay removeAllObjects];
    
    // self.data = [self.myDelegate getAllCHJEvents];
    // NSLog(@"Get all data: %@", self.data);
    // the previous logic has been changed into "prepareAllEvents"
    [self.myDelegate prepareAllCHJEvents];

//    self.weekDayEvents = [CHJEvent arrayToWeekDayDict:self.data];
//    NSLog(@"WeekDayEvents, size: %d; : %@", [self.weekDayEvents count], self.weekDayEvents);
    
    [self.tableView reloadData]; // to reload selected cell
}

- (void)renderWeekDayEvents:(NSArray *)dayEvents forCell:(UITableViewCell *)cell forKey:(NSNumber *)key {
    NSMutableArray *dayOverlays = [self.rowToOverlay objectForKey:key];
    for (UIView *overlay in dayOverlays) {
        [overlay removeFromSuperview];
    }
    for (int i = 0; i < dayEvents.count; i++) {
        CHJEvent *item = dayEvents[i];
//        NSManagedObjectID *eventID = [item objectID];
        UIView *eventView = [CHJUIUtility createOverlayForWeekDay:item.title startDateTime:item.startDateTime endDateTime:item.endDateTime indent:i];
        [self.eventToOverlay setObject:eventView forKey:[item objectID]];
        [dayOverlays addObject:eventView];
        [cell.contentView addSubview:eventView];
    }
}

- (void)addEntryAction:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CHJAddEventController *detailsViewController = [storyboard instantiateViewControllerWithIdentifier:@"CHJAddEventController"];
    [self.navigationController pushViewController:detailsViewController animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}

- (void)moreAction:(id)sender {
    //NSLog(@"more action");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CHJDayHourController *detailsViewController = [storyboard instantiateViewControllerWithIdentifier:@"CHJMonthViewController"];
    [self.navigationController pushViewController:detailsViewController animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}

- (void)toCurrentDayAction:(id)sender {
    NSLog(@"going to the current day view");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHJWeekDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeekDayCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CHJWeekDayTableViewCell" bundle:nil] forCellReuseIdentifier:@"WeekDayCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"WeekDayCell"];
    }
    
    int dayForRow = indexPath.row + 1;
    NSNumber *dayForRowNum = [[NSNumber alloc] initWithInt:dayForRow];
    
    if (dayForRow == [self.nowComps weekday]) {
        cell.currentDayIndicator.backgroundColor = [UIColor grayColor];
    } else {
        cell.currentDayIndicator.backgroundColor = [UIColor clearColor];
    }
    
    NSString *weekdayName = [CHJUIUtility integerToCNString:dayForRow];
    cell.weekDayLabel.text = [NSString stringWithFormat:@"周%@", weekdayName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ([self.rowToOverlay objectForKey:dayForRowNum] == nil) {
        [self.rowToOverlay setObject:[[NSMutableArray alloc] init] forKey:dayForRowNum];
    }
    NSMutableDictionary *weekDayEvents = [self.myDelegate getWeekDayEvents];
    NSArray *data = [weekDayEvents objectForKey:dayForRowNum];
//    NSLog(@"going to render day events for %d", dayForRow);
    
    [self renderWeekDayEvents:data forCell:cell forKey:dayForRowNum];
//    NSLog(@"For day: %d; size: %d.", indexPath.row, data.count);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];//1.
    
    // hide button bar
    self.hidesBottomBarWhenPushed = YES;

    int today = [self.nowComps weekday];
    int dayForRow = indexPath.row + 1;
    NSNumber *dayForRowNum = [[NSNumber alloc] initWithInt:dayForRow];
    
//    CHJDayHourController *detailsViewController = [[CHJDayHourController alloc] initWithNibName:@"CHJDayHourController" bundle:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CHJDayHourController *detailsViewController = [storyboard instantiateViewControllerWithIdentifier:@"CHJDayHourController"];

//    detailsViewController.weekDayEvents = self.weekDayEvents;
    detailsViewController.targetDay = dayForRow;
    detailsViewController.needHourIndicator = today == dayForRow;
    detailsViewController.forDay = [self.rowToDate objectForKey:dayForRowNum];
    
    [self.navigationController pushViewController:detailsViewController animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
