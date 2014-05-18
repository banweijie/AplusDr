//
//  WeMessage.h
//  AplusDr
//
//  Created by WeDoctor on 14-5-18.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeMessage : NSObject

@property(strong, nonatomic) NSString * messageId;
@property(strong, nonatomic) NSString * messageType;
@property(strong, nonatomic) NSString * receiverId;
@property(strong, nonatomic) NSString * senderId;
@property(strong, nonatomic) NSString * viewed;
@property(strong, nonatomic) NSString * content;
@property(strong, nonatomic) NSString * time;

- (WeMessage *)initWithNSDictionary:(NSDictionary *)info;
- (void)setWithNSDictionary:(NSDictionary *)info;

@end
