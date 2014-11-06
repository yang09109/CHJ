//
//  CHJAddEventController.m
//  CHJCalendar
//
//  Created by Vivian L on 14-8-11.
//  Copyright (c) 2014年 Vivian L. All rights reserved.
//

#import "CHJAddEventController.h"
#import "CHJEvent.h"
#import "CHJUIUtility.h"

@interface CHJAddEventController ()

@property (nonatomic) NSMutableArray *events;
@property (nonatomic) UIView *datePickerContainer;
// @property (nonatomic) UIActionSheet *datePickerContainer;
@property (nonatomic) UIDatePicker *datePicker;

@property (nonatomic, strong) NSDate *startDateTimeInput;
@property (nonatomic, strong) NSDate *endDateTimeInput;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *timeFormatter;
@property (nonatomic, strong) NSDateFormatter *dateTimeFormatter;

@property (nonatomic) BOOL isForStart;

@end

@implementation CHJAddEventController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initDatePickerTest {
    int height = 255;
    //create new view
    self.datePickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, height)];
    self.datePickerContainer.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    //add toolbar
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    toolbar.barStyle = UIBarStyleBlack;
    
    //add button
    UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"好了" style:UIBarButtonItemStyleDone target:self action:@selector(dismissDatePicker:)];
    toolbar.items = [NSArray arrayWithObjects:infoButtonItem, nil];
    
    //add date picker
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime; //UIDatePickerModeDate;
    [self.datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    self.datePicker.hidden = NO;
    self.datePicker.date = [NSDate date];
    self.datePicker.frame = CGRectMake(0, 40, 320, 250);
    [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self.datePickerContainer addSubview:self.datePicker];
    [self.datePickerContainer addSubview:toolbar];
    
    [self.startButton addTarget:self action:@selector(startButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.endButton addTarget:self action:@selector(endButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)showDatePicker {
    int height = 255;
    //add popup view
    [self.view addSubview:self.datePickerContainer];
    
    //animate it onto the screen
    CGRect temp = self.datePickerContainer.frame;
    temp.origin.y = CGRectGetMaxY(self.view.bounds);
    self.datePickerContainer.frame = temp;
    [UIView beginAnimations:nil context:nil];
    temp.origin.y -= height;
    self.datePickerContainer.frame = temp;
    [UIView commitAnimations];
}

-(void)dismissDatePicker:(id)sender {
    [self.datePickerContainer removeFromSuperview];
    [UIView commitAnimations];
}

-(void)initDateLabels {
    NSDate *now = [NSDate date];
    self.startDateTimeInput = self.startDateTime = now;
    self.endDateTimeInput = self.endDateTime = [NSDate dateWithTimeInterval:3600 sinceDate:now];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat: @"yyyy年MM月dd日"];
    self.timeFormatter = [[NSDateFormatter alloc] init];
    [self.timeFormatter setDateFormat: @"HH:mm"];
    self.dateTimeFormatter = [[NSDateFormatter alloc] init];
    [self.dateTimeFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    self.startDate.text = [self.dateFormatter stringFromDate:self.startDateTimeInput];
    self.startTime.text = [self.timeFormatter stringFromDate:self.startDateTimeInput];
    self.endDate.text = [self.dateFormatter stringFromDate:self.endDateTimeInput];
    self.endTime.text = [self.timeFormatter stringFromDate:self.endDateTimeInput];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.cancelButton setTarget:self];
    [self.cancelButton setAction:@selector(cancelEvent:)];
    
    [self.saveButton setTarget:self];
    [self.saveButton setAction:@selector(saveEvent:)];
    
    [self.startDateView.layer setCornerRadius:4.0];
    [self.endDateView.layer setCornerRadius:4.0];
    
    [self.moreButton.layer setCornerRadius:4.0];
    
    self.hidesBottomBarWhenPushed = YES;
    
    self.myDelegate = (CHJAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //[self initDatePickerInActionSheet];
    [self initDatePickerTest];
    [self initDateLabels];
}

-(void)startButtonEvent:(id)sender {
    self.isForStart = YES;
    //[self showDatePickerContainer];
    [self showDatePicker];
}

-(void)endButtonEvent:(id)sender {
    self.isForStart = NO;
    //[self showDatePickerContainer];
    [self showDatePicker];
}

-(void)datePickerChanged:(id)sender {
    if (self.isForStart) {
        self.startDateTimeInput = self.datePicker.date;
        [self setDateTimePicker:self.startDateTimeInput isForStartDateTime:self.isForStart];
    } else {
        self.endDateTimeInput = self.datePicker.date;
        [self setDateTimePicker:self.endDateTimeInput isForStartDateTime:self.isForStart];
    }
}

-(void)setDateTimePicker:(NSDate *)date isForStartDateTime:(BOOL)isForStart {
    UILabel *dateField;
    UILabel *timeField;
    if (isForStart) {
        dateField = self.startDate;
        timeField = self.startTime;
    } else {
        dateField = self.endDate;
        timeField = self.endTime;
    }
    NSString *dateStr = [self.dateFormatter stringFromDate:date];
    NSString *timeStr = [self.timeFormatter stringFromDate:date];
    
    dateField.text = dateStr;
    timeField.text = timeStr;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelEvent:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)saveEvent:(id)sender {    NSManagedObjectContext *managedObjectContext = [self.myDelegate getManagedObjectContext];

    NSLog(@"retrieve input content: %@", self.eventTextField.text);
    
    NSLog(@"got managed context: %@", managedObjectContext);
    CHJEvent *event = (CHJEvent *)[NSEntityDescription insertNewObjectForEntityForName:@"CHJEvent" inManagedObjectContext:managedObjectContext];
    
    NSString *title = self.eventTextField.text;
    [event setTitle:title];
    
    [self prepareDateTimeInput];
    NSLog(@"Start: %@; End: %@", self.startDateTime, self.endDateTime);
    
    [event setStartDateTime:self.startDateTime];
    [event setEndDateTime:self.endDateTime];
    
    NSLog(@"Scheduling the notification for it.");
    [self.myDelegate scheduleNotifications:title scheduleForDateTime:self.startDateTime];
    
    //[event setValue:title forKey:@"title"];
    //[event setValue:startDateTime forKey:@"startDateTime"];
    //[event setValue:endDateTime forKey:@"endDateTime"];
    // [event setBody:self.contentTextField.text];
    // [event setCreationDate:[NSDatedate]];
    
    NSError *error;
    
    NSLog(@"Saving: %@", event);
    //托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
    BOOL isSaveSuccess = [managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }else {
        NSLog(@"Save successful!");
    }
    
    [self.navigationController popViewControllerAnimated: YES];
}

-(void)prepareDateTimeInput {
    if (self.startDateTimeInput != nil) {
        self.startDateTime = self.startDateTimeInput;
    }
    if (self.endDateTimeInput != nil) {
        self.endDateTime = self.endDateTimeInput;
    }
    NSComparisonResult startEndCompare = [self.startDateTime compare:self.endDateTime];
    if (startEndCompare == NSOrderedDescending) {
        NSDate *oldStart = self.startDateTime;
        NSDate *oldEnd = self.endDateTime;
        self.endDateTime = oldStart;
        self.startDateTime = oldEnd;
    }
}

//单击按钮后执行查询操作
- (IBAction)queryFromDB:(id)sender {
    
    //创建取回数据请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //设置要检索哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CHJEvent" inManagedObjectContext:[self.myDelegate getManagedObjectContext]];
    
    //设置请求实体
    [request setEntity:entity];
    
    //指定对结果的排序方式
    // NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
    // NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    // [request setSortDescriptors:sortDescriptions];
    
    NSError *error = nil;
    //执行获取数据请求，返回数组
    NSMutableArray *mutableFetchResult = [[[self.myDelegate getManagedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    self.events = mutableFetchResult;
    
//    NSLog(@"The count of entry:%i",[self.events count]);
    
    for (CHJEvent *event in self.events) {
        NSLog(@"Title:%@---Content:%@---Date:%@", event.title, event.startDateTime);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.eventTextField isExclusiveTouch]) {
        [self.eventTextField resignFirstResponder];
    }
    if (![self.eventTextField isExclusiveTouch]) {
        [self.eventTextField resignFirstResponder];
    }
    if (![self.eventTextField isExclusiveTouch]) {
        [self.eventTextField resignFirstResponder];
    }
}

//更新操作
-(void)updateEntry:(CHJEvent *)event
{
    [event setTitle:self.eventTextField.text];
    // [event setBody:self.contentTextField.text];
    // [event setCreationDate:[NSDate date]];
    
    NSError *error;
    BOOL isUpdateSuccess = [[self.myDelegate getManagedObjectContext] save:&error];
    if (!isUpdateSuccess) {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
    }
}

//删除操作
-(void)deleteEntry:(CHJEvent *)entry
{
    [[self.myDelegate getManagedObjectContext] deleteObject:entry];
    // [self.entries removeObject:entry];
    
    NSError *error;
    if (![[self.myDelegate getManagedObjectContext] save:&error]) {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
    }
}

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
