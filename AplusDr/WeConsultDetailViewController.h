//
//  WeConsultDetailViewController.h
//  We_Doc
//
//  Created by WeDoctor on 14-7-14.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppDelegate.h"

@interface WeConsultDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSString * consultId;
@property(nonatomic, strong) WeFavorDoctor * currentDoctor;

@end
