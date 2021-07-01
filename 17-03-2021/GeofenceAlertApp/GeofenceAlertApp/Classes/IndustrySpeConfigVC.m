//
//  IndustrySpeConfigVC.m
//  GeofenceAlertApp
//
//  Created by Ashwin on 10/14/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import "IndustrySpeConfigVC.h"
#import "UIFloatLabelTextField.h"


@interface IndustrySpeConfigVC ()<UITextFieldDelegate,RadioButtonDelegate>
{
    UIFloatLabelTextField * txtBLEscanInterval ,*txtBLEscanTime;
    NSMutableArray *arrRadioBtns;
}
@end
@implementation IndustrySpeConfigVC
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
    [lblTitle setText:@"Industry-Specific Configuration"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGRegular size:textSize-1]];
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
//    [btnSaveCh setBackgroundImage:[UIImage imageNamed:@"BTN.png"] forState:UIControlStateNormal];
    [btnSaveCh setTitle:@"Save" forState:UIControlStateNormal];
    [btnSaveCh setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btnSaveCh addTarget:self action:@selector(btnSaveChClick) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnSaveCh];
 
    
    int ya = 70;

    txtBLEscanInterval = [[UIFloatLabelTextField alloc] initWithFrame:CGRectMake(10, ya, DEVICE_WIDTH-20, 50)];
    [txtBLEscanInterval setBackgroundColor:[UIColor clearColor]];
    [txtBLEscanInterval setTextColor:[UIColor whiteColor]];
    [txtBLEscanInterval setFont:[UIFont fontWithName:CGRegular size:textSize]];
    [txtBLEscanInterval setTextAlignment:NSTextAlignmentLeft];
    txtBLEscanInterval.placeholder = @"Enter BLE scan interval";
    txtBLEscanInterval.layer.borderColor = UIColor.lightGrayColor.CGColor;
    txtBLEscanInterval.layer.borderWidth = 0.5;
    txtBLEscanInterval.layer.cornerRadius = 4;
    [APP_DELEGATE getPlaceholderText:txtBLEscanInterval andColor:UIColor.whiteColor];
    txtBLEscanInterval.returnKeyType = UIReturnKeyNext;
    txtBLEscanInterval.delegate = self;
//    [self.view addSubview:txtBLEscanInterval];
    
     
    txtBLEscanTime = [[UIFloatLabelTextField alloc] initWithFrame:CGRectMake(10, ya+60, DEVICE_WIDTH-20, 50)];
    [txtBLEscanTime setBackgroundColor:[UIColor clearColor]];
    [txtBLEscanTime setTextColor:[UIColor whiteColor]];
    [txtBLEscanTime setFont:[UIFont fontWithName:CGRegular size:textSize]];
    [txtBLEscanTime setTextAlignment:NSTextAlignmentLeft];
    txtBLEscanTime.placeholder = @"Enter BLE scan time";
    [APP_DELEGATE getPlaceholderText:txtBLEscanTime andColor:UIColor.whiteColor];
    txtBLEscanTime.layer.borderColor = UIColor.lightGrayColor.CGColor;
    txtBLEscanTime.layer.borderWidth = 0.5;
    txtBLEscanTime.layer.cornerRadius = 4;
    txtBLEscanTime.returnKeyType = UIReturnKeyDone;
    txtBLEscanTime.delegate= self;
//    [self.view addSubview:txtBLEscanTime];
    
    

    /*NSMutableArray *  arrayData = [[NSMutableArray alloc] init];
    NSString * sqlquery = [NSString stringWithFormat:@"select * from tbl_industryspecific"];
    [[DataBaseManager dataBaseManager] execute:sqlquery resultsArray:arrayData];*/

        NSArray * arrItems = [NSArray arrayWithObjects:@"Off", @"Cellular ON",@"Satellite ON", nil];
        NSArray * arrHeadding = [NSArray arrayWithObjects:@"Flight mode",@"Garage mode", @"GIGO mode",@"Depth and temperature mode", nil];
        NSArray *  arrDatabaseKye = [NSArray arrayWithObjects:@"flight_mode",@"garage_mode", @"gigo_mode",@"depthtemp_mode", nil];

        int yt = 70;
        int ySwitch = 0;
        arrRadioBtns = [[NSMutableArray alloc] init];
    
        for (int i = 0; i< [arrHeadding count]; i++)
        {
            
            UIView * switchView = [[UIView alloc] initWithFrame:CGRectMake(10, yt + ySwitch, DEVICE_WIDTH - 20, 80)];
            switchView.layer.masksToBounds = YES;
            switchView.layer.borderColor = [UIColor grayColor].CGColor;
            switchView.layer.borderWidth = 0.6;
            switchView.layer.cornerRadius = 12;
            [self.view addSubview:switchView];
            
            UILabel *lblMenu = [[UILabel alloc] initWithFrame:CGRectMake(10,0, switchView.frame.size.width - 20, 30)];
            lblMenu.text = [arrHeadding objectAtIndex:i];
            lblMenu.textColor= UIColor.whiteColor;
    //        lblMenu.numberOfLines = 2;
            lblMenu.font = [UIFont fontWithName:CGRegular size:textSize-1];
            [switchView addSubview:lblMenu];
            
            RadioButtonClass * globalRadioButtonClass = [[RadioButtonClass alloc] init];
            globalRadioButtonClass.viewTag = 500 + i;
            globalRadioButtonClass.delegate = self;
                
                /*if ([arrayData count] > 0)
                {
                    NSInteger selectedIndex = [self getIndexfromValue:[[arrayData objectAtIndex:0] valueForKey:[arrDatabaseKye objectAtIndex:i]]];
                    [globalRadioButtonClass setButtonFrame:CGRectMake(10, 30, switchView.frame.size.width - 10 , 50) withNumberofItems:arrItems withSelectedIndex:selectedIndex];
                }
                else*/
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
}
-(NSInteger)getIndexfromValue:(NSString *)strValue
{
     if ([strValue isEqualToString:@"0"])
    {
        return 0;
    }
    else if ([strValue isEqualToString:@"1"])
    {
        return 1;
    }
    else if ([strValue isEqualToString:@"2"])
    {
        return 2;
    }
    else
    return -1;
}
#pragma mark - Textfield Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtBLEscanInterval)
    {
        [txtBLEscanTime becomeFirstResponder];
    }
    else if (textField == txtBLEscanTime)
    {
        [txtBLEscanTime resignFirstResponder];
    }
    return textField;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}
#pragma mark - Radio Button Delegate
-(void)RadioButtonClickEventDelegate:(NSInteger)selectedIndex withRadioButton:(NSInteger)radioBtnTag;
{
    NSInteger currentIndex = radioBtnTag - 500;

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
          else if (selectedIndex == 2)
          {
              strValue = @"2";
          }
            [[arrRadioBtns objectAtIndex:currentIndex] setValue:strValue forKey:@"selection"];
  }
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
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)btnSaveChClick
{
        [APP_DELEGATE startHudProcess:@"saving..."];
        [self InsertingtoDatabase:arrRadioBtns];
}
-(void)InsertingtoDatabase:(NSMutableArray *)arrydata
{
    NSString * strFlightMode = @"";
    NSString * strgarageMode = @"";
    NSString * strgigoMode = @"";
    NSString * strdepthandtempMode = @"";
        
    NSMutableArray *  tmpArray = [[NSMutableArray alloc] init];
    NSString * sqlquery = [NSString stringWithFormat:@"select * from tbl_industryspecific"];
    [[DataBaseManager dataBaseManager] execute:sqlquery resultsArray:tmpArray];
    

    for (int i = 0; i< [arrydata count]; i++)
    {
        NSLog(@"=========>>>>Index=%d     Selection==%@",i, [[arrydata objectAtIndex:i] valueForKey:@"selection"]);

        if ([[[arrydata objectAtIndex:i] valueForKey:@"index"] isEqual:@"0"])
        {
            strFlightMode = [[arrydata objectAtIndex:i] valueForKey:@"selection"];
        }
        else if ([[[arrydata objectAtIndex:i] valueForKey:@"index"] isEqual:@"1"])
        {
            strgarageMode = [[arrydata objectAtIndex:i] valueForKey:@"selection"];
        }
        else if ([[[arrydata objectAtIndex:i] valueForKey:@"index"] isEqual:@"2"])
        {
            strgigoMode = [[arrydata objectAtIndex:i] valueForKey:@"selection"];
        }
        else if ([[[arrydata objectAtIndex:i] valueForKey:@"index"] isEqual:@"3"])
        {
            strdepthandtempMode = [[arrydata objectAtIndex:i] valueForKey:@"selection"];
        }
    }
    NSArray * arrFirstOpcode = [NSArray arrayWithObjects:strFlightMode, strgarageMode, strgigoMode, strdepthandtempMode, nil];
    [self WriteIndustryConfigurationtoDevice:arrFirstOpcode];
    /*if (tmpArray.count > 0)
    {
        strIndustryConfigQuery =  [NSString stringWithFormat:@"update tbl_industryspecific set flight_mode = \"%@\",garage_mode = \"%@\",gigo_mode = \"%@\",depthtemp_mode = \"%@\"",strFlightMode,strgarageMode,strgigoMode,strdepthandtempMode];
        [[DataBaseManager dataBaseManager] executeSw:strIndustryConfigQuery];
    }
    else
    {
         strIndustryConfigQuery =  [NSString stringWithFormat:@"insert into 'tbl_industryspecific'('flight_mode','garage_mode','gigo_mode','depthtemp_mode') values(\"%@\",\"%@\",\"%@\",\"%@\")",strFlightMode,strgarageMode,strgigoMode,strdepthandtempMode];
        [[DataBaseManager dataBaseManager] executeSw:strIndustryConfigQuery];
    }*/
}
-(void)WriteIndustryConfigurationtoDevice:(NSArray *)arrData
{
    NSInteger intCommand = [@"194" integerValue];
    NSData * dataCommand = [[NSData alloc] initWithBytes:&intCommand length:1];

    NSInteger intLength = 4;
    NSData * dataLength = [[NSData alloc] initWithBytes:&intLength length:1];
    
    NSMutableData *completeData = [dataCommand mutableCopy];
    [completeData appendData:dataLength];
    
    for (int i =0 ; i < [arrData count]; i++)
    {
        NSInteger intPacket = [[arrData objectAtIndex:i] integerValue];
        NSData *  dataPacket = [[NSData alloc] initWithBytes:&intPacket length:1];
        [completeData appendData:dataPacket];
    }
    
    [[BLEService sharedInstance] WriteNSDataforEncryptionAndthenSendtoPeripheral:completeData withPeripheral:classPeripheral];
}
- (BOOL)isAllDigits:(NSString *)strTexr
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [strTexr rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound && strTexr.length > 0;
}
-(void)ReceviedSuccesResponseFromDevice:(NSString *)strResponse
{
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
    [APP_DELEGATE endHudProcess];
    if ([strResponse isEqualToString:@"0101"])
    {
        [self showSuccesMessage:@"Industry-Specfic configuration svaed"];
    }
    else
    {
        [self showCautionMessage:@"Faied to configure device Please try agin later"];
    }
        });
}
@end
