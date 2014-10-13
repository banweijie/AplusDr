//
//  WeCahIdSelfViewController.h
//  AplusDr
//
//  Created by ejren on 14-10-13.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppDelegate.h"
#import "WeCahCahViewController.h"
#import "WeCahExaViewController.h"
#import "WeNavViewController.h"
#import "WeCahCahViewController.h"

@interface WeCahIdSelfViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong) NSString * rmId;
@end
