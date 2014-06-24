//
//  WeFunMySup2ViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-24.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFunMySup2ViewController.h"

@interface WeFunMySup2ViewController () {
    UIActivityIndicatorView * sys_pendingView;
    UITableView * sys_tableView;
    UIButton * refreshButton;
    
    UIView * fundingCard_outterView;
    UIView * fundingCard_cell;
    
    WeFundingSupport * currentSupport;
    WeFundingLevel * currentLevel;
    WeFunding * currentFunding;
    NSMutableArray * infoList;
}

@end

@implementation WeFunMySup2ViewController

@synthesize currentSupportId;

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
    if (indexPath.section == 0 && indexPath.row == 1) {
        CGSize sizezz = [currentLevel.repay sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
        return sizezz.height + 80;
    }
    if (indexPath.section == 1) {
        if ([infoList[indexPath.row] isEqualToString:@"address"]) {
            NSString * tmpString = currentSupport.address;
            if ([currentSupport.address isEqualToString:@""]) tmpString = @"尚未填写寄送地址";
            
            CGSize sizezz = [tmpString sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
            return sizezz.height + 60;
        }
        if ([infoList[indexPath.row] isEqualToString:@"description"]) {
            NSString * tmpString = currentSupport.description;
            if ([currentSupport.description isEqualToString:@""]) tmpString = @"尚未填写自我介绍";
            
            CGSize sizezz = [tmpString sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
            return sizezz.height + 60;
        }
    }
    return [tableView rowHeight];
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 64 + 40 + 220;
    return 20;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return fundingCard_outterView;
    }
    return nil;
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 20 + self.tabBarController.tabBar.frame.size.height;
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
    return 2;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 2;
    if (section == 1) return [infoList count];
    return 1;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    cell.opaque = NO;
    cell.backgroundColor = We_background_cell_general;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell.textLabel setText:@"交易号"];
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_black_general];
        [cell.detailTextLabel setText:currentSupport.orderId];
        [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
        [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
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
        if ([infoList[indexPath.row] isEqualToString:@"name"]) {
            [cell.textLabel setText:@"真实姓名"];
            if (![currentSupport.name isEqualToString:@""]) {
                [cell.detailTextLabel setText:currentSupport.name];
            }
            else {
                [cell.detailTextLabel setText:@"尚未填写真实姓名"];
            }
            [cell.textLabel setFont:We_font_textfield_zh_cn];
            [cell.textLabel setTextColor:We_foreground_black_general];
            [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
            [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        }
        if ([infoList[indexPath.row] isEqualToString:@"phone"]) {
            [cell.textLabel setText:@"手机号码"];
            if (![currentSupport.phone isEqualToString:@""]) {
                [cell.detailTextLabel setText:currentSupport.phone];
            }
            else {
                [cell.detailTextLabel setText:@"尚未填写手机号码"];
            }
            [cell.textLabel setFont:We_font_textfield_zh_cn];
            [cell.textLabel setTextColor:We_foreground_black_general];
            [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
            [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        }
        if ([infoList[indexPath.row] isEqualToString:@"email"]) {
            [cell.textLabel setText:@"电子邮箱"];
            if (![currentSupport.email isEqualToString:@""]) {
                [cell.detailTextLabel setText:currentSupport.email];
            }
            else {
                [cell.detailTextLabel setText:@"尚未填写电子邮箱"];
            }
            [cell.textLabel setFont:We_font_textfield_zh_cn];
            [cell.textLabel setTextColor:We_foreground_black_general];
            [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
            [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        }
        if ([infoList[indexPath.row] isEqualToString:@"zip"]) {
            [cell.textLabel setText:@"邮政编码"];
            if (![currentSupport.zip isEqualToString:@""]) {
                [cell.detailTextLabel setText:currentSupport.zip];
            }
            else {
                [cell.detailTextLabel setText:@"尚未填写邮政编码"];
            }
            [cell.textLabel setFont:We_font_textfield_zh_cn];
            [cell.textLabel setTextColor:We_foreground_black_general];
            [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
            [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        }
        if ([infoList[indexPath.row] isEqualToString:@"address"]) {
            UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 220 - 16, 40)];
            [l1 setText:@"寄送地址"];
            l1.font = We_font_textfield_zh_cn;
            l1.textColor = We_foreground_black_general;
            [cell.contentView addSubview:l1];
            
            NSString * tmpString = currentSupport.address;
            if ([currentSupport.address isEqualToString:@""]) tmpString = @"尚未填写寄送地址";
            
            CGSize sizezz = [tmpString sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, sizezz.width, sizezz.height)];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.text = tmpString;
            label.font = We_font_textfield_zh_cn;
            label.textColor = We_foreground_gray_general;
            [cell.contentView addSubview:label];
        }
        if ([infoList[indexPath.row] isEqualToString:@"description"]) {
            UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 220 - 16, 40)];
            [l1 setText:@"自我简介"];
            l1.font = We_font_textfield_zh_cn;
            l1.textColor = We_foreground_black_general;
            [cell.contentView addSubview:l1];
            
            NSString * tmpString = currentSupport.description;
            if ([currentSupport.description isEqualToString:@""]) tmpString = @"尚未填写自我介绍";
            
            CGSize sizezz = [tmpString sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, sizezz.width, sizezz.height)];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.text = tmpString;
            label.font = We_font_textfield_zh_cn;
            label.textColor = We_foreground_gray_general;
            [cell.contentView addSubview:label];
        }
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
    [refreshButton setTitle:@"获取众筹详情失败，点击刷新" forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTintColor:We_foreground_red_general];
    [self.view addSubview:refreshButton];
    
    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    
    // 标题
    self.navigationItem.title = @"参与详情";
    
    // 访问获取众筹详情列表
    [self api_patient_viewSupport];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickButton_onPress:(id)sender {
    UINavigationController * nav = self.navigationController;
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    WeFunDetViewController * vc = [[WeFunDetViewController alloc] init];
    vc.currentFundingId = currentFunding.fundingId;
    
    [nav pushViewController:vc animated:YES];
}

- (void)refreshButton_onPress:(id)sender {
    [self api_patient_viewSupport];
}

- (void)api_patient_viewSupport {
    [sys_pendingView startAnimating];
    [refreshButton setHidden:YES];
    [sys_tableView setHidden:YES];
    
    [WeAppDelegate postToServerWithField:@"patient" action:@"viewSupport"
                              parameters:@{
                                           @"supportId":currentSupportId
                                           }
                                 success:^(id response) {
                                     NSLog(@"%@", response);
                                     currentSupport = [[WeFundingSupport alloc] initWithNSDictionary:response];
                                     currentLevel = [[WeFundingLevel alloc] initWithNSDictionary:response[@"fundingLevel"]];
                                     currentFunding = [[WeFunding alloc] initWithNSDictionary:response[@"fundingLevel"][@"funding"]];
                                     
                                     // 统计需要记录的信息
                                     infoList = [[NSMutableArray alloc] init];
                                     if (currentLevel.needName) [infoList addObject:@"name"];
                                     if (currentLevel.needPhone) [infoList addObject:@"phone"];
                                     if (currentLevel.needEmail) [infoList addObject:@"email"];
                                     if (currentLevel.needAddress) {
                                         [infoList addObject:@"zip"];
                                         [infoList addObject:@"address"];
                                     }
                                     if (currentLevel.needDescription) [infoList addObject:@"description"];
                                     
                                     [self preworkOnFundingCard];
                                     [self.view addSubview:sys_tableView];
                                     [sys_tableView reloadData];
                                     [sys_tableView setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     [refreshButton setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }];
}

- (void)preworkOnFundingCard {
    // 众筹卡片
    fundingCard_outterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64 + 40 + 220)];
    fundingCard_cell = [[UIView alloc] initWithFrame:CGRectMake(10, 20 + 64, 300, 200)];
    [fundingCard_outterView addSubview:fundingCard_cell];
    
    // 背景图片
    UIImageView * backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 220)];
    [backGroundImageView setImageWithURL:[NSURL URLWithString:yijiarenImageUrl(currentFunding.poster2)]];
    [backGroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [fundingCard_cell addSubview:backGroundImageView];
    
    // 阴影层
    UIImageView * shadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 220 - 49 - 70, 300, 70)];
    [shadow setImage:[UIImage imageNamed:@"crowdfunding-gradientcover"]];
    [fundingCard_cell addSubview:shadow];
    
    // 高斯模糊
    /*
     UIToolbar * toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 220 - 49 - 70, 300, 70)];
     [toolBar setBarStyle:UIBarStyleBlackTranslucent];
     [toolBar setBackgroundImage:[WeAppDelegate imageWithColor:[UIColor clearColor]] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
     [cell.contentView addSubview:toolBar];*/
    
    // 主标题
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 200, 30)];
    [title setText:currentFunding.title];
    [title setFont:We_font_textfield_large_zh_cn];
    [title setTextColor:We_foreground_white_general];
    [title setShadowColor:We_foreground_black_general];
    [title setShadowOffset:CGSizeMake(1, 1)];
    [fundingCard_cell addSubview:title];
    
    // 医生信息
    UILabel * docInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, 125, 200, 20)];
    [docInfo setText:[NSString stringWithFormat:@"%@ 医生  %@", currentFunding.initiator.userName, we_codings[@"doctorCategory"][currentFunding.initiator.category][@"title"][currentFunding.initiator.title]]];
    [docInfo setFont:We_font_textfield_small_zh_cn];
    [docInfo setTextColor:We_foreground_white_general];
    [docInfo setShadowColor:We_foreground_black_general];
    [docInfo setShadowOffset:CGSizeMake(1, 1)];
    [fundingCard_cell addSubview:docInfo];
    
    UILabel * docInfo2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 200, 20)];
    [docInfo2 setText:[NSString stringWithFormat:@"%@ %@", currentFunding.initiator.hospitalName, currentFunding.initiator.sectionName]];
    [docInfo2 setFont:We_font_textfield_small_zh_cn];
    [docInfo2 setTextColor:We_foreground_white_general];
    [docInfo2 setShadowColor:We_foreground_black_general];
    [docInfo2 setShadowOffset:CGSizeMake(1, 1)];
    [fundingCard_cell addSubview:docInfo2];
    
    UIImageView * avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(235, 110, 50, 50)];
    [avatarView.layer setCornerRadius:avatarView.frame.size.height / 2];
    [avatarView.layer setMasksToBounds:YES];
    [fundingCard_cell addSubview:avatarView];
    [avatarView setImageWithURL:[NSURL URLWithString:yijiarenAvatarUrl(currentFunding.initiator.avatarPath)]];
    
    // 信息层
    UIImageView * infoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 220 - 44, 300, 44)];
    [infoView setImage:[WeAppDelegate imageWithColor:We_foreground_white_general]];
    [fundingCard_cell addSubview:infoView];
    
    UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 220 - 44 + 12, 20, 20)];
    [imageView1 setImage:[UIImage imageNamed:@"crowdfunding-list-money"]];
    [imageView1 setContentMode:UIViewContentModeCenter];
    [fundingCard_cell addSubview:imageView1];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 - 44 + 12, 80, 20)];
    [label1 setFont:We_font_textfield_small_zh_cn];
    [label1 setTextColor:We_foreground_black_general];
    if ([currentFunding.type isEqualToString:@"D"]) {
        [label1 setText:[NSString stringWithFormat:@"%@人 已募", currentFunding.supportCount]];
    }
    else {
        [label1 setText:[NSString stringWithFormat:@"￥%@ 已筹", currentFunding.sum]];
    }
    [fundingCard_cell addSubview:label1];
    
    UIImageView * imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(110, 220 - 44 + 12, 20, 20)];
    [imageView2 setImage:[UIImage imageNamed:@"crowdfunding-list-favorite"]];
    [imageView2 setContentMode:UIViewContentModeCenter];
    [fundingCard_cell addSubview:imageView2];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(130, 220 - 44 + 12, 80, 20)];
    [label2 setFont:We_font_textfield_small_zh_cn];
    [label2 setTextColor:We_foreground_black_general];
    [label2 setText:[NSString stringWithFormat:@"%@ 赞", currentFunding.likeCount]];
    [fundingCard_cell addSubview:label2];
    
    UIImageView * imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(210, 220 - 44 + 12, 20, 20)];
    [imageView3 setImage:[UIImage imageNamed:@"crowdfunding-list-time"]];
    [imageView3 setContentMode:UIViewContentModeCenter];
    [fundingCard_cell addSubview:imageView3];
    
    UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake(230, 220 - 44 + 12, 80, 20)];
    [label3 setFont:We_font_textfield_small_zh_cn];
    [label3 setTextColor:We_foreground_black_general];
    int restSec =  [currentFunding.endTime longLongValue] / 1000 - [[NSDate date] timeIntervalSince1970];
    [label3 setText:[NSString stringWithFormat:@"%d 天", restSec / 86400 + 1]];
    [fundingCard_cell addSubview:label3];
    
    // 进度条
    UIImageView * progressView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 220 - 44 - 5, 300, 5)];
    [progressView setImage:[WeAppDelegate imageWithColor:We_background_cell_general]];
    [fundingCard_cell addSubview:progressView];
    if ([currentFunding.type isEqualToString:@"D"]) {
        UIImageView * progressBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 220 - 44 - 5, 300.0 * [currentFunding.supportCount intValue] / [currentFunding.goal intValue], 5)];
        [progressBar setImage:[WeAppDelegate imageWithColor:We_foreground_red_general]];
        [fundingCard_cell addSubview:progressBar];
    }
    else {
        UIImageView * progressBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 220 - 44 - 5, 300.0 * [currentFunding.sum intValue] / [currentFunding.goal intValue], 5)];
        [progressBar setImage:[WeAppDelegate imageWithColor:We_foreground_red_general]];
        [fundingCard_cell addSubview:progressBar];
    }
    
    // 按钮
    UIButton * clickButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clickButton setFrame:fundingCard_cell.frame];
    [clickButton addTarget:self action:@selector(clickButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [fundingCard_outterView addSubview:clickButton];
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
