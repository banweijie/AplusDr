//
//  WeMapIdxViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-13.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeMapIdxViewController.h"

@interface WeMapIdxViewController () {
}

@end

@implementation WeMapIdxViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
//    if (we_targetView == targetViewNone) [self.tabBarController setSelectedIndex:0];
    
    UIActivityIndicatorView * tmp = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    tmp.backgroundColor = [UIColor blackColor];
    [tmp setFrame:CGRectMake(0, 0, 320, 568)];
    [tmp setAlpha:0.5];
    [self.view addSubview:tmp];
    [tmp startAnimating];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    if (we_targetView == targetViewMainPage) we_targetView = targetViewNone;
    if (we_targetView == targetViewConsultingRoom) [self.tabBarController setSelectedIndex:weTabBarIdConsultingRoom];
    if (we_targetView == targetViewPersonalCenter) [self.tabBarController setSelectedIndex:weTabBarIdPersonalCenter];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
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
