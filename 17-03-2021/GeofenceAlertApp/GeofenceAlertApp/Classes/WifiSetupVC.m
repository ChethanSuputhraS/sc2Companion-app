//
//  WifiSetupVC.m
//  GeofenceAlertApp
//
//  Created by Ashwin on 11/3/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import "WifiSetupVC.h"

@interface WifiSetupVC ()<RadioButtonDelegate>
{
    NSMutableArray  * arrRadioBtns;
}
@end

@implementation WifiSetupVC
@synthesize classPeripheral;
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
     [btnBack setFrame:CGRectMake(10, 20, 60, yy)];
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
    [viewHeader addSubview:btnSaveCh];

    NSMutableArray *  arrEnableWifi = [[NSMutableArray alloc] initWithObjects:@"Disable",@"Enable",@"No change", nil];
//      NSMutableArray * arrFirmware = [[NSMutableArray alloc] initWithObjects:@"logg_ing",@"firm_ware",@"No_change", nil];
    
   
    
    arrRadioBtns = [[NSMutableArray alloc] init];
    

//    [self SetupViewwithRadiobuttons:arrEnableWifi withTag:500 withY:60 withHintText:@"Enable/Disable Wifi"];

//    [self SetupViewwithRadiobuttons:arrFirmware withTag:503 withY:170 withHintText:@"Wifi logging/firmware update"];
    
    NSMutableArray * arrHeadding = [[NSMutableArray alloc] initWithObjects:@"Enable/Disable Wifi",@"Wifi logging/firmware update", nil];

    
    int yt = 70;
    int ySwitch = 0;
    
    for (int i = 0; i< [arrHeadding count]; i++)
    {
        UIView * switchView = [[UIView alloc] initWithFrame:CGRectMake(5, yt + ySwitch, DEVICE_WIDTH - 10, 80)];
        switchView.layer.masksToBounds = YES;
        switchView.layer.borderColor = [UIColor grayColor].CGColor;
        switchView.layer.borderWidth = 0.6;
        switchView.layer.cornerRadius = 12;
        [self.view addSubview:switchView];
        
        UILabel *lblMenu = [[UILabel alloc] initWithFrame:CGRectMake(10,0, switchView.frame.size.width - 20, 30)];
        lblMenu.text = [arrHeadding objectAtIndex:i];
        lblMenu.textColor= UIColor.whiteColor;
        lblMenu.font = [UIFont fontWithName:CGRegular size:textSize-1];
        [switchView addSubview:lblMenu];
            
        RadioButtonClass * globalRadioButtonClass = [[RadioButtonClass alloc] init];
        globalRadioButtonClass.viewTag = 500 + i;
        globalRadioButtonClass.delegate = self;
        [globalRadioButtonClass setButtonFrame:CGRectMake(10, 30, switchView.frame.size.width - 10 , 50) withNumberofItems:arrEnableWifi withSelectedIndex:-1];
        [switchView addSubview:globalRadioButtonClass];
        
        ySwitch = ySwitch + 100;

    }
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"255" forKey:@"selection"];
    [arrRadioBtns addObject:dict];
    
}
-(void)SetupViewwithRadiobuttons:(NSMutableArray *)arrOptions withTag:(int)tagValue withY:(int)yy withHintText:(NSString *)strText
{

}
-(NSInteger)getIndexfromValue:(NSString *)strValue
{
    if ([strValue isEqualToString:@"255"])
    {
        return 2;
    }
    else if ([strValue isEqualToString:@"0"])
    {
        return 1;
    }
    else if ([strValue isEqualToString:@"1"])
    {
        return 0;
    }
    return -1;
}
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)btnSaveChClick
{
//    NSLog(@"Saved Result here=%@",arrRadioBtns);
    [APP_DELEGATE startHudProcess:@"Saving..."];
    [self WriteIndustryConfigurationtoDevice:arrRadioBtns];
}
-(void)showSuccesMessage:(NSString *)strMessage
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeSuccess];
    [alert showAlertInView:self
                 withTitle:@"SC2 Companion App"
              withSubtitle:strMessage
           withCustomImage:[UIImage imageNamed:@"logo.png"]
       withDoneButtonTitle:nil
                andButtons:nil];
}
-(void)showCautionMessage:(NSString *)strMessage
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeCaution];
    [alert showAlertInView:self
                 withTitle:@"SC2 Companion App"
              withSubtitle:strMessage
           withCustomImage:[UIImage imageNamed:@"logo.png"]
       withDoneButtonTitle:nil
                andButtons:nil];
}
#pragma mark - Radio Button Delegate
-(void)RadioButtonClickEventDelegate:(NSInteger)selectedIndex withRadioButton:(NSInteger)radioBtnTag;
{
    NSInteger currentIndex = 0;
    if (radioBtnTag >= 503)
    {
        currentIndex = 1;
    }
    if (arrRadioBtns.count > currentIndex)
    {
        NSString * strValue = @"255";
               
        if (selectedIndex == 0)
        {
            strValue = @"0";
        }
        else if (selectedIndex == 1)
        {
            strValue = @"1";
        }
        [[arrRadioBtns objectAtIndex:currentIndex] setValue:strValue forKey:@"selection"];
    }
}

-(void)WriteIndustryConfigurationtoDevice:(NSArray *)arrData
{
    NSInteger intCommand = [@"198" integerValue];
    NSData * dataCommand = [[NSData alloc] initWithBytes:&intCommand length:1];

    NSInteger intLength = 2;
    NSData * dataLength = [[NSData alloc] initWithBytes:&intLength length:1];
    
    NSInteger wifiEnable = 255;
    if ([[[arrRadioBtns objectAtIndex:0] valueForKey:@"selection"]isEqualToString:@"0"])
    {
        wifiEnable = 0;
    }
    else if ([[[arrRadioBtns objectAtIndex:0] valueForKey:@"selection"]isEqualToString:@"1"])
    {
        wifiEnable = 1;
    }
    NSData * dataWifi = [[NSData alloc] initWithBytes:&wifiEnable length:1];

    NSInteger wifiFirmware = 255;
    if ([[[arrRadioBtns objectAtIndex:1] valueForKey:@"selection"]isEqualToString:@"0"])
    {
        wifiFirmware = 0;
    }
    else if ([[[arrRadioBtns objectAtIndex:1] valueForKey:@"selection"]isEqualToString:@"1"])
    {
        wifiFirmware = 1;
    }
    NSData * dataWififirmware = [[NSData alloc] initWithBytes:&wifiFirmware length:1];

    NSMutableData *completeData = [dataCommand mutableCopy];
    [completeData appendData:dataLength];
    [completeData appendData:dataWifi];
    [completeData appendData:dataWififirmware];
    [[BLEService sharedInstance] WriteNSDataforEncryptionAndthenSendtoPeripheral:completeData withPeripheral:classPeripheral];
}
-(void)ReceviedSuccesResponseFromDevice:(NSString *)strResponse
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
    {
    [APP_DELEGATE endHudProcess];
    if ([strResponse isEqualToString:@"0101"])
    {
        [self showSuccesMessage:@"Wi-Fi configuration svaed"];
    }
    else
    {
        [self showCautionMessage:@"Faied to configure Wi-Fi Please try agin later"];
    }
 });
}
@end
