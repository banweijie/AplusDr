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

@interface WeFunSup2ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) WeFundingLevel * currentLevel;

@end
