//
//  WeFunIdxViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-20.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFunIdxViewController.h"

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
    vc.currentFundingId = [(WeFunding *)fundingList[path.section] fundingId];
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 220;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 10;
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
    cell.backgroundColor = We_background_cell_general;
    
    // 当前处理的众筹
    WeFunding * currentFunding = fundingList[indexPath.section];
    
    // 背景图片
    UIImageView * backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 220)];
    [backGroundImageView setImageWithURL:[NSURL URLWithString:yijiarenImageUrl(currentFunding.poster2)]];
    [backGroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [cell.contentView addSubview:backGroundImageView];
    
    // 阴影层
    UIImageView * shadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 220 - 49 - 70, 300, 70)];
    [shadow setImage:[UIImage imageNamed:@"crowdfunding-gradientcover"]];
    [cell.contentView addSubview:shadow];
    
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
    [cell.contentView addSubview:title];
    
    // 医生信息
    UILabel * docInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, 125, 200, 20)];
    [docInfo setText:[NSString stringWithFormat:@"%@ 医生  %@", currentFunding.initiator.userName, we_codings[@"doctorCategory"][currentFunding.initiator.category][@"title"][currentFunding.initiator.title]]];
    [docInfo setFont:We_font_textfield_small_zh_cn];
    [docInfo setTextColor:We_foreground_white_general];
    [docInfo setShadowColor:We_foreground_black_general];
    [docInfo setShadowOffset:CGSizeMake(1, 1)];
    [cell.contentView addSubview:docInfo];
    
    UILabel * docInfo2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 200, 20)];
    [docInfo2 setText:[NSString stringWithFormat:@"%@ %@", currentFunding.initiator.hospitalName, currentFunding.initiator.sectionName]];
    [docInfo2 setFont:We_font_textfield_small_zh_cn];
    [docInfo2 setTextColor:We_foreground_white_general];
    [docInfo2 setShadowColor:We_foreground_black_general];
    [docInfo2 setShadowOffset:CGSizeMake(1, 1)];
    [cell.contentView addSubview:docInfo2];
    
    UIImageView * avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(235, 110, 50, 50)];
    [avatarView.layer setCornerRadius:avatarView.frame.size.height / 2];
    [avatarView.layer setMasksToBounds:YES];
    [cell.contentView addSubview:avatarView];
    [avatarView setImageWithURL:[NSURL URLWithString:yijiarenAvatarUrl(currentFunding.initiator.avatarPath)]];
    
    // 信息层
    UIImageView * infoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 220 - 44, 300, 44)];
    [infoView setImage:[WeAppDelegate imageWithColor:We_foreground_white_general]];
    [cell.contentView addSubview:infoView];
    
    UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 220 - 44 + 12, 20, 20)];
    [imageView1 setImage:[UIImage imageNamed:@"crowdfunding-list-money"]];
    [imageView1 setContentMode:UIViewContentModeCenter];
    [cell.contentView addSubview:imageView1];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 - 44 + 12, 80, 20)];
    [label1 setFont:We_font_textfield_small_zh_cn];
    [label1 setTextColor:We_foreground_black_general];
    if ([currentFunding.type isEqualToString:@"D"]) {
        [label1 setText:[NSString stringWithFormat:@"%@人 已募", currentFunding.supportCount]];
    }
    else {
        [label1 setText:[NSString stringWithFormat:@"￥%@ 已筹", currentFunding.sum]];
    }
    [cell.contentView addSubview:label1];
    
    UIImageView * imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(110, 220 - 44 + 12, 20, 20)];
    [imageView2 setImage:[UIImage imageNamed:@"crowdfunding-list-favorite"]];
    [imageView2 setContentMode:UIViewContentModeCenter];
    [cell.contentView addSubview:imageView2];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(130, 220 - 44 + 12, 80, 20)];
    [label2 setFont:We_font_textfield_small_zh_cn];
    [label2 setTextColor:We_foreground_black_general];
    [label2 setText:[NSString stringWithFormat:@"%@ 赞", currentFunding.likeCount]];
    [cell.contentView addSubview:label2];
    
    UIImageView * imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(210, 220 - 44 + 12, 20, 20)];
    [imageView3 setImage:[UIImage imageNamed:@"crowdfunding-list-time"]];
    [imageView3 setContentMode:UIViewContentModeCenter];
    [cell.contentView addSubview:imageView3];
    
    UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake(230, 220 - 44 + 12, 80, 20)];
    [label3 setFont:We_font_textfield_small_zh_cn];
    [label3 setTextColor:We_foreground_black_general];
    int restSec =  [currentFunding.endTime longLongValue] / 1000 - [[NSDate date] timeIntervalSince1970];
    [label3 setText:[NSString stringWithFormat:@"%d 天", restSec / 86400 + 1]];
    [cell.contentView addSubview:label3];
    
    // 进度条
    UIImageView * progressView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 220 - 44 - 5, 300, 5)];
    [progressView setImage:[WeAppDelegate imageWithColor:We_background_cell_general]];
    [cell.contentView addSubview:progressView];
    if ([currentFunding.type isEqualToString:@"D"]) {
        UIImageView * progressBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 220 - 44 - 5, 300.0 * [currentFunding.supportCount intValue] / [currentFunding.goal intValue], 5)];
        [progressBar setImage:[WeAppDelegate imageWithColor:We_foreground_red_general]];
        [cell.contentView addSubview:progressBar];
    }
    else {
        UIImageView * progressBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 220 - 44 - 5, 300.0 * [currentFunding.sum intValue] / [currentFunding.goal intValue], 5)];
        [progressBar setImage:[WeAppDelegate imageWithColor:We_foreground_red_general]];
        [cell.contentView addSubview:progressBar];
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
    
    self.navigationItem.title = @"众筹项目";
    
    // 我的众筹按钮
    UIBarButtonItem * myFundingButton = [[UIBarButtonItem alloc] initWithTitle:@"我的参与" style:UIBarButtonItemStylePlain target:self action:@selector(myFundingButton_onPress:)];
    self.navigationItem.rightBarButtonItem = myFundingButton;
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // 所有内容
    contentView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:contentView];
    
    // 筛选参数
    sel_keyword = [NSMutableString stringWithString:@""];
    sel_type = [NSMutableString stringWithString:@""];
    sel_topSectionId = [NSMutableString stringWithString:@""];
    sel_topSectionName = [NSMutableString stringWithString:@"全部"];
    sel_secSectionId = [NSMutableString stringWithString:@""];
    sel_secSectionName = [NSMutableString stringWithString:@"全部"];
    
    // bar background image
    UIImageView * barBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 85)];
    barBackground.image = [UIImage imageNamed:@"bar"];
    [self.view addSubview:barBackground];
    
    UIButton * sortButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sortButton setFrame:CGRectMake(0, 64, 210, 40)];
    [sortButton setImage:[UIImage imageNamed:@"crowdfunding-list-order"] forState:UIControlStateNormal];
    [sortButton setTitle:@"  已筹募款从多到少" forState:UIControlStateNormal];
    [sortButton.titleLabel setFont:We_font_textfield_zh_cn];
    [sortButton setTintColor:We_foreground_red_general];
    [self.view addSubview:sortButton];
    
    UIButton * selectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [selectButton setFrame:CGRectMake(210, 64, 110, 40)];
    [selectButton setImage:[UIImage imageNamed:@"crowdfunding-list-filter"] forState:UIControlStateNormal];
    [selectButton setTitle:@"  筛选" forState:UIControlStateNormal];
    [selectButton.titleLabel setFont:We_font_textfield_zh_cn];
    [selectButton setTintColor:We_foreground_red_general];
    [selectButton addTarget:self action:@selector(selectButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectButton];
    
    // search bar
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 104, 320, 45)];
    searchBar.placeholder = @"搜索";
    searchBar.translucent = YES;
    searchBar.backgroundImage = [UIImage new];
    searchBar.scopeBarBackgroundImage = [UIImage new];
    [searchBar setTranslucent:YES];
    searchBar.delegate = self;
    
    // cover button
    coverButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    coverButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    coverButton.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    [coverButton addTarget:self action:@selector(coverButtonOnPress:) forControlEvents:UIControlEventTouchUpInside];
    coverButton.hidden = YES;
    [self.view addSubview:coverButton];
    
    [self.view addSubview:searchBar];
    
    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 64 + 85, 300, self.view.frame.size.height - 64 - 85) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:sys_tableView];
    
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
    [self api_data_listFunding];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"texture"] forBarMetrics:UIBarMetricsDefault];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    coverButton.hidden = NO;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    coverButton.hidden = YES;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)sbar {
    [sel_keyword setString:searchBar.text];
    [searchBar resignFirstResponder];
    [self api_data_listFunding];
}

- (void)coverButtonOnPress:(id)sender {
    [sel_keyword setString:searchBar.text];
    [searchBar resignFirstResponder];
    [self api_data_listFunding];
}

// 筛选按钮被按下
- (void)selectButton_onPress:(id)sender {
    WeFunSelViewController * vc = [[WeFunSelViewController alloc] init];
    vc.lastSel_type = sel_type;
    vc.lastSel_topSectionId = sel_topSectionId;
    vc.lastSel_topSectionName = sel_topSectionName;
    vc.lastSel_secSectionId = sel_secSectionId;
    vc.lastSel_secSectionName = sel_secSectionName;
    vc.originVC = self;
    
    WeNavViewController * nav = [[WeNavViewController alloc] init];
    [nav pushViewController:vc animated:NO];
    
    [self presentViewController:nav animated:YES completion:nil];
}

// 刷新按钮被按下
- (void)refreshButton_onPress:(id)sender {
    [self api_data_listFunding];
}

// 我的参与按钮被按下
- (void)myFundingButton_onPress:(id)sender {
    WeFunMySupViewController * vc = [[WeFunMySupViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 获取众筹列表接口
- (void)api_data_listFunding {
    [refreshButton setHidden:YES];
    [contentView setHidden:YES];
    [sys_pendingView startAnimating];
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    if (![sel_type isEqualToString:@""]) [parameters setValue:sel_type forKey:@"f.type"];
    if (![sel_topSectionId isEqualToString:@""]) [parameters setValue:sel_topSectionId forKey:@"f.topSectionId"];
    if (![sel_secSectionId isEqualToString:@""]) [parameters setValue:sel_secSectionId forKey:@"f.sectionId"];
    if (![sel_keyword isEqualToString:@""]) [parameters setValue:sel_keyword forKey:@"f.words"];
    
    [WeAppDelegate postToServerWithField:@"data" action:@"listFunding"
                              parameters:parameters
                                 success:^(id response) {
                                     fundingList = [[NSMutableArray alloc] init];
                                     NSArray * fundingJsonList = response[@"list"];
                                     for (int i = 0; i < [fundingJsonList count]; i++) {
                                         [fundingList addObject:[[WeFunding alloc] initWithNSDictionary:fundingJsonList[i]]];
                                     }
                                     [sys_tableView reloadData];
                                     [contentView setHidden:NO];
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
