//
//  WeFunMySup2ViewController.h
//  AplusDr
//
//  Created by WeDoctor on 14-6-24.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppDelegate.h"
#import "WeFundingSupport.h"
#import "WeFundingLevel.h"
#import "WeFunding.h"

@interface WeFunMySup2ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSString * currentSupportId;

@end
