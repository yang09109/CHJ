//
//  CHJAttenionViewController.m
//  CHJCalendar
//
//  Created by susu on 14-11-6.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "CHJAttenionViewController.h"

@interface CHJAttenionViewController ()<UITableViewDelegate ,UITableViewDataSource>
{
    UITableView *attentionTableView;
    UILabel * onOffLable;
}
@end

@implementation CHJAttenionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:238/255. green:238/255. blue:238/255. alpha:1.];
    self.navigationItem.title = @"关注选项";
    self.automaticallyAdjustsScrollViewInsets = NO;
    attentionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, 88)];
    attentionTableView.backgroundColor = [UIColor clearColor];
    attentionTableView.delegate =self;
    attentionTableView.dataSource =self;
    attentionTableView.scrollEnabled = NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        attentionTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [self.view addSubview:attentionTableView];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tableSampleIdentifier = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
    UITableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:tableSampleIdentifier];
    
    if (cell ==nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableSampleIdentifier];
    }
    else
    {
        [cell removeFromSuperview];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableSampleIdentifier];
        
    }
    
//    [cell setSelectionStyle:UITableViewCellEditingStyleNone];//取消cell点击效果
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = @"                                  是否可以被其他人关注";
        cell.textLabel.alpha = 0.6;
        cell.textLabel.font = [UIFont systemFontOfSize:14.];

    }
    else
    {
        cell.textLabel.text = @"  关注选项";
        cell.textLabel.alpha = 0.9;
        cell.textLabel.font = [UIFont systemFontOfSize:18.];
        onOffLable = [[UILabel alloc] initWithFrame:CGRectMake(200, 7, 40, 30)];
        onOffLable.text = @"关闭";
        onOffLable.alpha = 0.5;
        onOffLable.font = [UIFont systemFontOfSize:13.];
        [cell.contentView addSubview:onOffLable];
        
        UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(250, 5, 40, 30)];
        [switchButton setOn:NO];
        [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:switchButton];
        
    }
    
        return cell;
}
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        onOffLable.text = @"开启";
    }else {
        onOffLable.text = @"关闭";
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
