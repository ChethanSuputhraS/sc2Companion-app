//
//  ServerConfigVC.m
//  GeofenceAlertApp
//
//  Created by Ashwin on 10/13/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import "ServerConfigVC.h"
#import "UIFloatLabelTextField.h"

@interface ServerConfigVC ()<UITextFieldDelegate>
{
    UIFloatLabelTextField *txtSeverAdd,*txtKeepAliv,*txtserverPort;
    NSMutableArray * arryServer;
    NSTimer * btnSaveTimer, * timerConfig;
    NSMutableArray * arrSetServerConfigs, * arrAddresData;

}
@end

@implementation ServerConfigVC
@synthesize classPeripheral;

- (void)viewDidLoad
{
    arryServer = [[NSMutableArray alloc] init];
    arrSetServerConfigs = [[NSMutableArray alloc] init];
    arrAddresData = [[NSMutableArray alloc] init];
     
    [self setNavigationViewFrames];
    [self SetDefaultValuetoUI];
    
    if (classPeripheral.state == CBPeripheralStateConnected)
    {
        [timerConfig invalidate];
        timerConfig = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeOutforFetchConfig) userInfo:nil repeats:NO];
        [APP_DELEGATE startHudProcess:@"Fetching Configuration..."];
        
        [self WritetoReceiveStartPacketfromDevice];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)SetDefaultValuetoUI
{
    NSArray *   arrFirst = [NSArray arrayWithObjects:@"address", @"interval", @"port", nil];

    for (int i = 0 ; i < [arrFirst count]; i++)
    {
        if ([arrFirst count] > i)
        {
            NSMutableDictionary * tempDict = [[NSMutableDictionary alloc] init];
            [tempDict setValue:[arrFirst objectAtIndex:i] forKeyPath:@"title"];
            [tempDict setValue:@"NA" forKeyPath:@"value"];
            [tempDict setValue:@"0" forKeyPath:@"isChanaged"];
            [arrSetServerConfigs addObject:tempDict];
        }
    }
}
-(void)timeOutforFetchConfig
{
    [timerConfig invalidate];
    timerConfig = nil;
    [APP_DELEGATE endHudProcess];
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
    [lblTitle setText:@"Server Configuration"];
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
 
    
    int ya = 70;
    txtSeverAdd = [[UIFloatLabelTextField alloc] initWithFrame:CGRectMake(10, ya, DEVICE_WIDTH-20, 50)];
    [txtSeverAdd setBackgroundColor:[UIColor clearColor]];
    [txtSeverAdd setTextColor:[UIColor whiteColor]];
    [txtSeverAdd setFont:[UIFont fontWithName:CGRegular size:textSize]];
    [txtSeverAdd setTextAlignment:NSTextAlignmentLeft];
    txtSeverAdd.placeholder = @"Enter server address";
    [APP_DELEGATE getPlaceholderText:txtSeverAdd andColor:UIColor.whiteColor];
    txtSeverAdd.returnKeyType = UIReturnKeyNext;
    txtSeverAdd.layer.cornerRadius = 4;
    txtSeverAdd.layer.borderWidth = 0.5;
    txtSeverAdd.layer.borderColor = UIColor.lightGrayColor.CGColor;
    txtSeverAdd.delegate = self;
    txtSeverAdd.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.view addSubview:txtSeverAdd];
    
    txtKeepAliv = [[UIFloatLabelTextField alloc] initWithFrame:CGRectMake(10, ya+60, DEVICE_WIDTH-20, 50)];
    [txtKeepAliv setBackgroundColor:[UIColor clearColor]];
    [txtKeepAliv setTextColor:[UIColor whiteColor]];
    [txtKeepAliv setFont:[UIFont fontWithName:CGRegular size:textSize]];
    [txtKeepAliv setTextAlignment:NSTextAlignmentLeft];
    txtKeepAliv.placeholder = @"Keep alive interval";
    [APP_DELEGATE getPlaceholderText:txtKeepAliv andColor:UIColor.whiteColor];
    txtKeepAliv.returnKeyType = UIReturnKeyNext;
    txtKeepAliv.layer.cornerRadius = 4;
    txtKeepAliv.layer.borderWidth = 0.5;
    txtKeepAliv.layer.borderColor = UIColor.lightGrayColor.CGColor;
    txtKeepAliv.delegate = self;
    txtKeepAliv.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.view addSubview:txtKeepAliv];
    
     
    txtserverPort = [[UIFloatLabelTextField alloc] initWithFrame:CGRectMake(10, ya+120, DEVICE_WIDTH-20, 50)];
    [txtserverPort setBackgroundColor:[UIColor clearColor]];
    [txtserverPort setTextColor:[UIColor whiteColor]];
    [txtserverPort setFont:[UIFont fontWithName:CGRegular size:textSize]];
    [txtserverPort setTextAlignment:NSTextAlignmentLeft];
    txtserverPort.placeholder = @"Server port";
    [APP_DELEGATE getPlaceholderText:txtserverPort andColor:UIColor.whiteColor];
    txtserverPort.returnKeyType = UIReturnKeyDone;
    txtserverPort.layer.cornerRadius = 4;
    txtserverPort.layer.borderWidth = 0.5;
    txtserverPort.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    txtserverPort.layer.borderColor = UIColor.lightGrayColor.CGColor;
    txtserverPort.delegate = self;
    [self.view addSubview:txtserverPort];

}
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)btnSaveChClick
{
    if ([[APP_DELEGATE checkforValidString:txtSeverAdd.text] isEqualToString:@"NA"])
    {
        [self showErrorMessage:@"Please enter valid Server Address"];

    }
    else  if ([[APP_DELEGATE checkforValidString:txtKeepAliv.text] isEqualToString:@"NA"])
    {
        [self showErrorMessage:@"Please enter valid keppaliv interval"];

    }
    else  if ([[APP_DELEGATE checkforValidString:txtserverPort.text] isEqualToString:@"NA"])
    {
        [self showErrorMessage:@"Please enter valid Server poart"];
    }
    else
    {
        
        BOOL isValueChanged = NO;
        for (int i =0; i < [arrSetServerConfigs count]; i++)
        {
            if ([[[arrSetServerConfigs objectAtIndex:i] valueForKey:@"isChanaged"] isEqualToString:@"1"])
            {
                isValueChanged = YES;
            }
        }
        if (isValueChanged == YES)
        {
            NSLog(@"Valye Has Changed.....");
            if (classPeripheral.state == CBPeripheralStateConnected)
            {
                [timerConfig invalidate];
                timerConfig = nil;
                timerConfig = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeOutforFetchConfig) userInfo:nil repeats:NO];
                [APP_DELEGATE startHudProcess:@"Saving..."];

                NSMutableArray * arrAddressPackets = [[NSMutableArray alloc] init];
                NSInteger totalPackets = 0;

                NSString * strServerAddress = txtSeverAdd.text;
                totalPackets = [self getTotalNumberofPackets:strServerAddress];
                [self AddPacketstoArray:arrAddressPackets withString:strServerAddress withTotalPackets:totalPackets];

                totalPackets = 1 + [arrAddressPackets count] ;

                [self WriteStartPackettoDevicewithtotalPackets:totalPackets];//Write Start Packet with sending Total number of Packets

                //Send Server Packets
                [self WriteServerAddressPacketToDevicewithPacketsArray:arrAddressPackets withPacketType:@"2"];
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
       /*NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
       [dict setValue:txtSeverAdd.text forKey:@"serverAddress"];
       [dict setValue:txtKeepAliv.text forKey:@"keepAlive"];
       [dict setValue:txtserverPort.text forKey:@"severPort"];
       [arryServer addObject:dict];
      // [self InsertToDatabase:dict];
    
       [self showSuccesMessage:@"Server configuration saved"];
       NSLog(@"SeverConfigur Data====>>>%@",dict);*/
}
-(void)savingTimeout
{
    [APP_DELEGATE endHudProcess];
    [self showErrorMessage:@"Something went wrong try agian"];
}
-(void)buzzerTimeoutMethod
{
    NSMutableArray * arrAddressPackets = [[NSMutableArray alloc] init];
    NSInteger totalPackets = 0;

    NSString * strServerAddress = txtSeverAdd.text;
    totalPackets = [self getTotalNumberofPackets:strServerAddress];
    [self AddPacketstoArray:arrAddressPackets withString:strServerAddress withTotalPackets:totalPackets];
    
    totalPackets = 1 + [arrAddressPackets count] ;

    [self WriteStartPackettoDevicewithtotalPackets:totalPackets];//Write Start Packet with sending Total number of Packets
  
    //Send Server Packets
    [self WriteServerAddressPacketToDevicewithPacketsArray:arrAddressPackets withPacketType:@"2"];
}
#pragma mark - Textfield Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger arrIndex = 0;
    if (textField == txtSeverAdd)
    {
        [txtKeepAliv becomeFirstResponder];
    }
    else if (textField == txtKeepAliv)
    {
        arrIndex = 1;
        [txtserverPort becomeFirstResponder];
    }
    else if (textField == txtserverPort)
    {
        arrIndex = 2;
        [txtserverPort resignFirstResponder];
    }
    
    if (arrIndex >= 0 && arrSetServerConfigs.count > arrIndex)
    {
        NSString * strPreviousValue = [self checkforValidString:[[arrSetServerConfigs objectAtIndex:arrIndex] valueForKey:@"value"]];
        NSString * strCurrentValue = textField.text;
        if (![strPreviousValue isEqualToString:strCurrentValue])
        {
            [[arrSetServerConfigs objectAtIndex:arrIndex] setValue:@"1" forKey:@"isChanaged"];
        }
        else
        {
            [[arrSetServerConfigs objectAtIndex:arrIndex] setValue:@"0" forKey:@"isChanaged"];
        }
    }

    return textField;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
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
-(void)InsertToDatabase:(NSMutableDictionary *)dictData
{
    NSString * strServerAdd = [dictData valueForKey:@"serverAddress"];
    NSString * strkeppAlive = [dictData valueForKey:@"keepAlive"];
    NSString * strServerport = [dictData valueForKey:@"severPort"];
//    NSString * strServerQuery = @"NA";

    NSMutableArray *  arryData = [[NSMutableArray alloc] init];
    NSString * sqlquery = [NSString stringWithFormat:@"select * from tbl_server_Config"];
    [[DataBaseManager dataBaseManager] execute:sqlquery resultsArray:arryData];
    
    if (arryData.count > 0)
    {
        NSString * strServerQuery =  [NSString stringWithFormat:@"update tbl_server_Config set server_address = \"%@\",keepalive_interval = \"%@\",server_port = \"%@\"",strServerAdd,strkeppAlive,strServerport];
          [[DataBaseManager dataBaseManager] executeSw:strServerQuery];
    }
    else
    {
         NSString * strServerQuery =  [NSString stringWithFormat:@"insert into 'tbl_server_Config'('server_address','keepalive_interval','server_port') values(\"%@\",\"%@\",\"%@\")",strServerAdd,strkeppAlive,strServerport];
        [[DataBaseManager dataBaseManager] executeSw:strServerQuery];
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
        if (totallength >= (i * 11) + 11)
        {
            NSString * strMsg = [strAPNAddress substringWithRange:NSMakeRange(i * 11, 11)];
            [arrayPackets addObject:strMsg];
            NSLog(@"Greater Than PocketLength 11======%@",strMsg);
        }
        else
        {
            if ((totallength >= (i * 11)))
            {
                NSString * strMsg = [strAPNAddress substringWithRange:NSMakeRange(i * 11, totallength - (i * 11))];
                [arrayPackets addObject:strMsg];
                NSLog(@"Msg legth satisfied  11======%@",strMsg);
            }
        }
    }
}
#pragma mark - Write Configuration to Device
-(void)WritetoReceiveStartPacketfromDevice
{
    NSInteger intCmd = [@"196" integerValue];
    NSData * dataCmd = [[NSData alloc] initWithBytes:&intCmd length:1];
    
    NSInteger intLength = [@"1" integerValue];
    NSData * dataLength = [[NSData alloc] initWithBytes:&intLength length:1];
    
    NSInteger intPacketType = [@"1" integerValue];
    NSData * dataPacketType = [[NSData alloc] initWithBytes:&intPacketType length:1];


    NSMutableData *completeData = [dataCmd mutableCopy];
    [completeData appendData:dataLength];
    [completeData appendData:dataPacketType];
    
    [[BLEService sharedInstance] WriteNSDataforEncryptionAndthenSendtoPeripheral:completeData withPeripheral:classPeripheral];
}
-(void)WritetoReceiveAddressDataPacketfromDevice
{
    NSInteger intCmd = [@"196" integerValue];
    NSData * dataCmd = [[NSData alloc] initWithBytes:&intCmd length:1];
    
    NSInteger intLength = [@"1" integerValue];
    NSData * dataLength = [[NSData alloc] initWithBytes:&intLength length:1];
    
    NSInteger intPacketType = [@"2" integerValue];
    NSData * dataPacketType = [[NSData alloc] initWithBytes:&intPacketType length:1];

    NSMutableData *completeData = [dataCmd mutableCopy];
    [completeData appendData:dataLength];
    [completeData appendData:dataPacketType];
    
    [[BLEService sharedInstance] WriteNSDataforEncryptionAndthenSendtoPeripheral:completeData withPeripheral:classPeripheral];
}

-(void)WriteStartPackettoDevicewithtotalPackets:(NSInteger)TotalPackets
{
    NSInteger intCmd = [@"196" integerValue];
    NSData * dataCmd = [[NSData alloc] initWithBytes:&intCmd length:1];
    
    NSInteger intPacketType = [@"1" integerValue];
    NSData * dataPacketType = [[NSData alloc] initWithBytes:&intPacketType length:1];

    NSInteger intLength = [@"5" integerValue];
    NSData * dataLength = [[NSData alloc] initWithBytes:&intLength length:1];

    NSData * dataTotalPackets = [[NSData alloc] initWithBytes:&TotalPackets length:1];

    NSInteger intServerPort = 0;
    if (![[APP_DELEGATE checkforValidString:txtserverPort.text] isEqualToString:@"NA"])
    {
        intServerPort = [txtserverPort.text integerValue];
    }

    NSData * dataServerPorts = [[NSData alloc] initWithBytes:&intServerPort length:2];

    NSInteger intTimeInterval = 0;
    if (![[APP_DELEGATE checkforValidString:txtKeepAliv.text] isEqualToString:@"NA"])
    {
        intTimeInterval = [txtKeepAliv.text integerValue];
    }
    NSData * dataTimeInterval = [[NSData alloc] initWithBytes:&intTimeInterval length:1];

    NSMutableData *completeData = [dataCmd mutableCopy];
    [completeData appendData:dataLength];
    [completeData appendData:dataPacketType];
    [completeData appendData:dataTotalPackets];
    [completeData appendData:dataServerPorts];
    [completeData appendData:dataTimeInterval];
    
    [[BLEService sharedInstance] WriteNSDataforEncryptionAndthenSendtoPeripheral:completeData withPeripheral:classPeripheral];
}
-(void)WriteServerAddressPacketToDevicewithPacketsArray:(NSMutableArray *)arrAPNSPackets withPacketType:(NSString *)strPacketType
{
    for (int i =0; i < [arrAPNSPackets count]; i++)
    {
        NSInteger intOpCode = [@"196" integerValue];
        NSData * dataOpcode = [[NSData alloc] initWithBytes:&intOpCode length:1];

        NSInteger intPacketType = [strPacketType integerValue];
        NSData * dataPacketType = [[NSData alloc] initWithBytes:&intPacketType length:1];

        NSInteger intpacketNo = i + 1;
        NSData * dataPacketNo = [[NSData alloc] initWithBytes:&intpacketNo length:1];

        NSString * strPacket = [arrAPNSPackets objectAtIndex:i];
        NSInteger intPacketLength = [strPacket length] + 1; //+1 for Packet Continuity
        NSData * dataPacketLengh = [[NSData alloc] initWithBytes:&intPacketLength length:1];

        NSData * msgData = [self dataFromHexString:[self hexFromStr:strPacket]];
        
        NSInteger packetContinuity = 1;
        if ([arrAPNSPackets count] - 1 == i)
        {
            packetContinuity = 0;
        }
        NSData *  dataContinuity = [[NSData alloc] initWithBytes:&packetContinuity length:1];

        NSMutableData * finalData = [dataOpcode mutableCopy];
        [finalData appendData:dataPacketLengh];
        [finalData appendData:dataPacketType];
        [finalData appendData:dataPacketNo];
        [finalData appendData:msgData];
        [finalData appendData:dataContinuity];
        [[BLEService sharedInstance] WriteNSDataforEncryptionAndthenSendtoPeripheral:finalData withPeripheral:classPeripheral];
    }
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
-(void)ReceviedSuccesResponseFromDevice:(NSString *)strResponse
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [APP_DELEGATE endHudProcess];
        if ([strResponse isEqualToString:@"0101"])
        {
            [self showSuccesMessage:@"Server Specific configuration applied successfully. Device will restart after 3 minutes. Please connect after some time. "];
        }
        else
        {
            [self showErrorMessage:@"Faied to configure device Please try agin later"];
        }
    });
}
-(void)ReceivedStartPacketfromDevice:(NSArray *)arrData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([arrData count] >= 3)
        {
            self->txtKeepAliv.text = [arrData objectAtIndex:2];

            if ([[arrData objectAtIndex:2] isEqualToString:@"255"])
            {
                self->txtKeepAliv.text = @"";

            }
            self->txtserverPort.text = [arrData objectAtIndex:1];
            
            [[self->arrSetServerConfigs objectAtIndex:1] setValue:self->txtKeepAliv.text forKey:@"value"];
            [[self->arrSetServerConfigs objectAtIndex:1] setValue:@"0" forKey:@"isChanaged"];

            [[self->arrSetServerConfigs objectAtIndex:2] setValue:self->txtserverPort.text forKey:@"value"];
            [[self->arrSetServerConfigs objectAtIndex:2] setValue:@"0" forKey:@"isChanaged"];

        }
        [self WritetoReceiveAddressDataPacketfromDevice];

    });

}
-(void)ReceivedAddressPacketfromDevice:(NSDictionary *)dictPackets isLastPacket:(BOOL)isLastPacket
{
    [arrAddresData addObject:dictPackets];

    dispatch_async(dispatch_get_main_queue(), ^{
    
        if (isLastPacket == YES)
        {
            NSSortDescriptor * brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"PacketNo" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
            NSArray * arrAPNSSorted = [self->arrAddresData sortedArrayUsingDescriptors:sortDescriptors];
            
            NSString * strAddress;
            for (int i = 0; i < [arrAPNSSorted count]; i++)
            {
                if (strAddress.length == 0)
                {
                    strAddress = [[arrAPNSSorted objectAtIndex:i] valueForKey:@"Text"];
                }
                else
                {
                    strAddress = [strAddress stringByAppendingString:[[arrAPNSSorted objectAtIndex:i] valueForKey:@"Text"]];
                }
            }
            self->txtSeverAdd.text = strAddress;
            
            [[self->arrSetServerConfigs objectAtIndex:0] setValue:self->txtSeverAdd.text forKey:@"value"];
            [[self->arrSetServerConfigs objectAtIndex:0] setValue:@"0" forKey:@"isChanaged"];

                [APP_DELEGATE endHudProcess];

        }
    });

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
@end
