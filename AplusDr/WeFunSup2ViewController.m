//
//  WeFunSup2ViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-23.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFunSup2ViewController.h"

@interface WeFunSup2ViewController () {
    UITableView * sys_tableView;
    NSMutableArray * infoList;
}

@end

@implementation WeFunSup2ViewController

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
    if (indexPath.section == 0 && indexPath.row == 0) {
        CGSize sizezz = [_currentLevel.repay sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
        return sizezz.height + 80;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    cell.opaque = NO;
    cell.backgroundColor = We_background_cell_general;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 220 - 16, 60)];
        if ([_currentLevel.type isEqualToString:@"E"]) {
            l1.text = _currentLevel.way;
        }
        else {
            l1.text = [NSString stringWithFormat:@"支持 ￥%@", _currentLevel.money];
        }
        l1.font = We_font_textfield_large_zh_cn;
        l1.textColor = We_foreground_red_general;
        [cell.contentView addSubview:l1];
        
        UILabel * infoLabel = [[UILabel alloc] init];
        [infoLabel setFrame:CGRectMake(180, 15, 120, 30)];
        if ([_currentLevel.limit isEqualToString:@"0"]) {
            [infoLabel setText:[NSString stringWithFormat:@"%@人支持", _currentLevel.supportCount]];
        }
        else {
            [infoLabel setText:[NSString stringWithFormat:@"%@人支持/限%@人", _currentLevel.supportCount, _currentLevel.limit]];
        }
        [infoLabel setTextAlignment:NSTextAlignmentRight];
        [infoLabel setTextColor:We_foreground_black_general];
        [infoLabel setFont:We_font_textfield_zh_cn];
        [cell.contentView addSubview:infoLabel];
        
        CGSize sizezz = [_currentLevel.repay sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(16, 60, sizezz.width, sizezz.height)];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.text = _currentLevel.repay;
        label.font = We_font_textfield_zh_cn;
        label.textColor = We_foreground_gray_general;
        [cell.contentView addSubview:label];
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
    
    // 统计需要记录的信息
    if (_currentLevel.needName) [infoList addObject:@"name"];
    if (_currentLevel.needPhone) [infoList addObject:@"phone"];
    if (_currentLevel.needEmail) [infoList addObject:@"email"];
    if (_currentLevel.needAddress) [infoList addObject:@"address"];
    if (_currentLevel.needDescription) [infoList addObject:@"description"];
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
