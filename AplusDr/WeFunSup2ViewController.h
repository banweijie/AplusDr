//
//  WeFunSup2ViewController.h
//  AplusDr
//
//  Created by WeDoctor on 14-6-23.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeFundingLevel.h"
#import "WeAppDelegate.h"
#import "WeSentenceModifyViewController.h"
#import "WeParagraphModifyViewController.h"

@interface WeFunSup2ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, WePaymentCallback>

@property(nonatomic, strong) WeFundingLevel * currentLevel;
@property(nonatomic, strong) WeFunding * currentFunding;
@end
