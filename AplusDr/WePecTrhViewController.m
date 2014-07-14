//
//  WePecTrhViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-24.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WePecTrhViewController.h"

@interface WePecTrhViewController () {
    UIActivityIndicatorView * sys_pendingView;
    UITableView * sys_tableView;
    UIButton * refreshButton;
    
    NSMutableArray * orderList;
}

@end

@implementation WePecTrhViewController

#pragma mark - UITableView Delegate & DataSource

// 将展示某个Cell触发的事件
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = We_alpha_cell_general;;
    cell.opaque = YES;
}
// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tv.rowHeight * 2;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 30;
    return 30;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    [view setBackgroundColor:We_background_red_general];
    UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 30)];
    l1.font = We_font_textfield_zh_cn;
    l1.textColor = We_foreground_white_general;
    l1.text = [WeAppDelegate transitionToYearAndMonthFromSecond:[(WeOrder *)orderList[section][0] createTime]];
    [view addSubview:l1];
    return view;
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tv] - 1) {
        return 1 + self.tabBarController.tabBar.frame.size.height;
    }
    return 1;
}
// 询问每个段落的尾部标题
- (NSString *)tableView:(UITableView *)tv titleForFooterInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部
-(UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section{
    //if (section == 1) return sys_countDown_demo;
    return nil;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return [orderList count];
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return [orderList[section] count];
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
    
    WeOrder * currentOrder = orderList[indexPath.section][indexPath.row];
    
    UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 40)];
    [l1 setFont:We_font_textfield_large_zh_cn];
    [l1 setTextColor:We_foreground_black_general];
    [l1 setTextAlignment:NSTextAlignmentLeft];
    if ([currentOrder.type isEqualToString:@"C"]) {
        [l1 setText:@"在线咨询"];
    }
    else if ([currentOrder.type isEqualToString:@"F"]) {
        [l1 setText:@"众筹支持"];
    }
    else if ([currentOrder.type isEqualToString:@"J"]) {
        [l1 setText:@"加号预诊"];
    }
    [cell.contentView addSubview:l1];
    
    UILabel * l2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 38, 200, 40)];
    [l2 setFont:We_font_textfield_zh_cn];
    [l2 setTextColor:We_foreground_gray_general];
    [l2 setTextAlignment:NSTextAlignmentLeft];
    [l2 setText:[WeAppDelegate transitionToDateFromSecond:currentOrder.createTime]];
    [cell.contentView addSubview:l2];
    
    UILabel * l3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 260, 88)];
    [l3 setFont:We_font_textfield_large_zh_cn];
    if ([currentOrder.status isEqualToString:@"C"]) {
        [l3 setTextColor:We_foreground_gray_general];
    }
    else if ([currentOrder.status isEqualToString:@"W"]) {
        [l3 setTextColor:We_foreground_red_general];
    }
    else if ([currentOrder.status isEqualToString:@"P"]) {
        [l3 setTextColor:We_foreground_black_general];
    }
    [l3 setTextAlignment:NSTextAlignmentRight];
    [l3 setText:[NSString stringWithFormat:@"￥%.0f", currentOrder.amount]];
    [cell.contentView addSubview:l3];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
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
    
    // 标题
    self.navigationItem.title = @"交易记录";
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView.layer setCornerRadius:10];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
    // 刷新按钮
    refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    refreshButton.frame = self.view.frame;
    [refreshButton setTitle:@"获取交易记录列表失败，点击刷新" forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshButton_onPress) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTintColor:We_foreground_red_general];
    [self.view addSubview:refreshButton];
    
    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = We_background_cell_general;
    [self.view addSubview:sys_tableView];
    
    // 访问获取众筹详情列表
    [self api_patient_listOrders];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshButton_onPress {
    [self api_patient_listOrders];
}

- (void)api_patient_listOrders {
    [sys_pendingView startAnimating];
    [refreshButton setHidden:YES];
    [sys_tableView setHidden:YES];
    
    [WeAppDelegate postToServerWithField:@"patient" action:@"listOrders"
                              parameters:@{
                                           @"from":@"0",
                                           @"num":@"1000"
                                           }
                                 success:^(id response) {
                                     orderList = [self preworkOnOrderList:[NSMutableArray arrayWithArray:response[@"list"]]];
                                     [sys_tableView reloadData];
                                     [sys_tableView setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     [refreshButton setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }];
}

- (NSMutableArray *)preworkOnOrderList:(id)response {
    NSMutableArray * sourceData = [[NSMutableArray alloc] init];
    for (int i = 0; i < [response count]; i ++) {
        [sourceData addObject:[[WeOrder alloc] initWithNSDictionary:response[i]]];
    }
    
    [sourceData sortUsingComparator:^NSComparisonResult(id rA, id rB) {
        return [(WeOrder *)rA createTime] < [(WeOrder *)rB createTime];
    }];
    
    NSMutableArray * tableViewData0 = [[NSMutableArray alloc] init];
    tableViewData0 = [[NSMutableArray alloc] init];
    int j = -1;
    for (int i = 0; i < [sourceData count]; i ++) {
        if (i == 0 || ![[WeAppDelegate transitionToYearAndMonthFromSecond:[(WeOrder *)sourceData[i] createTime]] isEqualToString:[WeAppDelegate transitionToYearAndMonthFromSecond:[(WeOrder *)sourceData[i - 1] createTime]]]) {
            j ++;
            tableViewData0[j] = [[NSMutableArray alloc] init];
        }
        [tableViewData0[j] addObject:sourceData[i]];
    }
    
    return tableViewData0;
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
