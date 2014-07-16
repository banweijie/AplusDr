//
//  WeDoctor.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-14.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeDoctor.h"

@implementation WeDoctor

@synthesize title;
@synthesize category;
@synthesize hospitalName;
@synthesize sectionName;
@synthesize workPeriod;
@synthesize notice;
@synthesize groupIntro;
@synthesize consultPrice;
@synthesize degree;
@synthesize email;
@synthesize gender;
@synthesize maxResponseGap;
@synthesize plusPrice;
@synthesize currentFundingId;
@synthesize currentFundingLikeCount;
@synthesize currentFundingName;
@synthesize currentFundingSum;
@synthesize currentFundingSupportCount;
@synthesize currentFundingType;

- (WeDoctor *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    self.avatar = [UIImage imageNamed:@"defaultAvatar"];
    [self setHospitalName:[NSString stringWithFormat:@"%@", info[@"hospital"][@"text"]]];
    [self setSectionName:[NSString stringWithFormat:@"%@", info[@"section"][@"text"]]];
    [self setTitle:[NSString stringWithFormat:@"%@", info[@"title"]]];
    [self setCategory:[NSString stringWithFormat:@"%@", info[@"category"]]];
    [self setUserId:[NSString stringWithFormat:@"%@", info[@"id"]]];
    [self setUserName:[NSString stringWithFormat:@"%@", info[@"name"]]];
    [self setUserPhone:[NSString stringWithFormat:@"%@", info[@"phone"]]];
    [self setAvatarPath:[NSString stringWithFormat:@"%@", info[@"avatar"]]];
    [self setNotice:[NSString stringWithFormat:@"%@", info[@"notice"]]];
    [self setGroupIntro:[NSString stringWithFormat:@"%@", info[@"groupIntro"]]];
    [self setConsultPrice:[NSString stringWithFormat:@"%@", info[@"consultPrice"]]];
    [self setDegree:[NSString stringWithFormat:@"%@", info[@"degree"]]];
    [self setEmail:[NSString stringWithFormat:@"%@", info[@"email"]]];
    [self setGender:[NSString stringWithFormat:@"%@", info[@"gender"]]];
    [self setMaxResponseGap:[NSString stringWithFormat:@"%@", info[@"maxResponseGap"]]];
    [self setPlusPrice:[NSString stringWithFormat:@"%@", info[@"plusPrice"]]];
    [self setWorkPeriod:[NSString stringWithFormat:@"%@", info[@"workPeriod"]]];
    self.languages = [NSString stringWithFormat:@"%@", info[@"languages"]];
    
    if (![info[@"currentFunding"] isEqual:[NSNull null]]) {
        self.currentFundingId = [NSString stringWithFormat:@"%@", info[@"currentFunding"][@"id"]];
        self.currentFundingName = [NSString stringWithFormat:@"%@", info[@"currentFunding"][@"title"]];
        self.currentFundingType = [NSString stringWithFormat:@"%@", info[@"currentFunding"][@"type"]];
        self.currentFundingSupportCount = [NSString stringWithFormat:@"%@", info[@"currentFunding"][@"supportCount"]];
        self.currentFundingLikeCount = [NSString stringWithFormat:@"%@", info[@"currentFunding"][@"likeCount"]];
        self.currentFundingSum = [NSString stringWithFormat:@"%@", info[@"currentFunding"][@"sum"]];
    }
    else {
        self.currentFundingId = nil;
    }
}

@end
