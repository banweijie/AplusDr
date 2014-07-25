//
//  WeCsrIdxViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-5-5.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCsrIdxViewController.h"
#import "WeAppDelegate.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>

@interface WeCsrIdxViewController () {
    UITableView * sys_tableView;
    NSTimer * sys_refreshTimer;
    NSMutableArray * orderedIdOfDoctor;
    BOOL selecting;
}

@end

@implementation WeCsrIdxViewController

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path {
    return path;
}

// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path {
    we_doctorChating = orderedIdOfDoctor[path.section];
    WeCsrCtrViewController * vc = [[WeCsrCtrViewController alloc] init];
    vc.doctorChating = favorDoctorList[orderedIdOfDoctor[path.section]];
    [self.navigationController pushViewController:vc animated:YES];
    [tv deselectRowAtIndexPath:path animated:YES];
}

// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) return tv.rowHeight * 1.5;
    return tv.rowHeight;
}

// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 10 + 64;
    return 9;
}

// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    return @"";
}

// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 10;
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
    return [orderedIdOfDoctor count];
}

// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    WeFavorDoctor * currentDoctor = favorDoctorList[orderedIdOfDoctor[section]];
    if (currentDoctor.currentFundingId == nil) return 2;
    else return 3;
}

// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    
    WeFavorDoctor * doctor = favorDoctorList[orderedIdOfDoctor[indexPath.section]];
    if (indexPath.row == 0) {
        cell.contentView.backgroundColor = We_background_cell_general;
        // l1 - user name
        UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(75, 12, 240, 23)];
        l1.text = [NSString stringWithFormat:@"%@ %@", doctor.userName, we_codings[@"doctorCategory"][doctor.category][@"title"][doctor.title]];
        if ([l1.text isEqualToString:@""]) l1.text = @"尚未设置名称";
        l1.font = We_font_textfield_zh_cn;
        l1.textColor = We_foreground_black_general;
        [cell.contentView addSubview:l1];
        // l2 - lastMsg - content
        UILabel * l2 = [[UILabel alloc] initWithFrame:CGRectMake(75, 33, 240, 23)];
        l2.text = [NSString stringWithFormat:@"%@ %@", doctor.hospitalName, doctor.sectionName];
        l2.textColor = We_foreground_gray_general;
        l2.font = We_font_textfield_small_zh_cn;
        [cell.contentView addSubview:l2];
        // avatar
        UIImageView * avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, 48, 48)];
        //avatarView.image = doctor.avatar;
        [avatarView setImageWithURL:[NSURL URLWithString:yijiarenAvatarUrl(doctor.avatarPath)]];
        avatarView.layer.cornerRadius = avatarView.frame.size.height / 2;
        avatarView.clipsToBounds = YES;
        [cell.contentView addSubview:avatarView];
    }
    if (indexPath.row == 1 && doctor.currentFundingId != nil) {
        cell.imageView.image = [UIImage imageNamed:@"docinfo-crowdfunding"];
        cell.textLabel.text = doctor.currentFundingName;
        cell.textLabel.font = We_font_textfield_small_zh_cn;
        cell.textLabel.textColor = We_foreground_gray_general;
        if ([doctor.currentFundingType isEqualToString:@"D"]) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@人已募 / %@赞", doctor.currentFundingSupportCount, doctor.currentFundingLikeCount];
        }
        else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@已筹 / %@赞", doctor.currentFundingSum, doctor.currentFundingLikeCount];
        }
        cell.detailTextLabel.font = We_font_textfield_small_zh_cn;
        cell.detailTextLabel.textColor = We_foreground_black_general;
    }
    if (indexPath.row == 2 || (indexPath.row == 1 && doctor.currentFundingId == nil)) {
        // 从数据库中提取信息
        NSMutableArray * unviewedMessageList = [globalHelper search:[WeMessage class]
                                                      where:[NSString stringWithFormat:@"(senderId = %@ and viewed = 0)", doctor.userId]
                                                    orderBy:@"time desc"
                                                     offset:0
                                                      count:101];
        
        NSMutableArray * viewedmessageList = [globalHelper search:[WeMessage class]
                                                      where:[NSString stringWithFormat:@"(senderId = %@)", doctor.userId]
                                                    orderBy:@"time desc"
                                                     offset:0
                                                      count:100];
        
        
        
        if ([unviewedMessageList count] > 0) {
            UIButton * imageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [imageButton setFrame:CGRectMake(15, 12, 30, 20)];
            if ([unviewedMessageList count] <= 100) {
                [imageButton setTitle:[NSString stringWithFormat:@"%d", [unviewedMessageList count]] forState:UIControlStateNormal];
            }
            else {
                [imageButton setTitle:@"100+" forState:UIControlStateNormal];
            }
            [imageButton.titleLabel setFont:We_font_textfield_small_zh_cn];
            [imageButton setTintColor:We_foreground_white_general];
            [imageButton.layer setCornerRadius:imageButton.frame.size.height / 2];
            [imageButton.layer setMasksToBounds:YES];
            [imageButton setBackgroundColor:We_background_red_general];
            [cell.contentView addSubview:imageButton];
        }
        else {
            cell.imageView.image = [UIImage imageNamed:@"docinfo-chatroom"];
        }
        
        if ([viewedmessageList count] > 0) {
            WeMessage * lastMsg = viewedmessageList[0];
            
            UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 140, 44)];
            [l1 setFont:We_font_textfield_small_zh_cn];
            [cell.contentView addSubview:l1];
            
            UILabel * l2 = [[UILabel alloc] initWithFrame:CGRectMake(60 + 150, 0, 80, 44)];
            [l2 setFont:We_font_textfield_small_zh_cn];
            [l2 setTextAlignment:NSTextAlignmentRight];
            [l2 setTextColor:We_foreground_gray_general];
            [cell.contentView addSubview:l2];
            
            if ([lastMsg.messageType isEqualToString:@"T"]) {
                l1.text = lastMsg.content;
                l1.textColor = We_foreground_black_general;
            }
            else if ([lastMsg.messageType isEqualToString:@"A"]) {
                l1.text = @"[语音]";
                l1.textColor = We_foreground_red_general;
            }
            else if ([lastMsg.messageType isEqualToString:@"I"]) {
                l1.text = @"[图片]";
                l1.textColor = We_foreground_red_general;
            }
            else if ([lastMsg.messageType isEqualToString:@"X"]) {
                l1.text = [NSString stringWithFormat:@"%@", lastMsg.content];
                l1.textColor = We_foreground_red_general;
            }
            else {
                l1.text = [NSString stringWithFormat:@"尚未处理此类型(%@)的消息:%@", lastMsg.messageType, lastMsg.content];
            }
            l2.text = [WeAppDelegate transitionToDateFromSecond:lastMsg.time];
        }
    }
    return cell;
}

#pragma mark - ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    /*
    UIBarButtonItem * addDoctorButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chatroom-adddoctor"] style:UIBarButtonItemStylePlain target:self action:@selector(addDoctorButton_onPress:)];
    self.navigationItem.rightBarButtonItem = addDoctorButton;
    */
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, 300, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    sys_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:sys_tableView];
    
    sys_refreshTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(refreshData:) userInfo:nil repeats:YES];
    [self refreshData:self];
}

- (void)refreshData:(id)sender {
    orderedIdOfDoctor = [NSMutableArray arrayWithArray:[favorDoctorList allKeys]];
    [sys_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - customs

- (void)addDoctorButton_onPress:(id)sender {
    [self performSegueWithIdentifier:@"CsrIdx_pushto_CsrAdd" sender:self];
}

@end
