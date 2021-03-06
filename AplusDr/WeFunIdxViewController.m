//
//  WeFunIdxViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-20.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFunIdxViewController.h"
#import "WeFunTitle.h"
@interface WeFunIdxViewController () {
    UIActivityIndicatorView * sys_pendingView;
    UITableView * sys_tableView;
    UIButton * refreshButton;
    UIView * contentView;
    
    UISearchBar * searchBar;
    UIButton * coverButton;
    
    NSMutableArray * fundingList;
    
    NSMutableString * sel_keyword;
    NSMutableString * sel_type;
    NSMutableString * sel_topSectionId;
    NSMutableString * sel_topSectionName;
    NSMutableString * sel_secSectionId;
    NSMutableString * sel_secSectionName;
    
    UIButton * lastPressedButton;
    
    UIToolbar * selectView;
    UIToolbar * searchView;
    WeFunTitle * titleButton;
}

@end

@implementation WeFunIdxViewController

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path
{
    WeFunDetViewController * vc = [[WeFunDetViewController alloc] init];
    vc.currentFunding = (WeFunding *) fundingList[path.section];
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 220 + 5 + 40 + [WeAppDelegate calcSizeForString:[(WeFunding *)fundingList[indexPath.section] title] Font:We_font_textfield_large_zh_cn expectWidth:260].height + 40 + 60;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 10 + 64;
    return 9;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 10 + self.tabBarController.tabBar.frame.size.height;
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
    return [fundingList count];
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return 1;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    cell.opaque = NO;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 当前处理的众筹
    WeFunding * currentFunding = fundingList[indexPath.section];
    
    // 底色
    UIImageView * imageView000 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 40 + 60)];
    [imageView000 setBackgroundColor:We_background_cell_general];
    [cell.contentView addSubview:imageView000];
    
    // 背景图片
    UIImageView * backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 220)];
    [backGroundImageView setImageWithURL:[NSURL URLWithString:yijiarenImageUrl(currentFunding.poster2)]];
    [backGroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [backGroundImageView setClipsToBounds:YES];
    [cell.contentView addSubview:backGroundImageView];
    
    // 阴影层
    UIImageView * shadow = [[UIImageView alloc] initWithFrame:CGRectMake(10, 220 - 70, 300, 70)];
    [shadow setImage:[UIImage imageNamed:@"crowdfunding-gradientcover"]];
    [cell.contentView addSubview:shadow];
    
    // 进度条
    UIImageView * progressView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 220 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 40 + 2, 260, 5)];
    [progressView setImage:[WeAppDelegate imageWithColor:We_foreground_gray_general]];
    [cell.contentView addSubview:progressView];
    if ([currentFunding.type isEqualToString:@"D"]) {
        UIImageView * progressBar = [[UIImageView alloc] initWithFrame:CGRectMake(30, 220 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 40 + 2, 260.0 * MIN(1, 1.0 * [currentFunding.supportCount intValue] / [currentFunding.goal intValue]), 5)];
        [progressBar setImage:[WeAppDelegate imageWithColor:We_foreground_red_general]];
        [cell.contentView addSubview:progressBar];
    }
    else {
        UIImageView * progressBar = [[UIImageView alloc] initWithFrame:CGRectMake(30, 220 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 40 + 2, 260.0 * MIN(1, 1.0 * [currentFunding.sum intValue] / [currentFunding.goal intValue]), 5)];
        [progressBar setImage:[WeAppDelegate imageWithColor:We_foreground_red_general]];
        [cell.contentView addSubview:progressBar];
    }
    
    // 头像
    UIImageView * avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(245, 160, 50, 50)];
    [avatarView.layer setCornerRadius:avatarView.frame.size.height / 2];
    [avatarView.layer setMasksToBounds:YES];
    [avatarView.layer setBorderWidth:0.5];
    [avatarView.layer setBorderColor:We_foreground_black_general.CGColor];
    [cell.contentView addSubview:avatarView];
    [avatarView setImageWithURL:[NSURL URLWithString:yijiarenAvatarUrl(currentFunding.initiator.avatarPath)]];
    
    // 主标题栏
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 + 5 + 20, 260, [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height)];
    [title setText:currentFunding.title];
    [title setFont:We_font_textfield_large_zh_cn];
    [title setTextColor:We_foreground_black_general];
    [cell.contentView addSubview:title];
    
    // 医生信息
    UILabel * docInfo = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height, 200, 20)];
    [docInfo setText:[NSString stringWithFormat:@"%@   %@", currentFunding.initiator.userName, currentFunding.initiator.hospitalName]];
    [docInfo setFont:We_font_textfield_zh_cn];
    [docInfo setTextColor:We_foreground_gray_general];
    [cell.contentView addSubview:docInfo];
    
    // 同业支持
    UILabel * likeInfo = [[UILabel alloc] initWithFrame:CGRectMake(190, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height, 100, 20)];
    [likeInfo setTextAlignment:NSTextAlignmentRight];
    [likeInfo setText:[NSString stringWithFormat:@"同业支持 %@", currentFunding.likeCount]];
    [likeInfo setFont:We_font_textfield_small_zh_cn];
    [likeInfo setTextColor:We_foreground_red_general];
    [cell.contentView addSubview:likeInfo];
    
    // 已达
    UILabel * reachedData = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 20 + 20 + 10, 260, 20)];
    [reachedData setTextAlignment:NSTextAlignmentLeft];
    [reachedData setFont:We_font_textfield_small_zh_cn];
    if ([currentFunding.type isEqualToString:@"D"]) {
        [reachedData setText:[NSString stringWithFormat:@"%.2f%%", [currentFunding.supportCount intValue] * 100.0 / [currentFunding.goal intValue]]];
    }
    else {
        [reachedData setText:[NSString stringWithFormat:@"%.2f%%", [currentFunding.sum intValue] * 100.0 / [currentFunding.goal intValue]]];
    }
    [cell.contentView addSubview:reachedData];
    
    UILabel * reachedLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 20 + 20 + 20 + 10, 260, 20)];
    [reachedLabel setTextAlignment:NSTextAlignmentLeft];
    [reachedLabel setFont:We_font_textfield_small_zh_cn];
    [reachedLabel setTextColor:We_foreground_gray_general];
    [reachedLabel setText:@"已达"];
    [cell.contentView addSubview:reachedLabel];
    
    // 已筹资
    if ([currentFunding.type isEqualToString:@"D"]) {
        UILabel * reachedData = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 20 + 20 + 10, 260, 20)];
        [reachedData setTextAlignment:NSTextAlignmentCenter];
        [reachedData setFont:We_font_textfield_small_zh_cn];
        [reachedData setText:[NSString stringWithFormat:@"%@/%@ 人", currentFunding.supportCount, currentFunding.goal]];
        [cell.contentView addSubview:reachedData];
        
        UILabel * reachedLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 20 + 20 + 20 + 10, 260, 20)];
        [reachedLabel setTextAlignment:NSTextAlignmentCenter];
        [reachedLabel setFont:We_font_textfield_small_zh_cn];
        [reachedLabel setTextColor:We_foreground_gray_general];
        [reachedLabel setText:@"已招募"];
        [cell.contentView addSubview:reachedLabel];
    }
    else {
        UILabel * reachedData = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 20 + 20 + 10, 260, 20)];
        [reachedData setTextAlignment:NSTextAlignmentCenter];
        [reachedData setFont:We_font_textfield_small_zh_cn];
        [reachedData setText:[NSString stringWithFormat:@"￥%@/￥%@", currentFunding.sum, currentFunding.goal]];
        [cell.contentView addSubview:reachedData];
        
        UILabel * reachedLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 20 + 20 + 20 + 10, 260, 20)];
        [reachedLabel setTextAlignment:NSTextAlignmentCenter];
        [reachedLabel setFont:We_font_textfield_small_zh_cn];
        [reachedLabel setTextColor:We_foreground_gray_general];
        [reachedLabel setText:@"已筹资"];
        [cell.contentView addSubview:reachedLabel];
    }
    
    // 剩余时间
    UILabel * restData = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 20 + 20 + 10, 260, 20)];
    [restData setTextAlignment:NSTextAlignmentRight];
    [restData setFont:We_font_textfield_small_zh_cn];
    int restSec =  [currentFunding.endTime longLongValue] / 1000 - [[NSDate date] timeIntervalSince1970];
    if (restSec < 0) {
        [restData setText:[NSString stringWithFormat:@"已结束"]];
    }
    else {
        [restData setText:[NSString stringWithFormat:@"%d天", restSec / 86400]];
    }
    [cell.contentView addSubview:restData];
    
    UILabel * restLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 20 + 20 + 20 + 10, 260, 20)];
    [restLabel setTextAlignment:NSTextAlignmentRight];
    [restLabel setFont:We_font_textfield_small_zh_cn];
    [restLabel setTextColor:We_foreground_gray_general];
    [restLabel setText:@"剩余时间"];
    [cell.contentView addSubview:restLabel];
    
    // 框框1
    UIView * frame1 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 40)];
    [frame1.layer setBorderWidth:0.3];
    [frame1.layer setBorderColor:We_foreground_gray_general.CGColor];
    //[cell.contentView addSubview:frame1];
    
    // 框框2
    UIView * frame2 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 40 + 60)];
    [frame2.layer setBorderWidth:0.3];
    [frame2.layer setBorderColor:We_foreground_gray_general.CGColor];
    [cell.contentView addSubview:frame2];
    
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
    
    //self.navigationItem.title = @"众筹项目";
    
    titleButton = [WeFunTitle buttonWithType:UIButtonTypeCustom];
    [titleButton setFrame:CGRectMake(30, 0, 120, 64)];
    [titleButton setImage:[UIImage imageNamed:@"fav_down"] forState:UIControlStateNormal];
    [titleButton setTitle:@"医家仁推荐" forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(titleButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [titleButton.titleLabel setFont:We_font_textfield_huge_zh_cn];
    
    self.navigationItem.titleView = titleButton;
    
    /*
    // 我的众筹按钮
    UIBarButtonItem * myFundingButton = [[UIBarButtonItem alloc] initWithTitle:@"我的参与" style:UIBarButtonItemStylePlain target:self action:@selector(myFundingButton_onPress:)];
    self.navigationItem.rightBarButtonItem = myFundingButton;*/
    
    // 搜索按钮
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    sys_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [sys_tableView setHidden:YES];
    [self.view addSubview:sys_tableView];
    
    // 搜索按钮
    UIBarButtonItem * searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list-search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButton_onPress)];
    self.navigationItem.rightBarButtonItem = searchButton;
    
    // 筛选
    selectView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 64, 320, 200)];
    for (int i = 0; i < 5; i++) {
        WeInfoedButton * optionButton = [WeInfoedButton buttonWithType:UIButtonTypeRoundedRect];
        [optionButton setFrame:CGRectMake(0, 40 * i, 320, 40)];
        [optionButton setTintColor:We_foreground_black_general];
        [optionButton setUserData:[NSString stringWithFormat:@"%d", i]];
        [optionButton addTarget:self action:@selector(optionButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [optionButton setTintColor:We_foreground_red_general];
            lastPressedButton = optionButton;
        }
        if (i == 0) [optionButton setTitle:@"医家仁推荐" forState:UIControlStateNormal];
//        if (i == 1) [optionButton setTitle:@"全部" forState:UIControlStateNormal];
        if (i == 1) [optionButton setTitle:@"科研类" forState:UIControlStateNormal];
        if (i == 2) [optionButton setTitle:@"公益类" forState:UIControlStateNormal];
        if (i == 3) [optionButton setTitle:@"招募类" forState:UIControlStateNormal];
//        if (i == 5) [optionButton setTitle:@"进行中" forState:UIControlStateNormal];
        if (i == 4) [optionButton setTitle:@"已结束" forState:UIControlStateNormal];
        [selectView addSubview:optionButton];
    }
    [selectView setHidden:YES];
    [self.view addSubview:selectView];
    
    
    //
    searchView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 64, 320, 45)];
    [searchView setHidden:YES];
    [self.view addSubview:searchView];
    
    // search bar
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    searchBar.placeholder = @"搜索";
    searchBar.translucent = YES;
    searchBar.backgroundImage = [UIImage new];
    searchBar.scopeBarBackgroundImage = [UIImage new];
    [searchBar setTranslucent:YES];
    searchBar.delegate = self;
    [searchView addSubview:searchBar];
    
    // cover button
    coverButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    coverButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    coverButton.frame = CGRectMake(0, 64 + 45, 320, self.view.frame.size.height);
    [coverButton addTarget:self action:@selector(coverButtonOnPress:) forControlEvents:UIControlEventTouchUpInside];
    coverButton.hidden = YES;
    [self.view addSubview:coverButton];
    
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
    // 刷新按钮
    refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    refreshButton.frame = self.view.frame;
    [refreshButton setTitle:@"获取众筹列表失败，点击刷新" forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTintColor:We_foreground_red_general];
    [self.view addSubview:refreshButton];
    
    // 访问获取众筹列表接口
    [self api_data_listHomeFundings];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [sys_tableView reloadData];
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)sbar {
    [sel_keyword setString:searchBar.text];
    [self searchButton_onPress];
    [self api_data_listFunding:@{@"f.words":searchBar.text}];
    if ([searchBar.text isEqualToString:@""]) {
        [titleButton setTitle:@"医家仁推荐" forState:UIControlStateNormal];
    }
    else {
        [titleButton setTitle:[NSString stringWithFormat:@"搜索：%@", searchBar.text] forState:UIControlStateNormal];
    }

}

- (void)coverButtonOnPress:(id)sender {
    [self searchButton_onPress];
    [sel_keyword setString:searchBar.text];
    [self api_data_listFunding:@{@"f.words":searchBar.text}];
    if ([searchBar.text isEqualToString:@""]) {
        [titleButton setTitle:@"医家仁推荐" forState:UIControlStateNormal];
    }
    else {
        [titleButton setTitle:[NSString stringWithFormat:@"搜索：%@", searchBar.text] forState:UIControlStateNormal];
    }

}

//
- (void)titleButton_onPress:(id)sender {
    
    if(!searchView.isHidden)
    {
        [self searchButton_onPress];
    }
    [selectView setHidden:!selectView.isHidden];
    if (selectView.hidden) {
        [titleButton setImage:[UIImage imageNamed:@"fav_down"] forState:UIControlStateNormal];
    }
    else
    {
        [titleButton setImage:[UIImage imageNamed:@"fav_up"] forState:UIControlStateNormal];

    }
    
}

- (void)optionButton_onPress:(WeInfoedButton *)sender {
    NSString * order = sender.userData;
    if (lastPressedButton) {
        [lastPressedButton setTitleColor:We_foreground_black_general forState:UIControlStateNormal];
    }
    lastPressedButton = sender;
    [sender setTitleColor:We_foreground_red_general forState:UIControlStateNormal];
    
    if ([order isEqualToString:@"0"]) {
        [titleButton setTitle:@"医家仁推荐" forState:UIControlStateNormal];
        [self api_data_listHomeFundings];
    }
//    if ([order isEqualToString:@"1"]) {
//        [titleButton setTitle:@"全部" forState:UIControlStateNormal];
//        [self api_data_listFunding:@{}];
//    }
    if ([order isEqualToString:@"1"]) {
        [titleButton setTitle:@"科研类" forState:UIControlStateNormal];
        [self api_data_listFunding:@{@"f.type":@"B"}];
    }
    if ([order isEqualToString:@"2"]) {
        [titleButton setTitle:@"公益类" forState:UIControlStateNormal];
        [self api_data_listFunding:@{@"f.type":@"A"}];

    }
    if ([order isEqualToString:@"3"]) {
        [titleButton setTitle:@"招募类" forState:UIControlStateNormal];
        [self api_data_listFunding:@{@"f.type":@"D"}];

    }
//    if ([order isEqualToString:@"5"]) {
//        [titleButton setTitle:@"进行中" forState:UIControlStateNormal];
//        [self api_data_listFunding:@{@"f.status":@"E"}];
//    }
    if ([order isEqualToString:@"4"]) {
        [titleButton setTitle:@"已结束" forState:UIControlStateNormal];
        [self api_data_listFunding:@{@"f.status":@"G"}];

    }
    [selectView setHidden:YES];
    [titleButton setImage:[UIImage imageNamed:@"fav_down"] forState:UIControlStateNormal];
    
}
- (void)searchButton_onPress {
    [selectView setHidden:YES];
    [titleButton setImage:[UIImage imageNamed:@"fav_down"] forState:UIControlStateNormal];

    if (!searchView.isHidden) {
        searchView.hidden=YES;
        coverButton.hidden = YES;
        [searchBar resignFirstResponder];
    }else
    {
        searchView.hidden=NO;
        coverButton.hidden = NO;
        [searchBar becomeFirstResponder];
    }
}

// 刷新按钮被按下
- (void)refreshButton_onPress:(id)sender {
    [self api_data_listFunding:@{}];
}

//// 我的参与按钮被按下
//- (void)myFundingButton_onPress:(id)sender {
//    WeFunMySupViewController * vc = [[WeFunMySupViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}

// 获取众筹列表接口
- (void)api_data_listFunding:(NSDictionary *)parameters {
    [refreshButton setHidden:YES];
    [sys_tableView setHidden:YES];
    [sys_pendingView startAnimating];
    WeAppDelegate *app= (WeAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app refreshInitialData];
    
    [WeAppDelegate postToServerWithField:@"data" action:@"listFunding"
                              parameters:parameters
                                 success:^(id response) {
                                     fundingList = [[NSMutableArray alloc] init];
                                     NSArray * fundingJsonList = response[@"list"];
                                     for (int i = 0; i < [fundingJsonList count]; i++) {
                                         [fundingList addObject:[[WeFunding alloc] initWithNSDictionary:fundingJsonList[i]]];
                                     }
                                     [sys_tableView reloadData];
                                     [sys_tableView setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     [refreshButton setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }];
}

// 获取众筹列表接口
- (void)api_data_listHomeFundings {
    [refreshButton setHidden:YES];
    [sys_tableView setHidden:YES];
    [sys_pendingView startAnimating];
    
    [WeAppDelegate postToServerWithField:@"data" action:@"listHomeFundings"
                              parameters:nil
                                 success:^(id response) {
                                     fundingList = [[NSMutableArray alloc] init];
                                     NSArray * fundingJsonList = response;
                                     for (int i = 0; i < [fundingJsonList count]; i++) {
                                         [fundingList addObject:[[WeFunding alloc] initWithNSDictionary:fundingJsonList[i]]];
                                     }
                                     [sys_tableView reloadData];
                                     [sys_tableView setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     [refreshButton setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}
@end
