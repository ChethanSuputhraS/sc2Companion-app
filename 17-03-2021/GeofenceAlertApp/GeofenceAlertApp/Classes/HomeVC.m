//
//  HomeVC.m
//  GeofenceAlertApp
//
//  Created by Ashwin on 7/16/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//
#import "HomeCell.h"
#import "HomeVC.h"
#import "GeofencencAlertCell.h"
#import "ScandeviceVC.h"
#import "PolygonGeofenceVC.h"
#import "BLEService.h"
#import "HistoryVC.h"
#import "FCAlertView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "RadialGeofenceVC.h"
#import "ChatVC.h"
#import "SOSclassVC.h"
#import "RemotNavigationVC.h"
#import "LoginVC.h"
#import "LiveTrackingVC.h"




#if __has_feature(objc_arc)
  #define DLog(format, ...) CFShow((__bridge CFStringRef)[NSString stringWithFormat:format, ## __VA_ARGS__]);
#else
  #define DLog(format, ...) CFShow([NSString stringWithFormat:format, ## __VA_ARGS__]);
#endif

@interface HomeVC()<UITableViewDelegate,UITableViewDataSource,FCAlertViewDelegate,CBCentralManagerDelegate,URLManagerDelegate>
{
    NSMutableArray * arrGeofence,* arrActons, * arrPolygon, * arrRules, * arrAllSavedRules;
    CBCentralManager*centralManager;
    NSTimer * connectionTimer, * advertiseTimer,* timerForNotification;;
    CBPeripheral * classPeripheral;
    NSMutableDictionary * currentAlertDict, * waitDict;
//    int historyCount;
    FCAlertView * geofenceAlertPopup;
    UITextField *customField;
    NSInteger selectedIndex;
    NSMutableArray * arrTempListGeofence, * arrAlertPacketsQueue,*arryForIsviewd;
    CBPeripheral * tempSelectedPeripheral;
    
    bool isAnyGeofenceFoundSynced;
    NSIndexPath *  previousIndexPath;
    NSInteger selectedMoreIndex;
    NSMutableDictionary * notificationDict;
    NSString * strBleAddresstoChat;
}
@end

@implementation HomeVC

- (void)viewDidLoad
{
    selectedMoreIndex = -1;
    arrTempListGeofence=[[NSMutableArray alloc] init];
    arrAlertPacketsQueue =[[NSMutableArray alloc] init];

    
    self.navigationController.navigationBarHidden = true;
    
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

    globalBadgeCount = [UIApplication sharedApplication].applicationIconBadgeNumber;
    NSString * strQuery = [NSString stringWithFormat:@"Select * from Geofence_alert_Table where isViewed = '0'"];
    NSMutableArray * tmpArr = [[NSMutableArray alloc] init];
    [[DataBaseManager dataBaseManager] execute:strQuery resultsArray:tmpArr];
    globalBadgeCount = [tmpArr count];
    [UIApplication sharedApplication].applicationIconBadgeNumber = globalBadgeCount;

    [self setNavigationViewFrames];
    
    arrGeofence = [[NSMutableArray alloc]init];
    NSString * str = [NSString stringWithFormat:@"Select * from Geofence"];
    [[DataBaseManager dataBaseManager] execute:str resultsArray:arrGeofence];
    arrGlobalGeofenceList = [[NSMutableArray alloc]init];
    arrGlobalGeofenceList = arrGeofence;
    
    NSLog(@"<----==Geofence Arr--==%@",arrGeofence);
    globalDict = [[NSMutableDictionary alloc] init];
    arrActons = [[NSMutableArray alloc] init];
    arrPolygon = [[NSMutableArray alloc] init];
    arrGlobalDevices = [[NSMutableArray alloc] init];
    arrRules = [[NSMutableArray alloc] init];
    currentAlertDict = [[NSMutableDictionary alloc] init];
    arrAllSavedRules = [[NSMutableArray alloc] init];
    [advertiseTimer invalidate];
    advertiseTimer = nil;
    advertiseTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(AdvertiseTimerMethod) userInfo:nil repeats:NO];
    
    arrGlobalDeviceNames = [[NSMutableArray alloc] init];
    arrGlobalDeviceNames = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"DeviceName"] mutableCopy];
    
    if ([arrGlobalDeviceNames count] == 0)
    {
        arrGlobalDeviceNames = [[NSMutableArray alloc] init];
    }
        
    arryForIsviewd = [[NSMutableArray alloc] init];
    NSString * strGetViwed = [NSString stringWithFormat:@"Select * from Geofence_alert_Table where bleAddress & isViewed = '1'"];
    [[DataBaseManager dataBaseManager] execute:strGetViwed resultsArray:arryForIsviewd];
    
    
    [APP_DELEGATE endHudProcess];
    [APP_DELEGATE startHudProcess:@"Scanning..."];
    
    
//    [self SendignDeviceTokenTotheDeVice:@"eyJhbGciOiJIUzI1NiJ9.eyJkZXZpY2VTbiI6IjM1NDY3OTA5Mjk1NjAzOSJ9.dw58sc7YrVi49k1v6DW6CYPiF8NVj2Eh4ZkEhIk1Oos"];
//    [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%d",globalBadgeCount]];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    strCurrentScreen = @"NA";//Kalpesh26062021
    if (globalBadgeCount >0)
    {
        lblBadgeHistry.hidden = true; // false
        lblBadgeHistry.text = [NSString stringWithFormat:@"%ld",(long)globalBadgeCount];
    }
    else
    {
        lblBadgeHistry.hidden = true;
    }
    
    if (globalBadgeCount >= 100)
    {
        lblBadgeHistry.frame = CGRectMake(DEVICE_WIDTH-30, globalStatusHeight, 28, 20);
    }
    else
    {
        lblBadgeHistry.frame = CGRectMake(DEVICE_WIDTH-25, globalStatusHeight, 20, 20);
    }

    [self InitialBLE];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AuthenticationCompleted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AuthenticationCompleted) name:@"AuthenticationCompleted" object:nil];
    
    [APP_DELEGATE showTabBar:self.tabBarController];
    [super viewWillAppear:YES];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [tblDeviceList reloadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
//    [APP_DELEGATE hideTabBar:self.tabBarController];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateUTCtime" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateCurrentGPSlocation" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AuthenticationCompleted" object:nil];
    [super viewWillDisappear:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self refreshBtnClick];
}
-(void)GettingDeviceTokenFromURL:(NSString *)strIMEINUM
{
    NSString * strHexVal = [self stringFroHex:strIMEINUM];

    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"gettoken";
    manager.delegate = self;
    NSString *strServerUrl = @"https://ws.succorfish.net/basic/v2/device/get-token/"; // IMEI number
    //    NSString *strServerUrl = @"https://ws.succorfish.net/basic/v2/asset/search?view=BASIC"; // IMEI for remote tracking

    [manager getUrlCall:[NSString stringWithFormat:@"%@%@",strServerUrl,strHexVal] withParameters:nil];
}
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
    [lblTitle setText:@"SC2 Companion App"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGRegular size:textSize+2]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
    UIButton *btnhistory=[[UIButton alloc]initWithFrame:CGRectMake(DEVICE_WIDTH-60, globalStatusHeight-10, 60, 60)];
    btnhistory.backgroundColor = UIColor.clearColor;
    btnhistory.clipsToBounds = true;
    [btnhistory setImage:[UIImage imageNamed:@"history.png"] forState:UIControlStateNormal];
    [btnhistory addTarget:self action:@selector(btnHistoyClick) forControlEvents:UIControlEventTouchUpInside];
//    [viewHeader addSubview:btnhistory];
    
    lblBadgeHistry = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-25, globalStatusHeight, 20, 20)];
    lblBadgeHistry.backgroundColor = UIColor.redColor;
    lblBadgeHistry.layer.cornerRadius = 10;
    lblBadgeHistry.clipsToBounds = true;
//    lblBadgeHistry.text = @"20";
    lblBadgeHistry.font = [UIFont fontWithName:CGBold size:12];
    lblBadgeHistry.textColor = UIColor.whiteColor;
    lblBadgeHistry.textAlignment = NSTextAlignmentCenter;
    lblBadgeHistry.hidden = true;
//    [viewHeader addSubview:lblBadgeHistry];
    
    if (globalBadgeCount > 0)
    {
        lblBadgeHistry.hidden = false;// flase;
        lblBadgeHistry.text = [NSString stringWithFormat:@"%ld",(long)globalBadgeCount];
        if (globalBadgeCount >= 100)
        {
            lblBadgeHistry.frame = CGRectMake(DEVICE_WIDTH-30, globalStatusHeight, 28, 20);
        }
    }

    UIButton * btnLogout = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLogout setFrame:CGRectMake(10, globalStatusHeight-10, 60, 60)];
    btnLogout.backgroundColor = UIColor.clearColor;
    [btnLogout setImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
    [btnLogout addTarget:self action:@selector(btnLogoutClick) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnLogout];
    
    UIButton * btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRefresh setFrame:CGRectMake(DEVICE_WIDTH-60, globalStatusHeight-10, 60, 60)];
    btnRefresh.backgroundColor = UIColor.clearColor;
    [btnRefresh setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateNormal];
    [btnRefresh addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnRefresh];
    
    tblDeviceList = [[UITableView alloc] initWithFrame:CGRectMake(0, globalStatusHeight+yy, DEVICE_WIDTH, DEVICE_HEIGHT-yy)];
    tblDeviceList.delegate = self;
    tblDeviceList.dataSource= self;
    tblDeviceList.backgroundColor = UIColor.clearColor;
    tblDeviceList.separatorStyle = UITableViewCellSelectionStyleNone;
    [tblDeviceList setShowsVerticalScrollIndicator:NO];
    tblDeviceList.backgroundColor = [UIColor clearColor];
    tblDeviceList.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblDeviceList.separatorColor = [UIColor darkGrayColor];
    [self.view addSubview:tblDeviceList];
    
    topPullToRefreshManager = [[MNMPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:tblDeviceList withClient:self];
    [topPullToRefreshManager setPullToRefreshViewVisible:YES];
    [topPullToRefreshManager tableViewReloadFinishedAnimated:YES];
    
    yy = yy+30;
    
    lblScanning = [[UILabel alloc] initWithFrame:CGRectMake((DEVICE_WIDTH/2)-50, yy, 100, 44)];
    [lblScanning setBackgroundColor:[UIColor clearColor]];
    [lblScanning setText:@"Scanning..."];
    [lblScanning setTextAlignment:NSTextAlignmentCenter];
    [lblScanning setFont:[UIFont fontWithName:CGRegular size:textSize]];
    [lblScanning setTextColor:[UIColor whiteColor]];
    lblScanning.hidden = true;
    [self.view addSubview:lblScanning];

    lblNoDevice = [[UILabel alloc]initWithFrame:CGRectMake(30, (DEVICE_HEIGHT/2)-90, (DEVICE_WIDTH)-60, 100)];
    lblNoDevice.backgroundColor = UIColor.clearColor;
    [lblNoDevice setTextAlignment:NSTextAlignmentCenter];
    [lblNoDevice setFont:[UIFont fontWithName:CGRegular size:textSize+2]];
    [lblNoDevice setTextColor:[UIColor whiteColor]];
    lblNoDevice.text = @"No Devices Found.";
    [self.view addSubview:lblNoDevice];
    
}
-(void)ShowNotificationofGeofence:(NSString *)strTitle withMsg:(NSString *)strMsg withData:(NSDictionary *)dataDict
{
    notificationDict = [[NSMutableDictionary alloc] init];
    notificationDict = [dataDict mutableCopy];
    
    strMsg = [strMsg stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    [viewForNotification removeFromSuperview];
    viewForNotification = [[UIView alloc] initWithFrame:CGRectMake(0, -140, DEVICE_WIDTH, 140)];
    viewForNotification.backgroundColor = [UIColor colorWithRed:66.0/255.0 green:66.0/255.0 blue:69.0/255.0 alpha:1];
    [[APP_DELEGATE window] addSubview:viewForNotification];
    
    UILabel * lblNotifyTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 30, DEVICE_WIDTH-16, 22)];
    lblNotifyTitle.text = [NSString stringWithFormat:@"%@!",strTitle];
    lblNotifyTitle.backgroundColor = [UIColor clearColor];
    lblNotifyTitle.textColor = UIColor.whiteColor;
    lblNotifyTitle.font = [UIFont fontWithName:CGBold size:textSize+1];
    [viewForNotification addSubview:lblNotifyTitle];
    
    UILabel * lblAlertMsg = [[UILabel alloc] initWithFrame:CGRectMake(8, 47, DEVICE_WIDTH-16, 40)];
    lblAlertMsg.text = strMsg;
    lblAlertMsg.backgroundColor = UIColor.clearColor;
    lblAlertMsg.textColor = UIColor.whiteColor;
    lblAlertMsg.numberOfLines = 0;
    lblAlertMsg.font = [UIFont fontWithName:CGRegular size:textSize-2];
    [viewForNotification addSubview:lblAlertMsg];

    if (IS_IPHONE_X)
    {
        lblAlertMsg.frame = CGRectMake(8, 44, DEVICE_WIDTH - 16, 22);
        viewForNotification.frame = CGRectMake(0, -140 - 44, DEVICE_WIDTH, 140);
    }
    
    CGFloat btnWidth = (viewForNotification.frame.size.width / 2 ) - 10;
    UIButton * btnSeenInMap = [[UIButton alloc] initWithFrame:CGRectMake(5, viewForNotification.frame.size.height-50, btnWidth, 44)];
    btnSeenInMap.backgroundColor = UIColor.clearColor;
    [btnSeenInMap setTitle:@"See in map" forState:UIControlStateNormal];
    [btnSeenInMap setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [btnSeenInMap addTarget:self action:@selector(btnNotificationSeeMapClick) forControlEvents:UIControlEventTouchUpInside];
    btnSeenInMap.layer.cornerRadius = 4;
    btnSeenInMap.layer.borderColor = [UIColor whiteColor].CGColor;
    btnSeenInMap.layer.borderWidth = 1;
    [viewForNotification addSubview:btnSeenInMap];
    
    UIButton * btnIgnore = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth + 10 + 5, viewForNotification.frame.size.height-50, btnWidth, 44)];
    btnIgnore.backgroundColor = UIColor.redColor;
    [btnIgnore setTitle:@"Ignore" forState:UIControlStateNormal];
    [btnIgnore setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    btnIgnore.layer.cornerRadius = 4;
    btnIgnore.layer.borderColor = [UIColor whiteColor].CGColor;
    btnIgnore.layer.borderWidth = 1;
    [btnIgnore addTarget:self action:@selector(btnNotificationIgnoreClick) forControlEvents:UIControlEventTouchUpInside];
    [viewForNotification addSubview:btnIgnore];

    UILabel * lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, viewForNotification.frame.size.height-1, viewForNotification.frame.size.width, 1)];
    lblLine.backgroundColor = [UIColor blackColor];
    [viewForNotification addSubview:lblLine];

    [timerForNotification invalidate];
    timerForNotification = nil;
    timerForNotification = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(TimeoutforHideNotification) userInfo:nil repeats:NO];
    
    [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^
       {
        viewForNotification.frame = CGRectMake(0, 0, DEVICE_WIDTH-0, 140);
       }
       completion:(^(BOOL finished)
       {
      })];

}
#pragma mark- UITableView Header Methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;   // custom view for header. will be adjusted to default or specified header height
{
    if (tableView == tblDeviceList)
    {
        UIView * headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-146, 55)];
        headerView.backgroundColor = [UIColor clearColor];
        
       NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@" Tap on Connect button to pair with device"];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:CGRegular size:textSize-1] range:NSMakeRange(0,string.length)];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:CGBold size:textSize+1] range:NSMakeRange(7,8)];

        UILabel *lblmenu=[[UILabel alloc]init];
        lblmenu.frame = CGRectMake(0,0, DEVICE_WIDTH, 45);
        [lblmenu setAttributedText:string];
        [lblmenu setTextColor:[UIColor whiteColor]];
        lblmenu.backgroundColor = UIColor.blackColor;
        [headerView addSubview:lblmenu];
        return headerView;
    }
    return [UIView new];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 50;
}
#pragma mark- UITableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[BLEManager sharedManager] foundDevices].count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isMoreClicked = NO;
    if (selectedMoreIndex == indexPath.row)
    {
        isMoreClicked = YES;
        //this means show bottom two buttons
    }
        NSMutableArray * arrayDevices = [[NSMutableArray alloc] init];
        arrayDevices =[[BLEManager sharedManager] foundDevices];
        
        CBPeripheral * p = [[arrayDevices objectAtIndex:indexPath.row] valueForKey:@"peripheral"];
        if (p.state == CBPeripheralStateConnected)
        {
            if (isMoreClicked == YES)
            {
                return  195;
            }
            else
            {
                return  115;
            }
        }
        else
        {
                return  65;
        }
    return 65;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellReuseIdentifier = @"cellIdentifier";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (cell == nil)
    {
        cell = [[HomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }

    cell.btnmessage.tag = indexPath.row;
    cell.btnmap.tag = indexPath.row;
    cell.btnLivelocation.tag = indexPath.row;
    cell.btnMore1.tag = indexPath.row;
    
    [cell.btnmessage addTarget:self action:@selector(btnMessageClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnSetting addTarget:self action:@selector(btnSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnGeofence addTarget:self action:@selector(btnGeofencelick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnSOS addTarget:self action:@selector(btnSOSClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnLivelocation addTarget:self action:@selector(btnLiveTrackClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    cell.btnConnect.frame = CGRectMake(DEVICE_WIDTH-150, 0, 100, 60);
    cell.btnMore.hidden = true;
    cell.imgviewMoreButton.hidden = true;
    cell.lblConnect.text = @"Connect";
    [cell.btnMore1 addTarget:self action:@selector(btnMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnConnect addTarget:self action:@selector(btnConnectClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnConnect.tag = indexPath.row;
    cell.btnMore.tag = indexPath.row;
    cell.optionView.hidden = true;
    cell.settingView.hidden = true;

    BOOL isMoreClicked = NO;
    if (selectedMoreIndex == indexPath.row)
    {
        isMoreClicked = YES;
        //this means show bottom two buttons
    }

    NSMutableArray * arrayDevices = [[NSMutableArray alloc] init];
    arrayDevices =[[BLEManager sharedManager] foundDevices];

    cell.lblConnect.frame = CGRectMake(DEVICE_WIDTH-100, 0,  80, 60);
    
    CBPeripheral * p = [[arrayDevices objectAtIndex:indexPath.row] valueForKey:@"peripheral"];
    
    
    NSString * strBadgeCount = [self checkforValidString:[[NSUserDefaults standardUserDefaults] valueForKey:[[[arrayDevices  objectAtIndex:indexPath.row]valueForKey:@"bleAddress"] uppercaseString]]];
    
    int intBadgeCount = [strBadgeCount intValue];
    
    if (intBadgeCount == 100)
    {
        cell.lblBadgeCount.frame = CGRectMake(cell.btnGeofence.frame.size.width/2+5, 2, 40, 20);
    }
    
    cell.lblBadgeCount.text = [NSString stringWithFormat:@"%d",intBadgeCount];
    
    if (p.state == CBPeripheralStateConnected)
    {
        cell.lblConnect.frame = CGRectMake(DEVICE_WIDTH-130, 0, 100, 60);
        cell.lblConnect.text = @"Disconnect";
        cell.btnMore.hidden = false;
        cell.optionView.hidden = false;
        cell.imgviewMoreButton.hidden = false;

        if (isMoreClicked == YES)
        {
            cell.settingView.hidden = false;
        }
        else
        {
            cell.settingView.hidden = true;

        }
    }

        cell.lblDeviceName.text = [[arrayDevices  objectAtIndex:indexPath.row]valueForKey:@"name"];
        cell.lblAddress.text = [[arrayDevices  objectAtIndex:indexPath.row]valueForKey:@"bleAddress"];
         
    
        cell.backgroundColor = UIColor.clearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     CGRect myRect = [tableView rectForRowAtIndexPath:indexPath];
//
//    NSMutableArray * arrayDevices = [[NSMutableArray alloc] init];
//    arrayDevices =[[BLEManager sharedManager] foundDevices];
//    if ([arrayDevices count]>0)
//    {
//        CBPeripheral * p = [[arrayDevices objectAtIndex:indexPath.row] valueForKey:@"peripheral"];
//        if (p.state == CBPeripheralStateConnected)
//        {
//            if (selectedMoreIndex == indexPath.row)
//            {
//                selectedMoreIndex = -1;
//            }
//            [APP_DELEGATE startHudProcess:@"Disconnecting..."];
//            [[BLEManager sharedManager] disconnectDevice:p];
//            if ([[arrGlobalDevices valueForKey:@"peripheral"] containsObject:p])
//            {
//                NSInteger foundIndex = [[arrGlobalDevices valueForKey:@"peripheral"] indexOfObject:p];
//                if (foundIndex != NSNotFound)
//                {
//                    if (arrGlobalDevices.count > foundIndex)
//                    {
//                        [arrGlobalDevices removeObjectAtIndex:foundIndex];
//                    }
//                }
//            }
//        }
//        else
//        {
//            [connectionTimer invalidate];
//            connectionTimer = nil;
//            connectionTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(ConnectionTimeOutMethod) userInfo:nil repeats:NO];
//            isConnectedtoAdd = YES;
//            classPeripheral = p;
//            globalPeripheral = p;
//            [APP_DELEGATE startHudProcess:@"Connecting..."];
//            [[BLEManager sharedManager] connectDevice:p];
//        }
//    }
    selectedIndex = indexPath.row;
}
#pragma mark - MEScrollToTopDelegate Methods
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [topPullToRefreshManager tableViewScrolled];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y >=360.0f)
    {
    }
    else
        [topPullToRefreshManager tableViewReleased];
}
- (void)pullToRefreshTriggered:(MNMPullToRefreshManager *)manager
{
    [self performSelector:@selector(stoprefresh) withObject:nil afterDelay:1.5];
}
-(void)stoprefresh
{
    [self refreshBtnClick];
    [topPullToRefreshManager tableViewReloadFinishedAnimated:NO];
}
-(void)btnHistoyClick
{
    lblBadgeHistry.hidden = false;
         if (globalBadgeCount <= 0)
         {
             self->lblBadgeHistry.hidden = true;
         }
         else
         {
             self->lblBadgeHistry.hidden = false;
         }
    
    globalHistoryVC = [[HistoryVC alloc] init];
    [self.navigationController pushViewController:globalHistoryVC animated:true];
}
-(NSString *)checkforValidString:(NSString *)strRequest
{
    NSString * strValid;
    if (![strRequest isEqual:[NSNull null]]) //NULL
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
    strValid = [strValid stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    return strValid;
}
// css add this
-(void)refreshBtnClick
{
    
    [[[BLEManager sharedManager] foundDevices] removeAllObjects];
    [[BLEManager sharedManager] rescan];
    [tblDeviceList reloadData];
    
    NSArray * tmparr = [[BLEManager sharedManager]getLastConnected];
    for (int i=0; i<tmparr.count; i++)
    {
        CBPeripheral * p = [tmparr objectAtIndex:i];
        NSString * strCurrentIdentifier = [NSString stringWithFormat:@"%@",p.identifier];
        if ([[arrGlobalDevices valueForKey:@"identifier"] containsObject:strCurrentIdentifier])
        {
            NSInteger  foudIndex = [[arrGlobalDevices valueForKey:@"identifier"] indexOfObject:strCurrentIdentifier];
            if (foudIndex != NSNotFound)
            {
                if ([arrGlobalDevices count] > foudIndex)
                {
                    if (![[[[BLEManager sharedManager] foundDevices] valueForKey:@"identifier"] containsObject:strCurrentIdentifier])
                    {
                        [[[BLEManager sharedManager] foundDevices] addObject:[arrGlobalDevices objectAtIndex:foudIndex]];
                    }
                }
            }
        }
    }
    if ( [[[BLEManager sharedManager] foundDevices] count] >0)
    {
        tblDeviceList.hidden = false;
        lblNoDevice.hidden = true;
        [advertiseTimer invalidate];
        advertiseTimer = nil;
        [tblDeviceList reloadData];
    }
    else
    {
        tblDeviceList.hidden = true;
        lblNoDevice.hidden = false;
        [advertiseTimer invalidate];
        advertiseTimer = nil;
        advertiseTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(AdvertiseTimerMethod) userInfo:nil repeats:NO];
    }
}
-(void)btnLogoutClick
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeCaution];
    [alert addButton:@"Yes" withActionBlock:
     ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.3];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[[UIApplication sharedApplication] keyWindow] cache:YES];
        [UIView commitAnimations];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"IS_LOGGEDIN"];
     
        [[NSUserDefaults standardUserDefaults] synchronize];
    
        [APP_DELEGATE movetoLogin];
     }];
    [alert showAlertInView:self
                 withTitle:@"SC2 Companion App"
              withSubtitle:@"Are you sure you want to logout?"
           withCustomImage:[UIImage imageNamed:@"logo.png"]
       withDoneButtonTitle:@"No" andButtons:nil];
}
-(void)btnNotificationSeeMapClick
{
    [self TimeoutforHideNotification];

    globalBadgeCount = globalBadgeCount - 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = globalBadgeCount;

    
    if ([[notificationDict valueForKey:@"Geo_Type"] isEqualToString:@"00"])
    {
        RadialGeofenceVC *view1 = [[RadialGeofenceVC alloc]init];
        view1.isfromEdit = YES;
        view1.isfromHistory = NO;
        view1.dictGeofenceInfo = notificationDict;
        [self.navigationController pushViewController:view1 animated:true];
    }
    else
    {
        PolygonGeofenceVC *view1 = [[PolygonGeofenceVC alloc]init];
        view1.isfromEdit = YES;
        view1.isfromHistory = NO;
        view1.dictGeofenceInfo = notificationDict;
        [self.navigationController pushViewController:view1 animated:true];
    }
}
-(void)btnNotificationIgnoreClick
{
    [self TimeoutforHideNotification];
}
#pragma mark- AlertView
-(void)ShowGeofenceAlertWithTitle:(NSString *)strErrorMsg withTitle:(NSString *)strTitle withDict:(NSMutableDictionary *)detailDict
{
    if (lblBadgeHistry == nil)
    {
        NSLog(@"-==================> I am nil==========>");
    }
    
    NSString * strBleAddress = [self checkforValidString:[detailDict valueForKey:@"bleAddress"]];
    
    if (![strBleAddress isEqualToString:@"NA"])
    {
        NSString * strBadgeCount = [self checkforValidString:[[NSUserDefaults standardUserDefaults] valueForKey:strBleAddress]];
        int previousCount = 0;
        if (![strBadgeCount isEqualToString:@"NA"])
        {
            previousCount = [strBadgeCount intValue];
        }
        previousCount = previousCount + 1;
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",previousCount] forKey:strBleAddress];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [tblDeviceList reloadData];
    }
    globalBadgeCount = globalBadgeCount+1;
    lblBadgeHistry.hidden = false;
    lblBadgeHistry.text = [NSString stringWithFormat:@"%ld",(long)globalBadgeCount];
    if (globalBadgeCount >= 100)
    {
        lblBadgeHistry.frame = CGRectMake(DEVICE_WIDTH-30, globalStatusHeight, 28, 20);
    }
    else
    {
        lblBadgeHistry.frame = CGRectMake(DEVICE_WIDTH-25, globalStatusHeight, 20, 20);
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = globalBadgeCount; // biayya changed

    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication * app=[UIApplication sharedApplication];
        if (app.applicationState == UIApplicationStateBackground)
        {
            NSLog(@"We are in the background Disconnect");
            UIUserNotificationSettings *notifySettings=[[UIApplication sharedApplication] currentUserNotificationSettings];
            if ((notifySettings.types & UIUserNotificationTypeAlert)!=0)
            {
//                globalBadgeCount = globalBadgeCount+1;

                UILocalNotification *notification=[UILocalNotification new];
                notification.soundName = @"alert_alarm.mp3";
                notification.alertBody= strErrorMsg;
                [app presentLocalNotificationNow:notification];
            }
        }
    });

    //To show Alert Popup
    if ([strCurrentScreen isEqualToString:@"LiveTracking"])//Kalpesh26062021
    {
        [self ShowNotificationofGeofence:strTitle withMsg:strErrorMsg withData:detailDict];
//        ShowNotificationofGeofence
    }
    else
    {
        [geofenceAlertPopup removeFromSuperview];
        geofenceAlertPopup = [[FCAlertView alloc] init];
        geofenceAlertPopup.colorScheme = [UIColor blackColor];
        geofenceAlertPopup.detailsDict = detailDict;
        [geofenceAlertPopup makeAlertTypeCaution];
        typeof(self) __weak weakSelf = self;

           [geofenceAlertPopup addButton:@"Seen in Map" withActionBlock:^
           { // see in map action here
               NSLog(@"This alert's Data =%@",detailDict);
               
               globalBadgeCount = globalBadgeCount - 1;
               [UIApplication sharedApplication].applicationIconBadgeNumber = globalBadgeCount;

               typeof(weakSelf) __strong strongSelf = weakSelf;
               if (strongSelf != nil )
               {
                   if (globalBadgeCount <= 0)
                   {
                       strongSelf->lblBadgeHistry.hidden = true;
                       strongSelf->lblBadgeHistry.text = [NSString stringWithFormat:@"0"];
                   }
                   else
                   {
                       strongSelf->lblBadgeHistry.hidden = false;
                       strongSelf->lblBadgeHistry.text = [NSString stringWithFormat:@"%ld",(long)globalBadgeCount];
                   }
                   if (globalBadgeCount >= 100)
                   {
                       strongSelf->lblBadgeHistry.frame = CGRectMake(DEVICE_WIDTH-30, globalStatusHeight, 28, 20);
                   }
                   else
                   {
                       strongSelf->lblBadgeHistry.frame = CGRectMake(DEVICE_WIDTH-25, globalStatusHeight, 20, 20);
                   }
               }
               if ([[detailDict valueForKey:@"Geo_Type"] isEqualToString:@"00"])
               {
                   RadialGeofenceVC *view1 = [[RadialGeofenceVC alloc]init];
                   view1.isfromEdit = YES;
                   view1.isfromHistory = NO;
                   view1.dictGeofenceInfo = detailDict;
                   [strongSelf.navigationController pushViewController:view1 animated:true];
               }
               else
               {
                   PolygonGeofenceVC *view1 = [[PolygonGeofenceVC alloc]init];
                   view1.isfromEdit = YES;
                   view1.isfromHistory = NO;
                   view1.dictGeofenceInfo = detailDict;
                   [strongSelf.navigationController pushViewController:view1 animated:true];
               }
           }];
        geofenceAlertPopup.firstButtonCustomFont = [UIFont fontWithName:CGRegular size:textSize];
            geofenceAlertPopup.delegate = self;
       [geofenceAlertPopup showAlertWithTitle:strTitle withSubtitle:strErrorMsg withCustomImage:[UIImage imageNamed:@"alert-round.png"] withDoneButtonTitle:@"Ignore" andButtons:nil];
        [geofenceAlertPopup setAlertSoundWithFileName:@"alert_alarm.mp3"];
    }
}
-(void)SetupAlertViewForSetDeviceName
{
      FCAlertView *alert = [[FCAlertView alloc] init];
       alert.delegate = self;
       alert.tag = 123;
       alert.colorScheme = [UIColor colorWithRed:44.0/255.0f green:62.0/255.0f blue:80.0/255.0f alpha:1.0];
       customField = [[UITextField alloc] init];
       customField.tag = 123;
       customField.placeholder = @"Enter Name";
       [alert addTextFieldWithCustomTextField:customField andPlaceholder:nil andTextReturnBlock:^(NSString *text) {
           NSLog(@"Custom TextField Returns: %@", text); // Do what you'd like with the text returned from the field
       }];
    
    [alert addButton:@"Cancel" withActionBlock:^
    {
        NSLog(@"Cancel click");
        [self setDefaultDeviceName:[NSString stringWithFormat:@"SC2 Device %lu",arrGlobalDeviceNames.count+1]];
    }];
       [alert showAlertInView:self
                    withTitle:@"SC2 Companion App"
                 withSubtitle:@"Save your device name"
              withCustomImage:nil
          withDoneButtonTitle:OK_BTN
                   andButtons:nil];
}
- (void)FCAlertDoneButtonClicked:(FCAlertView *)alertView
{
    NSLog(@"Done Button Clicked");
    
    if (alertView.tag == 123)
    {
        if([[self checkforValidString:customField.text] isEqualToString:@"NA"])
        {
            [self setDefaultDeviceName:[NSString stringWithFormat:@"SC2 Device %lu",arrGlobalDeviceNames.count+1]];
        }
        else
        {
            [self setDefaultDeviceName:customField.text];
        }
    }
}
-(void)ErrorPopUP:(NSString *)strErrorMsg
{
    FCAlertView *alert = [[FCAlertView alloc] init];
            alert.colorScheme = [UIColor blackColor];
            [alert makeAlertTypeWarning];
            [alert showAlertInView:self
                         withTitle:@"SC2 Companion App"
                      withSubtitle:strErrorMsg
                   withCustomImage:[UIImage imageNamed:@"logo.png"]
               withDoneButtonTitle:nil
                        andButtons:nil];
}
#pragma mark - Set device Name Methods
-(void)setDefaultDeviceName:(NSString *)strDeviceName
{
//    NSMutableArray * arrtem = [[NSMutableArray alloc] init];
//    arrtem = [[[BLEManager sharedManager] foundDevices] mutableCopy];
    
    if ([[[[BLEManager sharedManager] foundDevices] valueForKey:@"peripheral"] containsObject:tempSelectedPeripheral])
    {
        NSInteger foundIndex = [[[[BLEManager sharedManager] foundDevices] valueForKey:@"peripheral"] indexOfObject:tempSelectedPeripheral];
        if (foundIndex != NSNotFound)
        {
            if ([[[BLEManager sharedManager] foundDevices] count] > foundIndex)
            {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                dict = [[[[BLEManager sharedManager] foundDevices] objectAtIndex:foundIndex] mutableCopy];
                [dict setValue:strDeviceName forKey:@"name"];
                [[[BLEManager sharedManager] foundDevices] replaceObjectAtIndex:foundIndex withObject:dict];
                [self->tblDeviceList reloadData];
                
                NSString *  strAddress = [[[[BLEManager sharedManager] foundDevices] objectAtIndex:foundIndex] valueForKey:@"bleAddress"];
                if ([[arrGlobalDevices valueForKey:@"bleAddress"] containsObject:strAddress])
                {
                    NSInteger foundIndex = [[arrGlobalDevices valueForKey:@"bleAddress"] indexOfObject:strAddress];
                    if (foundIndex != NSNotFound)
                    {
                        if ([arrGlobalDevices count] > foundIndex)
                        {
                            [arrGlobalDevices replaceObjectAtIndex:foundIndex withObject:dict];
                        }
                    }
                }
                if ([[arrGlobalDeviceNames valueForKey:@"BLE_Address"] containsObject:strAddress])
                {
                    NSInteger foundIndex = [[arrGlobalDeviceNames valueForKey:@"BLE_Address"] indexOfObject:strAddress];
                    if (foundIndex != NSNotFound)
                    {
                        if ([arrGlobalDeviceNames count] > foundIndex)
                        {
                            [[arrGlobalDeviceNames objectAtIndex:foundIndex] setValue:strDeviceName forKey:@"name"];
                        }
                    }
                }
                else
                {
                    NSMutableDictionary * dct = [[NSMutableDictionary alloc] init];
                    [dct setValue:strAddress forKey:@"BLE_Address"];
                    [dct setValue:strDeviceName forKey:@"name"];
                    [arrGlobalDeviceNames addObject:dct];
                }
                [[NSUserDefaults standardUserDefaults] setObject:arrGlobalDeviceNames forKey:@"DeviceName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
}
#pragma mark - Timer Methods
-(void)ConnectionTimeOutMethod
{
    if (classPeripheral.state == CBPeripheralStateConnected)
    {
    }
    else
    {
        if (classPeripheral == nil)
        {
            return;
        }
        [APP_DELEGATE endHudProcess];
        [self refreshBtnClick];
    }
}
-(void)AdvertiseTimerMethod
{
    [APP_DELEGATE endHudProcess];
    if ( [[[BLEManager sharedManager] foundDevices] count] >0)
    {
        self->tblDeviceList.hidden = false;
        self->lblNoDevice.hidden = true;
        [self->tblDeviceList reloadData];
    }
    else
    {
        self->tblDeviceList.hidden = true;
        self->lblNoDevice.hidden = false;
    }
        [self->tblDeviceList reloadData];
}
#pragma mark - BLE Methods
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (@available(iOS 10.0, *)) {
        if (central.state == CBManagerStatePoweredOff)
        {
            [APP_DELEGATE endHudProcess];
            [self GlobalBLuetoothCheck];
        }
    } else
    {
    }
}
-(void)InitialBLE
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotifiyDiscoveredDevices" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DeviceDidConnectNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DeviceDidDisConnectNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifiyDiscoveredDevices:) name:@"NotifiyDiscoveredDevices" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDidConnectNotification:) name:@"DeviceDidConnectNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDidDisConnectNotification:) name:@"DeviceDidDisConnectNotification" object:nil];
}
-(void)NotifiyDiscoveredDevices:(NSNotification*)notification//Update peripheral
{
dispatch_async(dispatch_get_main_queue(), ^(void)
    {
    if ( [[[BLEManager sharedManager] foundDevices] count] >0){
        self->tblDeviceList.hidden = false;
        self->lblNoDevice.hidden = true;
        [self->tblDeviceList reloadData];
        [self->advertiseTimer invalidate];
        self->advertiseTimer = nil;
        [APP_DELEGATE endHudProcess];
    }
    else
    {
        self->tblDeviceList.hidden = true;
        self->lblNoDevice.hidden = false;}
        [self->tblDeviceList reloadData];});
 }
-(void)DeviceDidConnectNotification:(NSNotification*)notification//Connect periperal
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self->tblDeviceList reloadData];
        [APP_DELEGATE endHudProcess];
    });
}

-(void)DeviceDidDisConnectNotification:(NSNotification*)notification//Disconnect periperal
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [[[BLEManager sharedManager] foundDevices] removeAllObjects];
        [[BLEManager sharedManager] rescan];
        [self->tblDeviceList reloadData];
        [APP_DELEGATE endHudProcess];
        [self TostNotification:@"Device Disconnected"];
        
        NSArray * tmparr = [[BLEManager sharedManager]getLastConnected];
        for (int i=0; i<tmparr.count; i++)
        {
            CBPeripheral * p = [tmparr objectAtIndex:i];
            NSString * strCurrentIdentifier = [NSString stringWithFormat:@"%@",p.identifier];
            if ([[arrGlobalDevices valueForKey:@"identifier"] containsObject:strCurrentIdentifier])
            {
                NSInteger  foudIndex = [[arrGlobalDevices valueForKey:@"identifier"] indexOfObject:strCurrentIdentifier];
                if (foudIndex != NSNotFound)
                {
                    if ([arrGlobalDevices count] > foudIndex)
                    {
                        if (![[[[BLEManager sharedManager] foundDevices] valueForKey:@"identifier"] containsObject:strCurrentIdentifier])
                        {
                            [[[BLEManager sharedManager] foundDevices] addObject:[arrGlobalDevices objectAtIndex:foudIndex]];
                        }
                    }
                }
            }
        }
    });
}
-(void)AuthenticationCompleted
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
    {
//        [APP_DELEGATE startHudProcess:@"Loading..."];
//        [self TostNotification:@"Device Connected"];
//        [self TestingWith100Packets];// for testing 100 packets
        
        globalPeripheral = self->classPeripheral;
        self-> tempSelectedPeripheral = self->classPeripheral;
        
        [self RequestForIMEInumbertotheDevice];
        
        NSMutableArray * tmpArr = [[BLEManager sharedManager] foundDevices];
        if ([[tmpArr valueForKey:@"peripheral"] containsObject:self->classPeripheral])
        {
            NSInteger  foudIndex = [[tmpArr valueForKey:@"peripheral"] indexOfObject:self->classPeripheral];
            if (foudIndex != NSNotFound)
            {
                if ([tmpArr count] > foudIndex)
                {
                    NSString * strCurrentIdentifier = [NSString stringWithFormat:@"%@",self->classPeripheral.identifier];
                    NSString * strName = [[tmpArr  objectAtIndex:foudIndex]valueForKey:@"name"];
                    NSString * strAddress = [[tmpArr  objectAtIndex:foudIndex]valueForKey:@"bleAddress"];

                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        
                        if ([arrGlobalDeviceNames count]==0)
                        {
                            [self SetupAlertViewForSetDeviceName];
                        }
                    });
                    if (![[arrGlobalDevices valueForKey:@"identifier"] containsObject:strCurrentIdentifier])
                    {
                        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:strCurrentIdentifier,@"identifier",self->classPeripheral,@"peripheral",strName,@"name",strAddress,@"bleAddress", nil];
                        [arrGlobalDevices addObject:dict];
                    }
                }
            }
        }
        [self->tblDeviceList reloadData];
        [self refreshBtnClick];
    });
}
-(void)GlobalBLuetoothCheck
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Geofence Alert" message:@"Please turn on Bluetooth to access the App." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:true completion:nil];
}
-(void)WritetoDevicetogetGeofenceDetail:(NSString *)strGeoID
{
    [[BLEService sharedInstance] WritetoDevicetogetGeofenceDetail:strGeoID];
}
-(NSString *)getStringConvertedinUnsigned:(NSString *)strNormal
{
    NSString * strKey = strNormal;
    long ketLength = [strKey length]/2;
    NSString * strVal;
    for (int i=0; i<ketLength; i++)
    {
        NSRange range73 = NSMakeRange(i*2, 2);
        NSString * str3 = [strKey substringWithRange:range73];
        if ([strVal length]==0)
        {
            strVal = [NSString stringWithFormat:@" 0x%@",str3];
        }
        else
        {
            strVal = [strVal stringByAppendingString:[NSString stringWithFormat:@" 0x%@",str3]];
        }
    }
    return strVal;
}
#pragma mark
-(void)ConnectionSuccessfulStatSyncGeofence;
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [APP_DELEGATE endHudProcess];
        [APP_DELEGATE startHudProcess:@"Syncing Geofence..."];
        [self performSelector:@selector(stopIndicatorOfSyncGeofence) withObject:nil afterDelay:20];
    });
}
-(void)stopIndicatorOfSyncGeofence
{
    [APP_DELEGATE endHudProcess];
}
-(void)SaveAllGeofenceListwithTimeStamp:(NSMutableArray *)arrGeoTimeStamp;
{
    isAnyGeofenceFoundSynced = YES;
    
    for (int i=0 ; i<[arrGeoTimeStamp count]; i++)
    {
        [arrTempListGeofence addObject:[arrGeoTimeStamp objectAtIndex:i]];
    }
    NSLog(@"All Geofence ID & Time Stamp =%@",arrTempListGeofence);
}
-(void)ReceievedGeofenceDatafromBLE
{
    if ([arrTempListGeofence count]>0)
    {
        [arrTempListGeofence removeObjectAtIndex:0];
        [self StartSyncingGeofence];
    }
}
-(void)StartSyncingGeofence
{
    NSLog(@"StartSyncingGeofence ==========%@",arrTempListGeofence);

    if ([arrTempListGeofence count]>0)
    {
        BOOL isDataVali = NO;
        NSString * strGeoId = [[arrTempListGeofence objectAtIndex:0] valueForKey:@"geofence_ID"];
        NSString * strTime = [[arrTempListGeofence objectAtIndex:0] valueForKey:@"time_stamp"];
        
        if ([[[arrTempListGeofence objectAtIndex:0] valueForKey:@"geofence_ID"]  isEqualToString: @"0000"])
        {
            [arrTempListGeofence removeObjectAtIndex:0];
            [self StartSyncingGeofence];
        }
        else
        {
            if ([[arrGlobalGeofenceList valueForKey:@"geofence_ID"] containsObject:strGeoId])
            {
                NSInteger foundIndex = [[arrGlobalGeofenceList valueForKey:@"geofence_ID"] indexOfObject:strGeoId];
                if (foundIndex != NSNotFound)
                {
                    if ([[arrGlobalGeofenceList valueForKey:@"time_stamp"] containsObject:strTime])
                    {
                        NSInteger foundTimeIndex = [[arrGlobalGeofenceList valueForKey:@"time_stamp"] indexOfObject:strTime];
                        if (foundTimeIndex != NSNotFound)
                        {
                            isDataVali = YES;
                        }
                    }
                }
            }
            if (isDataVali == YES)
            {
                [arrTempListGeofence removeObjectAtIndex:0];
                [self StartSyncingGeofence];
            }
            else
            {
                NSString * strPassId = [self stringFroHex:strGeoId];
                [self WritetoDevicetogetGeofenceDetail:strPassId];
            }
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^(void){
        [APP_DELEGATE endHudProcess];
        });
//        if (isAnyGeofenceFoundSynced == YES)
//        {
        NSLog(@"==========>[[BLEService sharedInstance] SendAcknowledgementofDataSyncFinished]");
            [[BLEService sharedInstance] SendAcknowledgementofDataSyncFinished];
//        }
    }
}
-(void)SendFirstPacketToHomeVC:(NSString *)strID withSize:(NSString *)strSize withType:(NSString *)strType  withRadius:(NSString *)strRadius withTime:(NSString *)strTimeStamp
{
    NSLog(@"=First Packet ID====>%@, SIZE ==%@, TYPE==%@, RADIUS ==%@",strID, strSize, strType, strRadius);
    [globalDict setValue:strID forKey:@"geofence_ID"];
    [globalDict setValue:strSize forKey:@"GeofenceSize"];
    [globalDict setValue:strType forKey:@"type"];
    [globalDict setValue:strRadius forKey:@"radiusOrvertices"];
    [globalDict setValue:strTimeStamp forKey:@"time_stamp"];
}
-(void)SendSecondPacketLatLongtoHomeVC:(float)latitude withLongitude:(float)longitude
{
    NSLog(@"=Second Packet Lat====>%f Long==%f",latitude, longitude);
  
    [globalDict setValue:[NSNumber numberWithFloat:latitude] forKey:@"lat"];
    [globalDict setValue:[NSNumber numberWithFloat:longitude] forKey:@"long"];
}
-(void)ThirdPackettoHomeVC:(NSString *)strLength withGSMTime:(NSString *)strGsmTime withIrridiumTime:(NSString *)strIrridmTime withRuleId:(NSString *)strRuleId
{
    NSLog(@"=Third packet No.of Rules=>%@",strRuleId);
    [globalDict setValue:strLength forKey:@"PacketLength"];
    [globalDict setValue:strRuleId forKey:@"number_of_rules"];
    [globalDict setValue:strGsmTime forKey:@"gsm_time"];
    [globalDict setValue:strIrridmTime forKey:@"irridium_time"];

}
-(void)FourthPacketToHomeVC:(NSString *)strruleID withValue:(NSString *)strValue withNoOfAction:(NSString *)strNoAction
{
    NSLog(@"=Fourth Packet Rule ID=>%@  RuleValue==%@  No.of Action-==%@",strruleID, strValue, strNoAction);
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:strruleID forKey:@"rule_ID"];
    [dict setValue:strValue forKey:@"rule_value"];
    [dict setValue:strNoAction forKey:@"NoAction"];
    [arrRules addObject:dict];
}
-(void)FifthPockeToHome:(NSMutableArray *)arrFithPacktData
{
    NSLog(@"=Fifth Packet Array=>%@",arrFithPacktData);
    for (int i=0 ; i<[arrFithPacktData count]; i++)
    {
        [arrActons addObject:[arrFithPacktData objectAtIndex:i]];
    }
}
-(void)PolygonLatLongtoHomeLatlonArray:(NSMutableArray *)arrLatLong
{
//    NSLog(@"Polygon Packet Array=>%@",arrLatLong);
    for (int i=0 ; i<[arrLatLong count]; i++)
    {
        [arrPolygon addObject:[arrLatLong objectAtIndex:i]];
    }
}
-(void)FifthPacketoHomeBLE //
{
    NSLog(@"=Sixth Packet =>");
    [self InsertToDataBase];
}
-(NSString *)getRuleNamefromRuleId:(NSString *)strRuleId
{
    NSString * strRuleName = @"NA";
    if ([strRuleId isEqualToString:@"03"])
    {
        strRuleName = @"Breach Minimum Dwell Time";
    }
    else if ([strRuleId isEqualToString:@"04"])
    {
        strRuleName = @"Breach Maximum Dwell Time";
    }
    else if ([strRuleId isEqualToString:@"05"])
    {
        strRuleName = @"Breach Minimum Speed limit";
    }
    else if ([strRuleId isEqualToString:@"06"])
    {
        strRuleName = @"Breach Maximum Speed limit";
    }
    else if ([strRuleId isEqualToString:@"07"])
    {
        strRuleName = @"Boundry Cross Violation";
    }
    return strRuleName;
}
-(void)SendAlertInfoGeoID:(NSMutableDictionary *)dataDict isGeoAvailable:(BOOL)isAvail
{
    currentAlertDict = [[NSMutableDictionary alloc] init];
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithInteger: timeStamp];
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [DateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC+5:30"]];
    
    NSString * currentDateAndTime = [NSString stringWithFormat:@"%@",[DateFormatter stringFromDate:[NSDate date]]];
    NSString * strTimeStamp = [NSString stringWithFormat:@"%@",timeStampObj];

    [dataDict setObject:currentDateAndTime forKey:@"date_Time"];
    [dataDict setObject:strTimeStamp forKey:@"timeStamp"];

    NSString * strFoundIdentifier = [dataDict valueForKey:@"identifier"];
    if ([[arrGlobalDevices valueForKey:@"identifier"] containsObject:strFoundIdentifier])
    {
        NSInteger  foudIndex = [[arrGlobalDevices valueForKey:@"identifier"] indexOfObject:strFoundIdentifier];
        if (foudIndex != NSNotFound)
        {
            if ([arrGlobalDevices count] > foudIndex)
            {
                NSString * strCurrentIdentifier = [NSString stringWithFormat:@"%@",globalPeripheral.identifier]; // classPeripheral
                NSString * strName = [[arrGlobalDevices objectAtIndex:foudIndex]valueForKey:@"name"];
                NSString * strAddress = [[arrGlobalDevices  objectAtIndex:foudIndex]valueForKey:@"bleAddress"];
                if ([[arrGlobalDeviceNames valueForKey:@"BLE_Address"] containsObject:strAddress])
                {
                    NSInteger foundIndex = [[arrGlobalDeviceNames valueForKey:@"BLE_Address"] indexOfObject:strAddress];
                    if (foundIndex != NSNotFound)
                    {
                        if ([arrGlobalDeviceNames count] > foundIndex)
                        {
                            strName = [[arrGlobalDeviceNames objectAtIndex:foundIndex] valueForKey:@"name"];
                        }
                    }
                }
                    [dataDict setObject:strCurrentIdentifier forKey:@"identifier"];
                    [dataDict setObject:globalPeripheral forKey:@"peripheral"]; // classPeripheral
                    [dataDict setObject:strName forKey:@"device_name"];
                    [dataDict setObject:strAddress forKey:@"bleAddress"];
            }
        }
    }
   
    [arrAlertPacketsQueue addObject:dataDict];
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(ShowDelayedPopup:) userInfo:dataDict repeats:NO];
    });
}
-(void)ShowDelayedPopup:(NSTimer*)theTimer
{
    NSString * strRuleId = [[theTimer userInfo] objectForKey:@"BreachRule_ID"];
    NSString * strBrechType = [[theTimer userInfo] objectForKey:@"Breach_Type"];
    NSString * strGeoID = [[theTimer userInfo] objectForKey:@"geofence_ID"];
    NSString * strBreachRuleValue = [[theTimer userInfo] objectForKey:@"BreachRuleValue"] ;
    NSString * strBreachLat = [[theTimer userInfo] objectForKey:@"Breach_Lat"] ;
    NSString * strBreachLon = [[theTimer userInfo] objectForKey:@"Breach_Long"] ;
    NSString * strBreachDateTime = [[theTimer userInfo] objectForKey:@"date_Time"] ;
    NSString * strBreachTimestamp = [[theTimer userInfo] objectForKey:@"timeStamp"] ;
    NSString * strBleAddress = [[[theTimer userInfo] objectForKey:@"bleAddress"] uppercaseString];
    NSString * strActualRuleValue = @"NA";
    NSString * strMsg = @"NA";
    NSString * strGeoType = @"NA";
    NSString * strGeoName = @"NA";
    //css add this
    NSString * strGeoTimeStamp = @"NA";
    NSString * strGeoLat = @"NA";
    NSString * strGeoLog = @"NA";
    NSString * strGeoRadius = @"NA";

    NSLog(@"-----------------> here we got the Popup delayed by 3 send--------->%@",[theTimer userInfo]);

    bool isGotData = NO;
    if ([[arrGlobalGeofenceList valueForKey:@"geofence_ID"] containsObject:strGeoID])
    {
        NSInteger foundIndex = [[arrGlobalGeofenceList valueForKey:@"geofence_ID"] indexOfObject:strGeoID];
        if (foundIndex != NSNotFound)
        {
            if ([arrGlobalGeofenceList count] > foundIndex)
            {
                isGotData = YES;
                strGeoType = [self checkforValidString:[[arrGlobalGeofenceList objectAtIndex:foundIndex] valueForKey:@"type"]];
                strGeoName = [self checkforValidString:[[arrGlobalGeofenceList objectAtIndex:foundIndex] valueForKey:@"geofence_ID"]];
                strGeoTimeStamp = [self checkforValidString:[[arrGlobalGeofenceList objectAtIndex:foundIndex] valueForKey:@"time_stamp"]];
                strGeoLat = [self checkforValidString:[[arrGlobalGeofenceList objectAtIndex:foundIndex] valueForKey:@"lat"]];
                strGeoLog = [self checkforValidString:[[arrGlobalGeofenceList objectAtIndex:foundIndex] valueForKey:@"long"]];
                strGeoRadius = [self checkforValidString:[[arrGlobalGeofenceList objectAtIndex:foundIndex] valueForKey:@"radiusOrvertices"]];
            }
        }
    }
    if (isGotData == NO)
    {
        NSString * strQuery = [NSString stringWithFormat:@"select * from Geofence where geofence_ID = '%@'", strGeoID];
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        [[DataBaseManager dataBaseManager] execute:strQuery resultsArray:arr];
        if ([arr count]>0)
        {
            strGeoType = [[arr objectAtIndex:0] valueForKey:@"type"];
            strGeoName = [[arr objectAtIndex:0] valueForKey:@"name"];
        }
    }
    
    currentAlertDict = [[theTimer userInfo] mutableCopy];
    NSString* strRuleName = [self getRuleNamefromRuleId:strRuleId];
    [currentAlertDict setObject:strRuleName forKey:@"Rule_Name"];
    [currentAlertDict setObject:strGeoType forKey:@"Geo_Type"];
    [currentAlertDict setObject:strGeoTimeStamp forKey:@"Geo_timeStamp"];
    [currentAlertDict setObject:strGeoLat forKey:@"Geo_Lat"];
    [currentAlertDict setObject:strGeoLog forKey:@"Geo_Log"];
    [currentAlertDict setObject:strGeoRadius forKey:@"Geo_Radius"];
    [currentAlertDict setObject:strBleAddress forKey:@"bleAddress"];

    if (![[self checkforValidString:strGeoName] isEqualToString:@"NA"])
    {
        strGeoName = [self checkforValidString:[self stringFroHex:strGeoID]];;
    }

    if ([strRuleId isEqual:@"07"])
    {
        if ([strBrechType isEqual:@"00"])
        {
            strMsg = [NSString stringWithFormat:@"SC2 Device : %@ went out of Geofence %@",strBleAddress,strGeoName];
            [self ShowGeofenceAlertWithTitle:strMsg withTitle:@"Boundry Cross Violation!" withDict:currentAlertDict];
        }
        else if ([strBrechType isEqual:@"01"])
        {
            strMsg = [NSString stringWithFormat:@"SC2 Device : %@ came in Geofence %@",strBleAddress,strGeoName];
            [self ShowGeofenceAlertWithTitle:strMsg  withTitle:@"Boundry Cross Violation!" withDict:currentAlertDict];
        }
    }
    else
    {
        BOOL isWeFoundRule = NO;
        if ([[arrAllSavedRules valueForKey:@"geofence_ID"] containsObject:strGeoID])
        {
            NSInteger foundGeoID = [[arrAllSavedRules valueForKey:@"geofence_ID"] indexOfObject:strGeoID];

            if (foundGeoID != NSNotFound)
            {
                if ([arrAllSavedRules count]>foundGeoID)
                {
                    NSMutableArray * arrAllRules = [[arrAllSavedRules objectAtIndex:foundGeoID] objectForKey:@"AllRules"];
                    if ([[arrAllRules valueForKey:@"rule_ID"] containsObject:strRuleId])
                    {
                        NSInteger foundRuleD = [[arrAllRules valueForKey:@"rule_ID"] indexOfObject:strRuleId];
                        if (foundRuleD != NSNotFound)
                        {
                            if ([arrAllRules count]>foundRuleD)
                            {
                                isWeFoundRule = YES;
                                strActualRuleValue = [[arrAllRules objectAtIndex:foundRuleD] valueForKey:@"rule_value"];
                                [currentAlertDict setObject:strActualRuleValue forKey:@"OriginalRuleValue"];
                            }
                        }
                    }
                }
            }
        }
        if (isWeFoundRule == NO)
        {
            NSString * strQuery = [NSString stringWithFormat:@"select rule_value from Rules_Table where geofence_ID = '%@' and rule_ID='%@'", strGeoID,strRuleId];
            NSMutableArray * arr = [[NSMutableArray alloc] init];
            [[DataBaseManager dataBaseManager] execute:strQuery resultsArray:arr];

            if ([arr count]>0)
            {
                strActualRuleValue = [[arr objectAtIndex:0] valueForKey:@"rule_value"];
                [currentAlertDict setObject:strActualRuleValue forKey:@"OriginalRuleValue"];
            }
        }
        if ([strRuleId isEqual:@"03"])
        {
            strMsg = [NSString stringWithFormat:@"%@\nMinimum Dwell time Permitted : %@\nTime spent : %@", strBleAddress,[self getHoursfromString:strActualRuleValue],[self getHoursfromString:strBreachRuleValue]];
            [self ShowGeofenceAlertWithTitle:strMsg  withTitle:@"Breach Minimum Dwell Time" withDict:currentAlertDict];
        }
        else if ([strRuleId isEqual:@"04"])
        {
            strMsg = [NSString stringWithFormat:@"%@\nMaximum Dwell time Permitted : %@\nTime spent : %@", strBleAddress,[self getHoursfromString:strActualRuleValue],[self getHoursfromString:strBreachRuleValue]];
            [self ShowGeofenceAlertWithTitle:strMsg  withTitle:@"Breach Maximum Dwell Time" withDict:currentAlertDict];
        }
        else if ([strRuleId isEqual:@"05"])
        {
            strMsg = [NSString stringWithFormat:@"%@\nMinimum Speed limit: %@ km/h\nCurrent Speed : %@ km/h", strBleAddress,strActualRuleValue,strBreachRuleValue];
            [self ShowGeofenceAlertWithTitle:strMsg  withTitle:@"Breach Minimum speed limit" withDict:currentAlertDict];
        }
        else if ([strRuleId isEqual:@"06"])
        {
            strMsg = [NSString stringWithFormat:@"%@\nMaximum Speed limit: %@ km/h\nCurrent Speed : %@ km/h", strBleAddress,strActualRuleValue,strBreachRuleValue];
            [self ShowGeofenceAlertWithTitle:strMsg  withTitle:@"Breach Maximum speed limit" withDict:currentAlertDict];
        }
    }
    [currentAlertDict setObject:strMsg forKey:@"Message"];

        NSString * strNA = @"NA";
        NSString * strActionQuery =  [NSString stringWithFormat:@"insert into 'Geofence_alert_Table'('geofence_ID','Breach_Type','Breach_Lat','Breach_Long','BreachRule_ID','BreachRuleValue','Geo_name','Geo_Type','date_Time','timeStamp','Rule_Name','is_Read','OriginalRuleValue', 'bleAddress','Message', 'isViewed','Geo_timeStamp','Geo_Lat','Geo_Log', 'Geo_Radius') values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",0,\"%@\",\"%@\",\"%@\",\"%@\")",strGeoID,strBrechType,strBreachLat,strBreachLon,strRuleId,strBreachRuleValue,strGeoName,strGeoType,strBreachDateTime,strBreachTimestamp,strRuleName,strNA,strActualRuleValue,strBleAddress,strMsg,strGeoTimeStamp,strGeoLat,strGeoLog, strGeoRadius];
        [[DataBaseManager dataBaseManager] executeSw:strActionQuery];
}
-(NSString *)getHoursfromString:(NSString *)strVal
{
    NSString * strHr = [NSString stringWithFormat:@"%@ Min",strVal]; //Hrs
    int inthr = [strVal intValue];
    if (inthr > 1)
    {
        strHr = [NSString stringWithFormat:@"%@ Min",strVal];// Hrs
    }
    return strHr;
}
#pragma mark- Insert to database
-(void)InsertToDataBase
{
    if (globalDict.count > 0)
    {
        NSString * FLat = [NSString stringWithFormat:@"%f", [[globalDict valueForKey:@"lat"] floatValue]];
        NSString * FLong = [NSString stringWithFormat:@"%f", [[globalDict valueForKey:@"long"] floatValue]];

        NSString * strGeoFncID = [self checkforValidString:[globalDict valueForKey:@"geofence_ID"]];
        NSString * strGeoFncType = [self checkforValidString:[globalDict valueForKey:@"type"]];
        NSString * strLat = [self checkforValidString:FLat]; //Latitude
        NSString * strLong = [self checkforValidString:FLong]; //Longitude
        NSString * strNoRules = [self checkforValidString:[globalDict valueForKey:@"number_of_rules"]];
        NSString * strIsActive = @"NA";
        NSString * strRadiusVertices = [self checkforValidString:[globalDict valueForKey:@"radiusOrvertices"]];
        NSString * strGSMtime = [self checkforValidString:[globalDict valueForKey:@"GSMtime"]];
        NSString * strIrridiumTime = [self checkforValidString:[globalDict valueForKey:@"IrridiumTime"]];
        NSString * strTimeStamp = [self checkforValidString:[globalDict valueForKey:@"time_stamp"]];

        NSString *query  = [NSString stringWithFormat:@"select * from Geofence where geofence_ID = '%@'",strGeoFncID];
        BOOL recordExist = [[DataBaseManager dataBaseManager] recordExistOrNot:query];
        NSString * strName = [self stringFroHex:strGeoFncID];


        if ([strGeoFncType isEqualToString:@"01"])
        {
            [globalDict setValue:[NSString stringWithFormat:@"0"] forKey:@"lat"];
            [globalDict setValue:[NSString stringWithFormat:@"0"] forKey:@"long"];
            
            strLat = @"0";
            strLong = @"0";
        }
        
        NSLog(@"=======================>Geofence Data===%@",globalDict);
        if (recordExist)
        {
            NSString *  strUpdateQury =  [NSString stringWithFormat:@"update Geofence set name = \"%@\", geofence_ID = \"%@\", type = \"%@\", lat = \"%@\", long = \"%@\", number_of_rules = \"%@\", is_active = \"%@\", radiusOrvertices = \"%@\", gsm_time = '%@', irridium_time = '%@', time_stamp = '%@' where id =\"%@\"",strName,strGeoFncID,strGeoFncType,strLat,strLong,strNoRules,strIsActive,strRadiusVertices,strGSMtime,strIrridiumTime,strTimeStamp,[globalDict valueForKey:@"geofence_ID"]];
            [[DataBaseManager dataBaseManager] execute:strUpdateQury];
            if ([[arrGlobalGeofenceList valueForKey:@"geofence_ID"] containsObject:strGeoFncID])
            {
                NSInteger foundIndex = [[arrGlobalGeofenceList valueForKey:@"geofence_ID"] indexOfObject:strGeoFncID];
                if (foundIndex != NSNotFound)
                {
                    if ([arrGlobalGeofenceList count] > foundIndex)
                    {
                        [arrGlobalGeofenceList replaceObjectAtIndex:foundIndex withObject:globalDict];;
                    }
                }
            }
            else
            {
                [arrGlobalGeofenceList addObject:globalDict];
            }
        }
        else
        {
            NSString * strGeofenceQuery = [NSString stringWithFormat:@"insert into 'Geofence'('name','geofence_ID','type','lat','long','number_of_rules','is_active','radiusOrvertices','gsm_time','irridium_time','time_stamp') values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",strName,strGeoFncID,strGeoFncType,strLat,strLong,strNoRules,strIsActive,strRadiusVertices,strGSMtime,strIrridiumTime, strTimeStamp];
            [[DataBaseManager dataBaseManager] execute:strGeofenceQuery];
            [arrGlobalGeofenceList addObject:globalDict];
        }
        NSLog(@"=======================>RUles Data===%@",arrRules);

        NSString * strDeleteRules = [NSString stringWithFormat:@"delete from Rules_Table where geofence_ID = '%@'",strGeoFncID];
        [[DataBaseManager dataBaseManager] executeSw:strDeleteRules];
        NSMutableArray * arrOnlyRules = [[NSMutableArray alloc] init];
        if ([[arrAllSavedRules valueForKey:@"geofence_ID"] containsObject:strGeoFncID])
        {
            NSInteger foundGeoID = [[arrAllSavedRules valueForKey:@"geofence_ID"] indexOfObject:strGeoFncID];

            if (foundGeoID != NSNotFound)
            {
                if ([arrAllSavedRules count]>foundGeoID)
                {
                    [arrAllSavedRules removeObjectAtIndex:foundGeoID];
                }
            }
        }
        for (int i = 0; i < [arrRules count]; i++)
        {
            NSString * strRuleID = [self checkforValidString:[[arrRules objectAtIndex:i] valueForKey:@"rule_ID"]];
            NSString * strValue  = [self checkforValidString:[[arrRules objectAtIndex:i] valueForKey:@"rule_value"]];
            NSString * strRuleNO = [self checkforValidString:[[arrRules objectAtIndex:i] valueForKey:@"NoAction"]];

            NSString * strRulesQuery =    [NSString stringWithFormat:@"insert into 'Rules_Table'('name','geofence_ID','rule_ID','rule_value','rule_number') values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",strName,strGeoFncID,strRuleID,strValue,strRuleNO];
             [[DataBaseManager dataBaseManager] executeSw:strRulesQuery];
            NSDictionary * dct = [[NSDictionary alloc] initWithObjectsAndKeys:strGeoFncID,@"geofence_ID",strValue,@"rule_value",strRuleID,@"rule_ID", nil];
            [arrOnlyRules addObject:dct];
        }
        if ([arrOnlyRules count] > 0)
        {
            NSDictionary * dct = [[NSDictionary alloc] initWithObjectsAndKeys:strGeoFncID,@"geofence_ID",arrOnlyRules,@"AllRules", nil];
            [arrAllSavedRules addObject:dct];
        }

        if ([strGeoFncType isEqualToString:@"01"])
        {
            /*NSString * strDeletePolygon = [NSString stringWithFormat:@"delete from Polygon_Lat_Long where geofence_ID = '%@'",strGeoFncID];
            [[DataBaseManager dataBaseManager] executeSw:strDeletePolygon];*/

            for (int i=0 ; i<[arrPolygon count]; i++)
            {
                NSString * strLat = [[arrPolygon objectAtIndex:i] valueForKey:@"lat"];
                NSString * strLon = [[arrPolygon objectAtIndex:i] valueForKey:@"lon"];
                NSString * strActionQuery =  [NSString stringWithFormat:@"insert into 'Polygon_Lat_Long'('geofence_ID','lat','long','Geo_timeStamp') values(\"%@\",\"%@\",\"%@\",\"%@\")",strGeoFncID,strLat,strLon,strTimeStamp];
                [[DataBaseManager dataBaseManager] execute:strActionQuery];
            }
        }
        if ([arrTempListGeofence count] > 0)
        {
            [arrTempListGeofence removeObjectAtIndex:0];
        }
        globalDict = [[NSMutableDictionary alloc] init];
        arrActons = [[NSMutableArray alloc] init];
        arrRules = [[NSMutableArray alloc] init];
        arrPolygon = [[NSMutableArray alloc] init];
        [self StartSyncingGeofence];
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
-(void)InsertToDeviceTable
{
//    NSString * strName = customField.text;
//    NSString * bleAddress = [arrayDevices valueForKey:@"bleAddress"];
//    NSString * strBLEDeviceData = [NSString stringWithFormat:@"insert into 'Geofence'('name','BLE_Address',) values(\"%@\",\"%@\")",strName,bleAddress];
//    [[DataBaseManager dataBaseManager] execute:strBLEDeviceData];
}
-(void)AlertViewFCTypeSuccess:(NSString *)strPopup
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeSuccess];
    [alert showAlertInView:self
                 withTitle:@"Boundry Cross Violation!"
              withSubtitle:strPopup
           withCustomImage:[UIImage imageNamed:@"logo.png"]
       withDoneButtonTitle:nil
                andButtons:nil];
}
-(void)TostNotification:(NSString *)StrToast
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = StrToast;
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.tag = 9999;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.9];
}
-(void)btnMoreClick:(id)sender
{
    if (selectedMoreIndex == [sender tag])
    {
        selectedMoreIndex = -1;
    }
    else
    {
        selectedMoreIndex = [sender tag];
    }
    [tblDeviceList reloadData];
}

-(void)GetTimeFromSettingVc:(NSString *)strTime
{
    NSLog(@"Selected time ====>%@",strTime);
}
-(void)btnConnectClick:(id)sender
{
    NSLog(@"%ld", (long)[sender tag]);
    NSMutableArray * arrayDevices = [[NSMutableArray alloc] init];
    arrayDevices =[[BLEManager sharedManager] foundDevices];

    if ([arrayDevices count]>0)
    {
        CBPeripheral * p = [[arrayDevices objectAtIndex:[sender tag]] valueForKey:@"peripheral"];
        if (p.state == CBPeripheralStateConnected)
        {
            [APP_DELEGATE startHudProcess:@"Disconnecting..."];
            [[BLEManager sharedManager] disconnectDevice:p];
        }
        else
        {
            [connectionTimer invalidate];
            connectionTimer = nil;
            connectionTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(ConnectionTimeOutMethod) userInfo:nil repeats:NO];
            [connectionTimer invalidate];
            connectionTimer = nil;
            isConnectedtoAdd = YES;
            classPeripheral = p;
            globalPeripheral = p;
            [APP_DELEGATE startHudProcess:@"Connecting..."];
            [[BLEManager sharedManager] connectDevice:p];
            selectedIndex = [sender tag];
        }
    }
}
#pragma mark-Cell Buttons
-(void)btnMessageClick:(id)sender
{
    if (classPeripheral.state == CBPeripheralStateConnected)
    {
   
        globalChatVC  = [[ChatVC alloc] init];
        globalChatVC.bleAdd = [[arrGlobalDevices objectAtIndex:[sender tag]] valueForKey:@"bleAddress"];
        [self.navigationController pushViewController:globalChatVC animated:true];

    }
    else
    {
//        [self ErrorPopUP:@"Please CONNECT device to send Message"];
    }
}
-(void)btnSettingClick:(id)sender
{
    NSMutableArray * arrayDevices = [[NSMutableArray alloc] init];
    arrayDevices =[[BLEManager sharedManager] foundDevices];

    if ([arrayDevices count]>0)
    {
        CBPeripheral * p = [[arrayDevices objectAtIndex:[sender tag]] valueForKey:@"peripheral"];
        [[BLEManager sharedManager] connectDevice:p];
        
        globalSettings = [[SettingVC alloc] init];
        globalSettings.classPeripheral = p;
        [self.navigationController pushViewController:globalSettings animated:true];
    }
}
-(void)btnSOSClick:(id)sender
{
    SOSclassVC * sosVc = [[SOSclassVC alloc] init];
    [self.navigationController pushViewController:sosVc animated:true];
}
-(void)btnGeofencelick:(id)sender
{
    lblBadgeHistry.hidden = false;
         if (globalBadgeCount <= 0)
         {
             self->lblBadgeHistry.hidden = true;
         }
         else
         {
             self->lblBadgeHistry.hidden = false;
         }
    
    globalHistoryVC = [[HistoryVC alloc] init];
    [self.navigationController pushViewController:globalHistoryVC animated:true];
    
}
-(void)btnEditClick:(id)sender
{
    
}
-(void)btnLiveTrackClick:(id)sender
{
    LiveTrackingVC * tVc = [[LiveTrackingVC alloc] init];
    tVc.classPeripheral = classPeripheral;
    [self.navigationController pushViewController:tVc animated:true];
    [self RequestForStartLivetracking:@"01"];

}
-(void)TestingWith100Packets
{
    for (int i = 0; i<100; i++)
    {
        NSInteger intopCode = [@"164" integerValue];
        NSData * dataCommand = [[NSData alloc] initWithBytes:&intopCode length:1];

        NSInteger intlength= i ;
        NSData * dataOpcode = [[NSData alloc] initWithBytes:&intlength length:1];
        
        NSMutableData *completeData = [dataCommand mutableCopy];
        [completeData appendData:dataOpcode];
        [completeData appendData:dataOpcode];
        
        [[BLEService sharedInstance] WriteNSDataforEncryptionAndthenSendtoPeripheral:completeData withPeripheral:classPeripheral];
        NSLog(@"100==Packets =====>>>>%@",completeData); 
    }
}
#pragma mark-  Send And  Receivec IMEI number
-(void)RequestForIMEInumbertotheDevice
{
    NSInteger intCommond = [@"225" integerValue]; // E1
    NSData * dataOpCmd = [[NSData alloc] initWithBytes:&intCommond length:1];

    NSInteger intLength = [@"0" integerValue];
    NSData * dataLength = [[NSData alloc] initWithBytes:&intLength length:1];

    NSMutableData *completeData = [dataOpCmd mutableCopy];
    [completeData appendData:dataLength];
    
    [[BLEService sharedInstance] WriteNSDataforEncryptionAndthenSendtoPeripheral:completeData withPeripheral:classPeripheral];
}
-(void)ReceievedGeofenceDatafromBLEIMEInumber:(NSString *)strIMEI
{
    dispatch_async(dispatch_get_main_queue(), ^{
    if ([[self checkforValidString:strIMEI]isEqualToString:@""])
    {
        // error
    }
    else
    {
        // Success
        if ([APP_DELEGATE isNetworkreachable])
        {
            [self GettingDeviceTokenFromURL:strIMEI];
        }
        else
        {
            [self ErrorPopUP:@"Please connect to the internet."];
            [[BLEManager sharedManager] disconnectDevice:globalPeripheral];
        }
    }
    });
}
-(void)ReceviedValidTokenFromDevice:(NSString *)strVAlidate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [APP_DELEGATE endHudProcess];
    if ([strVAlidate isEqualToString:@"00"])
    {
        [self ErrorPopUP:@"Please make sure it's your device"];
        
        [[BLEManager sharedManager] disconnectDevice:globalPeripheral];
    }
    else if([strVAlidate isEqualToString:@"01"]) //  valid token
    {
        [[BLEManager sharedManager] connectDevice:self->classPeripheral];
        // send a4ff
    }
    else if ([strVAlidate isEqualToString:@"02"]) //  retry after some time
    {
        [self ErrorPopUP:@"Decvice token not found !"];
        [[BLEManager sharedManager] disconnectDevice:globalPeripheral];
    }
    });
}
#pragma mark - UrlManager Delegate
- (void)onResult:(NSDictionary *)result
{
    [APP_DELEGATE endHudProcess];
//    NSLog(@"The result is...%@", result);
    
    if ([[result valueForKey:@"result"] isKindOfClass:[NSString class]])
    {
        if ([[result valueForKey:@"commandName"] isEqualToString:@"gettoken"])
        {
            NSString * StrData = [result valueForKey:@"result"];
            NSLog(@"Device Token====>>>>>%@",StrData);
            [self SendignDeviceTokenTotheDeVice:StrData];
        }
    }
    else
    {
        NSLog(@"show error popup");
        [self ErrorPopUP:@"Your not authorized to this device."];
        [[BLEManager sharedManager] disconnectDevice:globalPeripheral];
    }
}
- (void)onError:(NSError *)error
{
    [APP_DELEGATE endHudProcess];
    NSLog(@"The error is...%@", error);
}
-(void)SendignDeviceTokenTotheDeVice:(NSString *)strDeviceToken
{
    strDeviceToken = [strDeviceToken stringByReplacingOccurrencesOfString:@"\"" withString:@""];

    if (![[APP_DELEGATE checkforValidString:strDeviceToken] isEqualToString:@"NA"])
    {
        NSMutableArray * arrDeviceTokenPacket = [[NSMutableArray alloc] init];
        NSInteger totalPackets = 0;
        totalPackets = [self getTotalNumberofPackets:strDeviceToken];
        [self AddPacketstoArray:arrDeviceTokenPacket withString:strDeviceToken withTotalPackets:totalPackets];
        
        if ([APP_DELEGATE isNetworkreachable])
        {
            [self WriteDeviceTokenToDevicewithPacketsArray:arrDeviceTokenPacket withToalNoofPackets:totalPackets];
        }
        else
        {
            [self ErrorPopUP:@"Please connect to the internet."];
            [[BLEManager sharedManager] disconnectDevice:globalPeripheral];
        }
    }
}
-(void)AddPacketstoArray:(NSMutableArray *)arrayPackets withString:(NSString *)strDeviceToken withTotalPackets:(NSInteger )totalPackets
{
    NSInteger totallength = [strDeviceToken length];
    for (int i = 0; i < totalPackets; i++)
    {
        if (totallength >= (i * 13) + 13)
        {
            NSString * strMsg = [strDeviceToken substringWithRange:NSMakeRange(i * 13, 13)];
            [arrayPackets addObject:strMsg];
            NSLog(@"Greater Than PocketLength 13======%@",strMsg);
        }
        else
        {
            if ((totallength >= (i * 13)))
            {
                NSString * strMsg = [strDeviceToken substringWithRange:NSMakeRange(i * 13, totallength - (i * 13))];
                [arrayPackets addObject:strMsg];
                NSLog(@"Msg legth satisfied  13======%@",strMsg);
            }
        }
    }
}
-(void)WriteDeviceTokenToDevicewithPacketsArray:(NSMutableArray *)arrDevicePackets withToalNoofPackets:(NSInteger)totalPackets
{
    for (int i =0; i < [arrDevicePackets count]; i++)
    {
//        NSInteger reverseCount = [arrDevicePackets count] - (i + 1);
//
//        if ([arrDevicePackets count] >= reverseCount)
//        {
            NSString * strPacket = [arrDevicePackets objectAtIndex: i];
            NSInteger intPacketLength = [strPacket length] + 1;

            //1. Command
            NSInteger commandInt = 226;
            NSData * commandData = [[NSData alloc] initWithBytes:&commandInt length:1];
            
            //2. Length Data
            NSData * lengthData = [[NSData alloc] initWithBytes:&intPacketLength length:1];

            NSInteger packtInt = totalPackets - i;
            NSData * packetNoData = [[NSData alloc] initWithBytes:&packtInt length:1];

            NSData * msgData = [self dataFromHexString:[self hexFromStr:strPacket]];
            
            NSMutableData * completeData = [[NSMutableData alloc] initWithData:commandData];
            [completeData appendData:lengthData];
            [completeData appendData:packetNoData];
            [completeData appendData:msgData];
            NSLog(@"Tokent Sent Data=====%@",completeData);
            
            [[BLEService sharedInstance] WriteNSDataforEncryptionAndthenSendtoPeripheral:completeData withPeripheral:globalPeripheral];
//        }
    }
}

-(void)RequestForStartLivetracking:(NSString *)strState
{
    NSInteger intCommond = [@"227" integerValue]; // E3 start and stop Live Tracking
    NSData * dataOpCmd = [[NSData alloc] initWithBytes:&intCommond length:1];

    NSInteger intLength = [@"01" integerValue];
    NSData * dataLength = [[NSData alloc] initWithBytes:&intLength length:1];

    NSInteger intLengthStart = [strState integerValue];
    NSData * dataLengthStart = [[NSData alloc] initWithBytes:&intLengthStart length:1];
    
    NSMutableData *completeData = [dataOpCmd mutableCopy];
    [completeData appendData:dataLength];
    [completeData appendData:dataLengthStart];

    [[BLEService sharedInstance] WriteNSDataforEncryptionAndthenSendtoPeripheral:completeData withPeripheral:classPeripheral];
}
-(NSInteger)getTotalNumberofPackets:(NSString *)strText
{
    float lenghtFloat = [strText length];
    NSString * strLength = [NSString stringWithFormat:@"%f",lenghtFloat / 13];
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
-(void)TimeoutforHideNotification
{
    [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^
       {
        viewForNotification.frame = CGRectMake(0, -140, DEVICE_WIDTH-0, 140);
       }
       completion:(^(BOOL finished)
       {
        [viewForNotification removeFromSuperview];
      })];
}
@end
