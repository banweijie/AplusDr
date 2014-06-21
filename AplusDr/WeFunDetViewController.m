//
//  WeFunDetViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-21.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFunDetViewController.h"

@interface WeFunDetViewController () {
    UIImageView * posterView;
    UITableView * sys_tableView;
    UIView * barView;
}

@end

@implementation WeFunDetViewController

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path
{
    [tableView deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 220;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 310;
    return 9;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 400;
    }
    return 1;
}
// 询问每个段落的尾部标题
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return 1;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return 1;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    cell.opaque = NO;
    cell.backgroundColor = We_background_cell_general;
    
    return cell;
}
// 滑动到一定位置
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f", scrollView.contentOffset.y);
    
    // 调整背景图片位置
    CGRect frame = posterView.frame;
    frame.origin.y = -scrollView.contentOffset.y;
    posterView.frame = frame;
    [posterView setHidden:(scrollView.contentOffset.y > 235 - 64 - 2)];
    
    // 调整按钮栏位置
    CGRect frame2 = barView.frame;
    frame2.origin.y = MAX(235 - scrollView.contentOffset.y, 64);
    barView.frame = frame2;
    
    // 调整标题栏
    if (scrollView.contentOffset.y > 235 - 64 - 2) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"texture"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationItem setTitle:_currentFunding.title];
    }
    else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationItem setTitle:@""];
    }
}
// 滑动结束
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"!!!");
    
    if (scrollView.contentOffset.y < 117) {
        [scrollView scrollRectToVisible:CGRectMake(0, 0, 320, self.view.frame.size.height) animated:YES];
    }
    
    if (scrollView.contentOffset.y > 117 && scrollView.contentOffset.y < 235 - 64) {
        NSLog(@"up");
        [scrollView scrollRectToVisible:CGRectMake(0, 235 - 64, 320, self.view.frame.size.height) animated:YES];
    }
}


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
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // 导航栏背景
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent"] forBarMetrics:UIBarMetricsDefault];
    
    // 海报背景图片
    posterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 235)];
    NSLog(@"%@", yijiarenImageUrl(_currentFunding.poster2));
    [posterView setImageWithURL:[NSURL URLWithString:yijiarenImageUrl(_currentFunding.poster2)]];
    [posterView setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:posterView];
    
    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    sys_tableView.bounces = NO;
    [self.view addSubview:sys_tableView];
    
    // barView
    barView = [[UIView alloc] initWithFrame:CGRectMake(0, 235, 320, 50)];
    [self.view addSubview:barView];
    
    // barView - button0
    UIButton * button0 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button0 setFrame:CGRectMake(0, 2, 89, 48)];
    [button0 setBackgroundColor:[UIColor colorWithRed:90 / 255.0 green:41 / 255.0 blue:45 / 255.0 alpha:1.0]];
    [barView addSubview:button0];
    
    // barView - button0 - label0
    UILabel * button0label0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 89, 30)];
    [button0label0 setText:[NSString stringWithFormat:@"￥%@ ", _currentFunding.goal]];
    [button0label0 setTextAlignment:NSTextAlignmentCenter];
    [button0label0 setFont:We_font_textfield_zh_cn];
    [button0label0 setTextColor:We_foreground_white_general];
    [button0 addSubview:button0label0];
    
    // barView - button0 - label1
    UILabel * button0label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 89, 30)];
    [button0label1 setText:@"目标募款"];
    [button0label1 setTextAlignment:NSTextAlignmentCenter];
    [button0label1 setFont:We_font_textfield_small_zh_cn];
    [button0label1 setTextColor:We_foreground_gray_general];
    [button0 addSubview:button0label1];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setFrame:CGRectMake(91, 2, 138, 48)];
    [button1 setImage:[UIImage imageNamed:@"crowdfunding-detail-support"] forState:UIControlStateNormal];
    [button1 setTitle:@" 支持众筹项目" forState:UIControlStateNormal];
    //[button1 addTarget:self action:@selector(transferTo0:) forControlEvents:UIControlEventTouchUpInside];
    button1.tintColor = We_foreground_white_general;
    button1.backgroundColor = We_background_red_general;
    button1.titleLabel.font = We_font_textfield_zh_cn;
    [barView addSubview:button1];
    
    // barView - button2
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setFrame:CGRectMake(231, 2, 89, 48)];
    [button2 setBackgroundColor:[UIColor colorWithRed:90 / 255.0 green:41 / 255.0 blue:45 / 255.0 alpha:1.0]];
    [barView addSubview:button2];
    
    // barView - button2 - label0
    UILabel * button2label0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 89, 30)];
    NSLog(@"%f %lld", [[NSDate date] timeIntervalSince1970], [_currentFunding.endTime longLongValue] / 1000);
    int restSec =  [_currentFunding.endTime longLongValue] / 1000 - [[NSDate date] timeIntervalSince1970];
    [button2label0 setText:[NSString stringWithFormat:@"%d天", restSec / 86400 + 1]];
    [button2label0 setTextAlignment:NSTextAlignmentCenter];
    [button2label0 setFont:We_font_textfield_zh_cn];
    [button2label0 setTextColor:We_foreground_white_general];
    [button2 addSubview:button2label0];
    
    // barView - button2 - label1
    UILabel * button2label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 89, 30)];
    [button2label1 setText:@"剩余时限"];
    [button2label1 setTextAlignment:NSTextAlignmentCenter];
    [button2label1 setFont:We_font_textfield_small_zh_cn];
    [button2label1 setTextColor:We_foreground_gray_general];
    [button2 addSubview:button2label1];
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

@end
