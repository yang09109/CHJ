//
//  CHJDayHourController.m
//  CHJCalendar
//
//  Created by Vivian L on 14-8-11.
//  Copyright (c) 2014年 Vivian L. All rights reserved.
//

#import "CHJDayHourController.h"
#import "CHJUIUtility.h"
#import "CHJDayHourTableViewCell.h"
#import "CHJTabBarController.h"
#import "CHJAddEventController.h"
#import "CHJEventDetailController.h"
#import "CHJEvent.h"

@interface CHJDayHourController ()

// @property (nonatomic, strong) UITapGestureRecognizer *removeEventRecognizer;
@property (nonatomic, strong) NSArray *data;
@property (strong, nonatomic) CHJAppDelegate *myDelegate;
// @property (nonatomic, strong) NSMutableDictionary *overlays;
@property (nonatomic, strong) NSMutableDictionary *overlayToEvent;

@end

@implementation CHJDayHourController

-(void)initTitleBarButton {
    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    weekday.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [weekday setDateFormat: @"EEEE"];
    NSDateFormatter *yearday = [[NSDateFormatter alloc] init];
    [yearday setDateFormat: @"yyyy年MM月dd日"];
    
    UIButton *titleButton = [CHJUIUtility makeTitleButton:[yearday stringFromDate:self.forDay] subtitle:[weekday stringFromDate:self.forDay] actionTarget:self action:@selector(titleAction:)];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:titleButton];
    self.navigationItem.leftBarButtonItem = barButton;
}

-(void)loadDataFromDB {
    [self.myDelegate prepareAllCHJEvents];
    NSNumber *today = [[NSNumber alloc] initWithInt:self.targetDay];
    NSMutableDictionary *weekDayEvents = [self.myDelegate getWeekDayEvents];
    self.data = [weekDayEvents objectForKey:today];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.myDelegate = (CHJAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.now = [NSDate date];
    self.myOverlays = [[NSMutableArray alloc] init];
    self.currentHour = [[CHJUIUtility getDateComponents:self.now] hour];
//    self.overlays = [[NSMutableDictionary alloc] init];
    self.overlayToEvent = [[NSMutableDictionary alloc] init];
    
    [self initTitleBarButton];
    
    UIBarButtonItem *addEntryButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEntryAction:)];
    
    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(moreAction:)];
    
    NSArray *rightButtons = [[NSArray alloc] initWithObjects:addEntryButton, moreButton, nil];
    self.navigationItem.rightBarButtonItems = rightButtons;

    self.tableView.rowHeight = 60;
    
    [self loadDataFromDB];
    
    [self renderEvents:self.data];
    NSLog(@"All events rendered.");
    NSLog(@"%@", self.overlayToEvent);
    
    if (self.needHourIndicator) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentHour inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [self.tableView reloadData];
    }
}

-(IBAction)selectEventHandler:(UITapGestureRecognizer *)recognizer {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CHJEventDetailController *detailsViewController = [storyboard instantiateViewControllerWithIdentifier:@"CHJEventDetailController"];
    UIView *overlay = recognizer.view;
    NSNumber *tag = [[NSNumber alloc] initWithInt:overlay.tag];
    NSLog(@"Working on view-tag: %@", tag);
    detailsViewController.event = [self.overlayToEvent objectForKey:tag];
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

-(void)clearExistingOverlays {
    for(UIView *overlay in self.myOverlays) {
//        NSLog(@"Removing subview for key: %@", key);
        [overlay removeFromSuperview];
    }
    // [self.overlays removeAllObjects];
    [self.myOverlays removeAllObjects];
    [self.overlayToEvent removeAllObjects];
}

- (void)viewWillAppear:(BOOL)animated {
    //    NSLog(@"Entering viewWillAppear for WeekDay");
    [super viewWillAppear:animated];
    [self clearExistingOverlays];
    [self loadDataFromDB];
    [self renderEvents:self.data];
}


- (void)renderEvents:(NSArray *)data {
    for (int i = 0; i < data.count; i++) {
        CHJEvent *item = data[i];
        UIView *overlay = [CHJUIUtility
                           createOverlayForDayHour:item.title
                           startTime:item.startDateTime
                           endTime:item.endDateTime
                           indent:0];
        overlay.tag = i;
        NSNumber *tag = [[NSNumber alloc] initWithInt:i];
        [self.overlayToEvent setObject:item forKey:tag];
        // [self.overlays setObject:overlay forKey:tag];

        [self.myOverlays addObject:overlay];
        [self.view addSubview:overlay];
        
        UITapGestureRecognizer *removeEventRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self                                                                         action:@selector(selectEventHandler:)];
        [overlay addGestureRecognizer:removeEventRecognizer];
    }
}

- (void)addEntryAction:(id)sender {
    // hide button bar
    self.hidesBottomBarWhenPushed = YES;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CHJAddEventController *detailsViewController = [storyboard instantiateViewControllerWithIdentifier:@"CHJAddEventController"];
    [self.navigationController pushViewController:detailsViewController animated:YES];
    //[detailsViewController release];
    
    // self.hidesBottomBarWhenPushed = NO;
}

- (void)moreAction:(id)sender {
    // NSLog(@"more button pressed");
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)titleAction:(id)sender {
    NSLog(@"title button pressed");
    if (!self.needHourIndicator) {
        self.now = [NSDate date];
        self.forDay = self.now;
        
        [self initTitleBarButton];
        
        NSDateComponents *comps = [CHJUIUtility getDateComponents:self.now];
        self.targetDay = [comps weekday];
        self.needHourIndicator = YES;
        for (int i = 0; i < self.myOverlays.count; i++) {
            [self.myOverlays[i] removeFromSuperview];
        }
        [self viewDidLoad];
    }
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
    return 24;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHJDayHourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DayHourCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CHJDayHourTableViewCell" bundle:nil] forCellReuseIdentifier:@"DayHourCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"DayHourCell"];
    }
    cell.hourLabel.text = [NSString stringWithFormat: @"%02d", indexPath.row];
    
    if (self.needHourIndicator && indexPath.row == self.currentHour) {
        cell.currentHourIndicator.backgroundColor = [UIColor grayColor];
    } else {
        cell.currentHourIndicator.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
*/

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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
