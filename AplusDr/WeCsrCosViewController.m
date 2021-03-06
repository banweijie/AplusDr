//
//  WeCsrCosViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-12.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCsrCosViewController.h"
#import "WeAppDelegate.h"

@interface WeCsrCosViewController ()<UIAlertViewDelegate> {
    UIView * sys_explaination_view;
    UILabel * sys_explaination_label;
    UITableView * sys_tableView;
    UISwitch * user_ifemergent_switch;
    UIActivityIndicatorView * sys_pendingView;
    
    NSMutableString * user_gender;
    NSMutableString * user_age;
    NSMutableString * user_description;
    
    UIAlertView * isUseFunSupport;
    
    BOOL isFunFlag;
}

@end

@implementation WeCsrCosViewController

/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
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
    if (path.section == 1 && path.row == 0) {
        WeGenderPickerViewController * vc = [[WeGenderPickerViewController alloc] init];
        vc.stringToBeTitle = @"性别";
        vc.stringToModify = user_gender;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (path.section == 1 && path.row == 1) {
        WeSentenceModifyViewController * vc = [[WeSentenceModifyViewController alloc] init];
        vc.stringToBeTitle = @"年龄";
        vc.stringToModify = user_age;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (path.section == 1 && path.row == 3) {
        WeParagraphModifyViewController * vc = [[WeParagraphModifyViewController alloc] init];
        vc.stringToBeTitle = @"更多描述";
        vc.stringToModify = user_description;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (path.section == 2 && path.row == 0) {
        if ([self.currentDoctor.fundingId isEqualToString:@""]) {
            isFunFlag=NO;
            [self addConsult:self];
        }
        else
        {
            NSString *mes=[NSString stringWithFormat:@"您可以通过支持该医生的众筹项目‘%@’获得本次咨询机会\n支持金额为：%@元\n是否支持？",self.currentDoctor.Funding[@"title"],self.currentDoctor.fundingPrice];
            isUseFunSupport=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:mes delegate:self cancelButtonTitle:@"不使用" otherButtonTitles:@"使用", nil];
            [isUseFunSupport show];
        }
    }
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 3) {
        if ([user_description isEqualToString:@""]) {
            return [WeAppDelegate calcSizeForString:@"无" Font:We_font_textfield_zh_cn expectWidth:280].height + 60;
        }
        else {
            return [WeAppDelegate calcSizeForString:user_description Font:We_font_textfield_zh_cn expectWidth:280].height + 60;
        }
    }
    return tv.rowHeight;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 40 + 64;
    return 40;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return @"医生业务设置";
    if (section == 1) return @"咨询参考信息";
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    //if (section == 1) return 30;
    if (section == 0) return 60;
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 50 + self.tabBarController.tabBar.frame.size.height;
    return 10;
}
-(UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section{
    if (section == 0) return sys_explaination_view;
    return nil;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return 3;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 2;
    if (section == 1) return 4;
    if (section == 2) return 1;
    return 0;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        if (indexPath.section == 2) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        }
        else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
        }
    }
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    
                    cell.textLabel.text = @"咨询价格";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元/次", self.currentDoctor.consultPrice];
                    cell.detailTextLabel.font = We_font_textfield_zh_cn;
                    cell.detailTextLabel.textColor = We_foreground_black_general;
                    break;
                case 1:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    
                    cell.textLabel.text = @"咨询回复时限";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@小时", self.currentDoctor.maxResponseGap];
                    cell.detailTextLabel.font = We_font_textfield_zh_cn;
                    cell.detailTextLabel.textColor = We_foreground_black_general;
                    break;
                default:
                    break;
            }
            break;
        case 1:
            break;
        case 2:
            break;
        default:
            break;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.contentView.backgroundColor = We_background_cell_general;
        
        cell.textLabel.text = @"性别";
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        
        cell.detailTextLabel.text = [WeAppDelegate transitionGenderFromChar:user_gender];
        cell.detailTextLabel.font = We_font_textfield_zh_cn;
        cell.detailTextLabel.textColor = We_foreground_black_general;
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        cell.contentView.backgroundColor = We_background_cell_general;
        
        cell.textLabel.text = @"年龄";
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        
        cell.detailTextLabel.text = user_age;
        cell.detailTextLabel.font = We_font_textfield_zh_cn;
        cell.detailTextLabel.textColor = We_foreground_black_general;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        
        cell.contentView.backgroundColor = We_background_cell_general;
        
        cell.textLabel.text = @"是否紧急";
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        
        [cell.contentView addSubview:user_ifemergent_switch];
    }
    if (indexPath.section == 1 && indexPath.row == 3) {
        UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 280, 40)];
        l1.text = @"更多描述";
        l1.font = We_font_textfield_zh_cn;
        l1.textColor = We_foreground_black_general;
        [cell.contentView addSubview:l1];
        
        if ([user_description isEqualToString:@""]) {
            CGSize sizezz = [WeAppDelegate calcSizeForString:@"无" Font:We_font_textfield_zh_cn expectWidth:280];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, sizezz.width, sizezz.height)];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.text = @"无";
            label.font = We_font_textfield_zh_cn;
            label.textColor = We_foreground_gray_general;
            [cell.contentView addSubview:label];
        }
        else {
            CGSize sizezz = [WeAppDelegate calcSizeForString:user_description Font:We_font_textfield_zh_cn expectWidth:280];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, sizezz.width, sizezz.height)];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.text = user_description;
            label.font = We_font_textfield_zh_cn;
            label.textColor = We_foreground_gray_general;
            [cell.contentView addSubview:label];
        }
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.backgroundColor = We_foreground_red_general;
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"确认发起咨询";
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_white_general;
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

- (void)addConsult:(id)sender {
    [sys_pendingView startAnimating];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:yijiarenUrl(@"patient", @"addConsult") parameters:@{
                                                                      @"consult.doctor.id":self.currentDoctor.userId,
                                                                      @"consult.gender":user_gender,
                                                                      @"consult.age":user_age,
                                                                      @"consult.emergent":user_ifemergent_switch.on?@"true":@"false",
                                                                      @"consult.description":user_description
                                                                      }
          success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
              [sys_pendingView stopAnimating];
              NSString * errorMessage;
              
              NSString *result = [HTTPResponse objectForKey:@"result"];
              result = [NSString stringWithFormat:@"%@", result];
              if ([result isEqualToString:@"1"]) {
                  [WeAppDelegate updateFavorDoctorList];
                  if (isFunFlag) {
                      [self changeOrderWithDic:HTTPResponse[@"response"][@"order"]];
                  }
                  else
                  {
//                      NSLog(@"%@",HTTPResponse[@"response"][@"order"]);
                      WeSelectPayViewController *payview=[[WeSelectPayViewController alloc]init];
                      payview.order=HTTPResponse[@"response"][@"order"];
                      payview.message=@"您已成功发起在线咨询申请";
                      [self.navigationController pushViewController:payview animated:YES];
                  }
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
              UIAlertView *notPermitted = [[UIAlertView alloc]
                                           initWithTitle:@"操作失败"
                                           message:errorMessage
                                           delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
              [notPermitted show];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [sys_pendingView stopAnimating];
              NSLog(@"Error: %@", error);
              UIAlertView *notPermitted = [[UIAlertView alloc]
                                           initWithTitle:@"操作失败"
                                           message:@"未能连接服务器，请重试"
                                           delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
              [notPermitted show];
          }
     ];
    
}
-(void)changeOrderWithDic:(NSDictionary *)dic
{
    [sys_pendingView startAnimating];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    NSLog(@"fundingLevelId\n %@ orderId \n%@",self.currentDoctor.fundingId,dic[@"id"]);
    [manager POST:yijiarenUrl(@"patient", @"fundingConsult") parameters:@{
                                                                      @"fundingLevelId":self.currentDoctor.fundingId,
                                                                      @"orderId":dic[@"id"]
                                                                      }
          success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
              [sys_pendingView stopAnimating];
              NSString * errorMessage;
              
              NSString *result = [HTTPResponse objectForKey:@"result"];
              result = [NSString stringWithFormat:@"%@", result];
              if ([result isEqualToString:@"1"]) {
//                  NSLog(@"HTTPResponse\n%@",HTTPResponse);
                  [WeAppDelegate updateFavorDoctorList];
                  WeSelectPayViewController *payview=[[WeSelectPayViewController alloc]init];
                  payview.order=HTTPResponse[@"response"];
                  payview.message=@"您已成功发起在线咨询申请";
                  [self.navigationController pushViewController:payview animated:YES];
                  
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
              UIAlertView *notPermitted = [[UIAlertView alloc]
                                           initWithTitle:@"操作失败"
                                           message:errorMessage
                                           delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
              [notPermitted show];

            
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [sys_pendingView stopAnimating];
              NSLog(@"Error: %@", error);
              UIAlertView *notPermitted = [[UIAlertView alloc]
                                           initWithTitle:@"操作失败"
                                           message:@"未能连接服务器，请重试"
                                           delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
              [notPermitted show];
          }
     ];

}
- (void)user_cancel_onPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"发起咨询";
    
    // Initial conditions
    user_age = [[NSMutableString alloc] init];
    user_description = [[NSMutableString alloc] init];
    user_gender = [[NSMutableString alloc] initWithString:@"U"];
    
    // 是否紧急
    user_ifemergent_switch = [[UISwitch alloc] initWithFrame:CGRectMake(250, 5, 60, 30)];
    
    // sys_explaination
    sys_explaination_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    sys_explaination_label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 30)];
    sys_explaination_label.lineBreakMode = NSLineBreakByWordWrapping;
    sys_explaination_label.numberOfLines = 0;
    sys_explaination_label.text = @"患者发出咨询请求后，若您未能在该时限内回复则取消咨询，并将咨询费返还至患者账户";
    sys_explaination_label.font = We_font_textfield_zh_cn;
    sys_explaination_label.textColor = We_foreground_gray_general;
    sys_explaination_label.textAlignment = NSTextAlignmentCenter;
    [sys_explaination_view addSubview:sys_explaination_label];
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [sys_tableView reloadData];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==isUseFunSupport && buttonIndex==1) {
        isFunFlag=YES;
    }
    else
    {
        isFunFlag=NO;
    }
    [self addConsult:self];
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
