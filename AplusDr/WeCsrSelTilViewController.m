//
//  WeCsrSelTilViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-17.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCsrSelTilViewController.h"

@interface WeCsrSelTilViewController () {
    NSArray * keyTitle;
    UITableView * sys_tableView;
}

@end

@implementation WeCsrSelTilViewController

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
    if (path.row == 0) {
        condition_category = condition_category_tmp;
        condition_title = @"<null>";
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        condition_category = condition_category_tmp;
        condition_title = keyTitle[path.row - 1];
        [self.navigationController popToRootViewControllerAnimated:YES];
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
    return 1;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return [keyTitle count] + 1;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
        }
    }
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        cell.textLabel.text = @"全部";
        if ([condition_title isEqualToString:@"<null>"]) [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    if (indexPath.section == 0 && indexPath.row > 0) {
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        cell.textLabel.text = [WeAppDelegate toString:we_codings[@"doctorCategory"][condition_category_tmp][@"title"][keyTitle[indexPath.row - 1]]];
        if ([condition_title isEqualToString:[NSString stringWithFormat:@"%@", keyTitle[indexPath.row - 1]]]) [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
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
    
    keyTitle = [we_codings[@"doctorCategory"][condition_category_tmp][@"title"] allKeys];
    
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