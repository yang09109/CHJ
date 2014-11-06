//
//  CHJLoginViewController.m
//  CHJCalendar
//
//  Created by Vivian L on 14-8-5.
//  Copyright (c) 2014年 Vivian L. All rights reserved.
//

#import "CHJLoginViewController.h"

@interface CHJLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *username;

@end

@implementation CHJLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.button.layer setCornerRadius:4.0];
    self.view.backgroundColor = [UIColor colorWithRed:3/255.0 green:79/255.0 blue:156/255.0 alpha:1.0];
    //[self.view setBackgroundColor:[UIColor colorWithRed:3 green:79 blue:156 alpha:1.0]];
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.password isExclusiveTouch]) {
        [self.password resignFirstResponder];
    }
    if (![self.username isExclusiveTouch]) {
        [self.username resignFirstResponder];
    }
}

@end
