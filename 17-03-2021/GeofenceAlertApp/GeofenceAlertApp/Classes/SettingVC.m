//
//  SettingVC.m
//  GeofenceAlertApp
//
//  Created by Ashwin on 8/31/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import "SettingVC.h"
#import "SettingCell.h"
#import "BLEManager.h"
#import "FCAlertView.h"
#import "RadioButtonClass.h"
#import "DeviceConfigurVC.h"
#import "SIMconfigurVC.h"
#import "ServerConfigVC.h"
#import "IndustrySpeConfigVC.h"
#import "WifiSetupVC.h"

@import iOSDFULibrary;


@interface SettingVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UIDocumentPickerDelegate,LoggerDelegate,DFUServiceDelegate,DFUProgressDelegate,DFUPeripheralSelectorDelegate>
{
    UIView * viewBGPicker;
    UIPickerView * pickerSetting;
    NSString *selectedTime;
    NSMutableArray * arrayPickr;
    CBPeripheral * classPeripheral;
    NSTimer * buzzerTimer;
    BOOL isAckReceieved;
    NSMutableArray * arrAPNList;
     NSIndexPath * selectedIndex;

}
@end

@implementation SettingVC
@synthesize classPeripheral;
- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = true;
    self.view.backgroundColor = UIColor.blackColor;
    
    [self setNavigationViewFrames];
    arrayPickr =[[NSMutableArray alloc]initWithObjects:@"1 sec",@"2 sec",@"3 sec",@"4 sec",@"5 sec",@"6 sec",@"7 sec",@"8 sec",@"9 sec",@"10 sec", nil];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [APP_DELEGATE hideTabBar:self.tabBarController];
    [super viewWillAppear:YES];
    [tblSetting reloadData];
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
    [lblTitle setText:@"Settings"];
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
    
    tblSetting = [[UITableView alloc] initWithFrame:CGRectMake(0, yy+globalStatusHeight+1, DEVICE_WIDTH, DEVICE_HEIGHT-yy-globalStatusHeight)];
    tblSetting.delegate = self;
    tblSetting.dataSource= self;
    tblSetting.backgroundColor = UIColor.clearColor;
    tblSetting.separatorStyle = UITableViewCellSelectionStyleNone;
    tblSetting.hidden = false;
    tblSetting.scrollEnabled = false;
    [self.view addSubview:tblSetting];
    
}
#pragma mark-Tableview method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tblSetting)
    {
         return 9;
    }
    else if (tableView == tblListOfAPN)
    {
        return arrAPNList.count;
    }
    return 0;
    // array have to pass
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblSetting)
    {
         return 55;
    }
    else if (tableView == tblListOfAPN)
    {
        return 40;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellReuseIdentifier = @"cellIdentifier";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (cell == nil)
    {
        cell = [[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }

    [cell.swReconnect addTarget:self action:@selector(SwitchVlueChange:) forControlEvents:UIControlEventValueChanged];
    
    if (tableView == tblSetting)
    {
        if (indexPath.row == 0)
        {
            cell.lblForSetting.text = @"Set buzzer time interval";
            cell.lblSetValue.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"SetTimeInterval"];
        }
        else if (indexPath.row == 1)
        {
            cell.imgArrow.hidden = true;
            cell.swReconnect.hidden = false;
            cell.lblForSetting.text = @"Re-connect Device Enable";
              
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"BLEAutoconnect"] == true)//Kalpesh26062021
            {
                [cell.swReconnect setOn:YES animated:YES];
            }
            else
            {
                [cell.swReconnect setOn:NO animated:YES];
            }
        }
        else if (indexPath.row == 2)
        {
            cell.lblForSetting.text = @"Set Device configuration";
        }
        else if (indexPath.row == 3)
        {
             cell.lblForSetting.text = @"Set SIM configuration";
        }
        else if (indexPath.row == 4)
        {
             cell.lblForSetting.text = @"Set server configuraton";
        }
        else if (indexPath.row == 5)
        {
             cell.lblForSetting.text = @"Industry-Specific Configuration";
        }
        else if (indexPath.row == 6)
        {
            cell.lblForSetting.text = @"Wi-Fi Configuration";
        }
        else if (indexPath.row == 7)
        {
            cell.lblForSetting.text = @"Reset device";
        }
        else if (indexPath.row == 8)
        {
            cell.lblForSetting.text = @"Update firmware";
        }
    }
    else if (tableView == tblListOfAPN)
    {
        NSMutableDictionary * tmpDict = [[NSMutableDictionary alloc] init];

        [cell.lblForSetting setFont:[UIFont fontWithName:CGRegular size:textSize-2]];
        cell.lblForSetting.text = [arrAPNList objectAtIndex:indexPath.row];
        
         if([[tmpDict valueForKey:@"isSelected"] isEqualToString:@"1"])
         {
             cell.accessoryType = UITableViewCellAccessoryCheckmark;
             cell.tintColor = UIColor.whiteColor;
         }
        else
        {
             cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
        cell.backgroundColor = UIColor.clearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
 }
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblSetting)
    {
         if (indexPath.row == 0)
           {
               [self setupForSettingPicker];
               [APP_DELEGATE hideTabBar:self.tabBarController];
               [super viewWillAppear:YES];
           }
        else if (indexPath.row == 2)
          {
              globalDeviceConfig = [[DeviceConfigurVC alloc] init];
              globalDeviceConfig.classPeripheral = classPeripheral;
              [self.navigationController pushViewController:globalDeviceConfig animated:true];
          }
           else if (indexPath.row == 3)
           {
               globalSIMvc = [[SIMconfigurVC alloc] init];
               globalSIMvc.classPeripheral = classPeripheral;
               [self.navigationController pushViewController:globalSIMvc animated:true];
//               [self SetupForAPNConfiguration];
           }
           else if (indexPath.row == 4)
            {
                globalServerConfig = [[ServerConfigVC alloc] init];
                globalServerConfig.classPeripheral = classPeripheral;
                [self.navigationController pushViewController:globalServerConfig animated:true];
            }
           else if (indexPath.row == 5)
            {
                globalIndustVC = [[IndustrySpeConfigVC alloc] init];
                globalIndustVC.classPeripheral = classPeripheral;
                [self.navigationController pushViewController:globalIndustVC animated:true];
            }
         else if (indexPath.row == 6)
           {
               globalWiFiVC = [[WifiSetupVC alloc] init];
               globalWiFiVC.classPeripheral = classPeripheral;
               [self.navigationController pushViewController:globalWiFiVC animated:true];
           }
        else if (indexPath.row == 7)
          {
                [self AlertForReset];
          }
        else if (indexPath.row == 8)
        {
            [self OpenFileManager];
        }
    }
    else if (tableView == tblSetting)
    {
        NSMutableDictionary * tmpDict = [[NSMutableDictionary alloc] init];
        tmpDict = [arrAPNList objectAtIndex:indexPath.row];

        [tmpDict setValue:@"0" forKey:@"isSelected"];
    }
    
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6)
    {
          [self ShowPicker:NO andView:viewBGPicker];
    }
    [super viewWillAppear:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    if (tableView == tblListOfAPN)
    {
             UIView * headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, tblListOfAPN.frame.size.width, 55)];
                headerView.backgroundColor = [UIColor clearColor];
                
                UILabel *lblmenu=[[UILabel alloc]init];
                lblmenu.frame = CGRectMake(0,0, DEVICE_WIDTH, 35);
                lblmenu.text = @"Select to setup SIM configuration";
                [lblmenu setTextColor:[UIColor whiteColor]];
                [lblmenu setFont:[UIFont fontWithName:CGRegular size:textSize-2]];
                lblmenu.backgroundColor = UIColor.blackColor;
                lblmenu.textAlignment = NSTextAlignmentCenter;
                [headerView addSubview:lblmenu];
                return headerView;
    }
   return tableView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == tblListOfAPN)
    {
        return 35;
    }
    else
    {
        return 0;
    }
        return 0; //41
}
#pragma mark - Animations
-(void)ShowPicker:(BOOL)isShow andView:(UIView *)myView
{
    int viewHeight = 250;
    if (IS_IPHONE_4)
    {
        viewHeight = 230;
    }
    if (isShow == YES)
    {
        [UIView transitionWithView:myView duration:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [myView setFrame:CGRectMake(0, DEVICE_HEIGHT-viewHeight,DEVICE_WIDTH, viewHeight)];
            }
                        completion:^(BOOL finished)
            {
         }];
    }
    else
    {
        [UIView transitionWithView:myView duration:0.4 options:UIViewAnimationOptionTransitionNone animations:^{
            [myView setFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, viewHeight)];
            }
                        completion:^(BOOL finished)
            {
         }];
    }
}
-(void)setupForSettingPicker
{
    [viewBGPicker removeFromSuperview];
    viewBGPicker = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 250)];
    [viewBGPicker setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:viewBGPicker];
    
    [pickerSetting removeFromSuperview];
    pickerSetting = nil;
    pickerSetting.delegate=nil;
    pickerSetting.dataSource=nil;
    pickerSetting = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 34, DEVICE_WIDTH, 216)];
    [pickerSetting setBackgroundColor:[UIColor blackColor]];
    pickerSetting.tag=123;
    [pickerSetting setDelegate:self];
    [pickerSetting setDataSource:self];
    NSInteger indexSelctTemp = [[NSUserDefaults standardUserDefaults] integerForKey:@"IndexTime"];
    [pickerSetting selectRow:indexSelctTemp inComponent:0 animated:YES];

    [viewBGPicker addSubview:pickerSetting];
    
//    UILabel * lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, viewListBattry.frame.size.width, 1)];
//    lblLine.backgroundColor = UIColor.lightGrayColor;
//    [viewListBattry addSubview:lblLine];
    
    UIButton * btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(0 , 0, DEVICE_WIDTH, 44)];
    [btnDone setBackgroundImage:[UIImage imageNamed:@"BTN.png"] forState:UIControlStateNormal];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.titleLabel.font = [UIFont fontWithName:CGRegular size:textSize];
    [btnDone setTag:123];
    [btnDone addTarget:self action:@selector(btnDoneClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewBGPicker addSubview:btnDone];
    
  [self ShowPicker:YES andView:viewBGPicker];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arrayPickr.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
     return [arrayPickr objectAtIndex:row];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;

    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textAlignment=NSTextAlignmentCenter;
        pickerLabel.font = [UIFont fontWithName:CGRegular size:textSize];
        pickerLabel.textColor = UIColor.whiteColor;
    }
    [pickerLabel setText:[arrayPickr objectAtIndex:row]];

    return pickerLabel;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedTime = [arrayPickr objectAtIndex:row];
}
-(void)BuzzerTimeAcknowledgementfromDevice:(NSString *)strStatus;
{
    if ([strStatus  isEqual: @"00"])
    {
        [self TostNotification:@"Invalid"];
    }
    else
    {
        [self TostNotification:@"Buzzer timer set"];
    }
}

-(void)selctedIndexTime:(NSString *)strTempSelect
{
    if ([strTempSelect isEqual:@"1 sec"])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"IndexTime"];
    }
   else if ([strTempSelect isEqual:@"2 sec"])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"IndexTime"];
    }
    else if ([strTempSelect isEqual:@"3 sec"])
     {
         [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"IndexTime"];
     }
    else if ([strTempSelect isEqual:@"4 sec"])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"IndexTime"];
    }
    else if ([strTempSelect isEqual:@"5 sec"])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"IndexTime"];
    }
    else if ([strTempSelect isEqual:@"6 sec"])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"IndexTime"];
    }
    else if ([strTempSelect isEqual:@"7 sec"])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:6 forKey:@"IndexTime"];
    }
    else if ([strTempSelect isEqual:@"8 sec"])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:7 forKey:@"IndexTime"];
    }
    else if ([strTempSelect isEqual:@"9 sec"])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:8 forKey:@"IndexTime"];
    }
    else if ([strTempSelect isEqual:@"10 sec"])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:9 forKey:@"IndexTime"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self ShowPicker:NO andView:viewBGPicker];
}

-(void)TostNotification:(NSString *)StrToast
{
    [buzzerTimer invalidate];
    isAckReceieved = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [APP_DELEGATE endHudProcess];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = StrToast;
            hud.margin = 10.f;
            hud.yOffset = 150.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:0.9];
        });
}
#pragma mark - Timer Methods
-(void)buzzerTimeoutMethod
{
    [buzzerTimer invalidate];
    [APP_DELEGATE endHudProcess];
    if (isAckReceieved == NO)
    {
        [self AlertViewFCTypeCaution:@"Something went wrong. Please try again later."];
    }
}
-(void)SwitchVlueChange:(id)sender
{
     UISwitch *RecntSwitch = (UISwitch *)sender;
    
       if ([RecntSwitch isOn])
              {
                  isReconnect = true;
                  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BLEAutoconnect"];//Kalpesh26062021
                  [self TostNotification:@"Device Re-Connect Enabled"];
              }
              else
              {
                  isReconnect = false;
                  [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"BLEAutoconnect"];//Kalpesh26062021
                  [self TostNotification:@"Device Re-Connect Disabled"];
              }
}
-(void)AlertViewFCTypeCaution:(NSString *)strPopup
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeCaution];
    [alert showAlertInView:self
                 withTitle:@"SC2 Companion App"
              withSubtitle:strPopup
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
-(void)AlertForReset
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeWarning];
    [alert addButton:@"Yes" withActionBlock:
     ^{
    // ble commoned to reset the device 01 01 01
        
            NSInteger intCommand = [@"197" integerValue];
            NSData * dataCommand = [[NSData alloc] initWithBytes:&intCommand length:1];

            NSInteger intLength = 1;
            NSData * dataLength = [[NSData alloc] initWithBytes:&intLength length:1];
            
            NSInteger dataInt = 1;
            NSData * msgData = [[NSData alloc] initWithBytes:&dataInt length:1];

            NSMutableData *completeData = [dataCommand mutableCopy];
            [completeData appendData:dataLength];
            [completeData appendData:msgData];
        [[BLEService sharedInstance] WriteNSDataforEncryptionAndthenSendtoPeripheral:completeData withPeripheral:self->classPeripheral];
     }];
    [alert showAlertInView:self
                 withTitle:@"SC2 Companion App"
              withSubtitle:@"Are you sure want to Reset device?"
           withCustomImage:[UIImage imageNamed:@"Subsea White 180.png"]
       withDoneButtonTitle:@"Cancel" andButtons:nil];
}
-(void)SetupForAPNConfiguration
{
    viewAPNConifg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    viewAPNConifg.backgroundColor = [UIColor colorWithRed:0 green:(CGFloat)0 blue:0 alpha:0.8];
    [self.view addSubview:viewAPNConifg];

    viewAPNList = [[UIView alloc]initWithFrame:CGRectMake(20, (DEVICE_HEIGHT), DEVICE_WIDTH-40, DEVICE_HEIGHT-40)];
    viewAPNList.backgroundColor = UIColor.clearColor;
    viewAPNList.layer.cornerRadius = 6;
    viewAPNList.clipsToBounds = true;
    [viewAPNConifg addSubview:viewAPNList];

    UIView * viewForBgAllSnr = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewAPNList.frame.size.width, 50)];
    viewForBgAllSnr.backgroundColor = UIColor.blackColor; //[UIColor colorWithRed:24.0/255 green:(CGFloat)157.0/255 blue:191.0/255 alpha:1];
    [viewAPNList addSubview:viewForBgAllSnr];
    
    lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewAPNList.frame.size.width-100, 60)];
    [self setLabelProperties:lblHeader withText:@"Select to setup SIM configuration" backColor:UIColor.clearColor textColor:UIColor.whiteColor textSize:textSize-2];
    lblHeader.textAlignment = NSTextAlignmentCenter;
//    [viewForBgAllSnr addSubview:lblHeader];

 

    UIButton *btnCancelSlSnr = [[UIButton alloc]initWithFrame:CGRectMake(5, 0, 100, 60)];
    [self setButtonProperties:btnCancelSlSnr withTitle:@"Cancel" backColor:UIColor.clearColor textColor:UIColor.whiteColor txtSize:textSize];
    
    [btnCancelSlSnr addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    btnCancelSlSnr.layer.cornerRadius = 5;
    [viewForBgAllSnr addSubview:btnCancelSlSnr];

    UIButton *btnSelectOk = [[UIButton alloc]initWithFrame:CGRectMake(viewAPNList.frame.size.width-60, 0, 50, 60)];
    [self setButtonProperties:btnSelectOk withTitle:@"Save" backColor:UIColor.clearColor textColor:UIColor.whiteColor txtSize:textSize];
    [btnSelectOk addTarget:self action:@selector(btnSaveClick) forControlEvents:UIControlEventTouchUpInside];
    [viewForBgAllSnr addSubview:btnSelectOk];
    
    
    tblListOfAPN = [[UITableView alloc]initWithFrame: CGRectMake(0, 125, viewAPNList.frame.size.width, viewAPNList.frame.size.height-250) style:UITableViewStylePlain];
    tblListOfAPN.frame = CGRectMake(0, 60, viewAPNList.frame.size.width, viewAPNList.frame.size.height-255);
    tblListOfAPN.backgroundColor = UIColor.clearColor;
    tblListOfAPN.delegate= self;
    tblListOfAPN.dataSource = self;
    [viewAPNList addSubview:tblListOfAPN];

   [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^
       {
           self->viewAPNList.frame = CGRectMake(20, 125, DEVICE_WIDTH-40, DEVICE_HEIGHT-240);
           [self->tblListOfAPN reloadData];
       }
                   completion:NULL];
}
-(void)btnCancelClick
{
    [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^
    {
        self-> viewAPNList.frame = CGRectMake(20, DEVICE_HEIGHT, DEVICE_WIDTH-40, DEVICE_HEIGHT-40);
    }
                    completion:(^(BOOL finished)
    {
                    [self-> viewAPNConifg removeFromSuperview];
    })];
}
-(void)btnSaveClick
{

    [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^
    {
        self->viewAPNList.frame = CGRectMake(20, DEVICE_HEIGHT, DEVICE_WIDTH-40, DEVICE_HEIGHT-240);
        [self->tblListOfAPN reloadData];
        [self->viewAPNConifg removeFromSuperview];
    }
                    completion:NULL];
}
-(void)btnBackClick
{
    isAckReceieved = YES;
    [self.navigationController popViewControllerAnimated:true];
}
-(void)btnDoneClicked
{
    if ([[APP_DELEGATE checkforValidString:selectedTime] isEqualToString:@"NA"])
    {
        NSInteger index = [pickerSetting selectedRowInComponent:0];
        
        if (index == -1)
        {
            selectedTime = [NSString stringWithFormat:@"%ld",(long)index];
        }
        else
        {
            selectedTime = [arrayPickr objectAtIndex:0];
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:selectedTime  forKey:@"SetTimeInterval"];
     [tblSetting reloadData];
    
    [self ShowPicker:NO andView:viewBGPicker];
    [APP_DELEGATE hideTabBar:self.tabBarController];
    
    [APP_DELEGATE startHudProcess:@"Setting time..."];
    [super viewWillAppear:YES];
    [self selctedIndexTime:selectedTime];
    
    if (classPeripheral.state == CBPeripheralStateConnected)
    {
        isAckReceieved = NO;
        [buzzerTimer invalidate];
        buzzerTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(buzzerTimeoutMethod) userInfo:nil repeats:NO];
        [[BLEService sharedInstance] SetTimerForBuzzer:selectedTime withPeripheral:classPeripheral];
    }
    
    [tblSetting reloadData];
   }
-(void)setLabelProperties:(UILabel *)lbl withText:(NSString *)strText backColor:(UIColor *)backColor textColor:(UIColor *)txtColor textSize:(int)txtSize
{
    lbl.text = strText;
    lbl.textColor = txtColor;
    lbl.backgroundColor = backColor;
    lbl.clipsToBounds = true;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.layer.cornerRadius = 5;
    lbl.font = [UIFont fontWithName:@"Helvetica Neue" size:txtSize];
}
-(void)setButtonProperties:(UIButton *)btn withTitle:(NSString *)strText backColor:(UIColor *)backColor textColor:(UIColor *)txtColor txtSize:(int)txtSize
{
    [btn setTitle:strText forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:txtSize];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitleColor:txtColor forState:UIControlStateNormal];
    btn.backgroundColor = backColor;
    btn.clipsToBounds = true;
}
-(void)ReceviedSuccesResponseFromDevice:(NSString *)strResponse
{
    dispatch_async(dispatch_get_main_queue(), ^{
    [APP_DELEGATE endHudProcess];
    if ([strResponse isEqualToString:@"0101"])
    {
        [self showTypeSuccessMessage:@"Reset Done"];
    }
    else
    {
        [self AlertViewFCTypeCaution:@"Faied to reset the device Please try agin later"];
    }
    });
}
#pragma mark - Write Configuration to Device
-(void)WriteStartPackettoDevicewithtotalPackets
{
    NSInteger intCommond = [@"197" integerValue];
    NSData * dataOpCmd = [[NSData alloc] initWithBytes:&intCommond length:1];
    
    NSInteger intPacketType = [@"1" integerValue];
    NSData * dataPacketType = [[NSData alloc] initWithBytes:&intPacketType length:1];

    NSInteger intLength = [@"1" integerValue];
    NSData * dataLength = [[NSData alloc] initWithBytes:&intLength length:1];


    NSMutableData *completeData = [dataOpCmd mutableCopy];
    [completeData appendData:dataLength];
    [completeData appendData:dataPacketType];

    [[BLEService sharedInstance] WriteNSDataforEncryptionAndthenSendtoPeripheral:completeData withPeripheral:classPeripheral];
}
#pragma mark-DFU  Firmaware update
-(void)OpenFileManager
{
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.item"]
                      inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;

    [self presentViewController:documentPicker animated:YES completion:nil];
}
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls
{
    NSLog(@"FilePath======>>>>>>>%@",urls);
    
    NSString * result = [[urls valueForKey:@"description"] componentsJoinedByString:@""];//description
    NSString * strfilePath =  [result substringWithRange:NSMakeRange(8, result.length-8)];
    
    NSURL *uRL = [NSURL URLWithString:strfilePath];
    DFUFirmware *selectedFirmware = [[DFUFirmware alloc] initWithUrlToZipFile:uRL type:DFUFirmwareTypeApplication];
    NSLog(@"Selected Firmware========>>>>>>>%@",selectedFirmware);
  
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    DFUServiceInitiator *initiator = [[DFUServiceInitiator alloc] initWithQueue:queue];
    [initiator withFirmware:selectedFirmware];
    
    initiator.logger = self; //
    initiator.delegate = self; //
    initiator.progressDelegate = self;
    DFUServiceController * controller1 = [initiator startWithTarget:classPeripheral];
    [APP_DELEGATE startHudProcess:@"Updating..."];

}
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    
}
- (void)dfuStateDidChangeTo:(enum DFUState)state
{
    
}
- (void)dfuProgressDidChangeFor:(NSInteger)part outOf:(NSInteger)totalParts to:(NSInteger)progress currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond
{
    
}
- (void)dfuError:(enum DFUError)error didOccurWithMessage:(NSString *)message
{
    
}
-(void)logWith:(enum LogLevel)level message:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
    NSLog(@"LogWith Message=%@",message);
    
//    if ([[APP_DELEGATE checkforValidString:message] isEqualToString:@"=Upload completed in"])
//    {
        [APP_DELEGATE endHudProcess];
//    }
    });
}
@end
