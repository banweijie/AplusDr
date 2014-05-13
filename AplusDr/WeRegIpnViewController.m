//
//  WeRegisterInputPhoneNumberViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-6.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeRegIpnViewController.h"
#import "WeAppDelegate.h"

@interface WeRegIpnViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *navi;

@end

@implementation WeRegIpnViewController
{
    UITextField * user_phone_input;
    UIButton * sys_nextStep_button;
    UIView * sys_userAgreement_demo;
    UITableView * sys_tableView;
    int count;
}

/*
    [AREA] 
        UITableView dataSource & delegate interfaces
*/
// 调整格子的透明度
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = We_alpha_cell_general;;
    cell.opaque = YES;
}
// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section == 0) {
        return nil;
    }
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section == 1 && path.row == 0) {
        count ++;
        if (!self.sendVeriCode) return;
        we_vericode_type = @"NewPassword";
        we_phone_onReg = user_phone_input.text;
        [self push_to_ivc:nil];
    }
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 20 + 64;
    return 20;
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
// 询问每个段落的尾部
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return sys_userAgreement_demo;
    }
    return nil;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return 2;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    if (section == 1) return 1;
    return 0;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    NSLog(@"%ld, %ld",(long)indexPath.section, (long)indexPath.row);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.contentView.backgroundColor = We_background_cell_general;
            cell.textLabel.text = @"手机号";
            cell.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:16];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell addSubview:user_phone_input];
        }
    }
    if (indexPath.section == 1) {
        cell.contentView.backgroundColor = We_background_red_tableviewcell;
        cell.textLabel.text = @"下一步";
        cell.textLabel.font = We_font_button_zh_cn;
        cell.textLabel.textColor = We_foreground_white_general;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

/*
    [AREA]
        Actions of all views
*/
- (void)resignFirstResponder:(id)sender {
    NSLog(@"resignFirstResponder:");
    [sender resignFirstResponder];
}
- (void)checkForUserAgreement:(id)sender {
    NSLog(@"checkForUserAgreement:");
}
- (void)push_to_ivc:(id)sender {
    NSLog(@"segue~~:");
    [self performSegueWithIdentifier:@"ipn2ivc" sender:self];
}
/*
    [AREA]
        Functional
*/
- (BOOL) sendVeriCode
{
    NSLog(@"sendVeriCode");
    NSString *errorMessage = @"无法连接网络，请重试";
    NSString *urlString = @"http://115.28.222.1/yijiaren/user/sendVerificationCode.action";
    NSString *parasString = [NSString stringWithFormat:@"phone=%@", user_phone_input.text];
    NSData * DataResponse = [WeAppDelegate sendPhoneNumberToServer:urlString paras:parasString];
    if (DataResponse != NULL) {
        NSDictionary *HTTPResponse = [NSJSONSerialization JSONObjectWithData:DataResponse options:NSJSONReadingMutableLeaves error:nil];
    NSString *result = [HTTPResponse objectForKey:@"result"];
    result = [NSString stringWithFormat:@"%@", result];
    if ([result isEqualToString:@"1"]) {
        return YES;
    }
    if ([result isEqualToString:@"2"]) {
        NSString *fields = [HTTPResponse objectForKey:@"fields"];
        if (fields != NULL) errorMessage = [[HTTPResponse objectForKey:@"fields"] objectForKey:@"phone"];
    }
    if ([result isEqualToString:@"3"]) {
        errorMessage = [HTTPResponse objectForKey:@"info"];
    }
    if ([result isEqualToString:@"4"]) {
        errorMessage = [HTTPResponse objectForKey:@"info"];
    }
    }
    UIAlertView *notPermitted = [[UIAlertView alloc]
                                 initWithTitle:@"发送验证码失败"
                                 message:errorMessage
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [notPermitted show];
    return NO;
}
/*
    [AREA]
        View releated
*/
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
    
    count = 0;
    // navigation return button init
    //self.navigationController.navigationBar.TintColor = We_foreground_white_general;
    
    // user_phone_input init
    user_phone_input = [[UITextField alloc] initWithFrame:CGRectMake(100, 9, 220, 30)];
    user_phone_input.placeholder = @"请输入您的手机号码";
    user_phone_input.font = We_font_textfield_zh_cn;
    user_phone_input.autocorrectionType = UITextAutocorrectionTypeNo;
    [user_phone_input setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    // sys_nextStep_button init
    sys_nextStep_button = [UIButton buttonWithType:UIButtonTypeSystem];
    sys_nextStep_button.frame = CGRectMake(0, 0, 320, 44);
    [sys_nextStep_button setTitle:@"下一步" forState:UIControlStateNormal];
    [sys_nextStep_button setBackgroundColor:We_background_red_tableviewcell];
    [sys_nextStep_button setTintColor:We_foreground_white_general];
    sys_nextStep_button.titleLabel.font = We_font_button_zh_cn;
    //[sys_nextStep_button addTarget:self action:@selector(send_register:) forControlEvents:UIControlEventTouchUpInside];
    
    // sys_userAgreement_demo init
    sys_userAgreement_demo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    UILabel * sys_userAgreement_demo_text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    sys_userAgreement_demo_text.text = @"注册即视为同意                。";
    sys_userAgreement_demo_text.font = We_font_textfield_zh_cn;
    sys_userAgreement_demo_text.textColor = We_foreground_gray_general;
    sys_userAgreement_demo_text.textAlignment = NSTextAlignmentCenter;
    [sys_userAgreement_demo addSubview:sys_userAgreement_demo_text];
    UIButton * sys_userAgreement_demo_button = [UIButton buttonWithType:UIButtonTypeSystem];
    sys_userAgreement_demo_button.frame = CGRectMake(172, 0, 60, 30);
    [sys_userAgreement_demo_button setTitle:@"用户协议" forState:UIControlStateNormal];
    [sys_userAgreement_demo_button.titleLabel setFont:We_font_button_zh_cn];
    [sys_userAgreement_demo_button addTarget:self action:@selector(checkForUserAgreement:) forControlEvents:UIControlEventTouchUpInside];
    [sys_userAgreement_demo addSubview:sys_userAgreement_demo_button];
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    sys_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:sys_tableView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:nil action:nil];
}
@end
