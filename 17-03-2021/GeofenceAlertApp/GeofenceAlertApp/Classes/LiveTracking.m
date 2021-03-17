//
//  LiveTracking.m
//  GeofenceAlertApp
//
//  Created by Vithamas Technologies on 26/12/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import "LiveTracking.h"

@interface LiveTracking ()

@end

@implementation LiveTracking

- (void)viewDidLoad
{
    [self setNavigationViewFrames];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Set Frames
-(void)setNavigationViewFrames
{
    int yy = 44;
    if (IS_IPHONE_X)
    {
        yy = 44;
    }

    UIImageView * imgLogo = [[UIImageView alloc] init];
    imgLogo.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    imgLogo.image = [UIImage imageNamed:@"Splash_bg.png"];
    imgLogo.userInteractionEnabled = YES;
    [self.view addSubview:imgLogo];
    
    UIView * viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, yy + globalStatusHeight)];
    [viewHeader setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:viewHeader];
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, globalStatusHeight, DEVICE_WIDTH-100, yy)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"Wi-Fi Configuration"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGRegular size:textSize+2]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
     UIButton * btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
     [btnBack setFrame:CGRectMake(0, 20, 60, yy)];
     [btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
     [btnBack setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
     btnBack.backgroundColor = UIColor.clearColor;
     btnBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
     [viewHeader addSubview:btnBack];
    
    UIButton * btnSaveCh = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSaveCh setFrame:CGRectMake((DEVICE_WIDTH-70), 15, 60, 44)];
    [btnSaveCh setTitle:@"Save" forState:UIControlStateNormal];
    [btnSaveCh setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btnSaveCh addTarget:self action:@selector(btnSaveChClick) forControlEvents:UIControlEventTouchUpInside];
//    [viewHeader addSubview:btnSaveCh];



}
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:true];
}
@end
