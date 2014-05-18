//
//  WeCsrIdxViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-5-5.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCsrIdxViewController.h"
#import "PAImageView.h"
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
    we_doctorChating = orderedIdOfDoctor[path.section];
    [self performSegueWithIdentifier:@"CsrIdx_pushto_CsrCtr" sender:self];
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
    return [orderedIdOfDoctor count];
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return 3;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    
    if (indexPath.row == 0) {
        WeFavorDoctor * doctor = favorDoctors[orderedIdOfDoctor[indexPath.section]];
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
    if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"docinfo-crowdfunding"];
        cell.textLabel.text = @"众筹项目名称";
        cell.textLabel.font = We_font_textfield_small_zh_cn;
        cell.textLabel.textColor = We_foreground_gray_general;
        cell.detailTextLabel.text = @"￥10,000已筹 / 52赞";
        cell.detailTextLabel.font = We_font_textfield_small_zh_cn;
        cell.detailTextLabel.textColor = We_foreground_black_general;
    }
    if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"docinfo-chatroom"];
        WeMessage * lastMsg = [we_messagesWithDoctor[orderedIdOfDoctor[indexPath.section]] lastObject];
        if ([lastMsg.messageType isEqualToString:@"C"]) {
            long long restSecond = [we_maxResponseGap intValue] * 3600 - (long long) (([[NSDate date] timeIntervalSince1970] - lastMsg.time));
            cell.textLabel.text = [NSString stringWithFormat:@"[申请咨询中 剩余%lld小时%lld分钟]",  restSecond / 3600, restSecond % 3600 / 60];
            cell.textLabel.textColor = We_foreground_red_general;
        }
        else if ([lastMsg.messageType isEqualToString:@"T"]) {
            cell.textLabel.text = lastMsg.content;
            cell.textLabel.textColor = We_foreground_black_general;
        }
        else {
            cell.textLabel.text = [NSString stringWithFormat:@"尚未处理此类型(%@)的消息:%@", lastMsg.messageType, lastMsg.content];
        }
        cell.detailTextLabel.text = [WeAppDelegate transitionToDateFromSecond:lastMsg.time];
        cell.textLabel.font = We_font_textfield_small_zh_cn;
        cell.detailTextLabel.font = We_font_textfield_small_zh_cn;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)press:(id)sender {
    [self performSegueWithIdentifier:@"CsrIdx_pushto_CsrAdd" sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    UIBarButtonItem * user_save = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chatroom-adddoctor"] style:UIBarButtonItemStylePlain target:self action:@selector(press:)];
    self.navigationItem.rightBarButtonItem = user_save;
    
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
    orderedIdOfDoctor = [NSMutableArray arrayWithArray:[favorDoctors allKeys]];
    [sys_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (we_targetView == targetViewMainPage) [self.tabBarController setSelectedIndex:weTabBarIdMainPage];
    if (we_targetView == targetViewConsultingRoom) we_targetView = targetViewNone;
    if (we_targetView == targetViewPersonalCenter) [self.tabBarController setSelectedIndex:weTabBarIdPersonalCenter];
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
