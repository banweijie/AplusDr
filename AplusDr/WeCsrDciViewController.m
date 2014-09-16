//
//  WeCsrDciViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-12.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCsrDciViewController.h"
#import "WeAppDelegate.h"

@interface WeCsrDciViewController () {
    UIActivityIndicatorView * sys_pendingView;
    UITableView * sys_tableView;
    
    
    UIView * controlPanel;
    UIButton * panel0;
    UIButton * panel1;
    UIButton * panel2;
    UIButton * button0;
    UIButton * button1;
    UIButton * button2;
    UIButton * selectSign;
    
    NSString * notice;
    NSString * groupIntro;
    
    // 海报效果
    UIView * posterView;
    
    // 标题
    UIView * titleView;
    
    int currentPage;
}

@end

@implementation WeCsrDciViewController

#pragma mark - ActionSheet Delegate

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView * subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton *)subview;
            [button setTitleColor:We_foreground_red_general forState:UIControlStateNormal];
            button.titleLabel.font = We_font_textfield_zh_cn;
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self api_patient_cancelFav];
    }
}

#pragma mark - TableView Delegate & DataSource

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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (currentPage == 0) {
        if (indexPath.section == 0) {
            if (indexPath.row == 3) {
                return [WeAppDelegate calcSizeForString:groupIntro Font:We_font_textfield_zh_cn expectWidth:280].height + 60;
            }
            if (indexPath.row == 4) {
                return [WeAppDelegate calcSizeForString:[WeAppDelegate deCodeOfLanguages:self.currentDoctor.languages] Font:We_font_textfield_zh_cn expectWidth:280].height + 60;
            }
        }
    }
    if (currentPage == 1) {
        if (indexPath.section == 0) {
            return [WeAppDelegate calcSizeForString:notice Font:We_font_textfield_zh_cn expectWidth:280].height + 40;
        }
    }
    if (currentPage == 2) {
        WeFunding * currentFunding;
        if (indexPath.section == 0) {
            currentFunding = self.currentDoctor.currentFunding;
        }
        else {
            currentFunding = self.currentDoctor.finishedFundings[indexPath.section - 1];
        }
        
        return 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 40 + 60;
    }
    return [sys_tableView rowHeight];
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (currentPage == 1) {
        if (section == 0) return @"公告";
        if (section == 1) return @"出诊时间";
    }
    return @"";
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (currentPage == 0) {
        if (section == 0) return 20 + 320 + 156 - 64;
        return 20;
    }
    if (currentPage == 1) {
        if (section == 0) return 40 + 320 + 156 - 64;
        return 40;
    }
    if (currentPage == 2) {
        if (section == 0) return 20 + 320 + 156 - 64;
        return 20;
    }
    return 1;
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    if (currentPage == 0) {
        if (section == [self numberOfSectionsInTableView:tv] - 1) return self.tabBarController.tabBar.frame.size.height + 300;
    }
    if (currentPage == 1) {
        if (section == [self numberOfSectionsInTableView:tv] - 1) return self.tabBarController.tabBar.frame.size.height + 300;
    }
    if (currentPage == 2) {
        if (section == [self numberOfSectionsInTableView:tv] - 1) return self.tabBarController.tabBar.frame.size.height + 20;
    }
    return 1;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (currentPage == 0) {
        return 1;
    }
    if (currentPage == 1) {
        return 2;
    }
    if (currentPage == 2) {
        return 1 + [self.currentDoctor.finishedFundings count];
    }
    return 10;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (currentPage == 0) {
        if (section == 0) return 5;
    }
    if (currentPage == 1) {
        if (section == 0) return 1;
        if (section == 1) {
            if ([self.currentDoctor.workPeriod isEqualToString:@"<null>"]) return 1;
            else return [self.currentDoctor.workPeriod length] / 4;
        }
    }
    if (currentPage == 2) {
        return 1;
    }
    return 2;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    UILabel *label, * l1;
    CGSize sizezz;
    if (currentPage == 0) {
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        cell.contentView.backgroundColor = We_background_cell_general;
                        cell.textLabel.text = @"医院";
                        cell.textLabel.font = We_font_textfield_zh_cn;
                        cell.textLabel.textColor = We_foreground_black_general;
                        cell.detailTextLabel.text = self.currentDoctor.hospitalName;
                        cell.detailTextLabel.font = We_font_textfield_zh_cn;
                        cell.detailTextLabel.textColor = We_foreground_gray_general;
                        break;
                    case 1:
                        cell.contentView.backgroundColor = We_background_cell_general;
                        cell.textLabel.text = @"科室";
                        cell.textLabel.font = We_font_textfield_zh_cn;
                        cell.textLabel.textColor = We_foreground_black_general;
                        cell.detailTextLabel.text = self.currentDoctor.sectionName;
                        cell.detailTextLabel.font = We_font_textfield_zh_cn;
                        cell.detailTextLabel.textColor = We_foreground_gray_general;
                        break;
                    case 2:
                        cell.contentView.backgroundColor = We_background_cell_general;
                        cell.textLabel.text = @"职称";
                        cell.textLabel.font = We_font_textfield_zh_cn;
                        cell.textLabel.textColor = We_foreground_black_general;
                        cell.detailTextLabel.text = we_codings[@"doctorCategory"][self.currentDoctor.category][@"title"][self.currentDoctor.title];
                        cell.detailTextLabel.font = We_font_textfield_zh_cn;
                        cell.detailTextLabel.textColor = We_foreground_gray_general;
                        break;
                    case 3:
                        l1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 280, 40)];
                        l1.text = @"团队介绍";
                        l1.font = We_font_textfield_zh_cn;
                        l1.textColor = We_foreground_black_general;
                        [cell.contentView addSubview:l1];
                        sizezz = [WeAppDelegate calcSizeForString:groupIntro Font:We_font_textfield_zh_cn expectWidth:280];
                        label = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, sizezz.width, sizezz.height)];
                        label.numberOfLines = 0;
                        label.lineBreakMode = NSLineBreakByWordWrapping;
                        label.text = groupIntro;
                        label.font = We_font_textfield_zh_cn;
                        label.textColor = We_foreground_gray_general;
                        [cell.contentView addSubview:label];
                        break;
                    case 4:
                        l1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 280, 40)];
                        l1.text = @"工作语言";
                        l1.font = We_font_textfield_zh_cn;
                        l1.textColor = We_foreground_black_general;
                        [cell.contentView addSubview:l1];
                        
                        sizezz = [WeAppDelegate calcSizeForString:[WeAppDelegate deCodeOfLanguages:self.currentDoctor.languages] Font:We_font_textfield_zh_cn expectWidth:280];
                        label = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, sizezz.width, sizezz.height)];
                        label.numberOfLines = 0;
                        label.lineBreakMode = NSLineBreakByWordWrapping;
                        label.text = [WeAppDelegate deCodeOfLanguages:self.currentDoctor.languages];
                        label.font = We_font_textfield_zh_cn;
                        label.textColor = We_foreground_gray_general;
                        [cell.contentView addSubview:label];
                    default:
                        break;
                }
                break;
                
            default:
                break;
        }
    }
    if (currentPage == 1) {
        switch (indexPath.section) {
            case 0:
                sizezz = [WeAppDelegate calcSizeForString:notice Font:We_font_textfield_zh_cn expectWidth:280];
                label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, sizezz.width, sizezz.height)];
                label.numberOfLines = 0;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.text = notice;
                label.font = We_font_textfield_zh_cn;
                label.textColor = We_foreground_black_general;
                [cell.contentView addSubview:label];
                break;
            case 1:
                cell.contentView.backgroundColor = We_background_cell_general;
                if ([self.currentDoctor.workPeriod isEqualToString:@"<null>"]) {
                    cell.textLabel.text = @"该医生没有设置出诊时间";
                }
                else {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [WeAppDelegate transitionDayOfWeekFromChar:[self.currentDoctor.workPeriod substringWithRange:NSMakeRange(4 * indexPath.row + 1, 1)]], [WeAppDelegate transitionPeriodOfDayFromChar:[self.currentDoctor.workPeriod substringWithRange:NSMakeRange(4 * indexPath.row + 2, 1)]]];
                    cell.detailTextLabel.text = [WeAppDelegate transitionTypeOfPeriodFromChar:[self.currentDoctor.workPeriod substringWithRange:NSMakeRange(4 * indexPath.row + 3, 1)]];
                }
                cell.textLabel.font = We_font_textfield_zh_cn;
                cell.textLabel.textColor = We_foreground_black_general;
                cell.detailTextLabel.font = We_font_textfield_zh_cn;
                cell.detailTextLabel.textColor = We_foreground_gray_general;
            default:
                break;
        }
    }
    if (currentPage == 2) {
        cell.backgroundColor = [UIColor clearColor];

        if (indexPath.section == 0 && self.currentDoctor.currentFunding == nil) {
            
        }
        else {
            // 当前处理的众筹
            WeFunding * currentFunding;
            if (indexPath.section == 0) {
                currentFunding = self.currentDoctor.currentFunding;
            }
            else {
                currentFunding = self.currentDoctor.finishedFundings[indexPath.section - 1];
            }
            
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
                [restData setText:[NSString stringWithFormat:@"%d天", restSec / 86400 + 1]];
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

- (void)appointing:(id)sender {
    if (currentUser == nil) {
        WeRegWlcViewController * vc = [[WeRegWlcViewController alloc] init];
        vc.originTargetViewController = nil;
        vc.tabBarController = self.tabBarController;
        
        WeNavViewController * nav = [[WeNavViewController alloc] init];
        [nav pushViewController:vc animated:NO];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
    else {
        WeCsrJiaViewController * vc = [[WeCsrJiaViewController alloc] init];
        vc.currentDoctor = self.currentDoctor;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)consulting:(id)sender {
    if (currentUser == nil) {
        WeRegWlcViewController * vc = [[WeRegWlcViewController alloc] init];
        vc.originTargetViewController = nil;
        vc.tabBarController = self.tabBarController;
        
        WeNavViewController * nav = [[WeNavViewController alloc] init];
        [nav pushViewController:vc animated:NO];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
    else {
        WeCsrCosViewController * vc = [[WeCsrCosViewController alloc] init];
        vc.pushType = @"consultingRoom";
        vc.currentDoctor = self.currentDoctor;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect rect = controlPanel.frame;
    rect.origin.y = MAX(320 - scrollView.contentOffset.y, 64);
    controlPanel.frame = rect;
    
    [posterView setAlpha:MIN(MAX((320 - 64 - scrollView.contentOffset.y) / 64, 0), 1)];
    [titleView setAlpha:1 - MIN(MAX((320 - 64 - scrollView.contentOffset.y) / 64, 0), 1)];
}

// 滑动结束
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < 100) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    if (scrollView.contentOffset.y > 100 && scrollView.contentOffset.y < 320 - 64) {
        [scrollView setContentOffset:CGPointMake(0, 320 - 64) animated:YES];
    }
}

// 防止惯性滑动
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 100) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    if (scrollView.contentOffset.y > 100 && scrollView.contentOffset.y < 320 - 64) {
        [scrollView setContentOffset:CGPointMake(0, 320 - 64) animated:YES];
    }
}

#pragma mark - View related

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // 标题和用于返回的文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"基本资料" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationController.navigationBar setBackgroundImage:[WeAppDelegate imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    
    // 初始化变量
    notice = self.currentDoctor.notice;
    if ([notice isEqualToString:@"<null>"]) notice = @"该医生未设置公告";
    groupIntro = self.currentDoctor.groupIntro;
    if ([groupIntro isEqualToString:@"<null>"]) groupIntro = @"该医生未设置团队介绍";
    
    currentPage = 1;
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    sys_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    sys_tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:sys_tableView];
    
    // controlPanel
    controlPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 320, 320, 156 - 64)];
    
    button0 = [WeToolButton buttonWithType:UIButtonTypeRoundedRect];
    [button0 setFrame:CGRectMake(0, 2, 89, 48)];
    [button0 setImage:[UIImage imageNamed:@"docinfo-applychatting"] forState:UIControlStateNormal];
    [button0 setTitle:@"发起咨询" forState:UIControlStateNormal];
    [button0 addTarget:self action:@selector(consulting:) forControlEvents:UIControlEventTouchDragEnter];
    button0.tintColor = We_foreground_white_general;
    button0.backgroundColor = [UIColor colorWithRed:90 / 255.0 green:41 / 255.0 blue:45 / 255.0 alpha:1.0];
    button0.titleLabel.font = We_font_textfield_small_zh_cn;
    [controlPanel addSubview:button0];
    
    button1 = [WeToolButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setFrame:CGRectMake(91, 2, 138, 48)];
    if (favorDoctorList[self.currentDoctor.userId] == nil) {
        [button1 setTitle:@"添加为保健医" forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"docinfo-addfavorite"] forState:UIControlStateNormal];
    }
    else {
        [button1 setTitle:@"已添加为保健医" forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"docinfo-favorited"] forState:UIControlStateNormal];
    }
    [button1 addTarget:self action:@selector(button1_onPress) forControlEvents:UIControlEventTouchUpInside];
    button1.tintColor = We_foreground_white_general;
    button1.backgroundColor = We_background_red_general;
    button1.titleLabel.font = We_font_textfield_small_zh_cn;
    [controlPanel addSubview:button1];
    
    button2 = [WeToolButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setFrame:CGRectMake(231, 2, 89, 48)];
    [button2 setImage:[UIImage imageNamed:@"docinfo-makeappointment"] forState:UIControlStateNormal];
    [button2 setTitle:@"申请加号" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(appointing:) forControlEvents:UIControlEventTouchUpInside];
    button2.tintColor = We_foreground_white_general;
    button2.backgroundColor = [UIColor colorWithRed:90 / 255.0 green:41 / 255.0 blue:45 / 255.0 alpha:1.0];
    button2.titleLabel.font = We_font_textfield_small_zh_cn;
    [controlPanel addSubview:button2];
    
    panel0 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [panel0 setFrame:CGRectMake(0, 50, 120, 42)];
    [panel0 setTitle:@"基本资料" forState:UIControlStateNormal];
    [panel0 addTarget:self action:@selector(panel0_onPress) forControlEvents:UIControlEventTouchUpInside];
    panel0.tintColor = We_foreground_red_general;
    panel0.backgroundColor = We_background_general;
    panel0.titleLabel.font = We_font_textfield_zh_cn;
    [controlPanel addSubview:panel0];
    
    panel1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [panel1 setFrame:CGRectMake(120, 50, 80, 42)];
    [panel1 setTitle:@"业务公告" forState:UIControlStateNormal];
    [panel1 addTarget:self action:@selector(panel1_onPress) forControlEvents:UIControlEventTouchUpInside];
    panel1.tintColor = We_foreground_black_general;
    panel1.backgroundColor = We_background_general;
    panel1.titleLabel.font = We_font_textfield_zh_cn;
    [controlPanel addSubview:panel1];
    
    panel2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [panel2 setFrame:CGRectMake(200, 50, 120, 42)];
    [panel2 setTitle:@"众筹项目" forState:UIControlStateNormal];
    [panel2 addTarget:self action:@selector(panel2_onPress) forControlEvents:UIControlEventTouchUpInside];
    panel2.tintColor = We_foreground_black_general;
    panel2.backgroundColor = We_background_general;
    panel2.titleLabel.font = We_font_textfield_zh_cn;
    [controlPanel addSubview:panel2];
    
    selectSign = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [selectSign setFrame:CGRectMake(15, 92 - 5, 90, 5)];
    selectSign.backgroundColor = We_foreground_red_general;
    [controlPanel addSubview:selectSign];
    
    [self.view addSubview:controlPanel];
    
    // 头像
    posterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [sys_tableView addSubview:posterView];
    
    // 头像背景图片
    UIImageView * avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [avatarView setImageWithURL:[NSURL URLWithString:yijiarenAvatarUrl(self.currentDoctor.avatarPath)]];
    [avatarView setContentMode:UIViewContentModeScaleAspectFill];
    [posterView addSubview:avatarView];
    
    // 渐变黑色
//    UIToolbar * toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 320 - 80, 320, 80)];
//    [toolBar setBarStyle:UIBarStyleBlackTranslucent];
//    [toolBar setBarTintColor:[UIColor clearColor]];
//    [toolBar setAlpha:0.9];
    //[toolBar setBackgroundColor:UIColorFromRGB(0, 0, 100, 0.0)];
    //[toolBar setBackgroundImage:[UIImage imageNamed:@"crowdfunding-gradientcover"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    //[posterView addSubview:toolBar];
    
    UIImageView * shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 320 - 80, 320, 80)];
    [shadowView setImage:[UIImage imageNamed:@"crowdfunding-gradientcover"]];
    [shadowView setContentMode:UIViewContentModeScaleToFill];
    [posterView addSubview:shadowView];
    
    
    // 头像上的标题
    UILabel * posterTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 320 - 64, 320, 30)];
    [posterTitle setTextAlignment:NSTextAlignmentCenter];
    [posterTitle setText:[NSString stringWithFormat:@"%@ %@", self.currentDoctor.userName, we_codings[@"doctorCategory"][self.currentDoctor.category][@"title"][self.currentDoctor.title]]];
    [posterTitle setFont:We_font_textfield_huge_zh_cn];
    [posterTitle setTextColor:We_foreground_white_general];
    [posterView addSubview:posterTitle];
    
    // 头像上的副标题
    UILabel * posterTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 320 - 64 + 30, 320, 20)];
    [posterTitle2 setTextAlignment:NSTextAlignmentCenter];
    [posterTitle2 setText:[NSString stringWithFormat:@"%@ %@", self.currentDoctor.hospitalName, self.currentDoctor.sectionName]];
    [posterTitle2 setFont:We_font_textfield_large_zh_cn];
    [posterTitle2 setTextColor:We_foreground_white_general];
    [posterView addSubview:posterTitle2];
    
    // 标题
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    
    UIImageView * titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [titleImage setImage:[UIImage imageNamed:@"texture"]];
    [titleView addSubview:titleImage];
    
    [titleView setAlpha:0.0];
    [self.view addSubview:titleView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 40)];
    [titleLabel setText:[NSString stringWithFormat:@"%@ %@", self.currentDoctor.userName, we_codings[@"doctorCategory"][self.currentDoctor.category][@"title"][self.currentDoctor.title]]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:We_font_textfield_huge_zh_cn];
    [titleLabel setTextColor:We_foreground_white_general];
    [titleView addSubview: titleLabel];
    
    // sys_pendingView
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView setAlpha:1.0];
    //[sys_pendingView startAnimating];
    [self.view addSubview:sys_pendingView];
    
    [self refreshView];
    
    [self api_patient_getDoctorInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[WeAppDelegate imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    
    // refresh Page
    if (favorDoctorList[self.currentDoctor.userId] == nil) {
        [button1 setTitle:@"添加为保健医" forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"docinfo-addfavorite"] forState:UIControlStateNormal];
    }
    else {
        [button1 setTitle:@"已添加为保健医" forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"docinfo-favorited"] forState:UIControlStateNormal];
    }
}

-  (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"texture"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - functional

- (void)refreshView {
    [sys_tableView reloadData];
    
    // 设置tab样式
    [panel0 setTintColor:We_foreground_black_general];
    [panel1 setTintColor:We_foreground_black_general];
    [panel2 setTintColor:We_foreground_black_general];
    if (currentPage == 0) [panel0 setTintColor:We_foreground_red_general];
    if (currentPage == 1) [panel1 setTintColor:We_foreground_red_general];
    if (currentPage == 2) [panel2 setTintColor:We_foreground_red_general];
    
    CGRect rect = selectSign.frame;
    rect.origin.x = 15 + 100 * currentPage;
    selectSign.frame = rect;
}

#pragma mark - callbacks

- (void)panel0_onPress {
    currentPage = 0;
    [sys_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self refreshView];
    if (sys_tableView.contentOffset.y > 320 - 64) [sys_tableView setContentOffset:CGPointMake(0, 320 - 64) animated:NO];
}

- (void)panel1_onPress {
    currentPage = 1;
    [sys_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self refreshView];
    if (sys_tableView.contentOffset.y > 320 - 64) [sys_tableView setContentOffset:CGPointMake(0, 320 - 64) animated:NO];
}

- (void)panel2_onPress {
    currentPage = 2;
    [sys_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self refreshView];
    if (sys_tableView.contentOffset.y > 320 - 64) [sys_tableView setContentOffset:CGPointMake(0, 320 - 64) animated:NO];
}

- (void)button1_onPress {
    // 未登录处理
    if (currentUser == nil) {
        WeRegWlcViewController * vc = [[WeRegWlcViewController alloc] init];
        vc.originTargetViewController = nil;
        vc.tabBarController = self.tabBarController;
        
        WeNavViewController * nav = [[WeNavViewController alloc] init];
        [nav pushViewController:vc animated:NO];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
    else {
        // 取消保健医
        if ([button1.titleLabel.text isEqualToString:@"已添加为保健医"]) {
            UIActionSheet * actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:@"请问是否要取消与该医生的保健医关系\n（取消保健医后，该医生将不会出现在您的咨询室当中，但你们的咨询记录仍然保存在本地）"
                                          delegate:self
                                          cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showInView:self.view];
        }
        // 添加保健医
        else {
            [self api_patient_addFav];
        }
    }
}

#pragma mark - apis

- (void)api_patient_getDoctorInfo {
    [sys_pendingView startAnimating];
    [WeAppDelegate postToServerWithField:@"patient" action:@"getDoctorInfo"
                              parameters:@{
                                           @"doctorId":self.currentDoctor.userId
                                           }
                                 success:^(id response) {
                                     [self.currentDoctor setWithNSDictionary:response];
                                     if (response[@"currentFunding"] != [NSNull null]) {
                                         self.currentDoctor.currentFunding = [[WeFunding alloc] initWithNSDictionary:response[@"currentFunding"]];
                                     }
                                     self.currentDoctor.finishedFundings = [[NSMutableArray alloc] init];
                                     for (int i = 0; i < [response[@"finishedFundings"] count]; i++) {
                                         [self.currentDoctor.finishedFundings addObject:[[WeFunding alloc] initWithNSDictionary:response[@"finishedFundings"][i]]];
                                     }
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     [[[UIAlertView alloc] initWithTitle:@"获取医生信息失败" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                     [self.navigationController popViewControllerAnimated:YES];
                                     [sys_pendingView stopAnimating];
                                 }];
}

- (void)api_patient_addFav {
    // 判断登录状态
    [sys_pendingView startAnimating];
    [WeAppDelegate postToServerWithField:@"patient" action:@"addFav"
                              parameters:@{
                                           @"doctorId":self.currentDoctor.userId
                                           }
                                 success:^(id response) {
                                     [[[UIAlertView alloc] initWithTitle:@"添加保健医成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                     [button1 setTitle:@"已添加为保健医" forState:UIControlStateNormal];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     [[[UIAlertView alloc] initWithTitle:@"添加保健医失败" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                     [sys_pendingView stopAnimating];
                                 }];
}

- (void)api_patient_cancelFav {
    // 判断登录状态
    [sys_pendingView startAnimating];
    [WeAppDelegate postToServerWithField:@"patient" action:@"cancelFav"
                              parameters:@{
                                           @"doctorId":self.currentDoctor.userId
                                           }
                                 success:^(id response) {
                                     [[[UIAlertView alloc] initWithTitle:@"取消保健医成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                     [button1 setTitle:@"添加为保健医" forState:UIControlStateNormal];
                                     [favorDoctorList removeObjectForKey:self.currentDoctor.userId];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     [[[UIAlertView alloc] initWithTitle:@"取消保健医失败" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                     [sys_pendingView stopAnimating];
                                 }];
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
