//
//  YJRSqlite.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-14.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "YJRSqlite.h"

@implementation YJRSqlite

+ (void)init {
    globalHelper = [LKDBHelper getUsingLKDBHelper];
    [globalHelper createTableWithModelClass:[]];
}

@end
