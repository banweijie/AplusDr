//
//  WeCsrJiaViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-17.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCsrJiaViewController.h"
#import "WeParagraphModifyViewController.h"

@interface WeCsrJiaViewController () {
    UIView * sys_explaination_view;
    UILabel * sys_explaination_label;
    UIActivityIndicatorView * sys_pendingView;
    UITableView * sys_tableView;
    
    /*
    // 日历
    UIScrollView * sys_calenderView;
    UIButton * lastMonth;
    UIButton * nextMonth;
    UILabel * calenderTitle;
    int currentYear;
    int currentMonth;
    NSMutableArray * calenderDayView;
    NSMutableArray * calenderDayDate;
    NSMutableArray * calenderDayPart1;
    NSMutableArray * calenderDayPart2;
    
    NSInteger centerYear;
    NSInteger centerMonth;
    NSMutableArray * calenderViews;*/
    
    NSMutableString * dates;
    NSMutableString * datesToDemo;
    
    // 加号预诊信息
    NSMutableString * user_gender;
    NSMutableString * user_age;
    NSMutableString * user_name;
    NSMutableString * user_idNum;
    NSMutableString * user_description;
    NSMutableString * user_case;
    NSString *recorders;
    NSString * examations;
}
#define cacheWidth 5
@end

@implementation WeCsrJiaViewController
- (void)paymentHasBeenPayed
{}
/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section == 2) {
        WeCsrJiaChooseTimeViewController * vc = [[WeCsrJiaChooseTimeViewController alloc] init];
        vc.currentDoctor = self.currentDoctor;
        vc.dates = dates;
        vc.datesToDemo = datesToDemo;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (path.section == 3 && path.row == 0) {
        WeSentenceModifyViewController * vc = [[WeSentenceModifyViewController alloc] init];
        vc.stringToBeTitle = @"年龄";
        vc.stringToModify = user_age;
        vc.stringToPlaceHolder = @"";
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (path.section == 3 && path.row == 1) {
        WeGenderPickerViewController * vc = [[WeGenderPickerViewController alloc] init];
        vc.stringToBeTitle = @"性别";
        vc.stringToModify = user_gender;
        vc.stringToPlaceHolder = @"";
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (path.section == 3 && path.row == 2) {
        WeSentenceModifyViewController * vc = [[WeSentenceModifyViewController alloc] init];
        vc.stringToBeTitle = @"真实姓名";
        vc.stringToModify = user_name;
        vc.stringToPlaceHolder = @"";
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (path.section == 3 && path.row == 3) {
        WeSentenceModifyViewController * vc = [[WeSentenceModifyViewController alloc] init];
        vc.stringToBeTitle = @"身份证号";
        vc.stringToModify = user_idNum;
        vc.stringToPlaceHolder = @"";
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (path.section==3 &&path.row==4) {
        WeSelectRecordersViewController *vc=[[WeSelectRecordersViewController alloc]init];
        vc.delegrate=self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (path.section==3 &&path.row==5) {
        WeParagraphModifyViewController * vc = [[WeParagraphModifyViewController alloc] init];
        vc.stringToBeTitle = @"更多描述";
        vc.stringToModify = user_description;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (path.section == 4 && path.row == 0) {
        [self api_patient_addJiahao];
    }
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) return 51;//tv.rowHeight * 1.5; //sys_calenderView.frame.size.height;
    if (indexPath.section==3 &&indexPath.row==5) {
        if ([user_description isEqualToString:@""]) {
            return [WeAppDelegate calcSizeForString:@"无" Font:We_font_textfield_zh_cn expectWidth:280].height + 60;
        }
        else {
            return [WeAppDelegate calcSizeForString:user_description Font:We_font_textfield_zh_cn expectWidth:280].height + 60;
        }

    }
    return tv.rowHeight;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 40 + 64;
    return 40;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return @"医生业务设置";
    if (section == 1) return @"出诊时间";
    if (section == 2) return @"选择加号时间";
    if (section == 3) return @"加号预诊信息";
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    //if (section == 1) return 30;
    if (section == 0) return 60;
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 50;
    return 10;
}
-(UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section{
    if (section == 0) return sys_explaination_view;
    return nil;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return 5;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    if (section == 1) return [self.currentDoctor.workPeriod length] / 4;
    if (section == 2) return 1;
    if (section == 3) return 6;
    if (section == 4) return 1;
    return 0;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    [cell setBackgroundColor:We_background_cell_general];
    
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.contentView.backgroundColor = We_background_cell_general;
        
        cell.textLabel.text = @"加号预诊费";
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元/次", self.currentDoctor.plusPrice];
        cell.detailTextLabel.font = We_font_textfield_zh_cn;
        cell.detailTextLabel.textColor = We_foreground_black_general;
    }
    if (indexPath.section == 1) {
        cell.contentView.backgroundColor = We_background_cell_general;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [WeAppDelegate transitionDayOfWeekFromChar:[self.currentDoctor.workPeriod substringWithRange:NSMakeRange(4 * indexPath.row + 1, 1)]], [WeAppDelegate transitionPeriodOfDayFromChar:[self.currentDoctor.workPeriod substringWithRange:NSMakeRange(4 * indexPath.row + 2, 1)]]];
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        cell.detailTextLabel.text = [WeAppDelegate transitionTypeOfPeriodFromChar:[self.currentDoctor.workPeriod substringWithRange:NSMakeRange(4 * indexPath.row + 3, 1)]];
        cell.detailTextLabel.font = We_font_textfield_zh_cn;
        cell.detailTextLabel.textColor = We_foreground_gray_general;
    }
    if (indexPath.section == 2) {
        [cell.textLabel setNumberOfLines:0];
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        if ([datesToDemo isEqualToString:@""]) {
            [cell.textLabel setText:@"任意时刻均可"];
        }
        else {
            [cell.textLabel setText:datesToDemo];
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_black_general];
        [cell.textLabel setText:@"年龄"];
        [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
        [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        [cell.detailTextLabel setText:user_age];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 3 && indexPath.row == 1) {
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_black_general];
        [cell.textLabel setText:@"性别"];
        [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
        [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        [cell.detailTextLabel setText:[WeAppDelegate transitionGenderFromChar:user_gender]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 3 && indexPath.row == 2) {
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_black_general];
        [cell.textLabel setText:@"真实姓名"];
        [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
        [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        [cell.detailTextLabel setText:user_name];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 3 && indexPath.row == 3) {
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_black_general];
        [cell.textLabel setText:@"身份证号"];
        [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
        [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        [cell.detailTextLabel setText:user_idNum];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section==3 &&indexPath.row==4) {
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_black_general];
        [cell.textLabel setText:@"选择就诊记录或检查结果"];
        [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
        [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        [cell.detailTextLabel setText:user_case];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    }
    if (indexPath.section==3 &&indexPath.row==5) {
        
        UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 280, 40)];
        l1.text = @"更多描述";
        l1.font = We_font_textfield_zh_cn;
        l1.textColor = We_foreground_black_general;
        [cell.contentView addSubview:l1];
        
        if ([user_description isEqualToString:@""]) {
            CGSize sizezz = [WeAppDelegate calcSizeForString:@"无" Font:We_font_textfield_zh_cn expectWidth:280];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, sizezz.width, sizezz.height)];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.text = @"无";
            label.font = We_font_textfield_zh_cn;
            label.textColor = We_foreground_gray_general;
            [cell.contentView addSubview:label];
        }
        else {
            CGSize sizezz = [WeAppDelegate calcSizeForString:user_description Font:We_font_textfield_zh_cn expectWidth:280];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, sizezz.width, sizezz.height)];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.text = user_description;
            label.font = We_font_textfield_zh_cn;
            label.textColor = We_foreground_gray_general;
            [cell.contentView addSubview:label];
        }
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 4 && indexPath.row == 0) {
        [cell setBackgroundColor:We_background_red_tableviewcell];
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setText:@"确认加号"];
        [cell.textLabel setTextColor:We_foreground_white_general];
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

- (void)press:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"申请加号";
    
//    UIBarButtonItem * user_save = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(press:)];
    //self.navigationItem.leftBarButtonItem = user_save;
    
    // sys_explaination
    sys_explaination_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    sys_explaination_label = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 240, 30)];
    sys_explaination_label.lineBreakMode = NSLineBreakByWordWrapping;
    sys_explaination_label.numberOfLines = 0;
    sys_explaination_label.text = @"该费用为医生在加号时对病情的预诊费一旦申请加号成功则不可退回";
    sys_explaination_label.font = We_font_textfield_zh_cn;
    sys_explaination_label.textColor = We_foreground_gray_general;
    sys_explaination_label.textAlignment = NSTextAlignmentCenter;
    [sys_explaination_view addSubview:sys_explaination_label];
    
    // 背景图片
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
    [self.view addSubview:sys_tableView];
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
    // 加号时间
    dates = [[NSMutableString alloc] init];
    datesToDemo = [[NSMutableString alloc] init];
    
    // 加号预诊信息
    user_gender = [[NSMutableString alloc] initWithString:currentUser.gender];
    user_age = [[NSMutableString alloc] initWithString:@""];
    user_name = [[NSMutableString alloc] initWithString:currentUser.trueName];
    user_idNum = [[NSMutableString alloc] initWithString:currentUser.idNum];
    user_description = [[NSMutableString alloc] init];
    user_case=[[NSMutableString alloc] initWithString:@"未选择"];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [sys_tableView reloadData];
}
-(void)selectRecorders:(NSString *)rec examation:(NSString *)exa
{
    if ([rec isEqualToString:@""] && [exa isEqualToString:@""]) {
         user_case=[NSMutableString stringWithString:@"未选择"];
    }
    else
        user_case=[NSMutableString stringWithString:@"已选择"];
    recorders=rec;
    examations=exa;
    
}
#pragma mark - apis

- (void)api_patient_addJiahao {
    [sys_pendingView startAnimating];
    [WeAppDelegate postToServerWithField:@"patient" action:@"addJiahao"
                              parameters:@{
                                           @"jiahao.doctor.id":self.currentDoctor.userId,
                                           @"jiahao.gender":user_gender,
                                           @"jiahao.age":user_age,
                                           @"jiahao.name":user_name,
                                           @"jiahao.idNum":user_idNum,
                                           @"jiahao.dates":dates,
                                           @"jiahao.phone":currentUser.userPhone,
                                           @"jiahao.description":user_description,
                                           @"jiahao.recordMessage.recordIds":recorders,
                                           @"jiahao.recordMessage.examinationIds":examations
                                           }
                                 success:^(id response) {
//                                     NSString * orderId = [NSString stringWithFormat:@"%@", response[@"order"][@"id"]];
                                     
                                     [WeAppDelegate updateFavorDoctorList];
                                     
                                     WeSelectPayViewController *payview=[[WeSelectPayViewController alloc]init];
                                     payview.order=response[@"order"];
                                     payview.message=@"您已成功发起加号预诊申请";
                                     
                                     [self.navigationController pushViewController:payview animated:YES];
//
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     [[[UIAlertView alloc] initWithTitle:@"加号失败" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                     [sys_pendingView stopAnimating];
                                 }];
}

@end
