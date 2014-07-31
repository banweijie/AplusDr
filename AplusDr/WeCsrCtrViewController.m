//
//  WeCsrCtrViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-5-10.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCsrCtrViewController.h"
#define gasp 10
#define avatarWidth 40
#define maxTextWidth 180
#define maxImageWidth 120
#define maxImageHeight 150
#define rowLeastHeight gasp * 2 + avatarWidth

// 泡泡边界
#define bubbleGaspShort 20
#define bubbleGaspLong 15
#define bubbleGaspVertical 14

#define bubbleImageGaspShort 15
#define bubbleImageGaspLong 10
#define bubbleImageGaspVertical 9

@interface WeCsrCtrViewController () {
    UIBubbleTableView * bubbletTableView;
    NSMutableArray * bubbleData;
    
    // ChatView
    NSMutableArray * chatData;
    UITableView * chatTableView;
    
    NSTimer * timer;
    UITextField * inputTextField;
    NSInteger currentCount;
    UIButton * sendButton;
    UIButton * inputMoreButton;
    UIView * inputView;
    UIView * unionView;
    UIView * moreInputView;
    int currentKeyboardState;
    int currentInputMode;
    int currentMoreInputState;
    UIButton * changmodeButton;
    UIButton * audioRecoderButton;
    
    // audio recorder
    NSData * amrAudio;
    
    // 发起咨询和加号
    UIView * newConsultOrPlusView;
    
    // 双方头像
    UIImage * avatar1;
}

@end

@implementation WeCsrCtrViewController

@synthesize doctorChating;

//static double startRecordTime = 0;
//static double endRecordTime = 0;

// Action Sheet 按钮样式
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:We_foreground_red_general forState:UIControlStateNormal];
            button.titleLabel.font = We_font_textfield_zh_cn;
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;//设置类型为相机
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;//设置代理
            picker.allowsEditing = YES;//设置照片可编辑
            picker.sourceType = sourceType;
            //picker.showsCameraControls = NO;//默认为YES
            //创建叠加层
            UIView *overLayView=[[UIView alloc]initWithFrame:CGRectMake(0, 120, 320, 254)];
            //取景器的背景图片，该图片中间挖掉了一块变成透明，用来显示摄像头获取的图片；
            UIImage *overLayImag=[UIImage imageNamed:@"zhaoxiangdingwei.png"];
            UIImageView *bgImageView=[[UIImageView alloc]initWithImage:overLayImag];
            [overLayView addSubview:bgImageView];
            picker.cameraOverlayView=overLayView;
            picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;//选择前置摄像头或后置摄像头
            [self presentViewController:picker animated:YES completion:^{
            }];
        }
        else {
            NSLog(@"该设备无相机");
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = NO;
        [self presentViewController:pickerImage animated:YES completion:^{
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [self sendImage:image];
    }];
}

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path
{
    [tableView deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeMessage * currentMessage = chatData[indexPath.section][indexPath.row];
    
    if ([currentMessage.messageType isEqualToString:@"X"]) {
        return 40;
    }
    
    // 判断是谁发出的信息
    if ([currentMessage.senderId isEqualToString:currentUser.userId]) {
        if ([currentMessage.messageType isEqualToString:@"T"]) {
            // 计算文字大小
            CGSize textSize = [WeAppDelegate calcSizeForString:currentMessage.content Font:We_font_textfield_zh_cn expectWidth:maxTextWidth];
            return MAX(textSize.height + 2 * bubbleGaspVertical + 2 * gasp, rowLeastHeight);
        }
        if ([currentMessage.messageType isEqualToString:@"I"]) {
            // 计算图片大小
            CGSize imageSize = currentMessage.imageContent.size;
            if (imageSize.width > maxImageWidth) {
                imageSize.height = imageSize.height / imageSize.width * maxImageWidth;
                imageSize.width = maxImageWidth;
            }
            if (imageSize.height > maxImageHeight) {
                imageSize.width = imageSize.width / imageSize.height * maxImageHeight;
                imageSize.height = maxImageHeight;
            }
            return MAX(imageSize.height + 2 * bubbleImageGaspVertical + 2 * gasp, rowLeastHeight);
        }
        if ([currentMessage.messageType isEqualToString:@"A"]) {
            return 40 + 2 * gasp;
        }
    }
    else {
        if ([currentMessage.messageType isEqualToString:@"T"]) {
            // 计算文字大小
            CGSize textSize = [WeAppDelegate calcSizeForString:currentMessage.content Font:We_font_textfield_zh_cn expectWidth:maxTextWidth];
            return MAX(textSize.height + 2 * bubbleGaspVertical + 2 * gasp, rowLeastHeight);
        }
        if ([currentMessage.messageType isEqualToString:@"I"]) {
            // 计算图片大小
            CGSize imageSize = currentMessage.imageContent.size;
            if (imageSize.width > maxImageWidth) {
                imageSize.height = imageSize.height / imageSize.width * maxImageWidth;
                imageSize.width = maxImageWidth;
            }
            if (imageSize.height > maxImageHeight) {
                imageSize.width = imageSize.width / imageSize.height * maxImageHeight;
                imageSize.height = maxImageHeight;
            }
            return MAX(imageSize.height + 2 * bubbleImageGaspVertical + 2 * gasp, rowLeastHeight);
        }
        if ([currentMessage.messageType isEqualToString:@"A"]) {
            return 40 + 2 * gasp;
        }
    }
    return [tableView rowHeight] * 2;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 40 + 64;
    return 40;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [self tableView:tableView heightForHeaderInSection:section])];
    
    WeMessage * currentMessage = chatData[section][0];
    
    NSString * title = [WeAppDelegate transitionToDateFromSecond:currentMessage.time];
    
    CGSize titleSize = [WeAppDelegate calcSizeForString:title Font:We_font_textfield_small_zh_cn expectWidth:320];
    
    UIButton * titleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [titleButton setTitle:title forState:UIControlStateNormal];
    [titleButton setTintColor:We_foreground_white_general];
    [titleButton setBackgroundColor:We_foreground_gray_general];
    [titleButton setFrame:CGRectMake((320 - titleSize.width - 20) / 2, [self tableView:tableView heightForHeaderInSection:section] - 25, titleSize.width + 20, 20)];
    [titleButton.titleLabel setFont:We_font_textfield_small_zh_cn];
    [titleButton.layer setCornerRadius:4];
    [headerView addSubview:titleButton];
    
    return headerView;
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 20;
    }
    return 1;
}
// 询问每个段落的尾部标题
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [chatData count];
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return [chatData[section] count];
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    cell.opaque = NO;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WeMessage * currentMessage = chatData[indexPath.section][indexPath.row];
    
    // 系统消息
    if ([currentMessage.messageType isEqualToString:@"X"]) {
        NSString * title = currentMessage.content;
        
        CGSize titleSize = [WeAppDelegate calcSizeForString:title Font:We_font_textfield_small_zh_cn expectWidth:320];
        
        UIButton * titleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [titleButton setTitle:title forState:UIControlStateNormal];
        [titleButton setTintColor:We_foreground_white_general];
        [titleButton setBackgroundColor:We_foreground_gray_general];
        [titleButton setFrame:CGRectMake((320 - titleSize.width - 20) / 2, 40 - 25, titleSize.width + 20, 20)];
        [titleButton.titleLabel setFont:We_font_textfield_small_zh_cn];
        [titleButton.layer setCornerRadius:4];
        [cell.contentView addSubview:titleButton];
    }
    // 我发出的消息
    else if ([currentMessage.senderId isEqualToString:currentUser.userId]) {
        
        // 文本信息
        if ([currentMessage.messageType isEqualToString:@"T"]) {
            // 头像
            UIImageView * avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(320 - gasp - avatarWidth, gasp, avatarWidth, avatarWidth)];
            [avatarView setImageWithURL:[NSURL URLWithString:yijiarenAvatarUrl(currentUser.avatarPath)]];
            [avatarView.layer setCornerRadius:avatarView.frame.size.height / 2];
            [avatarView.layer setMasksToBounds:YES];
            [cell.contentView addSubview:avatarView];
            
            // 计算文字大小
            CGSize textSize = [WeAppDelegate calcSizeForString:currentMessage.content Font:We_font_textfield_zh_cn expectWidth:maxTextWidth];
            
            // 泡泡
            UIImageView * bubbleView = [[UIImageView alloc] initWithFrame:CGRectMake(320 - 2 * gasp - avatarWidth - (textSize.width + bubbleGaspShort + bubbleGaspLong), gasp, textSize.width + bubbleGaspShort + bubbleGaspLong, textSize.height + bubbleGaspVertical * 2)];
            [bubbleView setImage:[[UIImage imageNamed:@"chatbubble-right"] stretchableImageWithLeftCapWidth:6 topCapHeight:30]];
            [cell.contentView addSubview:bubbleView];
            
            // 文字
            UILabel * textView = [[UILabel alloc] initWithFrame:CGRectMake(320 - 2 * gasp - avatarWidth - bubbleGaspShort - textSize.width, gasp + bubbleGaspVertical, textSize.width, textSize.height)];
            [textView setFont:We_font_textfield_zh_cn];
            [textView setText:currentMessage.content];
            [textView setTextColor:We_foreground_black_general];
            [textView setNumberOfLines:0];
            [cell.contentView addSubview:textView];
            
            // 发送失败图标
            if (currentMessage.failed) {
                UIButton * failedButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
                [failedButton setFrame:CGRectMake(320 - 2 * gasp - avatarWidth - (textSize.width + bubbleGaspShort + bubbleGaspLong) - 50, gasp, 40, 40)];
                [cell.contentView addSubview:failedButton];
            }
            
            // 发送中图标
            if (currentMessage.sending) {
                UIActivityIndicatorView * sendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [sendingView setFrame:CGRectMake(320 - 2 * gasp - avatarWidth - (textSize.width + bubbleGaspShort + bubbleGaspLong) - 50, gasp, 40, 40)];
                [sendingView startAnimating];
                [cell.contentView addSubview:sendingView];
            }
        }
        
        // 图像信息
        if ([currentMessage.messageType isEqualToString:@"I"]) {
            // 头像
            UIImageView * avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(320 - gasp - avatarWidth, gasp, avatarWidth, avatarWidth)];
            [avatarView setImageWithURL:[NSURL URLWithString:yijiarenAvatarUrl(currentUser.avatarPath)]];
            [avatarView.layer setCornerRadius:avatarView.frame.size.height / 2];
            [avatarView.layer setMasksToBounds:YES];
            [cell.contentView addSubview:avatarView];
            
            // 计算图片大小
            CGSize imageSize = currentMessage.imageContent.size;
            if (imageSize.width > maxImageWidth) {
                imageSize.height = imageSize.height / imageSize.width * maxImageWidth;
                imageSize.width = maxImageWidth;
            }
            if (imageSize.height > maxImageHeight) {
                imageSize.width = imageSize.width / imageSize.height * maxImageHeight;
                imageSize.height = maxImageHeight;
            }
            
            // 泡泡
            UIImageView * bubbleView = [[UIImageView alloc] initWithFrame:CGRectMake(320 - 2 * gasp - avatarWidth - (imageSize.width + bubbleImageGaspShort + bubbleImageGaspLong), gasp, imageSize.width + bubbleImageGaspShort + bubbleImageGaspLong, imageSize.height + bubbleImageGaspVertical * 2)];
            [bubbleView setImage:[[UIImage imageNamed:@"chatbubble-right"] stretchableImageWithLeftCapWidth:6 topCapHeight:30]];
            [cell.contentView addSubview:bubbleView];
            
            // 图片
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320 - 2 * gasp - avatarWidth - bubbleImageGaspShort - imageSize.width, gasp + bubbleImageGaspVertical, imageSize.width, imageSize.height)];
            [imageView setImage:currentMessage.imageContent];
            [imageView.layer setCornerRadius:5];
            [imageView.layer setMasksToBounds:YES];
            [cell.contentView addSubview:imageView];
            
            // 发送失败图标
            if (currentMessage.failed) {
                UIButton * failedButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
                [failedButton setFrame:CGRectMake(320 - 2 * gasp - avatarWidth - (imageSize.width + bubbleImageGaspShort + bubbleImageGaspLong) - 50, gasp, 40, 40)];
                [cell.contentView addSubview:failedButton];
            }
            
            // 发送中图标
            if (currentMessage.sending) {
                UIActivityIndicatorView * sendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [sendingView setFrame:CGRectMake(320 - 2 * gasp - avatarWidth - (imageSize.width + bubbleImageGaspShort + bubbleImageGaspLong) - 50, gasp, 40, 40)];
                [sendingView startAnimating];
                [cell.contentView addSubview:sendingView];
            }
        }
        
        // 声音信息
        if ([currentMessage.messageType isEqualToString:@"A"]) {
            // 头像
            UIImageView * avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(320 - gasp - avatarWidth, gasp, avatarWidth, avatarWidth)];
            [avatarView setImageWithURL:[NSURL URLWithString:yijiarenAvatarUrl(currentUser.avatarPath)]];
            [avatarView.layer setCornerRadius:avatarView.frame.size.height / 2];
            [avatarView.layer setMasksToBounds:YES];
            [cell.contentView addSubview:avatarView];
            
            // 计算音频长度
            NSError * error;
            AVAudioPlayer * tmpPlayer = [[AVAudioPlayer alloc] initWithData:currentMessage.audioContent error:&error];
            if (error) NSLog(@"%@", error);
            else {
                // 计算泡泡大小
                CGSize bubbleSize = CGSizeMake(MIN(maxTextWidth, 50 + 8 * tmpPlayer.duration), 40);
                
                // 泡泡
                WeImageButton * buttonView = [WeImageButton buttonWithType:UIButtonTypeCustom];
                [buttonView setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
                [buttonView setFrame:CGRectMake(320 - 2 * gasp - avatarWidth - bubbleSize.width, gasp, bubbleSize.width, bubbleSize.height)];
                [buttonView setTintColor:We_foreground_white_general];
                [buttonView setImage:[[UIImage imageNamed:@"chatbubble-right"] stretchableImageWithLeftCapWidth:6 topCapHeight:30] forState:UIControlStateNormal];
                [buttonView setUserData:currentMessage];
                [buttonView addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:buttonView];
                
                // 音频图标
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320 - 2 * gasp - avatarWidth - bubbleImageGaspShort - 20, gasp + (40 - 20) / 2, 20, 20)];
                [imageView setContentMode:UIViewContentModeScaleAspectFit];
                [imageView setImage:[UIImage imageNamed:@"chatroom-audio-right"]];
                [cell.contentView addSubview:imageView];
                
                // 时间
                UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - 2 * gasp - avatarWidth - bubbleSize.width - 10 - 30, gasp + 10, 30, bubbleSize.height - 10)];
                [timeLabel setText:[NSString stringWithFormat:@"%d ''", (int)tmpPlayer.duration]];
                [timeLabel setFont:We_font_textfield_zh_cn];
                [timeLabel setTextColor:We_foreground_gray_general];
                [cell.contentView addSubview:timeLabel];
            }
            
        }

    }
    // 别人发出的消息
    else {
        if ([currentMessage.messageType isEqualToString:@"T"]) {
            // 头像
            WeImageButton * avatarView = [[WeImageButton alloc] initWithFrame:CGRectMake(gasp, gasp, avatarWidth, avatarWidth)];
            [avatarView setImage:avatar1 forState:UIControlStateNormal];
            [avatarView addTarget:self action:@selector(othersAvatarOnPress) forControlEvents:UIControlEventTouchUpInside];
            [avatarView.layer setCornerRadius:avatarView.frame.size.height / 2];
            [avatarView.layer setMasksToBounds:YES];
            [cell.contentView addSubview:avatarView];
            
            // 计算文字大小
            CGSize textSize = [WeAppDelegate calcSizeForString:currentMessage.content Font:We_font_textfield_zh_cn expectWidth:maxTextWidth];
            
            // 泡泡
            UIImageView * bubbleView = [[UIImageView alloc] initWithFrame:CGRectMake(2 * gasp + avatarWidth, gasp, textSize.width + bubbleGaspShort + bubbleGaspLong, textSize.height + bubbleGaspVertical * 2)];
            [bubbleView setImage:[[UIImage imageNamed:@"chatbubble-left"] stretchableImageWithLeftCapWidth:10 topCapHeight:30]];
            [cell.contentView addSubview:bubbleView];
            
            // 文字
            UILabel * textView = [[UILabel alloc] initWithFrame:CGRectMake(2 * gasp + avatarWidth + bubbleGaspShort, gasp + bubbleGaspVertical, textSize.width, textSize.height)];
            [textView setFont:We_font_textfield_zh_cn];
            [textView setText:currentMessage.content];
            [textView setTextColor:We_foreground_black_general];
            [textView setNumberOfLines:0];
            [cell.contentView addSubview:textView];
        }
        if ([currentMessage.messageType isEqualToString:@"I"]) {
            // 头像
            UIImageView * avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(gasp, gasp, avatarWidth, avatarWidth)];
            [avatarView setImageWithURL:[NSURL URLWithString:yijiarenAvatarUrl(doctorChating.avatarPath)]];
            [avatarView.layer setCornerRadius:avatarView.frame.size.height / 2];
            [avatarView.layer setMasksToBounds:YES];
            [cell.contentView addSubview:avatarView];
            
            // 计算图片大小
            CGSize imageSize = currentMessage.imageContent.size;
            if (imageSize.width > maxImageWidth) {
                imageSize.height = imageSize.height / imageSize.width * maxImageWidth;
                imageSize.width = maxImageWidth;
            }
            if (imageSize.height > maxImageHeight) {
                imageSize.width = imageSize.width / imageSize.height * maxImageHeight;
                imageSize.height = maxImageHeight;
            }
            
            // 泡泡
            UIImageView * bubbleView = [[UIImageView alloc] initWithFrame:CGRectMake(2 * gasp + avatarWidth, gasp, imageSize.width + bubbleImageGaspShort + bubbleImageGaspLong, imageSize.height + bubbleImageGaspVertical * 2)];
            [bubbleView setImage:[[UIImage imageNamed:@"chatbubble-left"] stretchableImageWithLeftCapWidth:10 topCapHeight:30]];
            [cell.contentView addSubview:bubbleView];
            
            // 图片
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2 * gasp + avatarWidth + bubbleImageGaspShort, gasp + bubbleImageGaspVertical, imageSize.width, imageSize.height)];
            [imageView setImage:currentMessage.imageContent];
            [imageView.layer setCornerRadius:5];
            [imageView.layer setMasksToBounds:YES];
            [cell.contentView addSubview:imageView];
        }
        if ([currentMessage.messageType isEqualToString:@"A"]) {
            // 头像
            UIImageView * avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(gasp, gasp, avatarWidth, avatarWidth)];
            [avatarView setImageWithURL:[NSURL URLWithString:yijiarenAvatarUrl(doctorChating.avatarPath)]];
            [avatarView.layer setCornerRadius:avatarView.frame.size.height / 2];
            [avatarView.layer setMasksToBounds:YES];
            [cell.contentView addSubview:avatarView];
            
            // 计算音频长度
            NSError * error;
            AVAudioPlayer * tmpPlayer = [[AVAudioPlayer alloc] initWithData:currentMessage.audioContent error:&error];
            if (error) NSLog(@"%@", error);
            else {
                // 计算泡泡大小
                CGSize bubbleSize = CGSizeMake(MIN(maxTextWidth, 50 + 8 * tmpPlayer.duration), 40);
                
                // 泡泡
                WeImageButton * buttonView = [WeImageButton buttonWithType:UIButtonTypeCustom];
                [buttonView setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
                [buttonView setFrame:CGRectMake(2 * gasp + avatarWidth, gasp, bubbleSize.width, bubbleSize.height)];
                [buttonView setTintColor:We_foreground_white_general];
                [buttonView setImage:[[UIImage imageNamed:@"chatbubble-left"] stretchableImageWithLeftCapWidth:10 topCapHeight:30] forState:UIControlStateNormal];
                [buttonView setUserData:currentMessage];
                [buttonView addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:buttonView];
                
                // 音频图标
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2 * gasp + avatarWidth + bubbleImageGaspShort, gasp + (40 - 20) / 2, 20, 20)];
                [imageView setContentMode:UIViewContentModeScaleAspectFit];
                [imageView setImage:[UIImage imageNamed:@"chatroom-audio-left"]];
                [cell.contentView addSubview:imageView];
                
                // 时间
                UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * gasp + avatarWidth + bubbleSize.width + 10, gasp + 10, 30, bubbleSize.height - 10)];
                [timeLabel setText:[NSString stringWithFormat:@"%d ''", (int)tmpPlayer.duration]];
                [timeLabel setFont:We_font_textfield_zh_cn];
                [timeLabel setTextColor:We_foreground_gray_general];
                [cell.contentView addSubview:timeLabel];
            }
            
        }
    }
    
    
    return cell;
}

#pragma mark - View related

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)refreshMessage:(BOOL)forced {
    // 从数据库中提取信息
    NSMutableArray * messageList = [globalHelper search:[WeMessage class]
                                                  where:[NSString stringWithFormat:@"(senderId = %@ and receiverId = %@) or (senderId = %@ and receiverId = %@)", currentUser.userId, doctorChating.userId, doctorChating.userId, currentUser.userId]
                                                orderBy:nil
                                                 offset:0
                                                  count:100];
    NSLog(@"\nSelect %lu message(s) from database.", (unsigned long)[messageList count]);
    
    // 根据信息数量判断是否需要刷新
    if ([messageList count] == currentCount && !forced) return;
    currentCount = [messageList count];
    
    // 处理信息分组
    int maxTimeInterval = 300;
    
    [messageList sortUsingComparator:^NSComparisonResult(id rA, id rB) {
        return [(WeMessage *)rA time] > [(WeMessage *)rB time];
    }];
    
    chatData = [[NSMutableArray alloc] init];
    int j = -1;
    long long lastTime = -1;
    for (int i = 0; i < [messageList count]; i ++) {
        if (i == 0 || [(WeMessage *)messageList[i] time] > lastTime + maxTimeInterval) {
            chatData[++j] = [[NSMutableArray alloc] init];
            lastTime = [(WeMessage *)messageList[i] time];
        }
        [chatData[j] addObject:messageList[i]];
    }
    
    // 重载数据并滑至最底
    [chatTableView reloadData];
    if ([chatData count] > 0) {
        [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:[[chatData lastObject] count] - 1 inSection:[chatData count] - 1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)playAudio:(WeInfoedButton *)sender {
    NSError * error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:[(WeMessage *)sender.userData audioContent] error:&error];
    self.audioPlayer.delegate = self;
    self.audioPlayer.volume = 1.0f;
    if (error != nil) {
        NSLog(@"Wrong init player:%@", error);
    }else{
        [self.audioPlayer play];
    }
}

// 发送文本
- (void)sendMessage:(id)sender {
    WeMessage * message = [[WeMessage alloc] init];
    message.messageType = @"T";
    message.senderId = currentUser.userId;
    message.receiverId = doctorChating.userId;
    message.content = inputTextField.text;
    message.time = [[NSDate date] timeIntervalSince1970];
    message.failed = NO;
    message.sending = YES;
    [globalHelper insertToDB:message];
    inputTextField.text = @"";
    [self textFieldDidChange:self];
    
    [WeAppDelegate postToServerWithField:@"message" action:@"postMsg"
                              parameters:@{
                                           @"m.receiverId":message.receiverId,
                                           @"m.content":message.content,
                                           @"m.type":message.messageType
                                           }
                                 success:^(id response) {
                                     NSLog(@"\n%@", response);
                                     [message setWithNSDictionary:response];
                                     [message setSending:NO];
                                     [globalHelper updateToDB:message where:nil];
                                     [self refreshView:YES];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     NSLog(@"\n%@", errorMessage);
                                     [message setSending:NO];
                                     [message setFailed:YES];
                                     [globalHelper updateToDB:message where:nil];
                                     [self refreshView:YES];
                                 }];
}

// 发送图片
- (void)sendImage:(UIImage *)image {
    WeMessage * message = [[WeMessage alloc] init];
    message.messageType = @"I";
    message.senderId = currentUser.userId;
    message.receiverId = doctorChating.userId;
    message.imageContent = image;
    message.time = [[NSDate date] timeIntervalSince1970];
    message.failed = NO;
    message.sending = YES;
    [globalHelper insertToDB:message];
    [self refreshView:YES];
    
    [WeAppDelegate postToServerWithField:@"message" action:@"postFileMsg"
                              parameters:@{
                                           @"receiverId":message.receiverId,
                                           @"type":message.messageType,
                                           @"fileFileName":@"a.jpg",
                                           }
                                fileData:UIImageJPEGRepresentation(image, 1.0)
                                fileName:@"a.jpg"
                                 success:^(id response) {
                                     NSLog(@"\n%@", response);
                                     [message setWithNSDictionary:response];
                                     [message setSending:NO];
                                     [globalHelper updateToDB:message where:nil];
                                     [self refreshView:YES];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     NSLog(@"\n%@", errorMessage);
                                     [message setSending:NO];
                                     [message setFailed:YES];
                                     [globalHelper updateToDB:message where:nil];
                                     [self refreshView:YES];
                                 }];
}

// 发送声音
- (void)sendAmrAudio:(NSData *)amrData wavAudio:(NSData *)wavData {
    WeMessage * message = [[WeMessage alloc] init];
    message.messageType = @"A";
    message.senderId = currentUser.userId;
    message.receiverId = doctorChating.userId;
    message.audioContent = wavData;
    message.time = [[NSDate date] timeIntervalSince1970];
    message.failed = NO;
    message.sending = YES;
    [globalHelper insertToDB:message];
    [self refreshView:YES];
    
    [WeAppDelegate postToServerWithField:@"message" action:@"postFileMsg"
                              parameters:@{
                                           @"receiverId":message.receiverId,
                                           @"type":message.messageType,
                                           @"fileFileName":@"a.amr",
                                           }
                                fileData:amrData
                                fileName:@"a.amr"
                                 success:^(id response) {
                                     NSLog(@"\n%@", response);
                                     [message setWithNSDictionary:response];
                                     [message setSending:NO];
                                     [globalHelper updateToDB:message where:nil];
                                     [self refreshView:YES];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     NSLog(@"\n%@", errorMessage);
                                     [message setSending:NO];
                                     [message setFailed:YES];
                                     [globalHelper updateToDB:message where:nil];
                                     [self refreshView:YES];
                                 }];
}

// Audio
- (void)audioRecorderButtonTouchDown:(id)sender {
    [audioRecoderButton setTitle:@"松开手指 取消发送" forState:UIControlStateNormal];
    [self.audioRecorder record];
}

- (void)audioRecorderButtonTouchUpInside:(id)sender {
    [audioRecoderButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self.audioRecorder stop];
    
    [VoiceConverter wavToAmr:[NSString stringWithFormat:@"%@record.wav", NSTemporaryDirectory()] amrSavePath:[NSString stringWithFormat:@"%@record.amr", NSTemporaryDirectory()]];
    
    [VoiceConverter amrToWav:[NSString stringWithFormat:@"%@record.amr", NSTemporaryDirectory()] wavSavePath:[NSString stringWithFormat:@"%@record1.wav", NSTemporaryDirectory()]];
    
    NSError *error;
    
    NSData * wavData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@record.wav", NSTemporaryDirectory()]options:NSDataReadingUncached error:&error];
    if (error != nil) {
        NSLog(@"Wrong loading file:%@", error);
        return;
    }
    
    NSData * amrData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@record.amr", NSTemporaryDirectory()]options:NSDataReadingUncached error:&error];
    if (error != nil) {
        NSLog(@"Wrong loading file:%@", error);
        return;
    }
    
    [self sendAmrAudio:amrData wavAudio:wavData];
}

- (void)audioRecorderButtonTouchUpOutside:(id)sender {
    [audioRecoderButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self.audioRecorder stop];
    NSLog(@"Outside");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 双方头像获取
    avatar1 = [[UIImage alloc] init];
    
    [WeAppDelegate DownloadImageWithURL:yijiarenAvatarUrl(self.doctorChating.avatarPath) successCompletion:^(UIImage * image) {
        avatar1 = image;
        [chatTableView reloadData];
    }];
    
    
    we_doctorChating = [NSString stringWithFormat:@"%@", we_doctorChating];
    currentKeyboardState = 0;
    currentInputMode = 0;
    // Setup Timer
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // Title
    
    // Invisible of tab bar
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    // Audio Recorder
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   nil];
    //录音文件保存地址的URL
    NSString * urlString = NSTemporaryDirectory();
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/record.wav", urlString]];
    NSError *error = nil;
    self.audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
    
    if (error != nil) {
        NSLog(@"Init audioRecorder error: %@",error);
    }else{
        //准备就绪，等待录音，注意该方法会返回Boolean，最好做个成功判断，因为其失败的时候无任何错误信息抛出
        if ([self.audioRecorder prepareToRecord]) {
            NSLog(@"Prepare successful");
        }
        else {
            NSLog(@"prepareError");
        }
    }
    
    // unionView
    unionView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:unionView];
    
    // sys_tableView
    // 表格
    chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 40) style:UITableViewStyleGrouped];
    chatTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    chatTableView.delegate = self;
    chatTableView.dataSource = self;
    chatTableView.backgroundColor = [UIColor clearColor];
    [chatTableView setSeparatorColor:[UIColor clearColor]];
    [unionView addSubview:chatTableView];
    
    // 输入面板
    inputView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
    inputView.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:228 / 255.0 blue:223 / 255.0 alpha:0.9];
    
    inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, 7, 240, 26)];
    inputTextField.returnKeyType = UIReturnKeyDone;
    inputTextField.backgroundColor = [UIColor whiteColor];
    inputTextField.font = We_font_textfield_zh_cn;
    inputTextField.clipsToBounds = YES;
    inputTextField.layer.cornerRadius = 4.0f;
    [inputTextField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    inputTextField.delegate = self;
    [inputView addSubview:inputTextField];
    
    audioRecoderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [audioRecoderButton setFrame:CGRectMake(40, 7, 240, 26)];
    audioRecoderButton.hidden = YES;
    [audioRecoderButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    [audioRecoderButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
    [audioRecoderButton addTarget:self action:@selector(audioRecorderButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [audioRecoderButton addTarget:self action:@selector(audioRecorderButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [audioRecoderButton addTarget:self action:@selector(audioRecorderButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    audioRecoderButton.layer.cornerRadius = 4.0f;
    audioRecoderButton.titleLabel.font = We_font_button_zh_cn;
    audioRecoderButton.backgroundColor = We_background_red_general;
    audioRecoderButton.tintColor = We_foreground_white_general;
    [inputView addSubview:audioRecoderButton];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendButton setFrame:CGRectMake(270, 7, 40, 26)];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.tintColor = We_foreground_white_general;
    sendButton.backgroundColor = We_foreground_red_general;
    sendButton.titleLabel.font = We_font_textfield_zh_cn;
    sendButton.clipsToBounds = YES;
    sendButton.layer.cornerRadius = 4.0f;
    sendButton.hidden = YES;
    [inputView addSubview:sendButton];
    
    inputMoreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [inputMoreButton setFrame:CGRectMake(280, 0, 40, 40)];
    [inputMoreButton setImage:[UIImage imageNamed:@"chatroom-inputmore"] forState:UIControlStateNormal];
    [inputMoreButton setTintColor:We_foreground_red_general];
    [inputMoreButton addTarget:self action:@selector(moreInputButtonOnPress:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:inputMoreButton];
    
    changmodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [changmodeButton setFrame:CGRectMake(0, 0, 40, 40)];
    [changmodeButton setImage:[UIImage imageNamed:@"chatroom-sendaudio"] forState:UIControlStateNormal];
    [changmodeButton setTintColor:We_foreground_red_general];
    [changmodeButton addTarget:self action:@selector(changeModeButtonOnPress:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:changmodeButton];
    
    // moreInputView
    moreInputView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 100)];
    moreInputView.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:228 / 255.0 blue:223 / 255.0 alpha:0.9];
    [self.view addSubview:moreInputView];
    
    WeToolButton * uploadPicButton = [WeToolButton buttonWithType:UIButtonTypeRoundedRect];
    [uploadPicButton setFrame:CGRectMake(0, 0, 80, 100)];
    [uploadPicButton setTitle:@"上传图片" forState:UIControlStateNormal];
    [uploadPicButton setImage:[UIImage imageNamed:@"chatroom-sendphoto"] forState:UIControlStateNormal];
    [uploadPicButton addTarget:self action:@selector(uploadPic:) forControlEvents:UIControlEventTouchUpInside];
    uploadPicButton.titleLabel.font = We_font_textfield_zh_cn;
    uploadPicButton.tintColor = We_foreground_red_general;
    [moreInputView addSubview:uploadPicButton];
    
    WeToolButton * uploadHiButton = [WeToolButton buttonWithType:UIButtonTypeRoundedRect];
    [uploadHiButton setFrame:CGRectMake(80, 0, 80, 100)];
    [uploadHiButton setTitle:@"上传病例" forState:UIControlStateNormal];
    [uploadHiButton setImage:[UIImage imageNamed:@"chatroom-sendcasehistory"] forState:UIControlStateNormal];
    uploadHiButton.titleLabel.font = We_font_textfield_zh_cn;
    uploadHiButton.tintColor = We_foreground_gray_general;
    [moreInputView addSubview:uploadHiButton];
    
    WeToolButton * uploadVedioButton = [WeToolButton buttonWithType:UIButtonTypeRoundedRect];
    [uploadVedioButton setFrame:CGRectMake(160, 0, 80, 100)];
    [uploadVedioButton setTitle:@"上传视频" forState:UIControlStateNormal];
    [uploadVedioButton setImage:[UIImage imageNamed:@"chatroom-sendvideo"] forState:UIControlStateNormal];
    uploadVedioButton.titleLabel.font = We_font_textfield_zh_cn;
    uploadVedioButton.tintColor = We_foreground_gray_general;
    [moreInputView addSubview:uploadVedioButton];
    
    WeToolButton * jiahaoButton = [WeToolButton buttonWithType:UIButtonTypeRoundedRect];
    [jiahaoButton setFrame:CGRectMake(240, 0, 80, 100)];
    [jiahaoButton setTitle:@"我要加号" forState:UIControlStateNormal];
    [jiahaoButton setImage:[UIImage imageNamed:@"chatroom-makeappointment"] forState:UIControlStateNormal];
    [jiahaoButton addTarget:self action:@selector(newAppointmentButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    jiahaoButton.titleLabel.font = We_font_textfield_zh_cn;
    jiahaoButton.tintColor = We_foreground_red_general;
    [moreInputView addSubview:jiahaoButton];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [unionView addSubview:inputView];
    
    // 发起咨询和发起加号
    newConsultOrPlusView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, 320, 44)];
    [newConsultOrPlusView setBackgroundColor:We_foreground_white_general];
    [self.view addSubview:newConsultOrPlusView];
    
    UIButton * newConsultButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [newConsultButton setFrame:CGRectMake(0, 0, 159, 44)];
    [newConsultButton setTitle:@"发起咨询" forState:UIControlStateNormal];
    [newConsultButton setTintColor:[UIColor whiteColor]];
    [newConsultButton setBackgroundColor:We_foreground_red_general];
    [newConsultButton.titleLabel setFont:We_font_button_zh_cn];
    [newConsultButton addTarget:self action:@selector(newConsultButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [newConsultOrPlusView addSubview:newConsultButton];
    
    UIButton * newAppointmentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [newAppointmentButton setFrame:CGRectMake(161, 0, 159, 44)];
    [newAppointmentButton setTitle:@"申请加号" forState:UIControlStateNormal];
    [newAppointmentButton setTintColor:[UIColor whiteColor]];
    [newAppointmentButton setBackgroundColor:We_foreground_red_general];
    [newAppointmentButton.titleLabel setFont:We_font_button_zh_cn];
    [newAppointmentButton addTarget:self action:@selector(newAppointmentButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [newConsultOrPlusView addSubview:newAppointmentButton];
    
    //
    [self refreshView:NO];
}

// 发起咨询按钮被按下
- (void)newConsultButton_onPress:(id)sender {
    WeCsrCosViewController * vc = [[WeCsrCosViewController alloc] init];
    vc.pushType = @"consultingRoom";
    vc.currentDoctor = favorDoctorList[we_doctorChating];
    [self.navigationController pushViewController:vc animated:YES];
}

// 申请加号按钮被按下
- (void)newAppointmentButton_onPress:(id)sender {
    WeCsrJiaViewController * vc = [[WeCsrJiaViewController alloc] init];
    vc.currentDoctor = favorDoctorList[we_doctorChating];
    [self.navigationController pushViewController:vc animated:YES];
}

// 输入框右侧更多选项
- (void)displayMoreInput:(int)mode {
    currentMoreInputState = mode;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    
    CGRect rect = moreInputView.frame;
    rect.origin.y = self.view.frame.size.height - 100 * mode;
    moreInputView.frame = rect;
    
    [UIView commitAnimations];
}

- (void)moveUnionView:(int)height withDuration:(CGFloat)duration {
    //[chatTableView setContentOffset:CGPointMake(0, chatTableView.contentSize.height - chatTableView.frame.size.height) animated:YES];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    
    CGRect rect = unionView.frame;
    rect.origin.y = - height;
    unionView.frame = rect;
    
    rect = chatTableView.frame;
    rect.origin.y = height;
    rect.size.height = self.view.frame.size.height - 40 - height;
    chatTableView.frame = rect;
    
    [UIView commitAnimations];
    
    if ([chatData count] > 0) {
        [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:[[chatData lastObject] count] - 1 inSection:[chatData count] - 1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)changeModeButtonOnPress:(id)sender {
    if (currentInputMode == 0) {
        [self changeInputMode:1];
        [self displayMoreInput:NO];
        [self moveUnionView:0 withDuration:0.2];
        inputTextField.text = @"";
        [self textFieldDidChange:self];
        [inputTextField resignFirstResponder];
    }
    else {
        [inputTextField becomeFirstResponder];
    }
}

- (void)changeInputMode:(int)target {
    if (target == 1) {
        currentInputMode = 1;
        [changmodeButton setImage:[UIImage imageNamed:@"chatroom-keyboard"] forState:UIControlStateNormal];
        inputTextField.hidden = YES;
        audioRecoderButton.hidden = NO;
    }
    else {
        currentInputMode = 0;
        [changmodeButton setImage:[UIImage imageNamed:@"chatroom-sendaudio"] forState:UIControlStateNormal];
        inputTextField.hidden = NO;
        audioRecoderButton.hidden = YES;
    }
}

- (void)uploadPic:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"选择本地图片",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSValue * keyboardBoundsValue = notification.userInfo[@"UIKeyboardBoundsUserInfoKey"];
    CGFloat KeyboardAnimationDurationUserInfoKey = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect keyboardBounds = [keyboardBoundsValue CGRectValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:KeyboardAnimationDurationUserInfoKey];
    
    [self moveUnionView:keyboardBounds.size.height withDuration:KeyboardAnimationDurationUserInfoKey];
    [self changeInputMode:0];
    [self displayMoreInput:0];
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    currentKeyboardState = 0;
    CGFloat KeyboardAnimationDurationUserInfoKey = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    [self moveUnionView:0 withDuration:KeyboardAnimationDurationUserInfoKey];
}

- (void)moreInputButtonOnPress:(id)sender {
    if (currentMoreInputState == 0) {
        [self displayMoreInput:YES];
        [self changeInputMode:0];
        [inputTextField resignFirstResponder];
        [self moveUnionView:100 withDuration:0.2];
    }
    else if (currentMoreInputState == 1) {
        [inputTextField becomeFirstResponder];
    }
}

- (void)textFieldDidChange:(id)sender {
    if ([inputTextField.text isEqualToString:@""]) {
        sendButton.hidden = YES;
        inputMoreButton.hidden = NO;
        [inputTextField setFrame:CGRectMake(40, 7, 240, 26)];
    }
    else {
        sendButton.hidden = NO;
        inputMoreButton.hidden = YES;
        [inputTextField setFrame:CGRectMake(40, 7, 220, 26)];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [inputTextField resignFirstResponder];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timer_onTick:) userInfo:nil repeats:YES];
}

- (void)timer_onTick:(id)sender {
    [self refreshView:NO];
}

- (void)refreshView:(BOOL)forced {
    [self refreshMessage:forced];
    [self refreshKeyboard];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@(%@)", doctorChating.userName, doctorChating.consultStatus];
    if ([doctorChating.consultStatus isEqualToString:@"A"]) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@(申请咨询中)", doctorChating.userName];
    }
    if ([doctorChating.consultStatus isEqualToString:@"N"]) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@", doctorChating.userName];
    }
    if ([doctorChating.consultStatus isEqualToString:@"C"]) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@(咨询中)", doctorChating.userName];
    }
    if ([doctorChating.consultStatus isEqualToString:@"W"]) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@(等待支付)", doctorChating.userName];
    }
    
    NSMutableArray * unviewedMessageList = [globalHelper search:[WeMessage class]
                                                          where:[NSString stringWithFormat:@"((senderId = %@ or receiverId = %@)and viewed = 0)", self.doctorChating.userId, self.doctorChating.userId]
                                                        orderBy:@"time desc"
                                                         offset:0
                                                          count:101];
    
    for (int i = 0; i < [unviewedMessageList count]; i++) {
        ((WeMessage *)unviewedMessageList[i]).viewed = YES;
        [globalHelper updateToDB:unviewedMessageList[i] where:nil];
    }
}

- (void)refreshKeyboard {
    [newConsultOrPlusView setHidden:YES];
    if (doctorChating.sendable || [doctorChating.consultStatus isEqualToString:@"C"]) {
        [newConsultOrPlusView setHidden:YES];
    }
    else {
        [newConsultOrPlusView setHidden:NO];
        [self displayMoreInput:NO];
        [self changeInputMode:0];
        [self moveUnionView:0 withDuration:0];
        [inputTextField resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [timer invalidate];
    timer = nil;
}

#pragma mark - Callbacks
- (void)othersAvatarOnPress {
    WeCsrDciViewController * vc = [[WeCsrDciViewController alloc] init];
    vc.currentDoctor = doctorChating;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
