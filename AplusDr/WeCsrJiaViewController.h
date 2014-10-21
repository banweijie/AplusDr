//
//  WeCsrJiaViewController.h
//  AplusDr
//
//  Created by WeDoctor on 14-5-17.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppDelegate.h"
#import "WeInfoedButton.h"
#import "WeCsrJiaChooseTimeViewController.h"
#import "WeSentenceModifyViewController.h"
#import "WeGenderPickerViewController.h"
#import "WeSelectRecordersViewController.h"

@interface WeCsrJiaViewController : UIViewController <WePaymentCallback, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,WeSelectRecordersViewDelegrate>

@property(strong, nonatomic) WeDoctor * currentDoctor;

@end
