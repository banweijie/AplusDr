//
//  WeFunSupViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-23.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFunSupViewController.h"

@interface WeFunSupViewController () {
    UITableView * sys_tableView;
    NSMutableArray * levels;
}

@end

@implementation WeFunSupViewController

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
    WeFundingLevel * currentLevel = levels[indexPath.section];
    CGSize sizezz = [currentLevel.repay sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    return sizezz.height + 80;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 20 + 64;
    return 19;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
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
    return [levels count];
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
    
    // 当前处理的支持方案
    WeFundingLevel * currentLevel = levels[indexPath.section];

    UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 220 - 16, 60)];
   
    l1.font = We_font_textfield_large_zh_cn;
    l1.textColor = We_foreground_red_general;
    [cell.contentView addSubview:l1];
    
    WeInfoedButton * supportButton = [WeInfoedButton buttonWithType:UIButtonTypeRoundedRect];
    [supportButton setFrame:CGRectMake(220, 15, 80, 30)];
    if ([currentLevel.limit isEqualToString:@"0"]) {
        [supportButton setTitle:[NSString stringWithFormat:@"支持(%@)", currentLevel.supportCount] forState:UIControlStateNormal];
    }
    else {
        [supportButton setTitle:[NSString stringWithFormat:@"支持(%@/%@)", currentLevel.supportCount, currentLevel.limit] forState:UIControlStateNormal];
    }
    [supportButton setBackgroundColor:We_foreground_red_general];
    [supportButton setTintColor:We_foreground_white_general];
    [supportButton.titleLabel setFont:We_font_textfield_zh_cn];
    //[supportButton setUserData:currentLevel];
    supportButton.userData = currentLevel;
    [supportButton.layer setCornerRadius:supportButton.frame.size.height / 2];
    [supportButton addTarget:self action:@selector(supportButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:supportButton];
    
    CGSize sizezz = [currentLevel.repay sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(16, 60, sizezz.width, sizezz.height)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = currentLevel.repay;
    label.font = We_font_textfield_zh_cn;
    label.textColor = We_foreground_gray_general;
    [cell.contentView addSubview:label];
    
    supportButton.userInteractionEnabled=YES;
    if ([currentLevel.type isEqualToString:@"C"]) {
        l1.text = currentLevel.way;
    }
    else if ([currentLevel.type isEqualToString:@"D"])
    {
        l1.text=@"成为合伙人";
        label.frame=CGRectMake(16, 60,300 , 15);
        label.text=@"成为合伙人，留下联系方式，我们会联系您";
    }
    else if ([currentLevel.type isEqualToString:@"E"])
    {
        l1.text= [NSString stringWithFormat:@"咨询档 ￥%@", currentLevel.money];
        label.frame=CGRectMake(16, 60,300 , 15);
        label.text=@"可以通过支持众筹获取在线咨询机会";
        supportButton.userInteractionEnabled=NO;
        [supportButton setTitle:[NSString stringWithFormat:@"已支持(%@)", currentLevel.supportCount] forState:UIControlStateNormal];
    }
    else {
        l1.text = [NSString stringWithFormat:@"支持 ￥%@", currentLevel.money];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)supportButton_onPress:(id)sender {
    if (currentUser == nil) {
        WeRegWlcViewController * vc = [[WeRegWlcViewController alloc] init];
        vc.originTargetViewController = nil;
        vc.tabBarController = self.tabBarController;
        
        WeNavViewController * nav = [[WeNavViewController alloc] init];
        [nav pushViewController:vc animated:NO];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
    else {
        WeInfoedButton * senderButton = sender;
        
        WeFunSup2ViewController * vc = [[WeFunSup2ViewController alloc] init];
        vc.currentLevel = (WeFundingLevel *)[senderButton userData];
        vc.currentFunding = self.currentFunding;
        
        UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backItem;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    [self.navigationItem setTitle:@"选择支持方案"];
    
    // 取出需要显示的级别
    levels = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.currentFunding.levels count]; i++) {
        WeFundingLevel * currentLevel = self.currentFunding.levels[i];
        if ([currentLevel.open isEqualToString:@"1"]) {
            [levels addObject:currentLevel];
        }
    }
    
    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-49) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sys_tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [sys_tableView reloadData];
}

- (void)cancelButton_onPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
