//
//  WeSharePayViewController.m
//  AplusDr
//
//  Created by 袁锐 on 14-9-26.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeSharePayViewController.h"
#import "WeAppDelegate.h"

#import <ShareSDK/ShareSDK.h>
#import <AGCommon/UIDevice+Common.h>
#import "UIView+Common.h"
#import "WXApi.h"

@interface WeSharePayViewController ()
{
    WeFunding *funding;
    
    NSString *amount;
}
@end

@implementation WeSharePayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=We_background_cell_general;
    
    //We_background_red_tableviewcell    字体颜色
    
    UILabel *labe=[[UILabel alloc]initWithFrame:CGRectMake(30, 60, 260, 80)];
    labe.textColor=We_background_red_tableviewcell;
    labe.font=[UIFont boldSystemFontOfSize:40];
    labe.textAlignment=NSTextAlignmentCenter;
    labe.text=@"支付成功";
    [self.view addSubview:labe];
    
    
    for (int i=0; i<4; i++) {
        UILabel *labe1=[[UILabel alloc]initWithFrame:CGRectMake(50, 130+30*i, 260, 30)];
        labe1.textColor=We_background_red_tableviewcell;
        labe1.font=[UIFont fontWithName:@"Heiti SC" size:20];
        [self.view addSubview:labe1];
        switch (i) {
            case 0:
                labe1.text=@"想成为大家眼中的焦点？";
                break;
            case 1:
                labe1.text=@"支持众筹项目";
                break;
            case 2:
                labe1.text=@"分享到朋友圈";
                break;
            case 3:
                labe1.text=@"让你的小伙伴也加进来吧！";
                break;
            default:
                break;
        }
    }
    
//    250
    UIImageView *ima=[[UIImageView alloc]initWithFrame:CGRectMake(50, 240, 220, 220)];
    ima.image=[UIImage imageNamed:@"successpay"];
    [self.view addSubview:ima];
    
    UIBarButtonItem * shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"crowdfunding-detail-share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButton_onPress:)];
    self.navigationItem.rightBarButtonItem = shareButton;
    UIBarButtonItem * lef = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftButton_onPress)];
    self.navigationItem.leftBarButtonItem = lef;

}
-(void)leftButton_onPress
{
    [self.navigationController popToViewController:self.navigationController.childViewControllers[2] animated:YES];
}
-(void)setOrderId:(NSString *)orderId
{
    if (_orderId!=orderId) {
        _orderId=orderId;
        [self api_patient_finishOrder];
    }
}
-(void)setFundingId:(NSString *)fundingId
{
    if (_fundingId!=fundingId) {
        _fundingId=fundingId;
        [self api_patient_finishOrder1:_fundingId];
    }

}
- (void)api_patient_finishOrder {
//    /http://test.ejren.com/patient/viewOrder.action?orderId=141180200649800098
    [WeAppDelegate postToServerWithField:@"patient" action:@"viewOrder"
                              parameters:@{
                                           @"orderId":_orderId
                                           }
                                 success:^(NSDictionary * response) {
                                     
//                                     response[@"foreignObject"][@"fundingLevel"][@"fundingId"];//获取到众筹详情
//                                     MyLog(@"====%@",response);
                                     [self api_patient_finishOrder1:response[@"foreignObject"][@"fundingLevel"][@"fundingId"]];
                                     
                                     amount=response[@"amount"];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     UIAlertView * notPermitted = [[UIAlertView alloc]
                                                                   initWithTitle:@"查询失败"
                                                                   message:errorMessage
                                                                   delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                                     [notPermitted show];
                                 }];
}
- (void)api_patient_finishOrder1:(NSString *)forid {
    [WeAppDelegate postToServerWithField:@"data" action:@"viewFunding"
                              parameters:@{
                                           @"fundingId":forid
                                           }
                                 success:^(NSDictionary * response) {
                                     
                                     WeFunding *fund=[[WeFunding alloc]initWithNSDictionary:response];
                                     
                                     funding=fund;
                                 }
                                 failure:^(NSString * errorMessage) {
                                     UIAlertView * notPermitted = [[UIAlertView alloc]
                                                                   initWithTitle:@"查询失败"
                                                                   message:errorMessage
                                                                   delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                                     [notPermitted show];
                                 }];
}

-(void)shareButton_onPress:(UIBarButtonItem *)sender
{
    //    MyLog(@"点击分享---图片：%@  标题：%@-%@  地址:http://test.ejren.com/crowdfunding.jsp?fundingId=%@ 描述:%@",yijiarenImageUrl(self.currentFunding.poster2),self.currentFunding.title ,self.currentFunding.subTitle,self.currentFunding.fundingId,self.currentFunding.introduction);
    
    
    
    id<ISSContainer> container = [ShareSDK container];
    
    [container setIPhoneContainerWithViewController:self];
    
    //分享的平台类型数组
    NSArray *shareList = [ShareSDK getShareListWithType:
                          
                          ShareTypeWeixiSession ,
                          ShareTypeWeixiTimeline,
                          nil];
    
    
    
    
    id<ISSContent> publishContent = nil;
    
    NSString *contentString = funding.introduction;
    NSString *titleString   =[NSString stringWithFormat:@"我在医家仁用%@元支持了该众筹项目,你也赶紧来吧！",amount];
    NSString *titleString1  =[NSString stringWithFormat:@"我在医家仁用%@元支持了“%@”,你也赶紧来吧！",amount,funding.title];

    if (amount==nil) {
        titleString   =[NSString stringWithFormat:@"我在医家仁支持了该众筹项目,你也赶紧来吧！"];
        titleString1  =[NSString stringWithFormat:@"我在医家仁支持了“%@”,你也赶紧来吧！",funding.title];
    }
    //[NSString stringWithFormat:@"%@-%@", funding.title ,funding.subTitle];
    NSString *urlString     = yijiarenShareURL(funding.fundingId);
    NSString *description   = @"Sample";
    
    
    //TODO: 4. 正确选择分享内容的 mediaType 以及填写参数，就能分享到微信
    publishContent = [ShareSDK content:contentString
                        defaultContent:@""
                                 image:[ShareSDK imageWithUrl:yijiarenImageUrl(funding.poster2)]
                                 title:titleString
                                   url:urlString
                           description:description
                             mediaType:SSPublishContentMediaTypeNews];
    //分享给好友
    [publishContent addWeixinSessionUnitWithType:@(2) content:titleString title:[NSString stringWithFormat:@"%@:%@", funding.title ,funding.subTitle] url:urlString image:[ShareSDK imageWithUrl:yijiarenImageUrl(funding.poster2)] musicFileUrl:nil extInfo:nil fileData:nil emoticonData:nil];
    //分享给朋友圈
    [publishContent addWeixinTimelineUnitWithType:@(2) content:contentString title:titleString1 url:urlString image:[ShareSDK imageWithUrl:yijiarenImageUrl(funding.poster2)] musicFileUrl:nil extInfo:nil fileData:nil emoticonData:nil];
    
    [ShareSDK setInterfaceOrientationMask:SSInterfaceOrientationMaskPortrait];

    id<ISSShareOptions> shareOptions =
    [ShareSDK defaultShareOptionsWithTitle:@""
                           oneKeyShareList:shareList
                        cameraButtonHidden:YES
                       mentionButtonHidden:NO
                         topicButtonHidden:NO
                            qqButtonHidden:YES
                     wxSessionButtonHidden:YES
                    wxTimelineButtonHidden:YES
                      showKeyboardOnAppear:NO
                         shareViewDelegate:nil
                       friendsViewDelegate:nil
                     picViewerViewDelegate:nil];
    
    
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:NO
                       authOptions:nil
                      shareOptions:shareOptions
                            result:^(ShareType type,
                                     SSResponseState state,
                                     id<ISSPlatformShareInfo> statusInfo,
                                     id<ICMErrorInfo> error, BOOL end)
     {
         NSString *name = nil;
         switch (type)
         {
             case ShareTypeWeixiSession:
                 name = @"微信好友";
                 break;
                 
             case ShareTypeWeixiTimeline:
                 name = @"微信朋友圈";
                 break;
             default:
                 name = @"某个平台";
                 break;
         }
         
         NSString *notice = nil;
         if (state == SSPublishContentStateSuccess)
         {
             notice = [NSString stringWithFormat:@"分享到%@成功！", name];
             NSLog(@"%@",notice);
             
             UIAlertView *view =
             [[UIAlertView alloc] initWithTitle:@"提示"
                                        message:notice
                                       delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles: nil];
             [view show];
         }
         else if (state == SSPublishContentStateFail)
         {
             notice = [NSString stringWithFormat:@"分享到%@失败,错误码:%ld,错误描述:%@", name, (long)[error errorCode], [error errorDescription]];
             NSLog(@"%@",notice);
             
             UIAlertView *view =
             [[UIAlertView alloc] initWithTitle:@"提示"
                                        message:notice
                                       delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles: nil];
             [view show];
         }
     }];
    
}


@end
