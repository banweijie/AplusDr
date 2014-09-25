//
//  WeCahSelectViewController.m
//  AplusDr
//
//  Created by 袁锐 on 14-9-24.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCahSelectViewController.h"
#import "WeNavViewController.h"
#import "WeAppDelegate.h"
#import "WeCahAddExaViewController.h"

@interface WeCahSelectViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UITableView *tableView_view1;
    UIButton *view1AddButton;
    
    UIView *ssview0;
    UIPickerView *ssview0_picker;
    
    UIButton *ssview0_shadowButton;
    
    NSMutableArray *tableViewData1;
}
@end

@implementation WeCahSelectViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // 检查结果页面 - 添加按钮
    view1AddButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [view1AddButton setFrame:CGRectMake(10, 95, 300, 50)];
    [view1AddButton setBackgroundImage:[UIImage imageNamed:@"button-addcasehistory"] forState:UIControlStateNormal];
    [view1AddButton addTarget:self action:@selector(view1AddButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    
    // 检查结果页面 - 目录
    tableView_view1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    tableView_view1.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView_view1.delegate = self;
    tableView_view1.dataSource = self;
    tableView_view1.backgroundColor = [UIColor clearColor];
    tableView_view1.bounces = NO;
    tableView_view1.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 155)];
    
    [self.view addSubview:tableView_view1];
    
    // 添加检查结果产生的效应
    ssview0 = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 300)];
    UIToolbar * toolBar0 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    [toolBar0 setTintColor:[UIColor whiteColor]];
    toolBar0.alpha = 0.98;
    [ssview0 addSubview:toolBar0];
    
    // 添加检查结果产生的效应 - 取消按钮
    UIButton * ssview0_cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ssview0_cancelButton setFrame:CGRectMake(0, 15, 80, 30)];
    [ssview0_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [ssview0_cancelButton setTintColor:We_foreground_black_general];
    [ssview0_cancelButton addTarget:self action:@selector(ssview0_shadowOrCancelButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [ssview0 addSubview:ssview0_cancelButton];
    
    // 添加检查结果产生的效应 - 标题
    UILabel * ssview0_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 160, 30)];
    [ssview0_titleLabel setText:@"选择检查类型"];
    [ssview0_titleLabel setTextColor:We_foreground_gray_general];
    [ssview0_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [ssview0_titleLabel setFont:We_font_textfield_zh_cn];
    [ssview0 addSubview:ssview0_titleLabel];
    
    // 添加检查结果产生的效应 - 第0条线
    UIView * ssview0_line0 = [[UIView alloc] initWithFrame:CGRectMake(20, 60, 280, 1)];
    [ssview0_line0 setBackgroundColor:[UIColor grayColor]];
    [ssview0_line0 setAlpha:0.5];
    [ssview0 addSubview:ssview0_line0];
    
    // 添加检查结果产生的效应 - 选择器
    ssview0_picker = [[UIPickerView alloc] initWithFrame:CGRectMake(40, 60, 240, 60)];
    ssview0_picker.dataSource = self;
    ssview0_picker.delegate = self;
    //secondaryTypeKeys = [we_examinationTypes[we_examinationTypeKeys[0]] allKeys];
    [ssview0 addSubview:ssview0_picker];
    
    // 添加检查结果产生的效应 - 第1条线
    UIView * ssview0_line1 = [[UIView alloc] initWithFrame:CGRectMake(20, 240, 280, 1)];
    [ssview0_line1 setBackgroundColor:[UIColor grayColor]];
    [ssview0_line1 setAlpha:0.5];
    [ssview0 addSubview:ssview0_line1];
    
    // 添加检查结果产生的效应 - 确认按钮
    UIButton * ssview0_submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ssview0_submitButton setFrame:CGRectMake(25, 250, 270, 40)];
    [ssview0_submitButton setBackgroundColor:We_background_red_tableviewcell];
    [ssview0_submitButton setTintColor:We_foreground_white_general];
    [ssview0_submitButton setTitle:@"添加检查结果" forState:UIControlStateNormal];
    [ssview0_submitButton addTarget:self action:@selector(ssview0_submitButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [ssview0 addSubview:ssview0_submitButton];
    
    // 添加检查结果产生的效应 - //遮罩层
    ssview0_shadowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ssview0_shadowButton setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [ssview0_shadowButton setBackgroundColor:[UIColor blackColor]];
    [ssview0_shadowButton setAlpha:0.0];
    [ssview0_shadowButton addTarget:self action:@selector(ssview0_shadowOrCancelButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.view addSubview:ssview0_shadowButton];
    
    [self.navigationController.view addSubview:ssview0];
    
    
    
    
    // 就诊历史页面 - 背景
    UIImageView * view1Header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 155)];
    view1Header.image = [UIImage imageNamed:@"addcasehistory-bg"];
    view1Header.contentMode = UIViewContentModeCenter;
    [tableView_view1.tableHeaderView addSubview:view1Header];
    [tableView_view1.tableHeaderView addSubview:view1AddButton];
    
    UIBarButtonItem * user_cancel = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(user_cancel_onPress:)];
    self.navigationItem.leftBarButtonItem = user_cancel;
    
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (showflag) {
        [self dismissViewControllerAnimated:NO completion:^{}];
    }
    else
    {
        [self preworkOnExaminations:self];
        [tableView_view1 reloadData];
    }
   
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    showflag=NO;
}
//返回按钮
- (void)user_cancel_onPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)ssview0_shadowOrCancelButton_onPress:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    [ssview0_shadowButton setAlpha:0.0];
    [ssview0_shadowButton setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    CGRect rect = ssview0.frame;
    rect.origin.y = self.view.frame.size.height;
    ssview0.frame = rect;
    
    [UIView commitAnimations];
}

// 添加检查结果
- (void)view1AddButton_onPress:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    [ssview0_shadowButton setAlpha:0.6];
    [ssview0_shadowButton setFrame:CGRectMake(0, -300, self.view.frame.size.width, self.view.frame.size.height)];
    
    CGRect rect = ssview0.frame;
    rect.origin.y = self.view.frame.size.height - ssview0.frame.size.height;
    ssview0.frame = rect;
    
    [UIView commitAnimations];
}

// 确认添加检查结果
- (void)ssview0_submitButton_onPress:(id)sender {
    
    WeNavViewController * nav = [[WeNavViewController alloc] init];
    addflag=YES;
    WeCahAddExaViewController * vc = [[WeCahAddExaViewController alloc] init];
    vc.lastViewController = self.last;
    vc.llViewController=self;
    vc.primaryTypeKey = we_examinationTypeKeys[[ssview0_picker selectedRowInComponent:0]];
    vc.secondaryTypeId = [NSString stringWithFormat:@"%@", we_examinationTypes[we_examinationTypeKeys[[ssview0_picker selectedRowInComponent:0]]][[ssview0_picker selectedRowInComponent:1]][@"id"]];
    //NSLog(@"%@", vc.secondaryTypeId);
    [nav pushViewController:vc animated:NO];
    
    [self presentViewController:nav animated:YES completion:nil];
    
    [self ssview0_shadowOrCancelButton_onPress:self];
}

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
    //
    
    
    [self bindExaminationrecId:_cahId examin:tableViewData1[path.section][path.row]];
    
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
// 询问每个段落的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    [view setBackgroundColor:We_background_red_general];
    UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 30)];
    l1.font = We_font_textfield_zh_cn;
    l1.textColor = We_foreground_white_general;
    
    l1.text = [self getYearAndMonth:[(WeCaseRecord *)tableViewData1[section][0] date]];
    
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
 
    return [tableViewData1 count];

}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    
    return [tableViewData1[section] count];
    
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    
    WeExamination * examination = tableViewData1[indexPath.section][indexPath.row];
    cell.backgroundColor = We_foreground_white_general;
    
    UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 40)];
    l1.font = We_font_textfield_zh_cn;
    l1.textColor = We_foreground_black_general;
    l1.text = we_secondaryTypeKeyToValue[examination.type.objId];
    [cell.contentView addSubview:l1];
    
    UILabel * l2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 200, 40)];
    l2.font = We_font_textfield_zh_cn;
    l2.textColor = We_foreground_gray_general;
    l2.text = examination.hospital;
    [cell.contentView addSubview:l2];
    
    UILabel * l3 = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 80, 88)];
    l3.font = We_font_textfield_zh_cn;
    l3.textColor = We_foreground_gray_general;
    l3.text = examination.date;
    [cell.contentView addSubview:l3];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

#pragma mark --pickerviewDelegrate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == ssview0_picker) {
        return 2;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == ssview0_picker) {
        if (component == 0) {
            return [we_codings[@"examinationType"] count];
        }
        if (component == 1) {
            return [we_examinationTypes[we_examinationTypeKeys[[pickerView selectedRowInComponent:0]]] count];
        }
    }
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel * newView = (UILabel *)view;
    if (!newView) {
        newView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 32)];
        newView.font = We_font_textfield_zh_cn;
        if (component == 0) {
            newView.text = we_codings[@"examinationType"][we_examinationTypeKeys[row]];
        }
        else if (component == 1) {
            newView.text = we_examinationTypes[we_examinationTypeKeys[[pickerView selectedRowInComponent:0]]][row][@"text"];
        }
        newView.adjustsFontSizeToFitWidth = YES;
    }
    return newView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [pickerView reloadAllComponents];
}



- (NSString *)getYearAndMonth:(NSString *)date {
    return [NSString stringWithFormat:@"%@年%@月", [date substringWithRange:NSMakeRange(0, 4)], [date substringWithRange:NSMakeRange(5, 2)]];
}
- (void)preworkOnExaminations:(id)sender {
    [examinations sortUsingComparator:^NSComparisonResult(id rA, id rB) {
        return [[(WeExamination *)rB date] compare:[(WeExamination *)rA date]];
    }];
    tableViewData1 = [[NSMutableArray alloc] init];
    int j = -1;
    for (int i = 0; i < [examinations count]; i ++) {
        if (i == 0 || ![[self getYearAndMonth:[(WeExamination *)examinations[i] date]] isEqualToString:[self getYearAndMonth:[(WeExamination *)examinations[i - 1] date]]]) {
            j ++;
            tableViewData1[j] = [[NSMutableArray alloc] init];
        }
        [tableViewData1[j] addObject:examinations[i]];
    }
}

- (void)bindExaminationrecId:(NSString *)recordId examin:(WeExamination*) exa {
    
//    MyLog(@"------%lld   %lld",[exa.examId longLongValue],[recordId longLongValue]);

    [self.view endEditing:YES];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:yijiarenUrl(@"patient", @"bindExamination") parameters:@{
                                                                         @"examinationId":exa.examId,
                                                                         @"recordId":recordId,
                                                                         @"bind":@"true"
                                                                         }
          success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
              NSString * errorMessage;
//              NSLog(@"HTTPResponse : %@", HTTPResponse);
              
              NSString *result = [HTTPResponse objectForKey:@"result"];
              result = [NSString stringWithFormat:@"%@", result];
              
              if ([result isEqualToString:@"1"]) {
            
//                  MyLog(@"---------------%i",caseRecordChanging.examinations.count);
                  for (int i=0; i<caseRecordChanging.examinations.count; i++) {
                      WeExamination *exa1=caseRecordChanging.examinations[i];
                      if ([exa1.examId isEqualToString:exa.examId]) {
                          [caseRecordChanging.examinations removeObject:exa1];
                      }
                  }
//                   MyLog(@"--================%i",caseRecordChanging.examinations.count);
                  [caseRecordChanging.examinations addObject:exa];
//                   MyLog(@"---------------%i",caseRecordChanging.examinations.count);
                  
                  [self dismissViewControllerAnimated:YES completion:nil];
                  
                  return;
              }
              
              UIAlertView *notPermitted = [[UIAlertView alloc]
                                           initWithTitle:@"添加检查信息失败"
                                           message:errorMessage
                                           delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
              [notPermitted show];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);

              UIAlertView *notPermitted = [[UIAlertView alloc]
                                           initWithTitle:@"添加检查信息失败"
                                           message:@"未能连接服务器，请重试"
                                           delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
              [notPermitted show];
          }
     ];
}


@end
