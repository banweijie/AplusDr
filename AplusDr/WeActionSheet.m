//
//  WeActionSheet.m
//  AplusDr
//
//  Created by WeDoctor on 14-7-29.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeActionSheet.h"

@implementation WeActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView * subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton *)subview;
            [button setTitleColor:We_foreground_red_general forState:UIControlStateNormal];
            button.titleLabel.font = We_font_textfield_zh_cn;
        }
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
