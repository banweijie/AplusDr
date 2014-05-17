//
//  WeCsrSelViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-17.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCsrSelViewController.h"

@interface WeCsrSelViewController () {
    UITableView * sys_tableView;
}

@end

@implementation WeCsrSelViewController

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
    if (path.section == 0 && path.row == 0) {
        [self performSegueWithIdentifier:@"CsrSel_pushto_CsrSelArea" sender:self];
    }
    if (path.section == 0 && path.row == 1) {
        [self performSegueWithIdentifier:@"CsrSel_pushto_CsrSelHos" sender:self];
    }
    if (path.section == 0 && path.row == 2) {
        [self performSegueWithIdentifier:@"CsrSel_pushto_CsrSelSec" sender:self];
    }
    if (path.section == 0 && path.row == 3) {
        [self performSegueWithIdentifier:@"CsrSel_pushto_CsrSelCat" sender:self];
    }
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tv.rowHeight;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 20 + 64;
    return 20;
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tv] - 1) {
        return 10 + 10 + self.tabBarController.tabBar.frame.size.height;
    }
    return 10;
}
//
- (UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section{
    return nil;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return 2;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 5;
    if (section == 1) return 1;
    return 0;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
        }
    }
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    if (indexPath.section == 0 && indexPath.row ==  0) {
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        cell.textLabel.text = @"地区";
        cell.detailTextLabel.font = We_font_textfield_zh_cn;
        cell.detailTextLabel.textColor = We_foreground_gray_general;
        if ([condition_provinceId isEqualToString:@"<null>"]) {
            cell.detailTextLabel.text = @"全部";
        }
        else {
            if ([condition_cityId isEqualToString:@"<null>"]) {
                cell.detailTextLabel.text = condition_provinceName;
            }
            else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", condition_provinceName, condition_cityName];
            }
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        cell.textLabel.text = @"医院";
        cell.detailTextLabel.font = We_font_textfield_zh_cn;
        cell.detailTextLabel.textColor = We_foreground_gray_general;
        if ([condition_hospitalId isEqualToString:@"<null>"]) {
            cell.detailTextLabel.text = @"全部";
        }
        else {
            cell.detailTextLabel.text = condition_hospitalName;
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        cell.textLabel.text = @"科室";
        cell.detailTextLabel.font = We_font_textfield_zh_cn;
        cell.detailTextLabel.textColor = We_foreground_gray_general;
        if ([condition_topSectionId isEqualToString:@"<null>"]) {
            cell.detailTextLabel.text = @"全部";
        }
        else {
            if ([condition_sectionId isEqualToString:@"<null>"]) {
                cell.detailTextLabel.text = condition_topSectionName;
            }
            else {
                cell.detailTextLabel.text = condition_sectionName;
            }
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 0 && indexPath.row == 3) {
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        cell.textLabel.text = @"职称";
        cell.detailTextLabel.font = We_font_textfield_zh_cn;
        cell.detailTextLabel.textColor = We_foreground_gray_general;
        if ([condition_title isEqualToString:@"<null>"]) {
            cell.detailTextLabel.text = @"全部";
        }
        else {
            cell.detailTextLabel.text = we_codings[@"doctorCategory"][condition_category][@"title"][condition_title];
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 0 && indexPath.row == 4) {
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        cell.textLabel.text = @"推荐";
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.backgroundColor = We_foreground_red_general;
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_white_general;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"筛选";
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

- (void)setConditionToDefault:(id)sender {
    condition_provinceId = @"<null>";
    condition_cityId = @"<null>";
    condition_hospitalId = @"<null>";
    condition_topSectionId = @"<null>";
    condition_sectionId = @"<null>";
    condition_category = @"<null>";
    condition_title = @"<null>";
    [sys_tableView reloadData];
}

- (void)user_cancel_onpress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Default Value
    [self setConditionToDefault:self];
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    sys_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:sys_tableView];
    
    UIBarButtonItem * user_reset = [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(setConditionToDefault:)];
    self.navigationItem.rightBarButtonItem = user_reset;

    UIBarButtonItem * user_cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(user_cancel_onpress:)];
    self.navigationItem.leftBarButtonItem = user_cancel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [sys_tableView reloadData];
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
