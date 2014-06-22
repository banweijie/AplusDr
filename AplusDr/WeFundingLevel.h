//
//  WeFundingLevel.h
//  AplusDr
//
//  Created by WeDoctor on 14-6-21.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeFundingLevel : NSObject

@property(nonatomic, strong) NSString * levelId;
@property(nonatomic, strong) NSString * money;
@property(nonatomic, strong) NSString * limit;
@property(nonatomic, strong) NSString * repay;
@property(nonatomic, strong) NSString * fundingId;
@property(nonatomic, strong) NSString * type;
@property(nonatomic, strong) NSString * way;
@property(nonatomic, strong) NSString * open;
@property(nonatomic, strong) NSString * needEmail;
@property(nonatomic, strong) NSString * needAddress;
@property(nonatomic, strong) NSString * needPhone;
@property(nonatomic, strong) NSString * needName;
@property(nonatomic, strong) NSString * needDescription;
@property(nonatomic, strong) NSString * sendRedPin;
@property(nonatomic, strong) NSString * sendBluePin;
@property(nonatomic, strong) NSString * supportCount;
@property(nonatomic, strong) NSMutableArray * supports;

- (WeFundingLevel *)initWithNSDictionary:(NSDictionary *)info;
- (void)setWithNSDictionary:(NSDictionary *)info;

@end
