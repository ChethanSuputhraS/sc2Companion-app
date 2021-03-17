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
    NSString * selectedURAT ,*strBAnds;
    NSInteger URATIndexselected;
    NSInteger simTypeSelection;
    
}
@end

@implementation SIMconfigurVC
@synthesize classPeripheral;
- (void)viewDidLoad
{
    arrAlldata = [[NSMutableArray alloc] init];
    
    [self setNavigationViewFrames];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    
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
    [lblTitle setText:@"SIM Configuration"];
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
//    [btnSaveCh setBackgroundImage:[UIImage imageNamed:@"BTN.png"] forState:UIControlStateNormal];
    [btnSaveCh setTitle:@"Save" forState:UIControlStateNormal];
    [btnSaveCh setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btnSaveCh addTarget:self action:@selector(btnSaveChClick) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnSaveCh];

    
    NSArray * arraySim = [NSArray arrayWithObjects:@"E-SIM",@"Nano SIM", nil];
    arrRadioBtns = [[NSMutableArray alloc] init];

        RadioButtonClass * radioBclass = [[RadioButtonClass alloc] init];
        radioBclass.viewTag = 500;
        radioBclass.delegate = self;
        [radioBclass setButtonFrame:CGRectMake(20, 70, DEVICE_WIDTH-40, 50) withNumberofItems:arraySim withSelectedIndex:-1];
        [self.view addSubview:radioBclass];
        
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
        cell.lblRightLbl.text = strBAnds;
    }
    else if (indexPath.row == 2)
    {        
        cell.lblBack.backgroundColor = UIColor.clearColor;
        cell.imgArrow.hidden = true;
         cell.txtFld.hidden = false;
        cell.txtFld.placeholder = @"Enter APN address (scstg.net)";
        cell.txtFld.returnKeyType = UIReturnKeyNext;
        [APP_DELEGATE getPlaceholderText:cell.txtFld andColor:UIColor.whiteColor];
//        cell.txtFld.delegate = self;

    }
    else if (indexPath.row == 3)
    {
        cell.imgArrow.hidden = true;
        cell.txtFld.hidden = false;
        cell.txtFld.placeholder =@"Enter User name";
        cell.txtFld.returnKeyType = UIReturnKeyNext;
        cell.lblBack.backgroundColor = UIColor.clearColor;
        [APP_DELEGATE getPlaceholderText:cell.txtFld andColor:UIColor.whiteColor];
    }
    else if (indexPath.row == 4)
    {
        cell.imgArrow.hidden = true;
        cell.txtFld.hidden = false;
        cell.txtFld.placeholder =@"Enter Password";
        cell.txtFld.returnKeyType = UIReturnKeyDone;
        cell.lblBack.backgroundColor = UIColor.clearColor;
        [APP_DELEGATE getPlaceholderText:cell.txtFld andColor:UIColor.whiteColor];
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
        [self.navigationController pushViewController:uRt animated:true];
    }
    else if (indexPath.row == 1)
    {
        BandConfigVC * bcVC = [[BandConfigVC alloc] init];
        bcVC.delegate = self;
        [self.navigationController pushViewController:bcVC animated:true];
    }
}
#pragma mark - Textfield Delegates // 65,534
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 102)
      {
          UITextField * txtfld = [self.view viewWithTag:103];
          [txtfld becomeFirstResponder];
      }
      else if (textField.tag  == 103)
      {
          UITextField * txtfld = [self.view viewWithTag:104];
          [txtfld becomeFirstResponder];
      }
      else if (textField.tag  == 104)
      {
        [textField  resignFirstResponder];
      }
    
    return textField;
}

-(void)btnBackClick
{
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
            NSLog(@"Greater Than PocketLength 11======%@",strMsg);
        }
        else
        {
            if ((totallength >= (i * 12)))
            {
                NSString * strMsg = [strAPNAddress substringWithRange:NSMakeRange(i * 12, totallength - (i * 12))];
                [arrayPackets addObject:strMsg];
                NSLog(@"Msg legth satisfied  11======%@",strMsg);
            }
        }
    }
}
-(void)RecevieTheSelectedURAT:(NSString *)strSelectedURAT withIndexPath:(NSInteger)indexP
{
    NSLog(@"Chethan data%@",strSelectedURAT);
    NSString *str = strSelectedURAT;
    NSString *newStr = [str substringFromIndex:3];
    selectedURAT = newStr;
    URATIndexselected = indexP;
    [tblListSIMstup reloadData];
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
    NSString * strBandConfig = strBAnds;
    NSString * strapnAdd = txtfld.text ;
    NSString * strapnUserName = txtfld1.text ;
    NSString * strapnUsePassword = txtfld2.text ;
    NSString * straindex = [NSString stringWithFormat:@"%ld",(long)URATIndexselected];
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
-(void)SentBandConfiguration:(NSInteger )intConfigValue
{
    bandConfigValue = intConfigValue;
    
    strBAnds = [NSString stringWithFormat:@"%lu",(unsigned long)intConfigValue];
    
    [tblListSIMstup reloadData];
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

    NSData * dataURATs = [[NSData alloc] initWithBytes:&URATIndexselected length:1];

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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:true];
}
@end
