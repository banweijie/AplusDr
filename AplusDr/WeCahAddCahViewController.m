//
//  WeCahAddCahViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-24.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCahAddCahViewController.h"
#import "WePickerSelectView.h"

@interface WeCahAddCahViewController ()<PickerSelectDelete>
{
    UITableView * sys_tableView;
    UITextField * user_date_input;
    UITextField * user_hospitalName_input;
    UITextField * user_diseaseName_input;
    UIActivityIndicatorView * sys_pendingView;
    
    WePickerSelectView *datePickerView;
    UIButton *ssview0_shadowButton;
}
@end

@implementation WeCahAddCahViewController

@synthesize lastViewController;

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
    if (tv == sys_tableView) {
        if (path.section == 0 && path.row == 0) {
//            [user_date_input becomeFirstResponder];
            [self moveUp];
            
        }
        if (path.section == 0 && path.row == 1) {
            [user_hospitalName_input becomeFirstResponder];
        }
        if (path.section == 0 && path.row == 2) {
            [user_diseaseName_input becomeFirstResponder];
        }
        if (path.section == 1) {
            [self addNewCaseHistory:self];
            [sys_pendingView startAnimating];
        }
    }
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tv.rowHeight;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 10 + 64;
    return 10;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
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
    if (tv == sys_tableView) {
        return 2;
    }
    return 0;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (tv == sys_tableView) {
        if (section == 0) return 3;
        if (section == 1) return 1;
    }
    return 0;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        }
    }
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    
    if (tv == sys_tableView) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.backgroundColor = We_foreground_white_general;
            cell.textLabel.text = @"就诊时间";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            [cell.contentView addSubview:user_date_input];
        }
        if (indexPath.section == 0 && indexPath.row == 1) {
            cell.backgroundColor = We_foreground_white_general;
            cell.textLabel.text = @"就诊地点";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            [cell.contentView addSubview:user_hospitalName_input];
        }
        if (indexPath.section == 0 && indexPath.row == 2) {
            cell.backgroundColor = We_foreground_white_general;
            cell.textLabel.text = @"疾病名称";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            [cell.contentView addSubview:user_diseaseName_input];
        }
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell.backgroundColor = We_foreground_red_general;
            cell.textLabel.text = @"提交并继续填写";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_white_general;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    return cell;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.navigationItem.title = @"添加就诊记录";
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sys_tableView];
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
    // 输入框初始化
    We_init_textFieldInCell_pholder(user_date_input, @"如：2014-02-16", We_font_textfield_en_us);   
    We_init_textFieldInCell_pholder(user_hospitalName_input, @"如：北医三院", We_font_textfield_zh_cn);
    We_init_textFieldInCell_pholder(user_diseaseName_input, @"如：哮喘", We_font_textfield_zh_cn);
    
    
    user_date_input.userInteractionEnabled=NO;
    
    // 取消按键
    UIBarButtonItem * user_cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(user_cancel_onPress:)];
    self.navigationItem.leftBarButtonItem = user_cancel;
    
    //遮罩层
    ssview0_shadowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ssview0_shadowButton setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [ssview0_shadowButton setBackgroundColor:[UIColor blackColor]];
    [ssview0_shadowButton setAlpha:0.0];
    [ssview0_shadowButton addTarget:self action:@selector(ssview0_shadowOrCancelButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:ssview0_shadowButton];
    
    datePickerView=[[WePickerSelectView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 300)];
    datePickerView.delegrate=self;
    [self.navigationController.view addSubview:datePickerView];

}
#pragma mark----pickerselectdelegrate

-(void)SelectDateInPicker:(NSString *)time
{
    user_date_input.text=time;
    [self moveDown];
}
-(void)SelectCancelButton:(UIButton *)but
{
    [self moveDown];
}

-(void)ssview0_shadowOrCancelButton_onPress:(UIButton *)sender
{
    [self moveDown];
}
-(void)moveDown
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect ff=datePickerView.frame;
    ff.origin.y+=300;
    datePickerView.frame=ff;
    ssview0_shadowButton.alpha=0;
    datePickerView.alpha=0;
    [UIView commitAnimations];
}
-(void)moveUp
{
    [self scrollViewDidScroll:nil];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect ff=datePickerView.frame;
    ff.origin.y-=300;
    datePickerView.frame=ff;
    ssview0_shadowButton.alpha=0.6;
    datePickerView.alpha=1;
    [UIView commitAnimations];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [user_diseaseName_input resignFirstResponder];
    [user_hospitalName_input resignFirstResponder];
}
- (void)user_cancel_onPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addNewCaseHistory:(id)sender {
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:yijiarenUrl(@"patient", @"addRecord") parameters:@{
                                                                       @"record.date":user_date_input.text,
                                                                       @"record.hospital":user_hospitalName_input.text,
                                                                       @"record.disease":user_diseaseName_input.text,
                                                                       }
          success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
              NSString * errorMessage;
              
              NSString *result = [HTTPResponse objectForKey:@"result"];
              result = [NSString stringWithFormat:@"%@", result];
              if ([result isEqualToString:@"1"]) {
//                  NSLog(@"response : %@", HTTPResponse[@"response"]);
                  WeCaseRecord * newCaseRecord = [[WeCaseRecord alloc] initWithNSDictionary:HTTPResponse[@"response"]];
                  [caseRecords addObject:newCaseRecord];
                  
                  caseRecordChanging = newCaseRecord;
                  
                  [self dismissViewControllerAnimated:YES completion:nil];
                  
                  WeCahCahViewController * vc = [[WeCahCahViewController alloc] init];
                  [self.lastViewController.navigationController pushViewController:vc animated:YES];
                  
                  we_justAddNewCaseRecord = YES;
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
                                           initWithTitle:@"发送信息失败"
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
                                           initWithTitle:@"发送信息失败"
                                           message:@"未能连接服务器，请重试"
                                           delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
              [notPermitted show];
          }
     ];
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
