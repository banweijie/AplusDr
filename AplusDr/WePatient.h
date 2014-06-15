//
//  WePatient.h
//  We_Doc
//
//  Created by WeDoctor on 14-5-19.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeUser.h"
#import "YJRSqlite.h"

@interface WePatient : NSObject

// 用户信息
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * userPhone;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * avatarPath;

// 病人信息
@property (nonatomic, strong) NSString * allergic;
@property (nonatomic, strong) NSString * allergicHistory;
@property (nonatomic, strong) NSString * bloodRh;
@property (nonatomic, strong) NSString * bloodType;
@property (nonatomic, strong) NSString * bornMonth;
@property (nonatomic, strong) NSString * bornYear;
@property (nonatomic, strong) NSString * drinking;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong) NSString * idNum;
@property (nonatomic, strong) NSString * job;
@property (nonatomic, strong) NSString * smoking;
@property (nonatomic, strong) NSString * trueName;

- (WePatient *)initWithNSDictionary:(NSDictionary *)info;
- (void)setWithNSDictionary:(NSDictionary *)info;

@end
