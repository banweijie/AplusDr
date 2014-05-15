//
//  WeCsrAddViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-12.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCsrAddViewController.h"
#import "WeAppDelegate.h"
#import "PAImageView.h"

@interface WeCsrAddViewController () {
    UITableView * sys_tableView;
    NSArray * doctorList;
    UISearchBar * searchBar;
    UITextField * user_searchContent_input;
}

@end

@implementation WeCsrAddViewController

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
    we_doctorViewing = doctorList[path.section];
    [self performSegueWithIdentifier:@"CsrAdd_pushto_CsrDci" sender:self];
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) return tv.rowHeight * 1.5;
    else return tv.rowHeight;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    return 7;
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    return 1;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return [doctorList count];
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return 2;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    UILabel * l1;
    UILabel * l2;
    PAImageView *avatarView;
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    switch (indexPath.row) {
        case 0:
            cell.contentView.backgroundColor = We_background_cell_general;
            // l1 - user name
            l1 = [[UILabel alloc] initWithFrame:CGRectMake(75, 12, 240, 23)];
            l1.text = [NSString stringWithFormat:@"%@ %@", doctorList[indexPath.section][@"name"], we_codings[@"doctorCategory"][doctorList[indexPath.section][@"category"]][@"title"][doctorList[indexPath.section][@"title"]]];
            if ([l1.text isEqualToString:@""]) l1.text = @"尚未设置名称";
            l1.font = We_font_textfield_zh_cn;
            l1.textColor = We_foreground_black_general;
            [cell.contentView addSubview:l1];
            // l2 - lastMsg - content
            l2 = [[UILabel alloc] initWithFrame:CGRectMake(75, 33, 240, 23)];
            l2.text = [NSString stringWithFormat:@"%@ %@", doctorList[indexPath.section][@"hospital"][@"name"], doctorList[indexPath.row][@"section"][@"text"]];
            l2.textColor = We_foreground_gray_general;
            l2.font = We_font_textfield_small_zh_cn;
            [cell.contentView addSubview:l2];
            // avatar
            avatarView = [[PAImageView alloc]initWithFrame:CGRectMake(15, 9, 48, 48) backgroundProgressColor:[UIColor clearColor] progressColor:[UIColor lightGrayColor]];
            [avatarView setImageURL:yijiarenAvatarUrl(doctorList[indexPath.section][@"avatar"]) placeholder:nil successCompletion:nil];
            [cell.contentView addSubview:avatarView];
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"docinfo-crowdfunding"];
            cell.textLabel.text = @"众筹项目名称";
            cell.textLabel.font = We_font_textfield_small_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            cell.detailTextLabel.text = @"￥10,000已筹 / 52赞";
            cell.detailTextLabel.font = We_font_textfield_small_zh_cn;
            cell.detailTextLabel.textColor = We_foreground_gray_general;
        default:
            break;
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
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    [self refreshDoctorList:self];
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 64 + 85, 310, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - 64 - 85) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    sys_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:sys_tableView];
    
    UIImageView * barBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 85)];
    barBackground.image = [UIImage imageNamed:@"bar"];
    [self.view addSubview:barBackground];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 104, 320, 45)];
    searchBar.placeholder = @"搜索";
    //searchBar.barTintColor = [UIColor colorWithRed:225 / 255.0 green:224 / 255.0 blue:219 / 255.0 alpha:1.0];
    // transparency for UISearchBar
    searchBar.translucent = YES;
    searchBar.backgroundImage = [UIImage new];
    searchBar.scopeBarBackgroundImage = [UIImage new];
    //searchBar.layer.borderWidth = 0.5f;
    //searchBar.layer.borderColor = [UIColor colorWithRed:206 / 255.0 green:187 / 255.0 blue:181 / 255.0 alpha:1.0];
    //[searchBar.layer ]
    [searchBar setTranslucent:YES];// 设置是否透明
    //[searchBar setShowsCancelButton:YES animated:YES];

    /* UIImageView * searchImage = [[UIImageView alloc] initWithFrame:(5, 5, 16, 16)];
    searchImage.image = [UIImage imageNamed:<#(NSString *)#>]
    
    user_searchContent_input = [[UITextField alloc] initWithFrame:CGRectMake(10, 120, 300, 26)];
    [user_searchContent_input setLeftViewMode:UITextFieldViewModeAlways]
    user_searchContent_input.leftView =
    user_searchContent_input.backgroundColor = [UIColor whiteColor];
    user_searchContent_input.font = We_font_textfield_zh_cn;
    user_searchContent_input.clipsToBounds = YES;
    user_searchContent_input.layer.cornerRadius = 3.0f;
    [self.view addSubview:user_searchContent_input];*/
    
    //myView.backgroundColor = [UIColor clearColor];
    UIToolbar* bgToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 450)];
    bgToolbar.barStyle = UIBarStyleDefault;
    bgToolbar.backgroundColor = [UIColor colorWithRed:225 / 255.0 green:224 / 255.0 blue:219 / 255.0 alpha:1.0];
    [bgToolbar setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIToolbarPositionAny
                          barMetrics:UIBarMetricsDefault];
    //[self.view addSubview:bgToolbar];
    
    [self.view addSubview:searchBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshDoctorList:(id)sender {
    // Get patients
    NSDictionary * parameters = @{};
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:yijiarenUrl(@"patient", @"searchDoctors") parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
             NSString * errorMessage;
             
             NSString *result = [HTTPResponse objectForKey:@"result"];
             result = [NSString stringWithFormat:@"%@", result];
             if ([result isEqualToString:@"1"]) {
                 NSLog(@"%@", HTTPResponse[@"response"]);
                 doctorList = HTTPResponse[@"response"];
                 [sys_tableView reloadData];
                 return;
             }
             if ([result isEqualToString:@"2"]) {
                 NSDictionary *fields = [HTTPResponse objectForKey:@"fields"];
                 NSEnumerator *enumerator = [fields keyEnumerator];
                 id key;
                 while ((key = [enumerator nextObject])) {
                     NSString * tmp1 = [fields objectForKey:key];
                     if (tmp1 != NULL) errorMessage = tmp1;
                 }
             }
             if ([result isEqualToString:@"3"]) {
                 errorMessage = [HTTPResponse objectForKey:@"info"];
             }
             if ([result isEqualToString:@"4"]) {
                 errorMessage = [HTTPResponse objectForKey:@"info"];
             }
             UIAlertView *notPermitted = [[UIAlertView alloc]
                                          initWithTitle:@"获取保健医列表失败"
                                          message:errorMessage
                                          delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
             [notPermitted show];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             UIAlertView *notPermitted = [[UIAlertView alloc]
                                          initWithTitle:@"获取保健医列表失败"
                                          message:@"未能连接服务器，请重试"
                                          delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
             [notPermitted show];
         }
     ];
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
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}
@end
