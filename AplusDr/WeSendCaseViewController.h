//
//  WeSendCaseViewController.h
//  AplusDr
//
//  Created by WeDoctor on 14-8-8.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppDelegate.h"
#import "WeCahCahViewController.h"
#import "WeCahAddCahViewController.h"
#import "WeCahAddExaViewController.h"
#import "WeCahExaViewController.h"
#import "WeNavViewController.h"
#import "WeCahCahViewController.h"

@interface WeSendCaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong) WeFavorDoctor * currentDoctor;

@end
