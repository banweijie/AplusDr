//
//  WePaymentCallback.h
//  AplusDr
//
//  Created by WeDoctor on 14-7-15.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WePaymentCallback <NSObject>

@required

- (void)paymentHasBeenPayed;

@end
