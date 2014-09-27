//
//  WeSelectPayViewController.m
//  AplusDr
//
//  Created by 袁锐 on 14-9-21.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeSelectPayViewController.h"
#import "WeAppDelegate.h"

#import "WeSharePayViewController.h"

@interface WeSelectPayViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,WePaymentCallback>

{
    UITableView *sys_tableview;
    UITextField *money;
    
    UILabel *labe;//可用余额
    UIActivityIndicatorView * sys_pendingView;
    
    UILabel *labe1;//还需支付
    
    double mymoney;//我的余额
    
    double smoney;//需要支付
    
}
@end

@implementation WeSelectPayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // 标题
    [self.navigationItem setTitle:@"支付订单"];
    
     smoney=[_order[@"amount"] floatValue];
    
    //输入金额
    money=[[UITextField alloc]initWithFrame:CGRectMake(110, 0, 100, 40)];
    money.placeholder=@"输入金额";
    money.font = We_font_textfield_zh_cn;
    money.textColor = We_foreground_gray_general;
    money.delegate=self;
    
    //可用余额
    labe=[[UILabel alloc]initWithFrame:CGRectMake(210, 15, 110, 20)];
    labe.font = We_font_textfield_zh_cn;
    labe.textColor = We_foreground_gray_general;
    labe.text=@"(可用余额)";
    
    //还需支付
    labe1=[[UILabel alloc]initWithFrame:CGRectMake(110, 15, 200, 20)];
    labe1.font = We_font_textfield_zh_cn;
    labe1.textColor = We_foreground_gray_general;
    labe1.text=[NSString stringWithFormat:@"%.2f",smoney];
    
   
    
    // 表格
    sys_tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableview.backgroundColor=[UIColor clearColor];
    sys_tableview.dataSource=self;
    sys_tableview.delegate=self;
    sys_tableview.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:sys_tableview];
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-44-49-20)];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
    [self api_user_viewAccount];
    
    
}

#pragma mark tableviewDataSoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Identifi=@"cellidentifi";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identifi];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    cell.opaque = NO;
    
    cell.backgroundColor = We_background_cell_general;
    cell.textLabel.font = We_font_textfield_zh_cn;
    cell.textLabel.textColor = We_foreground_black_general;
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(110, 15, 200, 20)];
    lab.font = We_font_textfield_zh_cn;
    lab.textColor = We_foreground_gray_general;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=@"订单号";
            lab.text=[NSString stringWithFormat:@"%@",_order[@"id"]];
            [cell addSubview:lab];
            break;
        case 1:
            cell.textLabel.text=@"支付金额";
            lab.text=[NSString stringWithFormat:@"%.2f",[_order[@"amount"] floatValue]];
            [cell addSubview:lab];
            break;
        case 2:
            cell.textLabel.text=@"使用余额";
            [cell addSubview:money];
            [cell addSubview:labe];
            break;
        case 3:
            cell.textLabel.text=@"还需支付";
            
            
            [cell addSubview:labe1];
            break;
        case 4:
            cell.textLabel.text=@"支付方式";
           
            
            break;
        case 5:
            [cell setBackgroundColor:We_background_red_tableviewcell];
            [cell.textLabel setFont:We_font_textfield_large_zh_cn];
            [cell.textLabel setTextColor:We_foreground_white_general];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.textLabel setText:@"确认支付"];
            break;
        default:
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0 && indexPath.row==2) {
        [money becomeFirstResponder];
    }
    else
        [money resignFirstResponder];
    
    if (indexPath.section==0 && indexPath.row==5) {
        
        if ([labe1.text floatValue]!=0) {
            [self payMoney];
        }
        else
        {
            [self api_patient_finishOrder];
        }
    }
}
#pragma mark ----uitextfiledDelegrate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    double min=MIN(smoney, mymoney);
    NSMutableString * text=[NSMutableString stringWithString:textField.text];
    if([string isEqualToString:@""])
    {
        [text deleteCharactersInRange:range];
    }
    else
    {
        [text insertString:string atIndex:range.location];
    }
    NSString * regex = @"^(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){0,2})?$";
    //正则表达式，谓词判断
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:text];
    if (!(isMatch || [text isEqualToString:@""])) {
        return false;
    }
    
    double now= [text floatValue];//当前输入的金额
    
    if (now>=0 && now <=min) {
        
        labe1.text=[NSString stringWithFormat:@"%.2f",smoney-now];
    }
    else
    {
        return false;
    }
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    double now= [textField.text floatValue];//当前输入的金额
    
    if (now>0 && now <=mymoney) {
        if (now<=smoney) {
            labe1.text=[NSString stringWithFormat:@"%.2f",smoney-now];
        }
        else
        {
            labe1.text=@"0";
            money.text=[NSString stringWithFormat:@"%.2f",smoney];
        }
    }
    else
    {
        money.text=@"";
    }
   
}
#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [money resignFirstResponder];
}
//请求余额数据
- (void)api_user_viewAccount {
    [sys_pendingView startAnimating];
    [WeAppDelegate postToServerWithField:@"user" action:@"viewAccount"
                              parameters:@{
                                           }
                                 success:^(NSDictionary * response) {
                                     
                                     
                                    
                                    labe.text=[NSString stringWithFormat:@"(可用余额%@)",[WeAppDelegate toString:response[@"amount"]]];
                                     mymoney=[response[@"amount"] floatValue];
                                    
                                    
                                    [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     UIAlertView * notPermitted = [[UIAlertView alloc]
                                                                   initWithTitle:@"查询余额失败"
                                                                   message:errorMessage
                                                                   delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                                     [notPermitted show];
                                     [sys_pendingView stopAnimating];
                                 }];
}

//patient/finishOrder
//余额支付
- (void)api_patient_finishOrder {
    [sys_pendingView startAnimating];
     NSString * orderId = [NSString stringWithFormat:@"%@", _order[@"id"]];
    [WeAppDelegate postToServerWithField:@"patient" action:@"finishOrder"
                              parameters:@{
                                           @"orderId":orderId
                                           }
                                 success:^(NSDictionary * response) {
                                     
                                    
                                     [self paymentHasBeenPayed];
                                     
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     UIAlertView * notPermitted = [[UIAlertView alloc]
                                                                   initWithTitle:@"支付失败"
                                                                   message:errorMessage
                                                                   delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                                     [notPermitted show];
                                     [sys_pendingView stopAnimating];
                                 }];
}


//支付宝付款
-(void)payMoney
{
    NSString * orderId = [NSString stringWithFormat:@"%@", _order[@"id"]];
    
     AlixPayOrder * newOrder = [[AlixPayOrder alloc] init];
     newOrder.partner = PartnerID;
     newOrder.seller = SellerID;
     newOrder.tradeNO = orderId;
     newOrder.productName = @"众筹支持";
     newOrder.productDescription = @"众筹支持的描述";
     newOrder.amount = labe1.text;
     newOrder.notifyURL = yijiarenS;

     NSString * appScheme = @"AplusDr";
     NSString * orderInfo = [newOrder description];
     NSString * signedStr = [CreateRSADataSigner(PartnerPrivKey) signString:orderInfo];

     NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                              orderInfo, signedStr, @"RSA"];

     paymentCallback = self;
     [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
}


#pragma mark - callBacks
-(void)paymentHasBeenPayed {
   
//    MyLog(@"众筹项目ID号码：＝＝＝＝%@",_order);
//    MyLog(@"obj------------%@",_order[@"foreignObject"]);
    
    if ([_order[@"type"] isEqualToString:@"F"]) {
        WeSharePayViewController * sha=[[WeSharePayViewController alloc]init];
        sha.orderId=_order[@"id"];
        [self.navigationController pushViewController:sha animated:YES];
    }
    else
    {
        [self.navigationController popToViewController:self.navigationController.childViewControllers[1] animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"支付成功" message:_message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
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

@end
