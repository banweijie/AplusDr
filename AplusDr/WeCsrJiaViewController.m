//
//  WeCsrJiaViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-17.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCsrJiaViewController.h"

@interface WeCsrJiaViewController () {
    UIView * sys_explaination_view;
    UILabel * sys_explaination_label;
    UITableView * sys_tableView;
    UIScrollView * sys_calenderView;
    UIButton * lastMonth;
    UIButton * nextMonth;
    
    NSInteger centerYear;
    NSInteger centerMonth;
    NSMutableArray * calenderViews;
}
#define cacheWidth 5
@end

@implementation WeCsrJiaViewController

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
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) return sys_calenderView.frame.size.height;
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
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    //if (section == 1) return 30;
    if (section == 0) return 60;
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 100;
    return 10;
}
-(UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section{
    if (section == 0) return sys_explaination_view;
    return nil;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return 4;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    if (section == 1) return [doctorViewing.workPeriod length] / 4;
    if (section == 2) return 1;
    if (section == 3) return 1;
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.contentView.backgroundColor = We_background_cell_general;
        
        cell.textLabel.text = @"加号预诊费";
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元/次", doctorViewing.plusPrice];
        cell.detailTextLabel.font = We_font_textfield_zh_cn;
        cell.detailTextLabel.textColor = We_foreground_black_general;
    }
    if (indexPath.section == 1) {
        cell.contentView.backgroundColor = We_background_cell_general;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [WeAppDelegate transitionDayOfWeekFromChar:[doctorViewing.workPeriod substringWithRange:NSMakeRange(4 * indexPath.row + 1, 1)]], [WeAppDelegate transitionPeriodOfDayFromChar:[doctorViewing.workPeriod substringWithRange:NSMakeRange(4 * indexPath.row + 2, 1)]]];
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        cell.detailTextLabel.text = [WeAppDelegate transitionTypeOfPeriodFromChar:[doctorViewing.workPeriod substringWithRange:NSMakeRange(4 * indexPath.row + 3, 1)]];
        cell.detailTextLabel.font = We_font_textfield_zh_cn;
        cell.detailTextLabel.textColor = We_foreground_gray_general;
    }
    if (indexPath.section == 2) {
        [cell.contentView addSubview:sys_calenderView];
        [cell.contentView addSubview:nextMonth];
        [cell.contentView addSubview:lastMonth];
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

- (UIView *)newCalenderAtBias:(NSInteger)Bias withFrame:(CGRect)frame {
    int month = centerMonth;
    int year = centerYear;
    month = month + Bias;
    while (month < 0) {
        month += 12; year --;
    }
    while (month > 12) {
        month -= 12; year ++;
    }
    UIView * newCalenderView = [[UIView alloc] initWithFrame:frame];
    UILabel * monthRepresent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    monthRepresent.text = [NSString stringWithFormat:@"%d年%d月", year, month];
    [newCalenderView addSubview:monthRepresent];
    return newCalenderView;
}

- (void)resetCenter {
    int Bias = cacheWidth / 2 - sys_calenderView.contentOffset.x / sys_calenderView.frame.size.width;
    NSMutableArray * newCalenderViews;
    for (int i = 0; i < cacheWidth; i++) {
        int j = (i + Bias + cacheWidth) % cacheWidth;
        if (i + Bias < 0) {
            calenderViews[i] = [self newCalenderAtBias:i + cacheWidth - cacheWidth / 2 withFrame:((UIView *)calenderViews[i]).frame];
        }
        else if (i + Bias >= cacheWidth) {
            calenderViews[i] = [self newCalenderAtBias:i - cacheWidth / 2 - cacheWidth withFrame:((UIView *)calenderViews[i]).frame];
        }
        UIView * tmp = calenderViews[i];
        CGRect tmpRect = tmp.frame;
        tmpRect.origin.x += (j - i) * sys_calenderView.frame.size.width;
        tmp.frame = tmpRect;
        newCalenderViews[j] = tmp;
    }
    calenderViews = newCalenderViews;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"!!!!!!!!!!");
    [self resetCenter];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem * user_save = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(press:)];
    self.navigationItem.leftBarButtonItem = user_save;
    
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
    
    
    // Calender
    NSDate * date = [NSDate date];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents * now = [calendar components:unitFlags fromDate:date];
    
    centerYear = [now year];
    centerMonth = [now month];
    
    sys_calenderView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    sys_calenderView.contentSize = CGSizeMake(320 * 5, 150);
    [sys_calenderView scrollRectToVisible:CGRectMake(0, 0, 320, 150) animated:NO];
    for (int i = 0; i < cacheWidth; i++) calenderViews[i] = [self newCalenderAtBias:i - cacheWidth / 2 withFrame:CGRectMake(0, 320 * i, 320, 150)];
    for (int i = 0; i < cacheWidth; i++) [sys_calenderView addSubview:calenderViews[i]];
    sys_calenderView.pagingEnabled = YES;
    
    //[self resetCenter];
    
    lastMonth = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    lastMonth.frame = CGRectMake(0, 0, 45, 45);
    [lastMonth setTitle:@"lastMonth" forState:UIControlStateNormal];
    lastMonth.tintColor = We_foreground_gray_general;
    
    nextMonth = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextMonth.frame = CGRectMake(275, 0, 45, 45);
    [nextMonth setTitle:@"nextMonth" forState:UIControlStateNormal];
    nextMonth.tintColor = We_foreground_gray_general;
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
