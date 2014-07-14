//
//  WeCsrCosViewController.h
//  AplusDr
//
//  Created by WeDoctor on 14-5-12.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeViewController.h"
#import "WeAppDelegate.h"
#import "WeCsrCosSelGenViewController.h"

#import "AlixLibService.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"

@interface WeCsrCosViewController :  WeViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property(strong, nonatomic) NSString * pushType;
@property(strong, nonatomic) WeDoctor * currentDoctor;

@end