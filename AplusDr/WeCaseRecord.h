//
//  WeCaseRecord.h
//  AplusDr
//
//  Created by WeDoctor on 14-5-24.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeCaseRecord : NSObject

@property(strong, nonatomic) NSString * caseRecordId;
@property(strong, nonatomic) NSString * hospitalName;
@property(strong, nonatomic) NSString * diseaseName;
@property(strong, nonatomic) NSString * treatment;
@property(strong, nonatomic) NSMutableArray * examinations;
@property(strong, nonatomic) NSMutableArray * recordDrugs;

@property(nonatomic) long long date;

@end
