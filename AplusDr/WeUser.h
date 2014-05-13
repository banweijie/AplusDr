//
//  WeUser.h
//  AplusDr
//
//  Created by WeDoctor on 14-5-14.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeUser : NSObject

@property(strong, nonatomic) NSString * userId;
@property(strong, nonatomic) UIImage * avatar;

- (id)init;
- (id)initWithUserId:(NSString *)_userId;
@end
