//
//  WeCahAddExaViewController.h
//  AplusDr
//
//  Created by WeDoctor on 14-5-25.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppDelegate.h"
#import "WeCahExaViewController.h"

@interface WeCahAddExaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property(nonatomic, strong) UIViewController * lastViewController;
@property(nonatomic, strong) UIViewController * llViewController;
@property(nonatomic, strong) NSString * primaryTypeKey;
@property(nonatomic, strong) NSString * secondaryTypeId;

@end
