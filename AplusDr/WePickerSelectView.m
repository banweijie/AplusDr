//
//  WePickerSelectView.m
//  AplusDr
//
//  Created by 袁锐 on 14-9-23.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WePickerSelectView.h"
#import "WeAppDelegate.h"


@implementation WePickerSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor whiteColor];
        // 添加检查结果产生的效应 - 取消按钮
        UIButton * ssview0_cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [ssview0_cancelButton setFrame:CGRectMake(0, 15, 80, 30)];
        [ssview0_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [ssview0_cancelButton setTintColor:We_foreground_black_general];
        [ssview0_cancelButton addTarget:self action:@selector(ssview0_shadowOrCancelButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:ssview0_cancelButton];
        
        // 添加检查结果产生的效应 - 标题
        UILabel * ssview0_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 160, 30)];
        [ssview0_titleLabel setText:@"选择时间"];
        [ssview0_titleLabel setTextColor:We_foreground_gray_general];
        [ssview0_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [ssview0_titleLabel setFont:We_font_textfield_zh_cn];
        [self addSubview:ssview0_titleLabel];
        
        // 添加检查结果产生的效应 - 第0条线
        UIView * ssview0_line0 = [[UIView alloc] initWithFrame:CGRectMake(20, 60, 280, 1)];
        [ssview0_line0 setBackgroundColor:[UIColor grayColor]];
        [ssview0_line0 setAlpha:0.5];
        [self addSubview:ssview0_line0];
        
        // 添加检查结果产生的效应 - 选择器
        ssview0_picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(40, 60, 240, 60)];
        ssview0_picker.datePickerMode=UIDatePickerModeDate;
        [self addSubview:ssview0_picker];
        
        // 添加检查结果产生的效应 - 第1条线
        UIView * ssview0_line1 = [[UIView alloc] initWithFrame:CGRectMake(20, 240, 280, 1)];
        [ssview0_line1 setBackgroundColor:[UIColor grayColor]];
        [ssview0_line1 setAlpha:0.5];
        [self addSubview:ssview0_line1];
        
        // 添加检查结果产生的效应 - 确认按钮
        UIButton * ssview0_submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [ssview0_submitButton setFrame:CGRectMake(25, 250, 270, 40)];
        [ssview0_submitButton setBackgroundColor:We_background_red_tableviewcell];
        [ssview0_submitButton setTintColor:We_foreground_white_general];
        [ssview0_submitButton setTitle:@"选择时间" forState:UIControlStateNormal];
        [ssview0_submitButton addTarget:self action:@selector(ssview0_submitButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:ssview0_submitButton];
    }
    return self;
}

-(void)ssview0_submitButton_onPress:(UIButton *)sender
{
   
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    
    NSString *timestamp = [formatter stringFromDate:ssview0_picker.date];

    if ([self.delegrate respondsToSelector:@selector(SelectDateInPicker:)]) {
        [self.delegrate SelectDateInPicker:timestamp];
    }
}
-(void)ssview0_shadowOrCancelButton_onPress:(UIButton *)sender
{
    
    if ([self.delegrate respondsToSelector:@selector(SelectCancelButton:)]) {
        [self.delegrate SelectCancelButton:sender];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
