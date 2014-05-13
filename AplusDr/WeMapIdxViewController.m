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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (we_targetView == targetViewConsultingRoom) [self.tabBarController setSelectedIndex:weTabBarIdConsultingRoom];
    if (we_targetView == targetViewPersonalCenter) [self.tabBarController setSelectedIndex:weTabBarIdPersonalCenter];
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
