//
//  WeCahIdxViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-24.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCahIdxViewController.h"

@interface WeCahIdxViewController () {
    UIView * view0;
    UIView * view1;
    UITableView * tableView_view0;
    UITableView * tableView_view1;
    UIActivityIndicatorView * sys_pendingView;
    NSMutableArray * tableViewData0;
    NSMutableArray * tableViewData1;
}

@end

@implementation WeCahIdxViewController

/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
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
    if (tv == tableView_view0) {
        caseRecordChanging = tableViewData0[path.section][path.row];
        [self performSegueWithIdentifier:@"CahIdx_pushto_CahCah" sender:self];
    }
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tv.rowHeight * 2;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    return 30;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    return @"";
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    [view setBackgroundColor:We_background_red_general];
    UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 30)];
    l1.font = We_font_textfield_zh_cn;
    l1.textColor = We_foreground_white_general;
    if (tableView == tableView_view0) {
        l1.text = [self getYearAndMonth:[(WeCaseRecord *)tableViewData0[section][0] date]];
    }
    else {
        l1.text = [self getYearAndMonth:[(WeCaseRecord *)tableViewData1[section][0] date]];
    }
    [view addSubview:l1];
    return view;
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tv] - 1) {
        return 1 + 10 + self.tabBarController.tabBar.frame.size.height;
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
    if (tv == tableView_view0) {
        return [tableViewData0 count];
    }
    return 0;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (tv == tableView_view0) {
        return [tableViewData0[section] count];
    }
    return 0;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    
    if (tv == tableView_view0) {
        WeCaseRecord * caseRecord = tableViewData0[indexPath.section][indexPath.row];
        cell.backgroundColor = We_foreground_white_general;
        
        UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 40)];
        l1.font = We_font_textfield_zh_cn;
        l1.textColor = We_foreground_black_general;
        l1.text = caseRecord.diseaseName;
        [cell.contentView addSubview:l1];
        
        UILabel * l2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 100, 40)];
        l2.font = We_font_textfield_zh_cn;
        l2.textColor = We_foreground_gray_general;
        l2.text = caseRecord.hospitalName;
        [cell.contentView addSubview:l2];
        
        UILabel * l3 = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 80, 88)];
        l3.font = We_font_textfield_zh_cn;
        l3.textColor = We_foreground_gray_general;
        l3.text = caseRecord.date;
        [cell.contentView addSubview:l3];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
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

// 当segControl产生切换
- (void)selectedSegmentChanged:(UISegmentedControl *)segControl {
    NSLog(@"%d", segControl.selectedSegmentIndex);
    if (segControl.selectedSegmentIndex == 0) {
        [view0 setHidden:NO];
        [view1 setHidden:YES];
    }
    else {
        [view0 setHidden:YES];
        [view1 setHidden:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    we_justAddNewCaseRecord = NO;
    
    // 切换“就诊历史"和"检查结果"
    UIView * segControlView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 44)];
    segControlView.backgroundColor = We_background_red_general;
    
    UISegmentedControl * segControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"就诊历史", @"检查结果", nil]];
    [segControl setFrame:CGRectMake(20, 7, 280, 30)];
    segControl.backgroundColor = [UIColor clearColor];
    segControl.selectedSegmentIndex = 0;
    segControl.tintColor = We_foreground_white_general;
    segControl.layer.cornerRadius = 5;
    [segControl addTarget:self action:@selector(selectedSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    [segControlView addSubview:segControl];
    
    // 就诊历史页面
    view0 = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 44, 320, self.view.frame.size.height - 64 - 44)];
    
    // 就诊历史页面 - 添加按钮
    UIButton * view0AddButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [view0AddButton setFrame:CGRectMake(0, 0, 320, 40)];
    [view0AddButton setTitle:@"添加" forState:UIControlStateNormal];
    [view0AddButton addTarget:self action:@selector(view0AddButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [view0 addSubview:view0AddButton];
    
    // 就诊历史页面 - 目录
    tableView_view0 = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, view0.frame.size.width, view0.frame.size.height - 40) style:UITableViewStyleGrouped];
    tableView_view0.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView_view0.delegate = self;
    tableView_view0.dataSource = self;
    tableView_view0.backgroundColor = [UIColor clearColor];
    [view0 addSubview:tableView_view0];
    
    // 检查结果页面
    view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 44, 320, self.view.frame.size.height - 64 - 44)];
    
    // 就诊历史页面 - 添加按钮
    UIButton * view1AddButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [view1AddButton setFrame:CGRectMake(0, 0, 320, 40)];
    [view1AddButton setTitle:@"添加" forState:UIControlStateNormal];
    [view1AddButton addTarget:self action:@selector(view1AddButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:view1AddButton];
    
    // 就诊历史页面 - 目录
    tableView_view1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, view1.frame.size.width, view1.frame.size.height - 40) style:UITableViewStyleGrouped];
    tableView_view1.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView_view1.delegate = self;
    tableView_view1.dataSource = self;
    tableView_view1.backgroundColor = [UIColor clearColor];
    [view1 addSubview:tableView_view1];
    
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    [self.view addSubview:segControlView];
    [self.view addSubview:view0];
    [self.view addSubview:view1];
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
    [self getCaseRecords:self];
    
    // test
    /*
    UIToolbar * toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [toolBar setTintColor:[UIColor clearColor]];
    toolBar.alpha = 0.95; */
}

- (void)viewWillAppear:(BOOL)animated {
    [self preworkOnCaseRecords:self];
    [tableView_view0 reloadData];
    [super viewWillAppear:animated];
}

- (void)view0AddButton_onPress:(id)sender {
    WeNavViewController * nav = [[WeNavViewController alloc] init];
    
    WeCahAddCahViewController * vc = [[WeCahAddCahViewController alloc] init];
    vc.lastViewController = self;
    [nav pushViewController:vc animated:NO];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)view1AddButton_onPress:(id)sender {
    
}

- (void)getCaseRecords:(id)sender {
    [sys_pendingView startAnimating];
    [self.view endEditing:YES];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:yijiarenUrl(@"patient", @"listRecords") parameters:nil
          success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
              NSString * errorMessage;
              
              NSString *result = [HTTPResponse objectForKey:@"result"];
              result = [NSString stringWithFormat:@"%@", result];
              if ([result isEqualToString:@"1"]) {
                  NSLog(@"response : %@", HTTPResponse[@"response"]);
                  for (int i = 0; i < [HTTPResponse[@"response"] count]; i++) {
                      WeCaseRecord * newCaseRecord = [[WeCaseRecord alloc] initWithNSDictionary:HTTPResponse[@"response"][i]];
                      [caseRecords addObject:newCaseRecord];
                  }
                  [sys_pendingView stopAnimating];
                  [self preworkOnCaseRecords:self];
                  [tableView_view0 reloadData];
                  return;
              }
              if ([result isEqualToString:@"2"]) {
                  NSDictionary *fields = [HTTPResponse objectForKey:@"fields"];
                  NSEnumerator *enumerator = [fields keyEnumerator];
                  id key;
                  while ((key = [enumerator nextObject])) {
                      NSString * tmp1 = [fields objectForKey:key];
                      if (tmp1 != NULL) errorMessage = tmp1;
                  }
              }
              if ([result isEqualToString:@"3"]) {
                  errorMessage = [HTTPResponse objectForKey:@"info"];
              }
              if ([result isEqualToString:@"4"]) {
                  errorMessage = [HTTPResponse objectForKey:@"info"];
              }
              [sys_pendingView stopAnimating];
              UIAlertView *notPermitted = [[UIAlertView alloc]
                                           initWithTitle:@"获取就诊记录"
                                           message:errorMessage
                                           delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
              [notPermitted show];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [sys_pendingView stopAnimating];
              UIAlertView *notPermitted = [[UIAlertView alloc]
                                           initWithTitle:@"获取就诊记录"
                                           message:@"未能连接服务器，请重试"
                                           delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
              [notPermitted show];
          }
     ];
}

- (NSString *)getYearAndMonth:(NSString *)date {
    return [NSString stringWithFormat:@"%@年%@月", [date substringWithRange:NSMakeRange(0, 4)], [date substringWithRange:NSMakeRange(5, 2)]];
}

- (void)preworkOnCaseRecords:(id)sender {
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
    }
    NSLog(@"%@", tableViewData0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
