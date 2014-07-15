//
//  WePecTrdViewController.h
//  AplusDr
//
//  Created by WeDoctor on 14-7-15.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppDelegate.h"

// Alipay
#import "AlixLibService.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"

@interface WePecTrdViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, WePaymentCallback>

@property(nonatomic, strong) NSString * currentOrderId;

@end
