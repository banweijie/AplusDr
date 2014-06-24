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
    
    NSArray * orderList;
}

@end

@implementation WePecTrhViewController

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
    [refreshButton addTarget:self action:@selector(refreshButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTintColor:We_foreground_red_general];
    [self.view addSubview:refreshButton];
    
    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height - 64 - 85) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sys_tableView];
    
    // 标题
    self.navigationItem.title = @"我的参与";
    
    // 访问获取众筹详情列表
    [self api_patient_listOrders];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)api_patient_listOrders {
    [sys_pendingView startAnimating];
    [refreshButton setHidden:YES];
    [sys_tableView setHidden:YES];
    
    [WeAppDelegate postToServerWithField:@"patient" action:@"listMySupports"
                              parameters:nil
                                 success:^(id response) {
                                     orderList = response;
                                     
                                     [sys_tableView reloadData];
                                     [sys_tableView setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     [refreshButton setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }];
}

- (void)preworkOnOrderList:(id)sender {
    /*
    [caseRecords sortUsingComparator:^NSComparisonResult(id rA, id rB) {
        return [[(WeCaseRecord *)rB date] compare:[(WeCaseRecord *)rA date]];
    }];
    tableViewData0 = [[NSMutableArray alloc] init];
    int j = -1;
    for (int i = 0; i < [caseRecords count]; i ++) {
        if (i == 0 || ![[self getYearAndMonth:[(WeCaseRecord *)caseRecords[i] date]] isEqualToString:[self getYearAndMonth:[(WeCaseRecord *)caseRecords[i - 1] date]]]) {
            j ++;
            tableViewData0[j] = [[NSMutableArray alloc] init];
        }
        [tableViewData0[j] addObject:caseRecords[i]];
    }*/
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
