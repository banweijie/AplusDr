//
//  WeFunDetViewController.h
//  AplusDr
//
//  Created by WeDoctor on 14-6-21.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppDelegate.h"
#import "WeFunding.h"

@interface WeFunDetViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) WeFunding * currentFunding;

@end
