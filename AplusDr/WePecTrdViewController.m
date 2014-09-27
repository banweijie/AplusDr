//
//  WePecTrdViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-7-15.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WePecTrdViewController.h"

@interface WePecTrdViewController () {
    // 页面元素三人组
    UIActivityIndicatorView * sys_pendingView;
    UITableView * sys_tableView;
    UIButton * refreshButton;
    
    // 模型
    WeOrder * currentOrder;
    
    WeFundingSupport * currentSupport;//众筹
    
    WeConsult * currentConsult;//咨询
    
    WeJiahao * currentJiahao;//加号
    NSDictionary *orderDic;
    
}

@end

@implementation WePecTrdViewController

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section == 2 && path.row == 0) {
        WeSelectPayViewController *payview=[[WeSelectPayViewController alloc]init];
        payview.order=orderDic;
        if ([currentOrder.type isEqualToString:@"C"])
        {
            payview.message=@"您已成功发起咨询申请";
        }
        else if ([currentOrder.type isEqualToString:@"F"])
        {
            
             payview.message=@"感谢您的支持";
            
        }
        else if ([currentOrder.type isEqualToString:@"J"])
        {
             payview.message=@"您已成功发起加号预诊申请";
        }
        else if ([currentOrder.type isEqualToString:@"T"])
        {
             payview.message=@"您已成功发起在线咨询申请";
        }
        
        [self.navigationController pushViewController:payview animated:YES];


    }
    if (path.section == 2 && path.row == 1) {
        if ([currentOrder.status isEqualToString:@"W"]) {
            [self api_patient_cancelOrder];
        }
    }
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) return tv.rowHeight * 2;
    return [tv rowHeight];
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
// 询问每个段落的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tv] - 1) {
        return 1 + self.tabBarController.tabBar.frame.size.height;
    }
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
    if (currentOrder == nil) return 0;
    return 3;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    if (section == 1)
    {
        if ([currentOrder.type isEqualToString:@"C"]) {
            return 5;
        }
        return 1;
    }
    if (section == 2) {
        if ([currentOrder.status isEqualToString:@"W"]) return 2;
//        if ([currentOrder.status isEqualToString:@"P"]) return 1;
        return 0;
    }
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
    [cell.textLabel setFont:We_font_textfield_zh_cn];
    
    
    if (indexPath.section==0 && indexPath.row==0) {
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
        lab.font=We_font_textfield_large_zh_cn;
        lab.text=@"订单号:";
        [cell.contentView addSubview:lab];
        
        UILabel *num=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 260, 20)];
        num.font=We_font_textfield_zh_cn;
        num.text=currentOrder.orderId;
//            num.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:num];
        
        UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(20, 35, 100, 20)];
        lab1.font=We_font_textfield_large_zh_cn;
        lab1.text=@"金  额:";
        [cell.contentView addSubview:lab1];
        
        UILabel *num1=[[UILabel alloc]initWithFrame:CGRectMake(100, 35, 260, 20)];
        num1.font=We_font_textfield_zh_cn;
        num1.text=[NSString stringWithFormat:@"¥ %.1f",currentOrder.amount];
        //            num.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:num1];
        
        
        UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(20, 60, 100, 20)];
        lab2.font=We_font_textfield_large_zh_cn;
        lab2.text=@"状  态:";
        [cell.contentView addSubview:lab2];
        
        UILabel *num2=[[UILabel alloc]initWithFrame:CGRectMake(100, 60, 260, 20)];
        num2.font=We_font_textfield_zh_cn;
        
        if ([currentOrder.status isEqualToString:@"W"]) {
            num2.text=@"等待支付";
        }
        else if ([currentOrder.status isEqualToString:@"P"])
        {
            num2.text=@"支付成功";
        }
        else
        {
            num2.text=@"交易取消";
        }
        [cell.contentView addSubview:num2];
    }
    
    if (indexPath.section==1) {
        
        if ([currentOrder.type isEqualToString:@"C"])
        {
            if (indexPath.row==0) {
                cell.textLabel.text=@"咨询申请信息";
            }
            
            if (indexPath.row==1) {
                if ([currentConsult.gender isEqualToString:@"M"]) {
                    cell.textLabel.text=@"性别：男";
                }
                else
                {
                    cell.textLabel.text=@"性别：女";
                }
            }
            if (indexPath.row==2) {
                cell.textLabel.text=[NSString stringWithFormat:@"年龄：%@ ",currentConsult.age];
            }
            if (indexPath.row==3) {
                if (currentConsult.emergent) {
                    cell.textLabel.text=@"是否加急：是";
                }
                else
                {
                    cell.textLabel.text=@"是否加急：否";
                }
            }
            if (indexPath.row==4) {
                if ([currentConsult.description isEqualToString:@""]) {
                    cell.textLabel.text=@"详细描述：无";
                }
                else
                {
                    cell.textLabel.text=[NSString stringWithFormat:@"详细描述：%@",currentConsult.description];
                }
            }
        }
        else if ([currentOrder.type isEqualToString:@"F"])
        {
            if (indexPath.row==0) {
                cell.textLabel.text=@"众筹支持";
            }
        }
        else if ([currentOrder.type isEqualToString:@"J"])
        {
            if (indexPath.row==0) {
                cell.textLabel.text=@"加号预诊申请信息";
            }
        }
        else if ([currentOrder.type isEqualToString:@"T"])
        {
            if (indexPath.row==0) {
                cell.textLabel.text=@"众筹支付咨询申请信息";
            }
        }
        
    }
    
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        if ([currentOrder.status isEqualToString:@"W"]) {
            [cell setBackgroundColor:We_background_red_general];
            [cell.textLabel setText:@"继续支付"];
            [cell.textLabel setTextColor:We_foreground_white_general];
        }
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        if ([currentOrder.status isEqualToString:@"W"]) {
            [cell.textLabel setText:@"取消订单"];
            [cell.textLabel setTextColor:We_foreground_red_general];
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
    
    orderDic=[NSDictionary dictionary];
    // 标题
    self.navigationItem.title = @"交易详情";
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView.layer setCornerRadius:10];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
    // 刷新按钮
    refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    refreshButton.frame = self.view.frame;
    [refreshButton setTitle:@"获取订单记录详情失败，点击刷新" forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshButton_onPress) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTintColor:We_foreground_red_general];
    [self.view addSubview:refreshButton];
    
    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sys_tableView];
    
    // 访问获取众筹详情列表
    [self api_patient_viewOrder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self api_patient_viewOrder];
}

#pragma mark - callbacks

- (void)refreshButton_onPress {
    [self api_patient_viewOrder];
}

-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                NSLog(@"success!");
                [self paymentHasBeenPayed];
                //验证签名成功，交易结果无篡改
			}
        }
        else
        {
            NSLog(@"fail!");
            //交易失败
        }
    }
    else
    {
        NSLog(@"fail!");
        //失败
    }
    
}

- (void)paymentHasBeenPayed {
    currentOrder.status = @"P";
    [sys_tableView reloadData];
}


#pragma mark - apis
- (void)api_patient_viewOrder {
    [sys_pendingView startAnimating];
    [refreshButton setHidden:YES];
    [sys_tableView setHidden:YES];
    
    [WeAppDelegate postToServerWithField:@"patient" action:@"viewOrder"
                              parameters:@{
                                           @"orderId":self.currentOrderId
                                           }
                                 success:^(id response) {
                                     orderDic=response;
                                     currentOrder = [[WeOrder alloc] initWithNSDictionary:response];
                                     if ([currentOrder.type isEqualToString:@"C"]) {
                                         currentConsult = [[WeConsult alloc] initWithNSDictionary:response[@"foreignObject"]];
                                         
                                     }
                                     else if ([currentOrder.type isEqualToString:@"F"]) {
                                         currentSupport = [[WeFundingSupport alloc] initWithNSDictionary:response[@"foreignObject"]];
//                                         MyLog(@"%@",currentSupport);
                                     }
                                     else if ([currentOrder.type isEqualToString:@"J"]) {
                                         currentJiahao = [[WeJiahao alloc] initWithNSDictionary:response[@"foreignObject"]];
//                                         MyLog(@"%@",currentJiahao);
                                     }
                                     [sys_tableView reloadData];
                                     [sys_tableView setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     NSLog(@"%@", errorMessage);
                                     [refreshButton setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }];
}

- (void)api_patient_cancelOrder {
    [sys_pendingView startAnimating];
    [refreshButton setHidden:YES];
    [sys_tableView setHidden:YES];
    
    [WeAppDelegate postToServerWithField:@"patient" action:@"cancelOrder"
                              parameters:@{
                                           @"orderId":self.currentOrderId
                                           }
                                 success:^(id response) {
                                     currentOrder.status = @"C";
                                     
                                     [sys_tableView reloadData];
                                     [sys_tableView setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     NSLog(@"%@", errorMessage);
                                     [refreshButton setHidden:NO];
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
