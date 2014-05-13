//
//  WeUser.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-14.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeUser.h"

@implementation WeUser

@synthesize avatar;
@synthesize avatarPath;
@synthesize userId;
@synthesize userName;
@synthesize userPhone;

- (id)init {
    userId = @"NotLogined";
    avatar = [UIImage imageNamed:@"defaultAvatar"];
    avatarPath = @"";
    return self;
}

- (id)initWithUserId:(NSString *)_userId {
    self.userId = _userId;
    return self;
}
@end
