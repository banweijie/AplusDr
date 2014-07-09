//
//  WeFunSup2ViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-23.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFunSup2ViewController.h"

@interface WeFunSup2ViewController () {
    UIActivityIndicatorView * sys_pendingView;
    
    UITableView * sys_tableView;
    NSMutableArray * infoList;
    
    NSMutableString * info_name;
    NSMutableString * info_phone;
    NSMutableString * info_address;
    NSMutableString * info_email;
    NSMutableString * info_description;
}

@end

@implementation WeFunSup2ViewController

@synthesize currentLevel;

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && [infoList count] != 0) {
        if ([infoList[indexPath.row] isEqualToString:@"name"]) {
            WeSentenceModifyViewController * vc = [[WeSentenceModifyViewController alloc] init];
            vc.stringToModify = info_name;
            vc.stringToPlaceHolder = @"尚未填写真实姓名";
            vc.stringToBeTitle = @"真实姓名";
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([infoList[indexPath.row] isEqualToString:@"phone"]) {
            WeSentenceModifyViewController * vc = [[WeSentenceModifyViewController alloc] init];
            vc.stringToModify = info_phone;
            vc.stringToPlaceHolder = @"尚未填写手机号码";
            vc.stringToBeTitle = @"手机号码";
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([infoList[indexPath.row] isEqualToString:@"email"]) {
            WeSentenceModifyViewController * vc = [[WeSentenceModifyViewController alloc] init];
            vc.stringToModify = info_email;
            vc.stringToPlaceHolder = @"尚未填写电子邮件";
            vc.stringToBeTitle = @"电子邮件";
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([infoList[indexPath.row] isEqualToString:@"address"]) {
            WeParagraphModifyViewController * vc = [[WeParagraphModifyViewController alloc] init];
            vc.stringToModify = info_address;
            vc.stringToPlaceHolder = @"尚未填写寄件地址";
            vc.stringToBeTitle = @"寄件地址";
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([infoList[indexPath.row] isEqualToString:@"description"]) {
            WeParagraphModifyViewController * vc = [[WeParagraphModifyViewController alloc] init];
            vc.stringToModify = info_description;
            vc.stringToPlaceHolder = @"尚未填写自我介绍";
            vc.stringToBeTitle = @"自我介绍";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self api_patient_supportFunding];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        CGSize sizezz = [currentLevel.repay sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
        return sizezz.height + 80;
    }
    if (indexPath.section == 1) {
        if ([infoList count] == 0) return [tableView rowHeight];
        if ([infoList[indexPath.row] isEqualToString:@"address"]) {
            NSString * tmpString = info_address;
            if ([info_address isEqualToString:@""]) tmpString = @"尚未填写寄送地址";
            
            CGSize sizezz = [tmpString sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
            return sizezz.height + 60;
        }
        if ([infoList[indexPath.row] isEqualToString:@"description"]) {
            NSString * tmpString = info_description;
            if ([info_description isEqualToString:@""]) tmpString = @"尚未填写自我介绍";
            
            CGSize sizezz = [tmpString sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
            return sizezz.height + 60;
        }
    }
    return [tableView rowHeight];
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 20 + 64;
    if (section == 1) return 39;
    return 19;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) return @"填写个人信息";
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) return 20;
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
    return 3;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    if (section == 1) return MAX([infoList count], 1);
    if (section == 2) return 1;
    return 1;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
        if (indexPath.section == 2 && indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        }
    }
    cell.opaque = NO;
    cell.backgroundColor = We_background_cell_general;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 220 - 16, 60)];
        if ([currentLevel.type isEqualToString:@"E"]) {
            l1.text = currentLevel.way;
        }
        else {
            l1.text = [NSString stringWithFormat:@"支持 ￥%@", currentLevel.money];
        }
        l1.font = We_font_textfield_large_zh_cn;
        l1.textColor = We_foreground_red_general;
        [cell.contentView addSubview:l1];
        
        UILabel * infoLabel = [[UILabel alloc] init];
        [infoLabel setFrame:CGRectMake(180, 15, 120, 30)];
        if ([currentLevel.limit isEqualToString:@"0"]) {
            [infoLabel setText:[NSString stringWithFormat:@"%@人支持", currentLevel.supportCount]];
        }
        else {
            [infoLabel setText:[NSString stringWithFormat:@"%@人支持/限%@人", currentLevel.supportCount, currentLevel.limit]];
        }
        [infoLabel setTextAlignment:NSTextAlignmentRight];
        [infoLabel setTextColor:We_foreground_black_general];
        [infoLabel setFont:We_font_textfield_zh_cn];
        [cell.contentView addSubview:infoLabel];
        
        CGSize sizezz = [currentLevel.repay sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(16, 60, sizezz.width, sizezz.height)];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.text = currentLevel.repay;
        label.font = We_font_textfield_zh_cn;
        label.textColor = We_foreground_gray_general;
        [cell.contentView addSubview:label];
    }
    if (indexPath.section == 1) {
        if ([infoList count] == 0) {
            [cell.textLabel setFont:We_font_textfield_zh_cn];
            [cell.textLabel setTextColor:We_foreground_black_general];
            [cell.textLabel setText:@"没有信息需要填写"];
        }
        else {
            if ([infoList[indexPath.row] isEqualToString:@"name"]) {
                [cell.textLabel setText:@"真实姓名"];
                if (![info_name isEqualToString:@""]) {
                    [cell.detailTextLabel setText:info_name];
                }
                else {
                    [cell.detailTextLabel setText:@"尚未填写真实姓名"];
                }
                [cell.textLabel setFont:We_font_textfield_zh_cn];
                [cell.textLabel setTextColor:We_foreground_black_general];
                [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
                [cell.detailTextLabel setTextColor:We_foreground_gray_general];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            if ([infoList[indexPath.row] isEqualToString:@"phone"]) {
                [cell.textLabel setText:@"手机号码"];
                if (![info_phone isEqualToString:@""]) {
                    [cell.detailTextLabel setText:info_phone];
                }
                else {
                    [cell.detailTextLabel setText:@"尚未填写手机号码"];
                }
                [cell.textLabel setFont:We_font_textfield_zh_cn];
                [cell.textLabel setTextColor:We_foreground_black_general];
                [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
                [cell.detailTextLabel setTextColor:We_foreground_gray_general];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            if ([infoList[indexPath.row] isEqualToString:@"email"]) {
                [cell.textLabel setText:@"电子邮箱"];
                if (![info_email isEqualToString:@""]) {
                    [cell.detailTextLabel setText:info_email];
                }
                else {
                    [cell.detailTextLabel setText:@"尚未填写电子邮箱"];
                }
                [cell.textLabel setFont:We_font_textfield_zh_cn];
                [cell.textLabel setTextColor:We_foreground_black_general];
                [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
                [cell.detailTextLabel setTextColor:We_foreground_gray_general];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            if ([infoList[indexPath.row] isEqualToString:@"address"]) {
                UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 220 - 16, 40)];
                [l1 setText:@"寄送地址"];
                l1.font = We_font_textfield_zh_cn;
                l1.textColor = We_foreground_black_general;
                [cell.contentView addSubview:l1];
                
                NSString * tmpString = info_address;
                if ([info_address isEqualToString:@""]) tmpString = @"尚未填写寄送地址";
                
                CGSize sizezz = [tmpString sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
                UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, sizezz.width, sizezz.height)];
                label.numberOfLines = 0;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.text = tmpString;
                label.font = We_font_textfield_zh_cn;
                label.textColor = We_foreground_gray_general;
                [cell.contentView addSubview:label];
                
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            if ([infoList[indexPath.row] isEqualToString:@"description"]) {
                UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 220 - 16, 40)];
                [l1 setText:@"自我简介"];
                l1.font = We_font_textfield_zh_cn;
                l1.textColor = We_foreground_black_general;
                [cell.contentView addSubview:l1];
                
                NSString * tmpString = info_description;
                if ([info_description isEqualToString:@""]) tmpString = @"尚未填写自我介绍";
                
                CGSize sizezz = [tmpString sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
                UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, sizezz.width, sizezz.height)];
                label.numberOfLines = 0;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.text = tmpString;
                label.font = We_font_textfield_zh_cn;
                label.textColor = We_foreground_gray_general;
                [cell.contentView addSubview:label];
                
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
        }
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        [cell setBackgroundColor:We_background_red_tableviewcell];
        [cell.textLabel setFont:We_font_textfield_large_zh_cn];
        [cell.textLabel setTextColor:We_foreground_white_general];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setText:@"确认支持"];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // 标题
    [self.navigationItem setTitle:@"确认支持方案"];
    
    // 表格
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
    
    // 统计需要记录的信息
    infoList = [[NSMutableArray alloc] init];
    if (currentLevel.needName) [infoList addObject:@"name"];
    if (currentLevel.needPhone) [infoList addObject:@"phone"];
    if (currentLevel.needEmail) [infoList addObject:@"email"];
    if (currentLevel.needAddress) [infoList addObject:@"address"];
    if (currentLevel.needDescription) [infoList addObject:@"description"];
    
    // 初始化各输入框
    NSLog(@"%@", currentUser.userName);
    info_name = [NSMutableString stringWithString:currentUser.trueName];
    info_phone = [NSMutableString stringWithString:currentUser.userPhone];
    info_email = [NSMutableString stringWithString:@""];
    info_address = [NSMutableString stringWithString:@""];
    info_description = [NSMutableString stringWithString:@""];
}

- (void)viewWillAppear:(BOOL)animated {
    [sys_tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)api_patient_supportFunding {
    [sys_pendingView startAnimating];
    
    [WeAppDelegate postToServerWithField:@"patient" action:@"supportFunding"
                              parameters:@{
                                           @"fs.fundingLevel.id":currentLevel.levelId,
                                           @"fs.email":info_email,
                                           @"fs.name":info_name,
                                           @"fs.address":info_address,
                                           @"fs.phone":info_phone,
                                           @"fs.description":info_description,
                                           @"fs.zip":@"100871"
                                           }
                                 success:^(id response) {
                                     NSLog(@"%@", response);
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     NSLog(@"%@", errorMessage);
                                     [sys_pendingView stopAnimating];
                                 }];
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
