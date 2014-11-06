//
//  CHJAboutViewController.m
//  CHJCalendar
//
//  Created by Vivian L on 14-9-26.
//  Copyright (c) 2014年 Vivian L. All rights reserved.
//

#import "CHJAboutViewController.h"

@interface CHJAboutViewController ()

@end

@implementation CHJAboutViewController

@synthesize aboutWebView;

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
//    
//    NSString *urlAddress = @"http://oa.caohejing.com:8080/CHJCalendar/about.htm";
//    NSURL *url = [NSURL URLWithString:urlAddress];
//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//    
//    self.aboutWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
//    self.aboutWebView.delegate = self;
//    [self.aboutWebView loadRequest:requestObj];
//    [self.view addSubview:self.aboutWebView];
    
    // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]     initWithTitle:@"Back"                                                                              style:UIBarButtonItemStylePlain                                                                         target:self action:@selector(goBack:)];
    
    self.view.backgroundColor = [UIColor colorWithRed:238/255. green:238/255. blue:238/255. alpha:1.];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
