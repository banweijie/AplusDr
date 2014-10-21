//
//  WeSelectRecordersViewController.h
//  AplusDr
//
//  Created by ejren on 14-10-21.
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

@protocol WeSelectRecordersViewDelegrate <NSObject>

-(void)selectRecorders:(NSString *)rec examation:(NSString *)exa;

@end

@interface WeSelectRecordersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate>


@property(nonatomic,assign)id <WeSelectRecordersViewDelegrate>delegrate;

@end
