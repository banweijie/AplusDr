//
//  WePecIdxViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-13.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WePecIdxViewController.h"
#import "WeAppDelegate.h"

@interface WePecIdxViewController () {
    NSTimer * sys_refreshTimer;
}
@end

@implementation WePecIdxViewController {
    UITableView * sys_tableView;
}

#pragma mark - UITableView

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    [tv deselectRowAtIndexPath:path animated:YES];
    switch (path.section) {
        case 0:
            switch (path.row) {
                case 0:
                    [self performSegueWithIdentifier:@"PecIdx_pushto_PecPea" sender:self];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    if (path.section == 1 && path.row == 0) {
        WeCahIdxViewController * vc = [[WeCahIdxViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (path.section == 2 && path.row == 0) {
        WeJiaMangementIndexViewController * vc = [[WeJiaMangementIndexViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (path.section == 2 && path.row == 1) {
        WeFunMySupViewController * vc = [[WeFunMySupViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (path.section == 3 && path.row == 0) {
        WePecMyaViewController * vc = [[WePecMyaViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (path.section == 3 && path.row == 1) {
        WePecTrhViewController * vc = [[WePecTrhViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (path.section == 4 && path.row == 0) {
        WeAboutUsViewController * vc = [[WeAboutUsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 90;//tv.rowHeight * 2;
    }
    return tv.rowHeight;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 20 + 64;
    return 20;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    return 10;
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
    return 5;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 2;
            break;
        case 4:
            return 1;
            break;
//        case 5:
//            return 1;
//            break;
        default:
            return 0;
    }
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    [cell.imageView setContentMode:UIViewContentModeCenter];
    [cell.imageView setFrame:CGRectMake(0, 0, 20, 20)];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        cell.contentView.backgroundColor = We_background_cell_general;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        // 用户名
        UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, 240, 25)];
        if ([currentUser.userName isEqualToString:@""]) l1.text = @"尚未设置名称";
        else l1.text = currentUser.userName;
        l1.font = We_font_textfield_zh_cn;
        l1.textColor = We_foreground_black_general;
        [cell.contentView addSubview:l1];
        // 手机号
        UILabel * l2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 45, 240, 25)];
        l2.text = currentUser.userPhone;
        l2.textColor = We_foreground_gray_general;
        l2.font = We_font_textfield_zh_cn;
        [cell.contentView addSubview:l2];
        // 头像
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
        [imageView setImageWithURL:[NSURL URLWithString:yijiarenAvatarUrl(currentUser.avatarPath)]];
        imageView.layer.cornerRadius = imageView.frame.size.height / 2;
        imageView.clipsToBounds = YES;
        [cell.contentView addSubview:imageView];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.contentView.backgroundColor = We_background_cell_general;
        cell.textLabel.text = @"病历管理";
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        cell.imageView.image = [UIImage imageNamed:@"tab-casehistory-selected"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.contentView.backgroundColor = We_background_cell_general;
        cell.textLabel.text = @"我的加号";
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        cell.imageView.image = [UIImage imageNamed:@"me-appointment"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        cell.contentView.backgroundColor = We_background_cell_general;
        cell.textLabel.text = @"我的众筹";
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        cell.imageView.image = [UIImage imageNamed:@"me-crowdfunding"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        cell.contentView.backgroundColor = We_background_cell_general;
        cell.textLabel.text = @"财务信息";
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        cell.imageView.image = [UIImage imageNamed:@"me-balance"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 3 && indexPath.row == 1) {
        cell.contentView.backgroundColor = We_background_cell_general;
        cell.textLabel.text = @"我的订单";
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        cell.imageView.image = [UIImage imageNamed:@"me-moneyhistory"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    switch (indexPath.section) {
//        case 4:
//            switch (indexPath.row) {
//                case 0:
//                    cell.contentView.backgroundColor = We_background_cell_general;
//                    cell.textLabel.text = @"设置";
//                    cell.textLabel.font = We_font_textfield_zh_cn;
//                    cell.textLabel.textColor = We_foreground_black_general;
//                    cell.imageView.image = [UIImage imageNamed:@"me-setting"];
//                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//                    break;
//                default:
//                    break;
//            }
//            break;
        case 4:
            switch (indexPath.row) {
                case 0:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"关于";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    cell.imageView.image = [UIImage imageNamed:@"me-info"];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    return cell;
}


/*
 [AREA]
 Actions of all views
 */
- (void)segue_to_RegWlc:(id)sender {
    NSLog(@"segue:to_RegWlc~~:");
    [self performSegueWithIdentifier:@"PecIdx2RegWlc" sender:self];
}

- (void)segue_to_PecCai:(id)sender {
    NSLog(@"segue:to_RegWlc~~:");
    [self performSegueWithIdentifier:@"PecIdx2PecCai" sender:self];
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
    
    // 页面刷新定时器
    sys_refreshTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(refreshData:) userInfo:nil repeats:YES];
}

- (void)refreshData:(id)sender {
    [sys_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
