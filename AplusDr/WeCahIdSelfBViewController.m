//
//  WeCahIdSelfBViewController.m
//  AplusDr
//
//  Created by ejren on 14-10-13.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCahIdSelfBViewController.h"

@interface WeCahIdSelfBViewController ()
{
    UITableView * sys_tableView;
    UITextField * user_date_input;
    UITextField * user_hospital_input;
    UITextView * user_result_input;
    UIActivityIndicatorView * sys_pendingView;
    UIView * sys_imageView;
    UIActionSheet * deleteImage_actionSheet;
    
    WeTextCoding * imageToDelete;
    WeTextCoding * imageToDemo;
}
@end

@implementation WeCahIdSelfBViewController

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:We_foreground_red_general forState:UIControlStateNormal];
            button.titleLabel.font = We_font_textfield_zh_cn;
        }
    }
}
/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
// 将展示某个Cell触发的事件
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
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && ![examinationChanging.typeParent isEqualToString:@"P"]) {
        return 20 + ([examinationChanging.images count] / 3 + 1) * 100;
    }
    return tv.rowHeight;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 21 + 64;
    if (section == 1 && ![examinationChanging.typeParent isEqualToString:@"P"]) return 40;
    if (section == 1 && [examinationChanging.typeParent isEqualToString:@"P"]) return 40;
    if (section == 2 && [examinationChanging.typeParent isEqualToString:@"C"]) return 40;
    if (section == 2 && [examinationChanging.typeParent isEqualToString:@"I"]) return 40;
    if (section == 3 && [examinationChanging.typeParent isEqualToString:@"P"]) return 40;
    if (section == 3 && [examinationChanging.typeParent isEqualToString:@"I"]) return 40;
    if (section == 4) return 40;
    return 10;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    
    if (section == 1 && ![examinationChanging.typeParent isEqualToString:@"P"]) return @"报告单照片";
    if (section == 1 && [examinationChanging.typeParent isEqualToString:@"P"]) return @"条目组";
    if (section == 2 && [examinationChanging.typeParent isEqualToString:@"C"]) return @"条目组";
    if (section == 2 && [examinationChanging.typeParent isEqualToString:@"I"]) return @"检查结果";
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 111;
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
    if (tv == sys_tableView) {
        if ([examinationChanging.typeParent isEqualToString:@"P"]) return 3;
        if ([examinationChanging.typeParent isEqualToString:@"C"]) return 4;
        if ([examinationChanging.typeParent isEqualToString:@"I"]) return 3;
    }
    return 0;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (tv == sys_tableView) {
        if (section == 0) return 2;
        if (section == 1 && ![examinationChanging.typeParent isEqualToString:@"P"]) return 1;
        if (section == 1 && [examinationChanging.typeParent isEqualToString:@"P"]) return MAX([examinationChanging.items count], 1);
        if (section == 2 && [examinationChanging.typeParent isEqualToString:@"P"]) return 1;
        if (section == 2 && [examinationChanging.typeParent isEqualToString:@"C"]) return MAX([examinationChanging.items count], 1);
        if (section == 2 && [examinationChanging.typeParent isEqualToString:@"I"]) return 1;
        if (section == 3 && [examinationChanging.typeParent isEqualToString:@"P"]) return 1;
        if (section == 3 && [examinationChanging.typeParent isEqualToString:@"C"]) return 1;
        if (section == 3 && [examinationChanging.typeParent isEqualToString:@"I"]) return 1;
        if (section == 4) return 1;
    }
    return 0;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (tv == sys_tableView) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.backgroundColor = We_foreground_white_general;
            cell.textLabel.text = @"检查时间";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            [cell.contentView addSubview:user_date_input];
        }
        if (indexPath.section == 0 && indexPath.row == 1) {
            cell.backgroundColor = We_foreground_white_general;
            cell.textLabel.text = @"检查地点";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            [cell.contentView addSubview:user_hospital_input];
        }
        if (indexPath.section == 1 && ![examinationChanging.typeParent isEqualToString:@"P"]) {
            [cell.contentView addSubview:sys_imageView];
        }
        if (indexPath.section == 1 && [examinationChanging.typeParent isEqualToString:@"P"]) {
            if ([examinationChanging.items count] == 0) {
                cell.backgroundColor = We_foreground_white_general;
                cell.textLabel.text = @"目前尚未有检查条目";
                cell.textLabel.font = We_font_textfield_zh_cn;
                cell.textLabel.textColor = We_foreground_black_general;
            }
            if ([examinationChanging.items count] > 0) {
                //                NSLog(@"!!!");
                WeExaminationItem * item = examinationChanging.items[indexPath.row];
                cell.backgroundColor = We_foreground_white_general;
                cell.textLabel.text = item.config.name;
                cell.textLabel.font = We_font_textfield_zh_cn;
                cell.textLabel.textColor = We_foreground_black_general;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", item.value, item.config.unit];
                cell.detailTextLabel.font = We_font_textfield_zh_cn;
                cell.detailTextLabel.textColor = We_foreground_gray_general;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
        }
        if (indexPath.section == 2 && [examinationChanging.typeParent isEqualToString:@"P"]) {
            cell.backgroundColor = We_foreground_white_general;
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_red_general;
            cell.textLabel.text = @"添加检查项目";
        }
        if (indexPath.section == 2 && [examinationChanging.typeParent isEqualToString:@"C"]) {
            if ([examinationChanging.items count] == 0) {
                cell.backgroundColor = We_foreground_white_general;
                cell.textLabel.text = @"目前尚未有检查条目";
                cell.textLabel.font = We_font_textfield_zh_cn;
                cell.textLabel.textColor = We_foreground_black_general;
            }
            if ([examinationChanging.items count] > 0) {
                //                NSLog(@"!!!");
                WeExaminationItem * item = examinationChanging.items[indexPath.row];
                cell.backgroundColor = We_foreground_white_general;
                cell.textLabel.text = item.config.name;
                cell.textLabel.font = We_font_textfield_zh_cn;
                cell.textLabel.textColor = We_foreground_black_general;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", item.value, item.config.unit];
                cell.detailTextLabel.font = We_font_textfield_zh_cn;
                cell.detailTextLabel.textColor = We_foreground_gray_general;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
        }
        if (indexPath.section == 2 && [examinationChanging.typeParent isEqualToString:@"I"]) {
            cell.backgroundColor = We_foreground_white_general;
            [cell.contentView addSubview:user_result_input];
        }
        if (indexPath.section == 3 && [examinationChanging.typeParent isEqualToString:@"P"]) {
            cell.backgroundColor = We_foreground_red_general;
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_white_general;
            cell.textLabel.text = @"删除";
        }
        if (indexPath.section == 3 && [examinationChanging.typeParent isEqualToString:@"C"]) {
            cell.backgroundColor = We_foreground_white_general;
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_red_general;
            cell.textLabel.text = @"添加检查项目";
        }
        if (indexPath.section == 3 && [examinationChanging.typeParent isEqualToString:@"I"]) {
            cell.backgroundColor = We_foreground_red_general;
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_white_general;
            cell.textLabel.text = @"删除";
        }
        if (indexPath.section == 4) {
            cell.backgroundColor = We_foreground_red_general;
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_white_general;
            cell.textLabel.text = @"删除";
        }
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
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@详情", we_codings[@"examinationType"][examinationChanging.typeParent]];
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // 更新图片集
    [self refreshImageView:self];
    
    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sys_tableView];
    
    // 输入框初始化
    
    We_init_textFieldInCell_general(user_date_input, examinationChanging.date, We_font_textfield_en_us);
    We_init_textFieldInCell_general(user_hospital_input, examinationChanging.hospital, We_font_textfield_zh_cn);
    We_init_textView_huge(user_result_input, examinationChanging.result, We_font_textfield_zh_cn)
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
    // 保存按键
    //    UIBarButtonItem * user_save = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(user_save_onPress:)];
    //    self.navigationItem.rightBarButtonItem = user_save;
}

- (void)viewWillAppear:(BOOL)animated {
    [sys_tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)refreshImageView:(id)sender {
    sys_imageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20 + (([examinationChanging.images count] + 1) / 3 + 1) * 100)];
    for (int i = 0; i <= [examinationChanging.images count]; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 + (i % 3) * 100, 20 + (i / 3) * 100, 80, 80)];
        WeInfoedButton * imageButton = [WeInfoedButton buttonWithType:UIButtonTypeRoundedRect];
        [imageButton setFrame:CGRectMake(20 + (i % 3) * 100, 20 + (i / 3) * 100, 80, 80)];
        
        [sys_imageView addSubview:imageView];
        [sys_imageView addSubview:imageButton];
        
        if (i < [examinationChanging.images count]) {
            [imageView setImageWithURL:[NSURL URLWithString:yijiarenImageUrl(((WeTextCoding *)examinationChanging.images[i]).objName)]];
            WeInfoedButton * deleteButton = [WeInfoedButton buttonWithType:UIButtonTypeRoundedRect];
            [deleteButton setFrame:CGRectMake(10 + (i % 3) * 100, 10 + (i / 3) * 100, 20, 20)];
            [deleteButton setBackgroundImage:[UIImage imageNamed:@"casehistory-deleteimage"] forState:UIControlStateNormal];
            [deleteButton setUserData:examinationChanging.images[i]];
//            [deleteButton addTarget:self action:@selector(deleteButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
            [sys_imageView addSubview:deleteButton];
            
            // 点击图片放大
            [imageButton setUserData:examinationChanging.images[i]];
            [imageButton addTarget:self action:@selector(demoImage:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [imageView setImage:[UIImage imageNamed:@"casehistory-addimage"]];
//            [imageButton addTarget:self action:@selector(addExaminationImage:) forControlEvents:UIControlEventTouchUpInside];
        }
        //NSLog(@"%@", yijiarenImageUrl(((WeTextCoding *)examinationChanging.images[i]).objName));
    }
}

- (void)demoImage:(WeInfoedButton *)sender {
    WeTextCoding * image = sender.userData;
    WeImageViewerViewController * vc = [[WeImageViewerViewController alloc] init];
    vc.imageToDemoPath = yijiarenImageUrl(image.objName);
    //[self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
