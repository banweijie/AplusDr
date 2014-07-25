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
@property(strong, nonatomic) NSString * workPeriod;
@property(strong, nonatomic) NSString * notice;
@property(strong, nonatomic) NSString * groupIntro;
@property(strong, nonatomic) NSString * consultPrice;
@property(strong, nonatomic) NSString * degree;
@property(strong, nonatomic) NSString * email;
@property(strong, nonatomic) NSString * gender;
@property(strong, nonatomic) NSString * maxResponseGap;
@property(strong, nonatomic) NSString * plusPrice;
@property(strong, nonatomic) NSString * languages;

@property(strong, nonatomic) NSString * currentFundingId;
@property(strong, nonatomic) NSString * currentFundingName;
@property(strong, nonatomic) NSString * currentFundingType;
@property(strong, nonatomic) NSString * currentFundingSupportCount;
@property(strong, nonatomic) NSString * currentFundingLikeCount;
@property(strong, nonatomic) NSString * currentFundingSum;
@property(strong, nonatomic) NSString * currentFundingPoster;
@property(strong, nonatomic) NSString * currentFundingEndTime;

- (WeDoctor *)initWithNSDictionary:(NSDictionary *)info;
- (void)setWithNSDictionary:(NSDictionary *)info;

@end
