//
//  WeCahIdxViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-24.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCahIdxViewController.h"

@interface WeCahIdxViewController () {
    UIView * view0;
    UIView * view1;
}

@end

@implementation WeCahIdxViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// 当segControl产生切换
- (void)selectedSegmentChanged:(UISegmentedControl *)segControl {
    NSLog(@"%d", segControl.selectedSegmentIndex);
    if (segControl.selectedSegmentIndex == 0) {
        [view0 setHidden:NO];
        [view1 setHidden:YES];
    }
    else {
        [view0 setHidden:YES];
        [view1 setHidden:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 切换“就诊历史"和"检查结果"
    UIView * segControlView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 44)];
    segControlView.backgroundColor = We_background_red_general;
    
    UISegmentedControl * segControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"就诊历史", @"检查结果", nil]];
    [segControl setFrame:CGRectMake(20, 7, 280, 30)];
    segControl.backgroundColor = [UIColor clearColor];
    segControl.selectedSegmentIndex = 0;
    segControl.tintColor = We_foreground_white_general;
    segControl.layer.cornerRadius = 5;
    [segControl addTarget:self action:@selector(selectedSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    [segControlView addSubview:segControl];
    
    // 就诊历史页面
    view0 = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + segControlView.frame.size.height, 320, self.view.frame.size.height - 64 - segControlView.frame.size.height)];
    
    [self.view addSubview:segControlView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
