//
//  WePickerSelectView.h
//  AplusDr
//
//  Created by 袁锐 on 14-9-23.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerSelectDelete <NSObject>

-(void)SelectDateInPicker:(NSString *)time;
-(void)SelectCancelButton:(UIButton *)but;

@end

@interface WePickerSelectView : UIView
{
    UIDatePicker * ssview0_picker;
}
@property(nonatomic,retain)id<PickerSelectDelete> delegrate;

@end
