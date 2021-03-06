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
    
    NSMutableArray * favorDoctors;
    
    int currentPage;
    
    NSIndexPath * selectpath;
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
    if (selectpath.section==path.section) {
        return;
    }
    else{
    we_doctorChating = favorDoctors[path.section];
//    NSLog(@"favorDoctors %@ we_doctorChating %@",favorDoctors,we_doctorChating);
    WeCsrCtrViewController * vc = [[WeCsrCtrViewController alloc] init];
    vc.doctorChating = favorDoctors[path.section];
    [self.navigationController pushViewController:vc animated:YES];
    selectpath=path;
    }
    [tv deselectRowAtIndexPath:path animated:YES];
}

// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;//tv.rowHeight * 2.5;
}

// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    return 20;
}

// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    return @"";
}

// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 10 + self.tabBarController.tabBar.frame.size.height;
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
    return [favorDoctors count];
}

// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell * cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    [cell setOpaque:NO];
    [cell setBackgroundColor:We_background_cell_general];
    
    WeFavorDoctor * doctor = favorDoctors[indexPath.section];
    
    /*
    // 底色
    UIView * groundView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 110)];
    [groundView setBackgroundColor:We_background_cell_general];
    [cell.contentView addSubview:groundView];*/
    
    // 姓名
    UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(85, 12, 240, 23)];
    l1.text = [NSString stringWithFormat:@"%@ %@", doctor.userName, we_codings[@"doctorCategory"][doctor.category][@"title"][doctor.title]];
    if ([l1.text isEqualToString:@""]) l1.text = @"尚未设置名称";
    l1.font = We_font_textfield_zh_cn;
    l1.textColor = We_foreground_black_general;
    [cell.contentView addSubview:l1];

    // 医院科室
    UILabel * l2 = [[UILabel alloc] initWithFrame:CGRectMake(85, 33, 240, 23)];
    l2.text = [NSString stringWithFormat:@"%@ %@", doctor.hospitalName, doctor.sectionName];
    l2.textColor = We_foreground_gray_general;
    l2.font = We_font_textfield_small_zh_cn;
    [cell.contentView addSubview:l2];

    // 头像
    UIImageView * avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 9, 48, 48)];
    [avatarView setImageWithURL:[NSURL URLWithString:yijiarenAvatarUrl(doctor.avatarPath)]];
    avatarView.layer.cornerRadius = avatarView.frame.size.height / 2;
    avatarView.clipsToBounds = YES;
    [cell.contentView addSubview:avatarView];
    
    
    // 从数据库中提取信息
    NSMutableArray * unviewedMessageList = [globalHelper search:[WeMessage class]
                                                  where:[NSString stringWithFormat:@"((senderId = %@ or receiverId = %@) and viewed = 0)", doctor.userId, doctor.userId]
                                                orderBy:@"time desc"
                                                 offset:0
                                                  count:101];
    
    NSMutableArray * viewedmessageList = [globalHelper search:[WeMessage class]
                                                  where:[NSString stringWithFormat:@"(senderId = %@ or receiverId = %@)", doctor.userId, doctor.userId]
                                                orderBy:@"time desc"
                                                 offset:0
                                                  count:100];
    
    // 图标
    if ([unviewedMessageList count] > 0) {
        UIButton * imageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [imageButton setFrame:CGRectMake(30, 78, 30, 20)];
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
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 78, 24, 24)];
        if ([doctor.consultStatus isEqualToString:@"C"]) {
            [imageView setImage:[UIImage imageNamed:@"docinfo-chatting"]];
        }
        else {
            [imageView setImage:[UIImage imageNamed:@"docinfo-chatroom"]];
        }
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [cell.contentView addSubview:imageView];
    }
    
    if ([viewedmessageList count] > 0) {
        WeMessage * lastMsg = viewedmessageList[0];
        
        UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(70, 66, 140, 44)];
        [l1 setFont:We_font_textfield_small_zh_cn];
        [cell.contentView addSubview:l1];
        
        UILabel * l2 = [[UILabel alloc] initWithFrame:CGRectMake(70 + 150, 66, 80, 44)];
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
        else if ([lastMsg.messageType isEqualToString:@"R"]) {
            l1.text = @"发送了一个病例";
            l1.textColor = We_foreground_red_general;
        }
        else {
            l1.text = [NSString stringWithFormat:@"尚未处理此类型(%@)的消息:%@", lastMsg.messageType, lastMsg.content];
        }
        l2.text = [WeAppDelegate transitionToDateFromSecond:lastMsg.time];
    }
    
    // 边框
    UIView * frame1 = [[UIView alloc] initWithFrame:CGRectMake(30, 66, 260, 0.3)];
    [frame1.layer setBorderWidth:0.3];
    [frame1.layer setBorderColor:We_foreground_gray_general.CGColor];
    [cell.contentView addSubview:frame1];
    
    /*
    UIView * frame2 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 110)];
    [frame2.layer setBorderWidth:0.3];
    [frame2.layer setBorderColor:We_foreground_gray_general.CGColor];
    [cell.contentView addSubview:frame2];*/

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
    selectpath=[NSIndexPath indexPathForItem:-1 inSection:-1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 变量初始化
    currentPage = 1;
    favorDoctors = [[NSMutableArray alloc] init];
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // tabs
    UIView * segControlView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 44)];
    segControlView.backgroundColor = We_background_red_general;
    [self.view addSubview:segControlView];
    
    UISegmentedControl * segControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"保健医", @"申请中", @"咨询中", nil]];
    [segControl setFrame:CGRectMake(20, 7, 280, 30)];
    segControl.backgroundColor = [UIColor clearColor];
    segControl.selectedSegmentIndex = 1;
    segControl.tintColor = We_foreground_white_general;
    segControl.layer.cornerRadius = 5;
    [segControl addTarget:self action:@selector(selectedSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    [segControlView addSubview:segControl];
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 44, 320, self.view.frame.size.height - 64 - 44) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    sys_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:sys_tableView];
    
    // 设置定时器并初始化
    sys_refreshTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
    [self refreshData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [WeAppDelegate postToServerWithField:@"patient" action:@"listFavorDoctors"
                              parameters:@{
                                           }
                                 success:^(NSArray * response) {
                                     favorDoctorList = [[NSMutableDictionary alloc] init];
                                     for (int i = 0; i < [response count]; i++) {
                                         WeFavorDoctor * newFavorDoctor = [[WeFavorDoctor alloc] initWithNSDictionary:response[i]];
                                         favorDoctorList[newFavorDoctor.userId] = newFavorDoctor;
                                     }
                                     
                                     [self refreshData];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     UIAlertView * notPermitted = [[UIAlertView alloc]
                                                                   initWithTitle:@"更新保健医列表失败"
                                                                   message:errorMessage
                                                                   delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                                     [notPermitted show];
                                 }];
   
}

#pragma mark - callBacks

- (void)refreshData {
    favorDoctors = [[NSMutableArray alloc] init];
    int b=0;
    for (WeFavorDoctor * doctor in [favorDoctorList objectEnumerator]) {
        // 咨询中
        if (currentPage == 2 && [doctor.consultStatus isEqualToString:@"C"]) [favorDoctors addObject:doctor];
        // 申请中
        if (currentPage == 1 && [doctor.consultStatus isEqualToString:@"A"]) [favorDoctors addObject:doctor];
        // 保健医
        if (currentPage == 0 && ([doctor.consultStatus isEqualToString:@"N"] || [doctor.consultStatus isEqualToString:@"W"]||[doctor.consultStatus isEqualToString:@"C"]||[doctor.consultStatus isEqualToString:@"A"])) [favorDoctors addObject:doctor];
        
        NSMutableArray * unviewedMessageList = [globalHelper search:[WeMessage class]
                                                              where:[NSString stringWithFormat:@"((senderId = %@ or receiverId = %@) and viewed = 0)", doctor.userId, doctor.userId]
                                                            orderBy:@"time desc"
                                                             offset:0
                                                              count:101];
        
        int a=[unviewedMessageList count];
        b+=a;

    }
    numOfIcon=b;
    if (numOfIcon>0) {
        messageFlag.alpha=0.8;
    }
    else
    {
        messageFlag.alpha=0;
    }

    
    [favorDoctors sortUsingComparator:^NSComparisonResult(id rA, id rB) {
        WeFavorDoctor * doctorA = rA, * doctorB = rB;
        NSMutableArray * viewedmessageListA = [globalHelper search:[WeMessage class]
                                                             where:[NSString stringWithFormat:@"(senderId = %@ or receiverId = %@)", doctorA.userId, doctorA.userId]
                                                           orderBy:@"time desc"
                                                            offset:0
                                                             count:1];
        NSMutableArray * viewedmessageListB = [globalHelper search:[WeMessage class]
                                                             where:[NSString stringWithFormat:@"(senderId = %@ or receiverId = %@)", doctorB.userId, doctorB.userId]
                                                           orderBy:@"time desc"
                                                            offset:0
                                                             count:1];
        if ([viewedmessageListA count] == 0) return 1;
        if ([viewedmessageListB count] == 0) return -1;
        return [(WeMessage *)viewedmessageListA[0] time] < [(WeMessage *)viewedmessageListB[0] time];
    }];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(abc) name:@"123" object:nil];
    
    [sys_tableView reloadData];
}

- (void)selectedSegmentChanged:(UISegmentedControl *)segControl {
    currentPage = segControl.selectedSegmentIndex;
    [self refreshData];
    [sys_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
}

@end
