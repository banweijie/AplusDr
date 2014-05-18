//
//  WeMessage.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-18.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeMessage.h"

@implementation WeMessage

@synthesize messageId;
@synthesize messageType;
@synthesize receiverId;
@synthesize senderId;
@synthesize viewed;
@synthesize content;
@synthesize time;


- (WeMessage *)initWithNSDictionary:(NSDictionary *)info {
    [self setMessageId:[NSString stringWithFormat:@"%@", info[@"id"]]];
    [self setMessageType:[NSString stringWithFormat:@"%@", info[@"type"]]];
    [self setReceiverId:[NSString stringWithFormat:@"%@", info[@"receiverId"]]];
    [self setSenderId:[NSString stringWithFormat:@"%@", info[@"senderId"]]];
    [self setViewed:[NSString stringWithFormat:@"%@", info[@"viewed"]]];
    [self setContent:[NSString stringWithFormat:@"%@", info[@"content"]]];
    [self setTime:[NSString stringWithFormat:@"%@", info[@"time"]]];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    [self setMessageId:[NSString stringWithFormat:@"%@", info[@"id"]]];
    [self setMessageType:[NSString stringWithFormat:@"%@", info[@"type"]]];
    [self setReceiverId:[NSString stringWithFormat:@"%@", info[@"receiverId"]]];
    [self setSenderId:[NSString stringWithFormat:@"%@", info[@"senderId"]]];
    [self setViewed:[NSString stringWithFormat:@"%@", info[@"viewed"]]];
    [self setContent:[NSString stringWithFormat:@"%@", info[@"content"]]];
    [self setTime:[NSString stringWithFormat:@"%@", info[@"time"]]];
}

@end
