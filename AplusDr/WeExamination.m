//
//  WeExamination.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-25.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeExamination.h"

@implementation WeExamination

- (WeExamination *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    // 提取信息
    self.type = [[WeTextCoding alloc] initWithNSDictionary:info[@"type"]];
    self.typeParent = [NSString stringWithFormat:@"%@", info[@"typeParent"]];
    self.date = [NSString stringWithFormat:@"%@", info[@"date"]];
    self.hospital = [NSString stringWithFormat:@"%@", info[@"hospital"]];
    self.result = [NSString stringWithFormat:@"%@", info[@"result"]];
}

@end
