//
//  WeDoctor.h
//  AplusDr
//
//  Created by WeDoctor on 14-5-14.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeUser.h"

@interface WeDoctor : WeUser

@property(strong, nonatomic) NSString * title;
@property(strong, nonatomic) NSString * category;
@property(strong, nonatomic) NSString * hospitalName;
@property(strong, nonatomic) NSString * sectionName;

@end
