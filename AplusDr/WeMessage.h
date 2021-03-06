//
//  WeMessage.h
//  AplusDr
//
//  Created by WeDoctor on 14-5-18.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface WeMessage : NSObject

@property(strong, nonatomic) NSString * messageId;
@property(strong, nonatomic) NSString * messageType;
@property(strong, nonatomic) NSString * receiverId;
@property(strong, nonatomic) NSString * senderId;
@property(strong, nonatomic) NSString * content;
@property(nonatomic) long long time;

@property(nonatomic) BOOL viewed;
@property(nonatomic) BOOL loading;
@property(nonatomic) BOOL sending;
@property(nonatomic) BOOL failed;
@property(strong, nonatomic) UIImage * detImageContent;

@property(strong, nonatomic) UIImage * imageContent;
@property(strong, nonatomic) NSData * audioContent;

- (WeMessage *)initWithNSDictionary:(NSDictionary *)info;
- (void)setWithNSDictionary:(NSDictionary *)info;
- (NSString *)stringValue;

@end
