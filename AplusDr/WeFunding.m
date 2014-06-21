//
//  WeFunding.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-21.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFunding.h"

@implementation WeFunding

@synthesize initiatorId;
@synthesize status;
@synthesize startTime;
@synthesize endTime;
@synthesize type;
@synthesize title;
@synthesize subTitle;
@synthesize poster;
@synthesize poster2;
@synthesize introduction;
@synthesize goal;
@synthesize days;
@synthesize video;
@synthesize description;
@synthesize levels;
@synthesize sum;
@synthesize likeCount;
@synthesize supportCount;

- (WeFunding *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    // 提取信息
    self.initiatorId = [NSString stringWithFormat:@"%@", info[@"initiatorId"]];
    self.status = [NSString stringWithFormat:@"%@", info[@"status"]];
    self.startTime = [NSString stringWithFormat:@"%@", info[@"startTime"]];
    self.endTime = [NSString stringWithFormat:@"%@", info[@"endTime"]];
    self.type = [NSString stringWithFormat:@"%@", info[@"type"]];
    self.title = [NSString stringWithFormat:@"%@", info[@"title"]];
    self.subTitle = [NSString stringWithFormat:@"%@", info[@"subTitle"]];
    self.poster = [NSString stringWithFormat:@"%@", info[@"poster"]];
    self.poster2 = [NSString stringWithFormat:@"%@", info[@"poster2"]];
    self.introduction = [NSString stringWithFormat:@"%@", info[@"introduction"]];
    self.goal = [NSString stringWithFormat:@"%@", info[@"goal"]];
    self.days = [NSString stringWithFormat:@"%@", info[@"days"]];
    self.video = [NSString stringWithFormat:@"%@", info[@"video"]];
    self.description = [NSString stringWithFormat:@"%@", info[@"description"]];
    self.sum = [NSString stringWithFormat:@"%@", info[@"sum"]];
    self.likeCount = [NSString stringWithFormat:@"%@", info[@"likeCount"]];
    self.supportCount = [NSString stringWithFormat:@"%@", info[@"supportCount"]];
}

@end
