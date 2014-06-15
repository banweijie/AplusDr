//
//  WePatient.m
//  We_Doc
//
//  Created by WeDoctor on 14-5-19.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WePatient.h"

@implementation WePatient

@synthesize userId;
@synthesize userPhone;
@synthesize userName;
@synthesize avatarPath;

@synthesize allergic;
@synthesize allergicHistory;
@synthesize bloodRh;
@synthesize bloodType;
@synthesize bornMonth;
@synthesize bornYear;
@synthesize drinking;
@synthesize gender;
@synthesize idNum;
@synthesize job;
@synthesize smoking;
@synthesize trueName;

- (WePatient *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    self.userId = [NSString stringWithFormat:@"%@", info[@"id"]];
    self.userPhone = [NSString stringWithFormat:@"%@", info[@"phone"]];
    self.userName= [NSString stringWithFormat:@"%@", info[@"name"]];
    self.avatarPath = [NSString stringWithFormat:@"%@", info[@"avatar"]];
    
    self.allergic = [NSString stringWithFormat:@"%@", info[@"allergic"]];
    self.allergicHistory = [NSString stringWithFormat:@"%@", info[@"allergicHistory"]];
    self.bloodRh = [NSString stringWithFormat:@"%@", info[@"bloodRh"]];
    self.bloodType = [NSString stringWithFormat:@"%@", info[@"bloodType"]];
    self.bornMonth = [NSString stringWithFormat:@"%@", info[@"bornMonth"]];
    self.bornYear = [NSString stringWithFormat:@"%@", info[@"bornYear"]];
    self.drinking = [NSString stringWithFormat:@"%@", info[@"drinking"]];
    self.gender = [NSString stringWithFormat:@"%@", info[@"gender"]];
    self.idNum = [NSString stringWithFormat:@"%@", info[@"idNum"]];
    self.job = [NSString stringWithFormat:@"%@", info[@"job"]];
    self.smoking = [NSString stringWithFormat:@"%@", info[@"smoking"]];
    self.trueName = [NSString stringWithFormat:@"%@", info[@"trueName"]];
}

+(NSString *)getTableName
{
    return @"patient";
}
@end
