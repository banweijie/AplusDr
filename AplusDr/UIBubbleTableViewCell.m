//
//  UIBubbleTableViewCell.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <QuartzCore/QuartzCore.h>
#import "UIBubbleTableViewCell.h"
#import "NSBubbleData.h"

@interface UIBubbleTableViewCell ()

@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) UIImageView *bubbleImage;
@property (nonatomic, retain) UIImageView *avatarImage;

- (void) setupInternalData;

@end

@implementation UIBubbleTableViewCell

@synthesize data = _data;
@synthesize customView = _customView;
@synthesize bubbleImage = _bubbleImage;
@synthesize showAvatar = _showAvatar;
@synthesize avatarImage = _avatarImage;

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
	[self setupInternalData];
}

#if !__has_feature(objc_arc)
- (void) dealloc
{
    self.data = nil;
    self.customView = nil;
    self.bubbleImage = nil;
    self.avatarImage = nil;
    [super dealloc];
}
#endif

- (void)setDataInternal:(NSBubbleData *)value
{
	self.data = value;
	[self setupInternalData];
}

- (void) setupInternalData
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.bubbleImage)
    {
#if !__has_feature(objc_arc)
        self.bubbleImage = [[[UIImageView alloc] init] autorelease];
#else
        self.bubbleImage = [[UIImageView alloc] init];        
#endif
        [self addSubview:self.bubbleImage];
    }
    
    NSBubbleType type = self.data.type;
    
    CGFloat width = self.data.view.frame.size.width;
    CGFloat height = self.data.view.frame.size.height;

    CGFloat x = (type == BubbleTypeSomeoneElse) ? 0 : self.frame.size.width - width - self.data.insets.left - self.data.insets.right;
    CGFloat y = 0;
    
    // Adjusting the x coordinate for avatar
    if (self.showAvatar)
    {
        [self.avatarImage removeFromSuperview];
#if !__has_feature(objc_arc)
        self.avatarImage = [[[UIImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"missingAvatar.png"])] autorelease];
#else
        self.avatarImage = [[UIImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"missingAvatar.png"])];
#endif
        self.avatarImage.layer.cornerRadius = 20.0f;
        self.avatarImage.layer.masksToBounds = YES;
        
        CGFloat avatarX = (type == BubbleTypeSomeoneElse) ? 6 : self.frame.size.width - 46;
        CGFloat avatarY = 0;
        
        self.avatarImage.frame = CGRectMake(avatarX, avatarY, 40, 40);
        [self addSubview:self.avatarImage];
        
//        CGFloat delta = self.frame.size.height - (self.data.insets.top + self.data.insets.bottom + self.data.view.frame.size.height);
        y = 0;
        
        if (type == BubbleTypeSomeoneElse) x += 54;
        if (type == BubbleTypeMine) x -= 54;
    }

    [self.customView removeFromSuperview];
    self.customView = self.data.view;
    self.customView.frame = CGRectMake(x + self.data.insets.left, y + self.data.insets.top, width, height);
    [self.contentView addSubview:self.customView];

    if (type == BubbleTypeSomeoneElse)
    {
        self.bubbleImage.image = [[UIImage imageNamed:@"chatbubble-left"] stretchableImageWithLeftCapWidth:10 topCapHeight:30];

    }
    else {
        self.bubbleImage.image = [[UIImage imageNamed:@"chatbubble-right"] stretchableImageWithLeftCapWidth:6 topCapHeight:30];
    }

    self.bubbleImage.frame = CGRectMake(x, y, width + self.data.insets.left + self.data.insets.right, height + self.data.insets.top + self.data.insets.bottom);
}

@end
