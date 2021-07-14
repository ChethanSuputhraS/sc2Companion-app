//
//  SIMconfigurVC.m
//  GeofenceAlertApp
//
//  Created by Ashwin on 10/13/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import "SIMconfigurVC.h"
#import "RadioButtonClass.h"
#import "SettingCell.h"
#import "URATConfigVC.h"
#import "BandConfigVC.h"

@interface SIMconfigurVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,RadioButtonDelegate, SIMBandConfigureDelegate>
{
    NSMutableArray * arrBands,*arrRadioBtns,*arrAlldata;
    NSString * selectedURAT ,*strBandValue;
    NSInteger uRATIndexselected;
    NSInteger simTypeSelection;
    NSMutableArray * arrSetSimConfig;
    RadioButtonClass * simRadioButtons;
    NSMutableArray * arruratOptions, * arrReceivedAPNSData, * arrReceivedUsernameData, * arrReceivedPassData;
    NSString * strAPNSValue, * strUsernameValue, * strPasswordValue;
    NSString * strBandList;
    NSTimer * timerConfig;
}
@end

@implementation SIMconfigurVC
@synthesize classPeripheral;
- (void)viewDidLoad
{
    arrAlldata = [[NSMutableArray alloc] init];
    arrSetSimConfig = [[NSMutableArray alloc] init];
    arrReceivedAPNSData = [[NSMutableArray alloc] init];
    arrReceivedUsernameData = [[NSMutableArray alloc] init];
    arrReceivedPassData = [[NSMutableArray alloc] init];

    [self SetDefaultConfigValuestoUI];
    
    strAPNSValue = @"NA";
    strUsernameValue = @"NA";
    strPasswordValue = @"NA";
    [self setNavigationViewFrames];
    [super viewDidLoad];
    
   /* if (classPeripheral.state == CBPeripheralStateConnected)
    {
        [timerConfig invalidate];
        timerConfig = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeOutforFetchConfig) userInfo:nil repeats:NO];
        [APP_DELEGATE startHudProcess:@"Fetching Configuration..."];
        
        [self WritetoReceiveStartPacketfromDevice];
    }*/
    // Do any additional setup after loading the view.
}
-(void)SetDefaultConfigValuestoUI
{
    NSArray *   arrFirst = [NSArray arrayWithObjects:@"sim_type", @"urat", @"band",@"address",@"username",@"password", nil];

    for (int i = 0 ; i < [arrFirst count]; i++)
    {
        if ([arrFirst count] > i)
        {
            NSMutableDictionary * tempDict = [[NSMutableDictionary alloc] init];
            [tempDict setValue:[arrFirst objectAtIndex:i] forKeyPath:@"title"];
            [tempDict setValue:@"NA" forKeyPath:@"value"];
            [tempDict setValue:@"0" forKeyPath:@"isChanaged"];
            [arrSetSimConfig addObject:tempDict];
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    
}
#pragma mark - Set Frames
-(void)setNavigationViewFrames
{
    int yy = 20;
    if (IS_IPHONE_X)
    {
        yy = 44;
    }

    UIImageView * imgLogo = [[UIImageView alloc] init];
    imgLogo.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    imgLogo.image = [UIImage imageNamed:@"Splash_bg.png"];
    imgLogo.userInteractionEnabled = YES;
    [self.view addSubview:imgLogo];
    
    UIView * viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, yy+ 44)];
    [viewHeader setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:viewHeader];
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, globalStatusHeight, DEVICE_WIDTH-100, 44)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"SIM Configuration"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGRegular size:textSize+2]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
    UIButton * btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(10, 20, 60, 44)];
    [btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
    [btnBack setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    btnBack.backgroundColor = UIColor.clearColor;
    btnBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [viewHeader addSubview:btnBack];
    
    UIButton * btnSaveCh = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSaveCh setFrame:CGRectMake((DEVICE_WIDTH-70), 20, 60, 44)];
    [btnSaveCh setTitle:@"Save" forState:UIControlStateNormal];
    [btnSaveCh setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btnSaveCh addTarget:self action:@selector(btnSaveChClick) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnSaveCh];
    
    NSArray * arraySim = [NSArray arrayWithObjects:@"E-SIM",@"Nano SIM", nil];
    arrRadioBtns = [[NSMutableArray alloc] init];

    int yt = 70;

    if (IS_IPHONE_X)
    {
        [btnBack setFrame:CGRectMake(10, 44, 60, 44)];
        [btnSaveCh setFrame:CGRectMake((DEVICE_WIDTH-70), 44, 60, 44)];
        yt = yy+44;
    }
    
    simRadioButtons = [[RadioButtonClass alloc] init];
    simRadioButtons.viewTag = 500;
    simRadioButtons.delegate = self;
    [simRadioButtons setButtonFrame:CGRectMake(20, yt, DEVICE_WIDTH-40, 50) withNumberofItems:arraySim withSelectedIndex:-1];
    [self.view addSubview:simRadioButtons];
        
    NSMutableDictionary * dictData = [[NSMutableDictionary alloc] init];
    [dictData setValue:@"" forKey:@"name"];
    [dictData setValue:@"ff" forKey:@"selection"]; // we have check with jithin
    [arrRadioBtns addObject:dictData];
    
    tblListSIMstup = [[UITableView alloc]initWithFrame: CGRectMake(0, 120, DEVICE_WIDTH, DEVICE_HEIGHT-180) style:UITableViewStylePlain];
    tblListSIMstup.frame = CGRectMake(0, 120, DEVICE_WIDTH, DEVICE_HEIGHT-120);
    tblListSIMstup.backgroundColor = UIColor.clearColor;
    tblListSIMstup.delegate= self;
    tblListSIMstup.dataSource = self;
    tblListSIMstup.separatorStyle = UITableViewCellSelectionStyleNone;
    tblListSIMstup.scrollEnabled = NO;
    [self.view addSubview:tblListSIMstup];
    
    arruratOptions =[[NSMutableArray alloc]initWithObjects:@"LTE Cat M1",@"LTE Cat NB1",@"GPRS / eGPRS",@"GPRS / eGPRS & LTE Cat NB1",@"GPRS / eGPRS & LTE Cat M1",@"LTE Cat NB1 & LTE Cat M1",@"LTE Cat NB1 & GPRS / eGPRS",@"LTE Cat M1 & LTE Cat NB1",@"LTE Cat M1 & GPRS / eGPRS",@"GPRS / eGPRS & LTE Cat NB1 & LTE Cat M1",@"GPRS / eGPRS & LTE Cat M1 & LTE Cat NB1",@"LTE Cat NB1 & GPRS / eGPRS & LTE Cat M1",@"LTE Cat NB1 & LTE Cat M1 & GPRS / eGPRS",@"LTE Cat M1 & LTE Cat NB1 & GPRS / eGPRS",@"LTE Cat M1 & GPRS / eGPRS & LTE Cat NB1", nil];

    if (IS_IPHONE_X)
    {
        tblListSIMstup.frame = CGRectMake(0, yt+50, DEVICE_WIDTH, DEVICE_HEIGHT-yt-60);
    }
    
}
#pragma mark-Tavbleview method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
    // array have to pass
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellReuseIdentifier = @"cellIdentifier";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (cell == nil)
    {
        cell = [[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    cell.txtFld.delegate = self;
    cell.txtFld.tag = indexPath.row+100;
   
    if (indexPath.row == 0)
    {
        cell.lblForSetting.text = @"URAT Configuration";
        cell.lblRightLbl.hidden = false;
        cell.lblRightLbl.text = selectedURAT;
    }
    else if (indexPath.row == 1)
    {
        cell.lblForSetting.text = @"Band Configuration";
        cell.lblRightLbl.hidden = false;
        cell.lblRightLbl.text = @"";
        if (![[self checkforValidString:strBandList] isEqualToString:@"NA"])
        {
            cell.lblRightLbl.text = strBandList;
        }
    }
    else if (indexPath.row == 2)
    {        
        cell.lblBack.backgroundColor = UIColor.clearColor;
        cell.imgArrow.hidden = true;
         cell.txtFld.hidden = false;
        cell.txtFld.placeholder = @"Enter APN address (g.scstg.net)";
        cell.txtFld.returnKeyType = UIReturnKeyNext;
        [APP_DELEGATE getPlaceholderText:cell.txtFld andColor:UIColor.whiteColor];
        if (![[self checkforValidString:strAPNSValue] isEqualToString:@"NA"])
        {
            cell.txtFld.text = strAPNSValue;
        }
    }
    else if (indexPath.row == 3)
    {
        cell.imgArrow.hidden = true;
        cell.txtFld.hidden = false;
        cell.txtFld.placeholder =@"Enter User name";
        cell.txtFld.returnKeyType = UIReturnKeyNext;
        cell.lblBack.backgroundColor = UIColor.clearColor;
        [APP_DELEGATE getPlaceholderText:cell.txtFld andColor:UIColor.whiteColor];
        if (![[self checkforValidString:strUsernameValue] isEqualToString:@"NA"])
        {
            cell.txtFld.text = strUsernameValue;
        }

    }
    else if (indexPath.row == 4)
    {
        cell.imgArrow.hidden = true;
        cell.txtFld.hidden = false;
        cell.txtFld.placeholder =@"Enter Password";
        cell.txtFld.returnKeyType = UIReturnKeyDone;
        cell.lblBack.backgroundColor = UIColor.clearColor;
        [APP_DELEGATE getPlaceholderText:cell.txtFld andColor:UIColor.whiteColor];
        if (![[self checkforValidString:strPasswordValue] isEqualToString:@"NA"])
        {
            cell.txtFld.text = strPasswordValue;
        }

    }
     
    cell.backgroundColor = UIColor.clearColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        URATConfigVC * uRt = [[URATConfigVC alloc] init];
        uRt.strUARTSelected = [APP_DELEGATE checkforValidString:selectedURAT];
        [self.navigationController pushViewController:uRt animated:true];
    }
    else if (indexPath.row == 1)
    {
        BandConfigVC * bcVC = [[BandConfigVC alloc] init];
        bcVC.delegate = self;
        bcVC.strBandValue = [APP_DELEGATE checkforValidString:strBandValue];
        [self.navigationController pushViewController:bcVC animated:true];
    }
}
#pragma mark - Textfield Delegates // 65,534
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    int arrIndex = 0;
    if (textField.tag == 102)
    {
        arrIndex = 3;
        UITextField * txtfld = [self.view viewWithTag:103];
        [txtfld becomeFirstResponder];
    }
    else if (textField.tag  == 103)
    {
        arrIndex = 4;
        UITextField * txtfld = [self.view viewWithTag:104];
        [txtfld becomeFirstResponder];
    }
    else if (textField.tag  == 104)
    {
        arrIndex = 5;
        [textField  resignFirstResponder];
    }
    
    if (arrIndex >= 0 && arrSetSimConfig.count > arrIndex)
    {
        NSString * strPreviousValue = [self checkforValidString:[[arrSetSimConfig objectAtIndex:arrIndex] valueForKey:@"value"]];
        NSString * strCurrentValue = textField.text;
        if (![strPreviousValue isEqualToString:strCurrentValue])
        {
            [[arrSetSimConfig objectAtIndex:arrIndex] setValue:@"1" forKey:@"isChanaged"];
        }
        else
        {
            [[arrSetSimConfig objectAtIndex:arrIndex] setValue:@"0" forKey:@"isChanaged"];
        }
    }

    return textField;
}

-(void)btnBackClick
{
//    [self CallTestMethod];
    [self.navigationController popViewControllerAnimated:true];
}
-(void)btnSaveChClick
{
    if ([[APP_DELEGATE checkforValidString:selectedURAT] isEqualToString:@"NA"] && bandConfigValue == 0)
    {
        //Show Popup
        FCAlertView *alert = [[FCAlertView alloc] init];
        alert.colorScheme = [UIColor blackColor];
        [alert makeAlertTypeWarning];
        [alert showAlertInView:self
                     withTitle:@"SC2 Companion App"
                  withSubtitle:@"Please provide inputs for atleast URAT and Band Configuration."
               withCustomImage:[UIImage imageNamed:@"logo.png"]
           withDoneButtonTitle:nil
                    andButtons:nil];
    }
    else
    {
        BOOL isValueChanged = NO;
        for (int i =0; i < [arrSetSimConfig count]; i++)
        {
            if ([[[arrSetSimConfig objectAtIndex:i] valueForKey:@"isChanaged"] isEqualToString:@"1"])
            {
                isValueChanged = YES;
            }
        }
        if (isValueChanged == YES)
        {
            NSLog(@"Valye Has Changed.....");
            if (classPeripheral.state == CBPeripheralStateConnected)
            {
                [APP_DELEGATE startHudProcess:@"saving..."];
                UITextField * txtAPNS = [self.view viewWithTag:102];
                UITextField * txtUsername = [self.view viewWithTag:103];
                UITextField * txtPassword = [self.view viewWithTag:104];

                if (![[APP_DELEGATE checkforValidString:txtAPNS.text] isEqualToString:@"NA"])
                {
                    NSMutableArray * arrAPNSPackets = [[NSMutableArray alloc] init];
                    NSMutableArray * arrUsernamePackets = [[NSMutableArray alloc] init];
                    NSMutableArray * arrPasswordPackets = [[NSMutableArray alloc] init];

                    NSInteger totalPackets = 0;

                    //1. Take total packets of APNS Address
                    NSString * strAPNAddress = txtAPNS.text;
                    totalPackets = [self getTotalNumberofPackets:strAPNAddress];
                    [self AddPacketstoArray:arrAPNSPackets withString:strAPNAddress withTotalPackets:totalPackets];

                    //2. Take total packets of USERNAME
                    NSString * strUsername = txtUsername.text;
                    totalPackets = [self getTotalNumberofPackets:strUsername];
                    [self AddPacketstoArray:arrUsernamePackets withString:strUsername withTotalPackets:totalPackets];

                    //3. Take total packets of PASSWORD
                    NSString * strPassword = txtPassword.text;
                    totalPackets = [self getTotalNumberofPackets:strPassword];
                    [self AddPacketstoArray:arrPasswordPackets withString:strPassword withTotalPackets:totalPackets];

                    NSLog(@"APNS Arr = %@ \nUserName =%@ \nPassword=%@",arrAPNSPackets, arrUsernamePackets,arrPasswordPackets);
                    
                    //Send Start Packet
                    totalPackets = 1 + [arrAPNSPackets count] + [arrUsernamePackets count] + [arrPasswordPackets count] + 1;
                    [self WriteStartPackettoDevicewithtotalPackets:totalPackets];//Write Start Packet with sending Total number of Packets
                    
                    //Send APNS Packets
                    [self WriteAPNSPacketToDevicewithPacketsArray:arrAPNSPackets withPacketType:@"2"];
                    
                    //Send USERNAME Packets
                    [self WriteAPNSPacketToDevicewithPacketsArray:arrUsernamePackets withPacketType:@"3"];

                    //Send PASSWORD Packets
                    [self WriteAPNSPacketToDevicewithPacketsArray:arrPasswordPackets withPacketType:@"4"];
                    
                    //Send End Packet
                    [self WriteEndPacketstoDevice];

                }
                else //If not entered APNS details then send Start & End packet details without APNS details
                {
                    //Send Start Packet
                    [self WriteStartPackettoDevicewithtotalPackets:2];//Write Start Packet with sending Total number of Packets
                    //Send End Packet
                    [self WriteEndPacketstoDevice];
                }
            }
            else
            {
                [APP_DELEGATE endHudProcess];
                [self showErrorMessage:@"Device Disconnected. Please connect first."];
            }
        }
        else
        {
            NSLog(@"Value Has Not Changed.....");
            [APP_DELEGATE endHudProcess];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(NSInteger)getTotalNumberofPackets:(NSString *)strText
{
    float lenghtFloat = [strText length];
    NSString * strLength = [NSString stringWithFormat:@"%f",lenghtFloat / 11];
    NSArray * tmpArr = [strLength componentsSeparatedByString:@"."];
    NSInteger totalPackets = 0;
    if ([tmpArr count]>1)
    {
        NSInteger afterPoint = [[tmpArr objectAtIndex:1] integerValue];
        if (afterPoint == 0)
        {
            totalPackets = [[tmpArr objectAtIndex:0] integerValue];
        }
        else
        {
            totalPackets = [[tmpArr objectAtIndex:0] integerValue] + 1;
        }
        NSLog(@"its integer=%ld",(long)afterPoint);
    }
    return totalPackets;
}
-(void)AddPacketstoArray:(NSMutableArray *)arrayPackets withString:(NSString *)strAPNAddress withTotalPackets:(NSInteger )totalPackets
{
    NSInteger totallength = [strAPNAddress length];
    for (int i = 0; i < totalPackets; i++)
    {
        if (totallength >= (i * 12) + 12)
        {
            NSString * strMsg = [strAPNAddress substringWithRange:NSMakeRange(i * 12, 12)];
            [arrayPackets addObject:strMsg];
//            NSLog(@"Greater Than PocketLength 11======%@",strMsg);
        }
        else
        {
            if ((totallength >= (i * 12)))
            {
                NSString * strMsg = [strAPNAddress substringWithRange:NSMakeRange(i * 12, totallength - (i * 12))];
                [arrayPackets addObject:strMsg];
//                NSLog(@"Msg legth satisfied  11======%@",strMsg);
            }
        }
    }
}
-(void)RecevieTheSelectedURAT:(NSString *)strSelectedURAT withIndexPath:(NSInteger)indexP
{
    NSLog(@"Chethan data%@",strSelectedURAT);
    selectedURAT = strSelectedURAT;
    uRATIndexselected = indexP;
    [tblListSIMstup reloadData];
    
    int arrIndex = 1;
    if (arrIndex >= 0 && arrSetSimConfig.count > arrIndex)
    {
        NSString * strPreviousValue = [self checkforValidString:[[arrSetSimConfig objectAtIndex:arrIndex] valueForKey:@"value"]];
        NSString * strCurrentValue = selectedURAT;
        if (![strPreviousValue isEqualToString:strCurrentValue])
        {
            [[arrSetSimConfig objectAtIndex:arrIndex] setValue:@"1" forKey:@"isChanaged"];
        }
        else
        {
            [[arrSetSimConfig objectAtIndex:arrIndex] setValue:@"0" forKey:@"isChanaged"];
        }
    }
}

#pragma mark - Radio Button Delegate
-(void)RadioButtonClickEventDelegate:(NSInteger)selectedIndex withRadioButton:(NSInteger)radioBtnTag;
{
        NSString * strValue = @"ff";
        NSString * strName = @"NA";
        
        if (selectedIndex == 0)
        {
            simTypeSelection = 0;
            strValue = @"0";
            strName = @"ESIM";
        }
        else if (selectedIndex == 1)
        {
            simTypeSelection = 1;
             strValue = @"1";
            strName = @"NanoSIM";
        }
    
    NSInteger arrIndex = 0;
    if (arrIndex >= 0 && arrSetSimConfig.count > arrIndex)
    {
        NSString * strPreviousValue = [self checkforValidString:[[arrSetSimConfig objectAtIndex:arrIndex] valueForKey:@"value"]];
        NSString * strCurrentValue = [self checkforValidString:strValue];
        if (![strPreviousValue isEqualToString:strCurrentValue])
        {
            [[arrSetSimConfig objectAtIndex:arrIndex] setValue:@"1" forKey:@"isChanaged"];
        }
        else
        {
            [[arrSetSimConfig objectAtIndex:arrIndex] setValue:@"0" forKey:@"isChanaged"];
        }
    }
    
    [arrRadioBtns setValue:strValue forKey:@"selection"];
    [arrRadioBtns setValue:strName forKey:@"name"];
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
-(void)InsertToDatabase
{
    
    NSMutableArray * arrayDatabase = [[NSMutableArray alloc] init];
    NSString * sqlquery = [NSString stringWithFormat:@"select * from tbl_SIMConfig"];
    [[DataBaseManager dataBaseManager] execute:sqlquery resultsArray:arrayDatabase];
    
    UITextField * txtfld = [self.view viewWithTag:102];
    UITextField * txtfld1= [self.view viewWithTag:103];
    UITextField * txtfld2 = [self.view viewWithTag:104];
    
    NSString * strSimtpe = [[arrRadioBtns objectAtIndex:0] valueForKey:@"name"];
    NSString * strSim = [[arrRadioBtns objectAtIndex:0] valueForKey:@"selection"];
    NSString * strURAT  = selectedURAT;
    NSString * strBandConfig = strBandValue;
    NSString * strapnAdd = txtfld.text ;
    NSString * strapnUserName = txtfld1.text ;
    NSString * strapnUsePassword = txtfld2.text ;
    NSString * straindex = [NSString stringWithFormat:@"%ld",(long)uRATIndexselected];
    NSString * strSIMConfigQuery = @"";
    
    if (arrayDatabase.count > 0)
    {
        strSIMConfigQuery =  [NSString stringWithFormat:@"update  tbl_SIMConfig set sim_type = \"%@\",sim_selection = \"%@\",urat_config = \"%@\",urat_index = \"%@\",band_config = \"%@\",apn_address = \"%@\",user_name = \"%@\",user_password =\"%@\"",strSimtpe,strSim,strURAT,straindex,strBandConfig,strapnAdd,strapnUserName,strapnUsePassword];
        [[DataBaseManager dataBaseManager] executeSw:strSIMConfigQuery];
    }
    else
    {
        strSIMConfigQuery =  [NSString stringWithFormat:@"insert into 'tbl_SIMConfig'('sim_type','sim_selection','urat_config','urat_index','band_config','apn_address','user_name','user_password') values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",strSimtpe,strSim,strURAT,straindex,strBandConfig,strapnAdd,strapnUserName,strapnUsePassword];
        [[DataBaseManager dataBaseManager] executeSw:strSIMConfigQuery];
    }

}

#pragma mark - Band Configuration Delegate Call back
-(void)SentBandConfiguration:(NSInteger )intConfigValue withArray:(nonnull NSArray *)arrData
{
    bandConfigValue = intConfigValue;
    
    strBandValue = [NSString stringWithFormat:@"%lu",(unsigned long)intConfigValue];
    strBandList = [arrData componentsJoinedByString:@","];
    [tblListSIMstup reloadData];
    
    int arrIndex = 2;
    if (arrIndex >= 0 && arrSetSimConfig.count > arrIndex)
    {
        NSString * strPreviousValue = [self checkforValidString:[[arrSetSimConfig objectAtIndex:arrIndex] valueForKey:@"value"]];
        NSString * strCurrentValue = strBandValue;
        if (![strPreviousValue isEqualToString:strCurrentValue])
        {
            [[arrSetSimConfig objectAtIndex:arrIndex] setValue:@"1" forKey:@"isChanaged"];
        }
        else
        {
            [[arrSetSimConfig objectAtIndex:arrIndex] setValue:@"0" forKey:@"isChanaged"];
        }
    }

    NSLog(@"=========Band Configuration Value====%ld",(long)intConfigValue);
}
#pragma mark - Write Configuration to Device
-(void)WriteStartPackettoDevicewithtotalPackets:(NSInteger)TotalPackets
{
    NSInteger intCommond = [@"195" integerValue];
    NSData * dataOpCmd = [[NSData alloc] initWithBytes:&intCommond length:1];
    
    NSInteger intPacketType = [@"1" integerValue];
    NSData * dataPacketType = [[NSData alloc] initWithBytes:&intPacketType length:1];

    NSInteger intLength = [@"7" integerValue];
    NSData * dataLength = [[NSData alloc] initWithBytes:&intLength length:1];

    NSData * dataPackets = [[NSData alloc] initWithBytes:&TotalPackets length:1];

    NSData * dataSim = [[NSData alloc] initWithBytes:&simTypeSelection length:1];

    NSData * dataURATs = [[NSData alloc] initWithBytes:&uRATIndexselected length:1];

    NSData * dataBandConfig = [[NSData alloc] initWithBytes:&bandConfigValue length:4];

    NSMutableData *completeData = [dataOpCmd mutableCopy];
    [completeData appendData:dataLength];
    [completeData appendData:dataPacketType];
    [completeData appendData:dataSim];
    [completeData appendData:dataURATs];
    [completeData appendData:dataBandConfig];
    
    [[BLEService sharedInstance] WriteNSDataforEncryptionAndthenSendtoPeripheral:completeData withPeripheral:classPeripheral];
}
-(void)WriteAPNSPacketToDevicewithPacketsArray:(NSMutableArray *)arrAPNSPackets withPacketType:(NSString *)strPacketType
{
    for (int i =0; i < [arrAPNSPackets count]; i++)
    {
        NSInteger reverseCount = [arrAPNSPackets count] - (i + 1);
        if ([arrAPNSPackets count] >= reverseCount)
        {
            NSInteger intCommand = [@"195" integerValue];
            NSData * dataCommand = [[NSData alloc] initWithBytes:&intCommand length:1];
            
            NSString * strPacket = [arrAPNSPackets objectAtIndex: reverseCount];
            NSInteger intPacketLength = [strPacket length] + 2;
            NSData * dataPacketLengh = [[NSData alloc] initWithBytes:&intPacketLength length:1];

            NSInteger inOpcode = [strPacketType integerValue];
            NSData * dataOpcode = [[NSData alloc] initWithBytes:&inOpcode length:1];

            NSInteger intpacketNo = reverseCount + 1;
            NSData * dataPacketNo = [[NSData alloc] initWithBytes:&intpacketNo length:1];
          
            NSData * msgData = [self dataFromHexString:[self hexFromStr:strPacket]];
            
            NSMutableData * finalData = [dataCommand mutableCopy];
            [finalData appendData:dataPacketLengh];
            [finalData appendData:dataOpcode];
            [finalData appendData:dataPacketNo];
            [finalData appendData:msgData];
            [[BLEService sharedInstance] WriteNSDataforEncryptionAndthenSendtoPeripheral:finalData withPeripheral:classPeripheral];
        }
    }
}
-(void)WriteEndPacketstoDevice
{
    NSInteger intOpCode = [@"195" integerValue];
    NSData * dataOpcode = [[NSData alloc] initWithBytes:&intOpCode length:1];
    
    NSInteger intPacketType = [@"5" integerValue];
    NSData * dataPacketType = [[NSData alloc] initWithBytes:&intPacketType length:1];

    NSInteger intLength = [@"2" integerValue];
    NSData * dataLength = [[NSData alloc] initWithBytes:&intLength length:1];

    NSInteger intLengthEnd = [@"1" integerValue];
    NSData * dataPackets = [[NSData alloc] initWithBytes:&intLengthEnd length:1];

    NSMutableData *completeData = [dataOpcode mutableCopy];
    [completeData appendData:dataLength];
    [completeData appendData:dataPacketType];
    [completeData appendData:dataPackets];
    [[BLEService sharedInstance] WriteNSDataforEncryptionAndthenSendtoPeripheral:completeData withPeripheral:classPeripheral];
}

#pragma mark - Conversation Methods
-(NSString*)hexFromStr:(NSString*)str
{
    NSData* nsData = [str dataUsingEncoding:NSUTF8StringEncoding];
    const char* data = [nsData bytes];
    NSUInteger len = nsData.length;
    NSMutableString* hex = [NSMutableString string];
    for(int i = 0; i < len; ++i)
        [hex appendFormat:@"%02X", data[i]];
    return hex;
}

- (NSData *)dataFromHexString:(NSString*)hexStr
{
    const char *chars = [hexStr UTF8String];
    int i = 0, len = hexStr.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:true];
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

-(void)ReceviedSuccesResponseFromDevice:(NSString *)strResponse
{
    dispatch_async(dispatch_get_main_queue(), ^{
    [APP_DELEGATE endHudProcess];
    if ([strResponse isEqualToString:@"0101"])
    {
        [self showTypeSuccessMessage:@"SIM Configuration applied successfully. Now SC2 Device will restart and auto connect if Re-connect is enabled. Otherwise please connect again."];
    }
    else
    {
        [self showErrorMessage:@"Faied to configure device Please try agin later"];
    }
    });
}
-(void)ReceivedFirstPacketfromDevice:(NSArray *)arrFirstPacket
{
    if ([arrFirstPacket count] >= 3)
    {
        int switchValue = [[arrFirstPacket objectAtIndex:0] intValue];
        simTypeSelection = switchValue;
        if (switchValue == 0)
        {
            
            [simRadioButtons UpdateButtonsforSIMConfiguration:0 withObject:simRadioButtons];
        }
        else
        {
            [simRadioButtons UpdateButtonsforSIMConfiguration:1 withObject:simRadioButtons];
        }

        int uRatIndex = [[arrFirstPacket objectAtIndex:1] intValue];
        if ([arruratOptions count] > uRatIndex)
        {
            selectedURAT = [arruratOptions objectAtIndex:uRatIndex];
            uRATIndexselected = uRatIndex;
        }
        
        strBandValue = [arrFirstPacket objectAtIndex:2];
        [self fetchBandsfromDecimalValue:strBandValue];
        
        [tblListSIMstup reloadData];
    }
}
-(void)ReceivedAPNSPacketfromDevice:(NSDictionary *)arrFirstPacket
{
    [arrReceivedAPNSData addObject:arrFirstPacket];
}
-(void)ReceivedUsernamePacketfromDevice:(NSDictionary *)arrFirstPacket
{
    [arrReceivedUsernameData addObject:arrFirstPacket];
}
-(void)ReceivedPasswordPacketfromDevice:(NSDictionary *)arrFirstPacket
{
    [arrReceivedPassData addObject:arrFirstPacket];
}
-(void)ReceivedEndPacketfromDevice;
{
    NSSortDescriptor * brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"PacketNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
    NSArray * arrAPNSSorted = [arrReceivedAPNSData sortedArrayUsingDescriptors:sortDescriptors];
    NSArray * arrUsernameSorted = [arrReceivedUsernameData sortedArrayUsingDescriptors:sortDescriptors];
    NSArray * arrPasswordSorted = [arrReceivedPassData sortedArrayUsingDescriptors:sortDescriptors];

    NSLog(@"APNS===%@",arrAPNSSorted);
    NSLog(@"Username===%@",arrUsernameSorted);
    NSLog(@"Password===%@",arrPasswordSorted);
    
    strAPNSValue = [self GetStringTextfromArr:arrAPNSSorted];
    
    strUsernameValue = [self GetStringTextfromArr:arrUsernameSorted];

    strPasswordValue = [self GetStringTextfromArr:arrPasswordSorted];
    
    [tblListSIMstup reloadData];
    

}
-(NSString *)GetStringTextfromArr:(NSArray *)arr
{
    NSString * strAPNS;
    for (int i = 0; i < [arr count]; i++)
    {
        if (strAPNS.length == 0)
        {
            strAPNS = [[arr objectAtIndex:i] valueForKey:@"Text"];
        }
        else
        {
            strAPNS = [strAPNS stringByAppendingString:[[arr objectAtIndex:i] valueForKey:@"Text"]];
        }
    }
    return strAPNS;
}
-(void)CallTestMethod
{
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    [arr addObject:@"c30701000000e00000"];
    [arr addObject:@"c306020469636520"];
    [arr addObject:@"c30e0203776562736974652e73657276"];
    [arr addObject:@"c30e02022e737563636f72666973682e"];
    [arr addObject:@"c30e02015363617468696e672e6e6574"];
    [arr addObject:@"c306030437383930"];
    [arr addObject:@"c30e0303353637383930313233343536"];

    
    [arr addObject:@"c30e0302333435363738393031323334"];
    [arr addObject:@"c30e0301313233343536373839303132"];
    [arr addObject:@"c3080403353637383930"];
    [arr addObject:@"c30e0402333435363738393031323334"];
    [arr addObject:@"c30e0401313233343536373839303132"];
//    [arr addObject:@"c30e0402393539353935393434393439"];
//    [arr addObject:@"c30e0401333437343835393639353935"];
    [arr addObject:@"c3020501"];

//    0xc3020501

    for (int i = 0; i < [arr count]; i++)
    {
        [self ToTestDataRecevingMethod:[arr objectAtIndex:i]];
    }
    
}
-(void)ToTestDataRecevingMethod:(NSString *)valueStr
{
    if ([valueStr length] > 6)
    {
        if ([[valueStr substringWithRange:NSMakeRange(0, 8)] isEqualToString:@"c3020501"])
        {
            //End Packet while receiving from device.
            [globalSIMvc ReceivedEndPacketfromDevice];

        }
        else
        {
            NSString * strC1PacketType =  [valueStr substringWithRange:NSMakeRange(2, 2)];
            if ([strC1PacketType isEqualToString:@"01"]) //For C3 Write Status
            {
                NSString * strSuccessResponse =  [valueStr substringWithRange:NSMakeRange(2, 4)];
                if ([strSuccessResponse isEqualToString:@"0101"])
                {
                    [globalSIMvc ReceviedSuccesResponseFromDevice:strSuccessResponse];
                }
                else
                {
                    
                }
            }
            else if ([strC1PacketType isEqualToString:@"07"]) //C3 Start Packet
            {
                if ([valueStr length] >= 18)
                {
                    NSString * str1 = [self stringFroHex:[valueStr substringWithRange:NSMakeRange(6, 2)]];
                    NSString * str2 = [self stringFroHex:[valueStr substringWithRange:NSMakeRange(8,2)]];
                    NSString * str3 = [self stringFroHex:[valueStr substringWithRange:NSMakeRange(10,8)]];
                    NSArray * arrData = [[NSArray alloc] initWithObjects:str1,str2,str3, nil];
                    [globalSIMvc ReceivedFirstPacketfromDevice:arrData];
                }

            }
            else //APNS, USERNAME & PASSWORD Packets...
            {
                if ([[valueStr substringWithRange:NSMakeRange(4, 2)] isEqualToString:@"02"])
                {
                    //Second Packet of APNS
                    NSString * strPacketNo = [valueStr substringWithRange:NSMakeRange(6, 2)];
                    NSString *strHex = [valueStr substringWithRange:NSMakeRange(8,valueStr.length-8)];
                    NSString * strText = [self StringfromHexaUTF8:strHex];
                    NSDictionary * dicData = [[NSDictionary alloc] initWithObjectsAndKeys:strPacketNo,@"PacketNo",strText,@"Text", nil];
                    [globalSIMvc ReceivedAPNSPacketfromDevice:dicData];
                }
                else if ([[valueStr substringWithRange:NSMakeRange(4, 2)] isEqualToString:@"03"])
                {
                    //Second Packet of Username
                    NSString * strPacketNo = [valueStr substringWithRange:NSMakeRange(6, 2)];
                    NSString *strHex = [valueStr substringWithRange:NSMakeRange(8,valueStr.length-8)];
                    NSString * strText = [self StringfromHexaUTF8:strHex];
                    NSDictionary * dicData = [[NSDictionary alloc] initWithObjectsAndKeys:strPacketNo,@"PacketNo",strText,@"Text", nil];
                    [globalSIMvc ReceivedUsernamePacketfromDevice:dicData];
                }
                else if ([[valueStr substringWithRange:NSMakeRange(4, 2)] isEqualToString:@"04"])
                {
                    //Second Packet of Password
                    NSString * strPacketNo = [valueStr substringWithRange:NSMakeRange(6, 2)];
                    NSString *strHex = [valueStr substringWithRange:NSMakeRange(8,valueStr.length-8)];
                    NSString * strText = [self StringfromHexaUTF8:strHex];
                    NSDictionary * dicData = [[NSDictionary alloc] initWithObjectsAndKeys:strPacketNo,@"PacketNo",strText,@"Text", nil];
                    [globalSIMvc ReceivedPasswordPacketfromDevice:dicData];
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
-(NSString *)StringfromHexaUTF8:(NSString *)strHex
{
    NSString * strValue = strHex;
    NSMutableString * newString = [[NSMutableString alloc] init];
    int i = 0;
    while (i < [strValue length])
    {
        NSString * hexChar = [strValue substringWithRange: NSMakeRange(i, 2)];
        int value = 0;
        sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
        [newString appendFormat:@"%c", (char)value];
        i+=2;
    }
//    NSLog(@"Final inputs=%@",newString);

    return newString;
}
-(void)fetchBandsfromDecimalValue:(NSString *)strDecimalValue
{
    NSMutableArray * arrBandValue = [[NSMutableArray alloc] init];
    
    if (![[APP_DELEGATE checkforValidString:strDecimalValue] isEqualToString:@"NA"])
    {
        NSInteger bandIntvalue = [strDecimalValue integerValue];
        NSData * dataBandConfig = [[NSData alloc] initWithBytes:&bandIntvalue length:4];
        NSMutableData *pillowData = [dataBandConfig mutableCopy];

        uint32_t *bytes = pillowData.mutableBytes;
        *bytes = CFSwapInt32(*bytes);
        NSLog(@"%@", pillowData);
        
        NSString * strHexBandValue = [NSString stringWithFormat:@"%@",pillowData];

        strHexBandValue = [strHexBandValue stringByReplacingOccurrencesOfString:@" " withString:@""];
        strHexBandValue = [strHexBandValue stringByReplacingOccurrencesOfString:@"<" withString:@""];
        strHexBandValue = [strHexBandValue stringByReplacingOccurrencesOfString:@">" withString:@""];

        NSString * strBinary = [self GetBinaryfromHex:strHexBandValue];
        if ([strBinary length] >0)
        {
            for (int i =1 ; i < 29; i++)
            {
                NSMutableDictionary* dictBAndData = [[NSMutableDictionary alloc] init];
                 
                NSString * strIndex = [NSString stringWithFormat:@"%d",i+1];
                NSString * strName = [NSString stringWithFormat:@"B%d",i+1];
                
                [dictBAndData setObject:strIndex forKey:@"index"];
                [dictBAndData setObject:strName forKey:@"name"];
                [dictBAndData setObject:@"NO" forKey:@"isSelected"];
                if (strBinary.length > i)
                {
                    if ([[strBinary substringWithRange:NSMakeRange(strBinary.length - i - 1, 1)] isEqualToString:@"1"])
                    {
                        [arrBandValue addObject:strName];
                    }
                }
            }
        }
    }
    strBandList = [arrBandValue componentsJoinedByString:@","];
    [tblListSIMstup reloadData];
}
-(NSString *)GetBinaryfromHex:(NSString *)strHex
{
    NSString *hex = strHex;
    long hexAsInt;
    [[NSScanner scannerWithString:hex] scanHexInt:&hexAsInt];
    NSString *binary = [NSString stringWithFormat:@"%@", [self toBinary:hexAsInt]];
    
//    NSLog(@"===========Binary==========%@",binary);
    return binary;
}
-(NSString *)toBinary:(NSUInteger)input
{
    if (input == 1 || input == 0)
        return [NSString stringWithFormat:@"%lu", (unsigned long)input];
    return [NSString stringWithFormat:@"%@%lu", [self toBinary:input / 2], input % 2];
}
@end
