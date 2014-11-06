//
//  CHJEventDetailController.m
//  CHJCalendar
//
//  Created by Vivian L on 14-9-27.
//  Copyright (c) 2014年 Vivian L. All rights reserved.
//

#import "CHJEventDetailController.h"
#import "CHJAppDelegate.h"

@interface CHJEventDetailController ()

@property (nonatomic, strong) NSDateFormatter *dateTimeFormatter;
@property (nonatomic, weak) CHJAppDelegate *myDelegate;

@end

@implementation CHJEventDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initContentView {
    NSString *startDateTimeStr = [self.dateTimeFormatter stringFromDate:self.event.startDateTime];
    NSString *endDateTimeStr = [self.dateTimeFormatter stringFromDate:self.event.endDateTime];
    self.eventStartTimeLabel.text = [NSString stringWithFormat:@"开始：%@", startDateTimeStr];
    self.eventEndTimeLabel.text = [NSString stringWithFormat:@"结束：%@", endDateTimeStr];
    self.eventTitleLabel.text = self.event.title;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myDelegate = (CHJAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSLog(@"EventDetailView: for event %@", self.event);
    self.dateTimeFormatter = [[NSDateFormatter alloc] init];
    [self.dateTimeFormatter setDateFormat:@"M月dd日 HH:mm"];
    
    [self initContentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(IBAction)deleteEventAction:(id)sender {
    NSLog(@"Start to remove event");
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要删除当前事件？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    alert.alertViewStyle=UIAlertViewStyleDefault;
    //UIAlertViewStyleDefault 默认风格，无输入框
    //UIAlertViewStyleSecureTextInput 带一个密码输入框
    //UIAlertViewStylePlainTextInput 带一个文本输入框
    //UIAlertViewLoginAndPasswordInput 带一个文本输入框，一个密码输入框
    [alert show];

}

//AlertView已经消失时执行的事件
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"Confirmed delete");
        NSManagedObjectContext *managedObjectContext = [self.myDelegate getManagedObjectContext];
        NSError *error;
        
        [managedObjectContext deleteObject:self.event];
        
        NSLog(@"deleting: %@", self.event);
        NSLog(@"trying to save");
        //托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
        BOOL isSaveSuccess = [managedObjectContext save:&error];
        
        if (!isSaveSuccess) {
            NSLog(@"Error: %@,%@",error,[error userInfo]);
        }else {
            NSLog(@"Delete successful!");
        }
        
        [self.navigationController popViewControllerAnimated: YES];
    } else {
        NSLog(@"Cancel delete");
    }
}


@end
