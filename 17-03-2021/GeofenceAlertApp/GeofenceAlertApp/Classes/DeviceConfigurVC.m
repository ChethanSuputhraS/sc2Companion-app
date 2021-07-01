//
//  DeviceConfigurVC.m
//  GeofenceAlertApp
//
//  Created by Ashwin on 10/12/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import "DeviceConfigurVC.h"
#import "RadioButtonClass.h"
#import "UIFloatLabelTextField.h"
#import "FCAlertView.h"

@interface DeviceConfigurVC ()<UITextFieldDelegate,FCAlertViewDelegate, RadioButtonDelegate>
{
    UIFloatLabelTextField * txtfld;
    UILabel *lblMenu;
    NSString *strTextFieldEnterd;
    NSMutableArray * arrRadioBtns;
    NSTimer * timerConfig;
}
@end

@implementation DeviceConfigurVC
@synthesize classPeripheral;

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = true;
    
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

    [self setNavigationViewFrames];
    
    if (classPeripheral.state == CBPeripheralStateConnected)
    {
        [timerConfig invalidate];
        timerConfig = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timeOutforFetchConfig) userInfo:nil repeats:NO];
        [APP_DELEGATE startHudProcess:@"Fetching Configuration..."];
        [self GetDeviceConfiguration:@"1"];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Set Frames
-(void)setNavigationViewFrames
{
    int yy = 20;
    if (IS_IPHONE_X)
    {
        yy = 44;
    }
    scrlContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, yy + 44, DEVICE_WIDTH, DEVICE_HEIGHT - yy - 44)];
    scrlContent.showsVerticalScrollIndicator = NO;
    scrlContent.scrollEnabled = true;
    [self.view addSubview:scrlContent];
    [scrlContent setContentSize:CGSizeMake(DEVICE_WIDTH, 1200)];
        
    UIView * viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, yy + 44)];
    [viewHeader setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:viewHeader];
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, yy, DEVICE_WIDTH-100, 44)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"Device Configuration"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGRegular size:textSize+2]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
    UIButton * btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, yy, 60, 44)];
    [btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
    [btnBack setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    btnBack.backgroundColor = UIColor.clearColor;
    btnBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [viewHeader addSubview:btnBack];

    UIButton * btnSaveCh = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSaveCh setFrame:CGRectMake((DEVICE_WIDTH-70), yy, 60, 44)];
    [btnSaveCh setTitle:@"Save" forState:UIControlStateNormal];
    [btnSaveCh setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btnSaveCh addTarget:self action:@selector(btnSaveChClick) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnSaveCh];
    
    NSMutableArray *  arrayData = [[NSMutableArray alloc] init];
    NSString * sqlquery = [NSString stringWithFormat:@"select * from tbl_DeviceConfig"];
    [[DataBaseManager dataBaseManager] execute:sqlquery resultsArray:arrayData];
      
        NSArray *   arrNote = [NSArray arrayWithObjects:@"GSM Interval in seconds", @"GSM timeout in seconds", @"GPS Interval in seconds",@"GPS timeout in seconds",@"Satellite Interval in seconds",@"Satellite Timeout in seconds",@"Cheapest Mode Multiplier", nil];

    
    NSArray * arrPlacehOlder = [NSArray arrayWithObjects:@"Enter GSM Interval", @"Enter GSM Timeout", @"Enter GPS Interval",@"Enter GPS Timeout",@"Enter Satellite Interval",@"Enter Satellite Timeout",@"Enter Cheapest multiplier", nil];
    
    if ([arrayData count] > 0)
    {
        NSString * gsm_interval = [[arrayData objectAtIndex:0] valueForKey:@"gsm_interval"];
        NSString * gsm_timeout = [[arrayData objectAtIndex:0] valueForKey:@"gsm_timeout"];
        NSString * gps_interval = [[arrayData objectAtIndex:0] valueForKey:@"gps_interval"];
        NSString * gps_timeout = [[arrayData objectAtIndex:0] valueForKey:@"gps_timeout"];
        NSString * satellite_interval = [[arrayData objectAtIndex:0] valueForKey:@"satellite_interval"];
        NSString * satellite_timeout = [[arrayData objectAtIndex:0] valueForKey:@"satellite_timeout"];
        NSString * cheapest_multiplier = [[arrayData objectAtIndex:0] valueForKey:@"cheapest_multiplier"];
        
        arrPlacehOlder = [NSArray arrayWithObjects:gsm_interval, gsm_timeout, gps_interval,gps_timeout,satellite_interval,satellite_timeout,cheapest_multiplier, nil];
    }
    
    int cnt = 100;
    int yt = 0;

    for (int i = 0; i<[arrPlacehOlder count]; i++)
    {
        UILabel *  lblMenu = [[UILabel alloc] initWithFrame:CGRectMake(20,yt, DEVICE_WIDTH-40, 44)];
        lblMenu.text = [arrPlacehOlder objectAtIndex:i];
        lblMenu.textColor= UIColor.whiteColor;
        lblMenu.numberOfLines = 0;
        lblMenu.tag = (cnt * 2) + i;
        lblMenu.font = [UIFont fontWithName:CGRegular size:textSize-1];
        [scrlContent addSubview:lblMenu];
                
        UIButton * btnFortxtFld = [[UIButton alloc] initWithFrame:CGRectMake(10, yt, DEVICE_WIDTH-20, 44)];
        btnFortxtFld.backgroundColor = UIColor.clearColor;
        btnFortxtFld.alpha = 0.6;
        btnFortxtFld.layer.cornerRadius = 4;
        btnFortxtFld.clipsToBounds = true;
        btnFortxtFld.tag = cnt+i;
        btnFortxtFld.layer.borderColor = UIColor.lightGrayColor.CGColor;
        btnFortxtFld.layer.borderWidth = 0.5;
        [btnFortxtFld addTarget:self action:@selector(btnTxtField:) forControlEvents:UIControlEventTouchUpInside];
        [scrlContent addSubview:btnFortxtFld];
        
        UILabel * lblNote  = [[UILabel alloc] initWithFrame:CGRectMake(10, yt + 40, DEVICE_WIDTH-20, 45)];
        lblNote.text = [arrNote objectAtIndex:i];
        lblNote.textColor = UIColor.lightGrayColor;
        lblNote.backgroundColor = UIColor.clearColor;
        lblNote.clipsToBounds = true;
        lblNote.layer.cornerRadius = 5;
        lblNote.numberOfLines = 2;
        lblNote.font = [UIFont fontWithName:CGRegularItalic size:textSize-3];
        [scrlContent addSubview:lblNote];

        if (i== 1 || i == 3 || i == 4 || i == 5 )
        {
            lblNote.frame = CGRectMake(10, yt + 40, DEVICE_WIDTH-20, 25);
            yt = yt + 45 + 40;
        }
        else
        {
            yt = yt + 45 + 55;
        }
    }
    NSArray * arrItems = [NSArray arrayWithObjects:@"on", @"off",@"unchanged", nil];
    NSArray * arrHeadding = [NSArray arrayWithObjects:@"Cheapest mode",@"Ultra low power mode", @"USB download mode",@"Iridium always on",@"Iridium events on",@"Instant tamper",@"Waypoint on movement", nil];
    NSArray * arrDatabaseKye = [NSArray arrayWithObjects:@"chepest_mode",@"ultrapower_mode",@"usb_mode",@"iridium_on",@"iridium_events_on",@"instant_tamper", @"waypoint_on", nil];

    yt = yt + 20;
    arrRadioBtns = [[NSMutableArray alloc] init];
    
    int ySwitch = 0;
    for (int i = 0; i< [arrHeadding count]; i++)
    {
        UIView * switchView = [[UIView alloc] initWithFrame:CGRectMake(10, yt + ySwitch, DEVICE_WIDTH - 20, 80)];
        switchView.layer.masksToBounds = YES;
        switchView.layer.borderColor = [UIColor grayColor].CGColor;
        switchView.layer.borderWidth = 0.6;
        switchView.layer.cornerRadius = 12;
        switchView.tag = 9999 +  i;
        [scrlContent addSubview:switchView];
        
        UILabel *lblMenu = [[UILabel alloc] initWithFrame:CGRectMake(10,0, switchView.frame.size.width - 20, 30)];
        lblMenu.text = [arrHeadding objectAtIndex:i];
        lblMenu.textColor= UIColor.whiteColor;
        lblMenu.font = [UIFont fontWithName:CGRegular size:textSize];
        [switchView addSubview:lblMenu];
        
        RadioButtonClass * globalRadioButtonClass = [[RadioButtonClass alloc] init];
        globalRadioButtonClass.viewTag = 500 + i;
        globalRadioButtonClass.delegate = self;
        
        if ([arrayData count] > 0)
        {
            NSInteger selectedIndex = [self getIndexfromValue:[[arrayData objectAtIndex:0] valueForKey:[arrDatabaseKye objectAtIndex:i]]];
            [globalRadioButtonClass setButtonFrame:CGRectMake(10, 30, switchView.frame.size.width - 10 , 50) withNumberofItems:arrItems withSelectedIndex:selectedIndex];
        }
        else
        {
            [globalRadioButtonClass setButtonFrame:CGRectMake(10, 30, switchView.frame.size.width - 10 , 50) withNumberofItems:arrItems withSelectedIndex:-1];
        }
        [switchView addSubview:globalRadioButtonClass];

        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[arrHeadding objectAtIndex:i] forKey:@"name"];
        [dict setValue:[NSString stringWithFormat:@"%d",i] forKey:@"index"];
        [dict setValue:@"255" forKey:@"selection"];
        [arrRadioBtns addObject:dict];
        
        ySwitch = ySwitch + 100;
    }
    [scrlContent setContentSize:CGSizeMake(DEVICE_WIDTH, yt + ySwitch + 20)];
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
#pragma mark - Button Click Events
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)btnSaveChClick
{
    [APP_DELEGATE startHudProcess:@"Saving..."];
    [self InsertingtoDatabaseOnlyRadioButtons:arrRadioBtns];
}
-(void)btnTxtField:(id)sender
{
    UIButton * tmpBtn = (UIButton *)sender;
    UILabel * lbltemp = [self.view viewWithTag:tmpBtn.tag + 100];

    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.delegate = self;
    alert.tag =tmpBtn.tag;
    alert.colorScheme = [UIColor colorWithRed:44.0/255.0f green:62.0/255.0f blue:80.0/255.0f alpha:1.0];
    UITextField * customField = [[UITextField alloc] init];
    customField.tag =  9000 +  tmpBtn.tag;
    customField.placeholder = lbltemp.text;
    customField.keyboardType = UIKeyboardTypeNumberPad;
    
    
    if (![[self checkforValidString:lbltemp.text] isEqualToString:@"NA"])
    {
        if ([lbltemp.text rangeOfString:@"Enter"].location == NSNotFound )
        {
            if ([lbltemp.text  isEqual: @"65535"])
            {
                customField.text = @"";
            }
            else
            {
                customField.text = lbltemp.text;
            }
        }
    }
    [customField becomeFirstResponder];
    [alert addTextFieldWithCustomTextField:customField andPlaceholder:nil andTextReturnBlock:^(NSString *text)
    {
    }];
    [alert addButton:@"Cancel" withActionBlock:^
    {
    }];
    [alert showAlertInView:self
                 withTitle:@"SC2 Companian App"
              withSubtitle:@"Save your device configuration"
           withCustomImage:nil
       withDoneButtonTitle:OK_BTN
                andButtons:nil];
}
#pragma mark :- FCAlertview Delegate Methods
- (void)FCAlertView:( FCAlertView *)alertView clickedButtonIndex:(NSInteger)index buttonTitle:(NSString *)title;
{
}
- (void)FCAlertDoneButtonClicked:(FCAlertView *)alertView;
{
    if (![[self checkforValidString:alertView.strTextfieldText] isEqualToString:@"NA"])
    {
        if (alertView.tag >= 9000)
        {
            NSInteger currentTag = alertView.tag - 9000;
            UILabel * lbltemp = [self.view viewWithTag:currentTag + 100];
            lbltemp.text = alertView.strTextfieldText;
        }
        else
        {
            UILabel * lbltemp = [self.view viewWithTag:alertView.tag + 100];
            lbltemp.text = alertView.strTextfieldText;
        }
    }
    NSLog(@"Alertview Texfield Done===%@",alertView.strTextfieldText);
}
-(NSString *)checkforValidString:(NSString *)strRequest
{
    NSString * strValid;
    if (![strRequest isEqual:[NSNull null]])
    {
        if (strRequest != nil && strRequest != NULL && ![strRequest isEqualToString:@""])
        {
            strValid = strRequest;
        }
        else
        {
            strValid = @"NA";
        }
    }
    else
    {
        strValid = @"NA";
    }
    return strValid;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:true];
}
-(void)showErrorMessage:(NSString *)strMessage
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeWarning];
    [alert showAlertInView:self
                 withTitle:@"SC2 Companion App"
              withSubtitle:strMessage
           withCustomImage:[UIImage imageNamed:@"logo.png"]
       withDoneButtonTitle:nil
                andButtons:nil];
}
-(void)showTypeSuccessMessage:(NSString *)strMessage
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
#pragma mark - Radio Button Delegate
-(void)RadioButtonClickEventDelegate:(NSInteger)selectedIndex withRadioButton:(NSInteger)radioBtnTag;
{
    NSInteger currentIndex = radioBtnTag - 500;

    if (arrRadioBtns.count > currentIndex)
    {
        NSString * strValue = @"1";
        
        if (selectedIndex == 1)
        {
            strValue = @"0";
        }
        else if (selectedIndex == 2)
        {
            strValue = @"255";
        }
        [[arrRadioBtns objectAtIndex:currentIndex] setValue:strValue forKey:@"selection"];
    }
}
#pragma mark - Database Method
-(void)InsertingtoDatabaseOnlyRadioButtons:(NSMutableArray *)arrayData
{
    if (classPeripheral.state == CBPeripheralStateConnected)
    {
         NSString * strcheapMode = @"NA";
         NSString * strultraLowMode = @"NA";
         NSString * strUSBMode = @"NA";
         NSString * strIridiumAlwaysON = @"NA";
         NSString * strIridiumEventON = @"NA";
         NSString * strinstantTamper = @"NA";
         NSString * strwaypointON = @"NA";
         NSString * strDeivceConfigQuery = @"NA";
         
         NSString * strGsm_interval = @"NA";
         NSString * strGsm_timeout = @"NA";
         NSString * strGps_interval = @"NA";
         NSString * strGps_timeout = @"NA";
         NSString * strSatelite_interval = @"NA";
         NSString * strSatelite_timeout = @"NA";
         NSString * strCheapest_Multiplier = @"NA";
         
         for (int i = 0; i< [arrayData count]; i++)       //7 Textfields & 7 Radio Buttons
         {
             UILabel * tmpLabel = [self.view viewWithTag:200 + i];
             NSLog(@"=========>>>>>%d      ==%@",[self isAllDigits:tmpLabel.text], tmpLabel.text);
             NSString * strText = @"65535";// == ffff //
             
             if ([self isAllDigits:tmpLabel.text] == YES)
             {
                 strText = tmpLabel.text;
             }
             if ([[[arrayData objectAtIndex:i] valueForKey:@"index"] isEqual:@"0"])
             {
                 strcheapMode = [[arrayData objectAtIndex:i] valueForKey:@"selection"];
                 strGsm_interval = strText;
             }
             else if ([[[arrayData objectAtIndex:i] valueForKey:@"index"] isEqual:@"1"])
             {
                 strultraLowMode = [[arrayData objectAtIndex:i] valueForKey:@"selection"];
                 strGsm_timeout = strText;
             }
             else if ([[[arrayData objectAtIndex:i] valueForKey:@"index"] isEqual:@"2"])
             {
                 strUSBMode = [[arrayData objectAtIndex:i] valueForKey:@"selection"];
                 strGps_interval = strText;
             }
             else if ([[[arrayData objectAtIndex:i] valueForKey:@"index"] isEqual:@"3"])
             {
                 strIridiumAlwaysON = [[arrayData objectAtIndex:i] valueForKey:@"selection"];
                 strGps_timeout = strText;
             }
             else if ([[[arrayData objectAtIndex:i] valueForKey:@"index"] isEqual:@"4"])
             {
                 strIridiumEventON = [[arrayData objectAtIndex:i] valueForKey:@"selection"];
                 strSatelite_interval = strText;
             }
             else if ([[[arrayData objectAtIndex:i] valueForKey:@"index"] isEqual:@"5"])
             {
                 strinstantTamper = [[arrayData objectAtIndex:i] valueForKey:@"selection"];
                 strSatelite_timeout = strText;
             }
             else if ([[[arrayData objectAtIndex:i] valueForKey:@"index"] isEqual:@"6"])
             {
                 strwaypointON = [[arrayData objectAtIndex:i] valueForKey:@"selection"];
                 strCheapest_Multiplier = strText;
             }
         }

         NSArray * arrFirstOpcode = [NSArray arrayWithObjects:strGsm_interval, strGsm_timeout, strGps_interval, strGps_timeout, strSatelite_interval, strSatelite_timeout, strCheapest_Multiplier, nil];
         
         NSArray * arrSecondOpcode = [NSArray arrayWithObjects:strcheapMode, strultraLowMode, strUSBMode, strIridiumAlwaysON, strIridiumEventON, strinstantTamper, strwaypointON, nil];

        
         NSMutableArray *  tmpArray = [[NSMutableArray alloc] init];
          NSString * sqlquery = [NSString stringWithFormat:@"select * from tbl_DeviceConfig"];
          [[DataBaseManager dataBaseManager] execute:sqlquery resultsArray:tmpArray];
         
         if (tmpArray.count > 0)
         {
             strDeivceConfigQuery =  [NSString stringWithFormat:@"update tbl_DeviceConfig set chepest_mode = \"%@\",ultrapower_mode = \"%@\",usb_mode = \"%@\",iridium_on = \"%@\",iridium_events_on = \"%@\", instant_tamper = \"%@\", waypoint_on = \"%@\", gsm_interval = \"%@\",gsm_timeout = \"%@\", gps_interval = \"%@\", gps_timeout = \"%@\", satellite_interval = \"%@\", satellite_timeout = \"%@\", cheapest_multiplier = \"%@\"",strcheapMode,strultraLowMode,strUSBMode,strIridiumAlwaysON,strIridiumEventON,strinstantTamper,strwaypointON,strGsm_interval,strGsm_timeout,strGps_interval,strGps_timeout,strSatelite_interval, strSatelite_timeout,strCheapest_Multiplier];
             [[DataBaseManager dataBaseManager] executeSw:strDeivceConfigQuery];
         }
         else
         {
             strDeivceConfigQuery =  [NSString stringWithFormat:@"insert into 'tbl_DeviceConfig'('chepest_mode','ultrapower_mode','usb_mode','iridium_on','iridium_events_on','instant_tamper', 'waypoint_on','gsm_interval','gsm_timeout','gps_interval','gps_timeout','satellite_interval','satellite_timeout', 'cheapest_multiplier') values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",strcheapMode,strultraLowMode,strUSBMode,strIridiumAlwaysON,strIridiumEventON,strinstantTamper,strwaypointON,strGsm_interval,strGsm_timeout,strGps_interval,strGps_timeout,strSatelite_interval, strSatelite_timeout,strCheapest_Multiplier];
             [[DataBaseManager dataBaseManager] executeSw:strDeivceConfigQuery];
         }
         
         NSLog(@"Data Saving Query=====%@",strDeivceConfigQuery);

        [self WriteDeviceConfigurationtoDevice:@"1" withDataArray:arrFirstOpcode];

        [self performSelector:@selector(WriteSecondOpcodeAfterDelay:) withObject:arrSecondOpcode afterDelay:0];
    }
    else
    {
        [self showErrorMessage:@"Device Disconnected. Please connect first."];
    }
}

- (BOOL)isAllDigits:(NSString *)strTexr
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [strTexr rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound && strTexr.length > 0;
}
-(void)ReceviedSuccesResponseFromDevice:(NSString *)strResponse
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [APP_DELEGATE endHudProcess];
        if ([strResponse isEqualToString:@"0101"])
        {
            [self showTypeSuccessMessage:@"Device configuration svaed"];
        }
        else
        {
            [self showErrorMessage:@"Faied to configure device Please try agin later"];
        }
    });
}

#pragma mark: - BLE Methods
-(void)WriteSecondOpcodeAfterDelay:(NSArray *)arrData
{
    [self WriteDeviceConfigurationtoDevice:@"2" withDataArray:arrData];
}
-(void)WriteDeviceConfigurationtoDevice:(NSString *)strOpcode withDataArray:(NSArray *)arrData
{
    NSInteger intCommand = [@"193" integerValue];
    NSData * dataCommand = [[NSData alloc] initWithBytes:&intCommand length:1];

    NSInteger intOpCode = [strOpcode integerValue];
    NSData * dataOpcode = [[NSData alloc] initWithBytes:&intOpCode length:1];

    NSInteger intLength = 14;// 13 previously
    BOOL isOpcodefirst = YES;
    if ([strOpcode isEqualToString:@"2"])
    {
        intLength = 8; // 7
        isOpcodefirst = NO;
    }
    NSData * dataLength = [[NSData alloc] initWithBytes:&intLength length:1];
        
    NSMutableData *completeData = [dataCommand mutableCopy];
    [completeData appendData:dataLength];
    [completeData appendData:dataOpcode];

    if (isOpcodefirst == YES)
    {
        for (int i =0 ; i < [arrData count]; i++)
        {
            NSInteger intPacket = [[arrData objectAtIndex:i] integerValue];
            NSData *  dataPacket = [[NSData alloc] initWithBytes:&intPacket length:2];
            if (i == 6)
            {
                dataPacket = [[NSData alloc] initWithBytes:&intPacket length:1];
            }
            [completeData appendData:dataPacket];
        }
        [[BLEService sharedInstance] WriteNSDataforEncryptionAndthenSendtoPeripheral:completeData withPeripheral:classPeripheral];
    }
    else
    {
        for (int i =0 ; i < [arrData count]; i++)
        {
            NSInteger intPacket = [[arrData objectAtIndex:i] integerValue];
            NSData *  dataPacket = [[NSData alloc] initWithBytes:&intPacket length:1];
            [completeData appendData:dataPacket];
        }
        [[BLEService sharedInstance] WriteNSDataforEncryptionAndthenSendtoPeripheral:completeData withPeripheral:classPeripheral];
    }
}
-(void)GetDeviceConfiguration:(NSString *)strOpcode
{
    NSInteger intCommand = [@"193" integerValue];
    NSData * dataCommand = [[NSData alloc] initWithBytes:&intCommand length:1];

    NSInteger intOpCode = [strOpcode integerValue];
    NSData * dataOpcode = [[NSData alloc] initWithBytes:&intOpCode length:1];

    NSInteger intLength = 1;// 13 previously
    NSData * dataLength = [[NSData alloc] initWithBytes:&intLength length:1];
        
    NSMutableData *completeData = [dataCommand mutableCopy];
    [completeData appendData:dataLength];
    [completeData appendData:dataOpcode];

    [[BLEService sharedInstance] WriteNSDataforEncryptionAndthenSendtoPeripheral:completeData withPeripheral:classPeripheral];
}
-(void)setDeviceConfigurationValuetoUI:(NSArray *)arrData withType:(NSString *)strType
{
    dispatch_async(dispatch_get_main_queue(), ^{
    if ([strType isEqualToString:@"01"])
    {
        for (int i = 0 ; i < [arrData count]; i++)
        {
            NSString * strText = [arrData objectAtIndex:i];
            UILabel * lbltemp = [self.view viewWithTag:i + 200];
            lbltemp.text = strText;
            if ([[strText lowercaseString] isEqualToString:@"ffff"] || [[strText lowercaseString] isEqualToString:@"65535"])//65535
            {
                lbltemp.text = @"";
            }
        }
        [self GetDeviceConfiguration:@"2"];
    }
    else if ([strType isEqualToString:@"02"])
    {
        for (int i = 0 ; i < [arrData count]; i++)
        {
            UIView * tmpView = [self.view viewWithTag:9999 +i];
            NSArray * arr = [tmpView subviews];
            
            for (int j = 0; j < arr.count; j++)
            {
                id objct = [arr objectAtIndex:j];
                if ([objct isKindOfClass:[RadioButtonClass class]])
                {
                    if ([[arrData objectAtIndex:i] isEqualToString:@"1"])
                    {
                        [objct SetButtonSelectedwithIndex:1 withObject:objct];
                    }
                    else if ([[arrData objectAtIndex:i] isEqualToString:@"0"])
                    {
                        [objct SetButtonSelectedwithIndex:0 withObject:objct];
                    }
                    else if ([[arrData objectAtIndex:i] isEqualToString:@"255"])
                    {
                        [objct SetButtonSelectedwithIndex:2 withObject:objct];
                    }
                }
            }
        }
        [timerConfig invalidate];
        timerConfig = nil;
    }
});
}

-(void)TestingMethod
{
    NSString * valueStr = @"C1080200FFFF000000FF";
    //  0xC1 0x0E 0x01 0x02 0x58 0x02 0x58 0x00 0x00 0x01 0x2C 0x00 0x00 0x01 0x2C 0x00
    //  0xC1 0x08 0x02 0x00 0xFF 0xFF 0x00 0x00 0x00 0xFF
    {
        if ([valueStr length] > 6)
        {
            NSString * strC1PacketType =  [valueStr substringWithRange:NSMakeRange(2, 2)];
            if ([strC1PacketType isEqualToString:@"01"]) //For C1 Write Status
            {
                NSString * strSuccessResponse = [valueStr substringWithRange:NSMakeRange(2, 4)];
                if ([strSuccessResponse isEqualToString:@"0101"])
                {
                    [globalDeviceConfig ReceviedSuccesResponseFromDevice:strSuccessResponse];
                }
                else
                {
                    [globalDeviceConfig ReceviedSuccesResponseFromDevice:strSuccessResponse];
                }
            }
            else //For Recieving device configuration
            {
                if ([strC1PacketType isEqualToString:@"0E"] || [strC1PacketType isEqualToString:@"0e"])
                {
                    if ([valueStr length] >= 32)
                    {
                        NSString * str1 = [self stringFroHex:[valueStr substringWithRange:NSMakeRange(6, 4)]];
                        NSString * str2 = [self stringFroHex:[valueStr substringWithRange:NSMakeRange(10,4)]];
                        NSString * str3 = [self stringFroHex:[valueStr substringWithRange:NSMakeRange(14,4)]];
                        NSString * str4 = [self stringFroHex:[valueStr substringWithRange:NSMakeRange(18,4)]];
                        NSString * str5 = [self stringFroHex:[valueStr substringWithRange:NSMakeRange(22,4)]];
                        NSString * str6 = [self stringFroHex:[valueStr substringWithRange:NSMakeRange(26,4)]];
                        NSString * str7 = [self stringFroHex:[valueStr substringWithRange:NSMakeRange(30,2)]];
                        NSArray * arrData = [[NSArray alloc] initWithObjects:str1,str2,str3,str4,str5,str6,str7, nil];
                        [globalDeviceConfig setDeviceConfigurationValuetoUI:arrData withType:@"01"];
                    }
                }
                else if ([strC1PacketType isEqualToString:@"08"] )
                {
                    if ([valueStr length] >= 20)
                    {
                        NSString * str1 = [self stringFroHex:[valueStr substringWithRange:NSMakeRange(6, 2)]];
                        NSString * str2 = [self stringFroHex:[valueStr substringWithRange:NSMakeRange(8,2)]];
                        NSString * str3 = [self stringFroHex:[valueStr substringWithRange:NSMakeRange(10,2)]];
                        NSString * str4 = [self stringFroHex:[valueStr substringWithRange:NSMakeRange(12,2)]];
                        NSString * str5 = [self stringFroHex:[valueStr substringWithRange:NSMakeRange(14,2)]];
                        NSString * str6 = [self stringFroHex:[valueStr substringWithRange:NSMakeRange(16,2)]];
                        NSString * str7 = [self stringFroHex:[valueStr substringWithRange:NSMakeRange(18,2)]];
                        NSArray * arrData = [[NSArray alloc] initWithObjects:str1,str2,str3,str4,str5,str6,str7, nil];
                        [globalDeviceConfig setDeviceConfigurationValuetoUI:arrData withType:@"02"];
                    }
                }
                
            }
        }
    }
}
-(NSString*)stringFroHex:(NSString *)hexStr
{
    unsigned long long startlong;
    NSScanner* scanner1 = [NSScanner scannerWithString:hexStr];
    [scanner1 scanHexLongLong:&startlong];
    double unixStart = startlong;
    NSNumber * startNumber = [[NSNumber alloc] initWithDouble:unixStart];
    return [startNumber stringValue];
}
-(void)timeOutforFetchConfig
{
    [APP_DELEGATE endHudProcess];
}

@end


