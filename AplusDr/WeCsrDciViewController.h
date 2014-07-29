//
//  WeCsrDciViewController.h
//  AplusDr
//
//  Created by WeDoctor on 14-5-12.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeCsrCosViewController.h"
#import "WeNavViewController.h"
#import "WeCsrJiaViewController.h"
#import "WeToolButton.h"

@interface WeCsrDciViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate>


@property(nonatomic, strong) WeDoctor * currentDoctor;
@property(nonatomic) bool forward;

@end
