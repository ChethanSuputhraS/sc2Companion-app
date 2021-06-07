//
//  AppDelegate.m
//  GeofenceAlertApp
//
//  Created by srivatsa s pobbathi on 06/06/19.
//  Copyright © 2019 srivatsa s pobbathi. All rights reserved.
//
#import "Reachability.h"
#import <objc/runtime.h>
#import "AppDelegate.h"
#import "PolygonGeofenceVC.h"
#import "HomeVC.h"
#import "HistoryVC.h"
#import "SettingVC.h"
#import "ChatVC.h"
#import "LoginVC.h"
#import "SettingVC.h"
#import "SOSclassVC.h"
#import "HistoryVC.h"
#import "RemotNavigationVC.h"
#import "LiveTrackingVC.h"
#import "DeviceConfigurVC.h"


@import Firebase;

@interface AppDelegate ()<CLLocationManagerDelegate,UITabBarControllerDelegate>
{
    NSTimer  *  locationUpdateTimer;

}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSData* nsData = [@"$%^&!@*#$$%%()?<:{}{|+`~}" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"=================================%@",nsData);

    [FIRApp configure];
    
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        
    }
    [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    
    /*-----------Push Notitications----------*/
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        // Register for Push Notitications, if running iOS 8
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else
    {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
        [application enabledRemoteNotificationTypes];
    }
    /*-------------------------------------------*/

    textSize = 16;
    globalStatusHeight = 20;
    if (IS_IPHONE_4 || IS_IPHONE_5)
    {
        textSize = 14;
    }
    if (IS_IPHONE_X)
    {
        globalStatusHeight = 44;
    }
    
    if (IS_IPHONE_6plus)
    {
        approaxSize = 1.29;
    }
    else if (IS_IPHONE_6 || IS_IPHONE_X)
    {
        approaxSize = 1.17;
    }
    else
    {
        approaxSize = 1;
    }
    
// for badge count of alert popup
 
    
    
    
    
    
    if ([[self checkforValidString:[[NSUserDefaults standardUserDefaults] valueForKey:@"SetTimeInterval"]] isEqualToString:@"NA"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"2 sec" forKey:@"SetTimeInterval"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    deviceTokenStr = @"1234567";
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"IS_LOGGEDIN"] == false)
    {
        LoginVC *view1 = [[LoginVC alloc]init];
        UINavigationController *navig = [[UINavigationController alloc]initWithRootViewController:view1];
        self.window = [[UIWindow alloc]init];
        self.window.frame = self.window.bounds;
        self.window.rootViewController = navig;
        [self.window makeKeyAndVisible];

        }
        else if ([[NSUserDefaults standardUserDefaults]boolForKey:@"IS_LOGGEDIN"] == true)
        {
            [UIView beginAnimations:nil context:nil]; // context null
            [UIView setAnimationDuration:1.3];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[[UIApplication sharedApplication] keyWindow] cache:YES];
            [UIView commitAnimations];

            globalHomeVC = [[HomeVC alloc]init];
            UINavigationController *navig = [[UINavigationController   alloc]initWithRootViewController:globalHomeVC]; //globalHomeVC
            self.window = [[UIWindow alloc]init];
            self.window.frame = self.window.bounds;
            self.window.rootViewController = navig;
            [self.window makeKeyAndVisible];
            [self setUpTabBarController];
           
        }
   
    [self createDatabase];
    [self getLocationMethod];


    //google api key
    [GMSServices provideAPIKey:@"AIzaSyCl_QnzYBK6eJW1CDQGaArWmQwdqg2XvgA"];
    [GMSServices provideAPIKey:@"AIzaSyCl_QnzYBK6eJW1CDQGaArWmQwdqg2XvgA"];
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    locationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(UpdateLocationAccess) userInfo:nil repeats:YES];
    [self generateSecretkey];


    // css add this
    if ([[self checkforValidString:[[NSUserDefaults standardUserDefaults] valueForKey:@"isFirst"]] isEqualToString:@"NA"])
    {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"isFirst"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSMutableArray * arrRules = [[NSMutableArray alloc] initWithObjects:@"Start date",@"End date",@"Dwell time Minimum",@"Dwell time Maximum",@"Minimum speed",@"Maximum speed",@"Boundary cross", nil];
        NSMutableArray * arrDiscrip = [[NSMutableArray alloc] initWithObjects:@"Any date from when geofence should be enabled/disabled.",@"Any date from when geofence should be enabled/disabled.",@"Duration to stay inside the geofence.  The rule is met if the device stays within the geofence for the set time.",@"Speed limit",@"Speed limit",@"The device entered or exited geofence. The state changed from the previous position.",@"Send a respective event to the server",@"The device entered or exited geofence. The state changed from the previous position.", nil];
        
        
        NSMutableArray * arrAction = [[NSMutableArray alloc] initWithObjects:@"Enable/disable geofence",@"Enable/disable GSM reporting",@"Enable/disable Iridium reporting",@"Gsm reporting interval",@"Iridium reporting interval",@"BLE Alert", nil];
        
        NSMutableArray * arrActiDisrip = [[NSMutableArray alloc] initWithObjects:@"Enable or disable geofence check",@"Enable or disable reporting any event/waypoint over GSM",@"Enable or disable reporting any event/waypoint over IRIDIUM",@"Change GSM reporting interval",@"Change IRIDIUM reporting interval",@"Alert over BLE-APP", nil];
        
        NSMutableArray * arrRuleID = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
        NSMutableArray * arrActANID = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil];

        for (int i =0 ; i<[arrRuleID count] ; i++)
        {
            NSString * strID  = [arrRuleID objectAtIndex:i];
            NSString * strRule = [arrRules objectAtIndex:i];
            NSString * strDiscription = [arrDiscrip objectAtIndex:i];

            NSString * requestStr =  [NSString stringWithFormat:@"insert into 'Rule_info_Table' ('Rule', 'Rule_ID', 'description') values(\"%@\",\"%@\",\"%@\")",strID,strRule,strDiscription];
            [[DataBaseManager dataBaseManager] executeSw:requestStr];
        }
        for (int i = 0; i<[arrActANID count]; i++)
        {
            NSString * strAcID = [arrActANID objectAtIndex:i];
            NSString * strAction = [arrAction objectAtIndex:i];
            NSString * strActDiscrip = [arrActiDisrip objectAtIndex:i];
            
            NSString * requestStr1 =  [NSString stringWithFormat:@"insert into 'Action_info_Table' ('action', 'action_ID', 'description') values(\"%@\",\"%@\",\"%@\")",strAcID,strAction,strActDiscrip];
            [[DataBaseManager dataBaseManager] executeSw:requestStr1];
        }
    }
    
    

    return YES;
}
-(void)UpdateLocationAccess
{
    [locationManager startUpdatingLocation];
    NSMutableArray * arrGeo = [[NSMutableArray alloc] init];
    NSString * strQuery = [NSString stringWithFormat:@"select * from Geofence"];
    [[DataBaseManager dataBaseManager] execute:strQuery resultsArray:arrGeo];
    
    if ([arrGeo count]>0)
    {
        for (int i=0; i<[arrGeo count]; i++)
        {
            if ([[[arrGeo objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"Circular"])
            {
                
            }
            else
            {
                [self CheckPolygonRegionInOut:[arrGeo objectAtIndex:i]];
            }
        }
    }
}
-(void)CheckPolygonRegionInOut:(NSMutableDictionary *)dataDetail
{

    NSMutableArray * polyCorners = [[NSMutableArray alloc]init];
    NSString * strQury = [NSString stringWithFormat:@"select * from Geofence_Polygon where geofence_ID ='%@'",[dataDetail valueForKey:@"id"]];
    [[DataBaseManager dataBaseManager] execute:strQury resultsArray:polyCorners];
    
    int nvert = [polyCorners count];
    float vertx, verty,  testx, testy, vertJx, vertJy;
    testx = globalLatitude;
    testy = globalLongitude;
    int i, j, c = 0;
    for (i = 0, j = nvert-1; i < nvert; j = i++)
    {
        vertx = [[[polyCorners objectAtIndex:i] valueForKey:@"lat"] floatValue];
        verty =  [[[polyCorners objectAtIndex:i] valueForKey:@"long"] floatValue];
        
        vertJx = [[[polyCorners objectAtIndex:j] valueForKey:@"lat"] floatValue];
        vertJy =  [[[polyCorners objectAtIndex:j] valueForKey:@"long"] floatValue];
        
        if ( ((verty>testy) != (vertJy>testy)) &&
            (testx < (vertJx-vertx) * (testy-verty) / (vertJy-verty) + vertx) )
            c = !c;
    }
    if (c==1)
    {
        if ([[dataDetail valueForKey:@"last_status"] isEqualToString:@"1"])
        {
            
        }
        else
        {
            //Fire notification of Entered in geofence
            NSString * strMessage = [NSString stringWithFormat:@"Device is entered in Geofence"];
            if (![[self checkforValidString:[dataDetail valueForKey:@"name"]] isEqualToString:@"NA"])
            {
                strMessage = [NSString stringWithFormat:@"Device entered in %@ geofence",[dataDetail valueForKey:@"name"]];
            
                
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:7];
                notification.alertBody = [NSString stringWithFormat:@"Device entered in %@ geofence",[dataDetail valueForKey:@"name"]];
                notification.timeZone = [NSTimeZone defaultTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
//                notification.applicationIconBadgeNumber = 10;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
        }
    }
    else
    {
        if ([[dataDetail valueForKey:@"last_status"] isEqualToString:@"0"])
        {
            
        }
        else
        {
            NSString * strMessage = [NSString stringWithFormat:@"Device is out of Geofence"];
            if (![[self checkforValidString:[dataDetail valueForKey:@"name"]] isEqualToString:@"NA"])
            {
                strMessage = [NSString stringWithFormat:@"Device is out of %@ geofence",[dataDetail valueForKey:@"name"]];
            }
            //Fire notification of Out of geofence
            
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:7];
            notification.alertBody = [NSString stringWithFormat:@"Device is out of %@ geofence",[dataDetail valueForKey:@"name"]];
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.soundName = UILocalNotificationDefaultSoundName;
//            notification.applicationIconBadgeNumber = 10;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
}
-(void)getLocationMethod
{
    NSLog(@"%s",__FUNCTION__);
    /*-----------Start Location Manager----------*/
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = 0; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation; // 100 m
    if(IS_OS_8_OR_LATER)
    {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    [locationManager startMonitoringSignificantLocationChanges];
    // Start heading updates.
    if ([CLLocationManager locationServicesEnabled]&&[CLLocationManager headingAvailable])
    {
        [locationManager startUpdatingLocation];//开启定位服务
        [locationManager startUpdatingHeading];//开始获得航向数据
    }
    /*-------------------------------------------*/
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation * lastLocation = locations.lastObject;
    globalLatitude = lastLocation.coordinate.latitude;
    globalLongitude = lastLocation.coordinate.longitude;
//    NSLog(@"Location updated===========>>>>>>>>>");
}
/*
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region;
{
    NSLog(@"didEnterRegion is working");
    NSString * checkNameStr = [NSString stringWithFormat:@"%@",region.identifier];
    if ([checkNameStr rangeOfString:@"Polygon"].location != NSNotFound)
    {
        NSArray * arrCheck = [checkNameStr componentsSeparatedByString:@"_"];
        if ([arrCheck count]>0)
        {
            NSString * strCheckID = [NSString stringWithFormat:@"%@",[arrCheck lastObject]];
            NSMutableArray * arrGeo = [[NSMutableArray alloc] init];
            NSString * strQuery = [NSString stringWithFormat:@"select * from Geofence where id ='%@'",strCheckID];
            [[DataBaseManager dataBaseManager] execute:strQuery resultsArray:arrGeo];
            if ([arrGeo count]>0)
            {
                for (int i=0; i<[arrGeo count]; i++)
                {
                    if ([[[arrGeo objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"Polygon"])
                    {
                        [self CheckPolygonRegionInOut:[arrGeo objectAtIndex:i]];
                    }
                }
            }
        }
    }
    else
    {
        NSString * strMsg = [NSString stringWithFormat:@"Device entered in geofence"];
        if (![[self checkforValidString:region.identifier] isEqualToString:@"NA"])
        {
            strMsg = [NSString stringWithFormat:@"Device entered in %@ geofence",region.identifier];
        }
        UILocalNotification *notification=[UILocalNotification new];
        notification.alertBody=[NSString stringWithFormat:@"%@", strMsg];
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
        NSLog(@"Entered Region =%@",region.identifier);
}
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(nonnull CLRegion *)region
{
    NSLog(@"didExitRegion is working");

    NSString * checkNameStr = [NSString stringWithFormat:@"%@",region.identifier];
    if ([checkNameStr rangeOfString:@"Polygon"].location != NSNotFound)
    {
        NSArray * arrCheck = [checkNameStr componentsSeparatedByString:@"_"];
        if ([arrCheck count]>0)
        {
            NSString * strCheckID = [NSString stringWithFormat:@"%@",[arrCheck lastObject]];
            NSMutableArray * arrGeo = [[NSMutableArray alloc] init];
            NSString * strQuery = [NSString stringWithFormat:@"select * from Geofence where id ='%@'",strCheckID];
            [[DataBaseManager dataBaseManager] execute:strQuery resultsArray:arrGeo];
            if ([arrGeo count]>0)
            {
                for (int i=0; i<[arrGeo count]; i++)
                {
                    if ([[[arrGeo objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"Polygon"])
                    {
                        [self CheckPolygonRegionInOut:[arrGeo objectAtIndex:i]];
                    }
                }
            }
        }
    }
    else
    {
        NSString * strMsg = [NSString stringWithFormat:@"Device went out of geofence"];
        if (![[self checkforValidString:region.identifier] isEqualToString:@"NA"])
        {
            strMsg = [NSString stringWithFormat:@"Device went out of %@ geofence",region.identifier];
        }
        UILocalNotification *notification=[UILocalNotification new];
        notification.alertBody=[NSString stringWithFormat:@"%@", strMsg];
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        NSLog(@"exited Region =%@",region.identifier);
    }
}
*/
-(void)getPlaceholderText:(UITextField *)txtField  andColor:(UIColor*)color
{
    Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel"); 
          UILabel *placeholderLabel = object_getIvar(txtField, ivar);
          placeholderLabel.textColor = color;
}
-(BOOL)isNetworkreachable
{
    Reachability *networkReachability = [[Reachability alloc] init];
    NetworkStatus networkStatus = [networkReachability internetConnectionStatus];
    if (networkStatus == NotReachable)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
}
-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{

}
-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSString * checkNameStr = [NSString stringWithFormat:@"%@",region.identifier];
    if ([checkNameStr rangeOfString:@"Polygon"].location != NSNotFound)
    {
        NSArray * arrCheck = [checkNameStr componentsSeparatedByString:@"_"];
        if ([arrCheck count]>0)
        {
            NSString * strCheckID = [NSString stringWithFormat:@"%@",[arrCheck lastObject]];
            NSMutableArray * arrGeo = [[NSMutableArray alloc] init];
            NSString * strQuery = [NSString stringWithFormat:@"select * from Geofence where id ='%@'",strCheckID];
            [[DataBaseManager dataBaseManager] execute:strQuery resultsArray:arrGeo];
            if ([arrGeo count]>0)
            {
                for (int i=0; i<[arrGeo count]; i++)
                {
                    if ([[[arrGeo objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"Polygon"])
                    {
                        [self CheckPolygonRegionInOut:[arrGeo objectAtIndex:i]];
                    }
                }
            }
        }
    }
    else if(state == CLRegionStateInside)
    {
        NSString * strMsg = [NSString stringWithFormat:@"Device entered in geofence"];
        if (![[self checkforValidString:region.identifier] isEqualToString:@"NA"])
        {
            strMsg = [NSString stringWithFormat:@"Device entered in %@ geofence",region.identifier];
        }
        UILocalNotification *notification=[UILocalNotification new];
        notification.alertBody=[NSString stringWithFormat:@"%@", strMsg];
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        
        NSLog(@"state is CLRegionStateInside");
    }
    else if(state  == CLRegionStateOutside)
    {
        NSString * strMsg = [NSString stringWithFormat:@"Device went out of geofence"];
        if (![[self checkforValidString:region.identifier] isEqualToString:@"NA"])
        {
            strMsg = [NSString stringWithFormat:@"Device went out of %@ geofence",region.identifier];
        }
        UILocalNotification *notification=[UILocalNotification new];
        notification.alertBody=[NSString stringWithFormat:@"%@", strMsg];
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        NSLog(@"exited Region =%@",region.identifier);
        
        state = CLRegionStateInside;
        NSLog(@"state is CLRegionStateOutside");
    }
}
#pragma mark - data Database
-(void)createDatabase
{
    [[DataBaseManager dataBaseManager] Create_Geofence];
    [[DataBaseManager dataBaseManager] Create_Geofence_Polygon];
    [[DataBaseManager dataBaseManager] Create_Rules];
    [[DataBaseManager dataBaseManager] Create_Actions_Table];
    [[DataBaseManager dataBaseManager] Create_ActionInfo_Table];
    [[DataBaseManager dataBaseManager] Create_RuleInfo_Table];
    [[DataBaseManager dataBaseManager] Create_Geofence_Alert_Table];
    [[DataBaseManager dataBaseManager] CrateTableForDeviceBLEAdress];
    [[DataBaseManager dataBaseManager] createNewChatTable];
    [[DataBaseManager dataBaseManager] CreateDeviceConfigurationTable];
    [[DataBaseManager dataBaseManager] CreateSIMConfigurationTable];
    [[DataBaseManager dataBaseManager] CreateServerConfigurationTable];
    [[DataBaseManager dataBaseManager] CreateIndustrySpecificConfigurationTable];
    [[DataBaseManager dataBaseManager] CreateBandConfigurationTable];

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
    strValid = [strValid stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    return strValid;
}
#pragma mark - SetUp Tabbar
-(void)setUpTabBarController
{
    globalHomeVC = [[HomeVC alloc]init];
    globalHomeVC.title=@"Home";
    globalHomeVC.tabBarItem=[[UITabBarItem alloc] initWithTitle:@"Home" image:[[UIImage imageNamed:@"home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] selectedImage:[[UIImage imageNamed:@"home_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ];
    firstNavigation = [[UINavigationController alloc]initWithRootViewController:globalHomeVC];
    firstNavigation.navigationBarHidden = YES;
    
    
    RemotNavigationVC * thirdViewController = [[RemotNavigationVC alloc]init]; //RemotNavigationVC
    thirdViewController.title = @"Remote Navigation";
    thirdViewController.tabBarItem=[[UITabBarItem alloc] initWithTitle:@"Remote Navigation" image:[[UIImage imageNamed:@"remote.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] selectedImage:[[UIImage imageNamed:@"Remote_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ];
    thirdNavigation = [[UINavigationController alloc]initWithRootViewController:thirdViewController];
    thirdNavigation.navigationBarHidden = YES;
    
//    globalChatVC * forthViewController = [[globalChatVC alloc]init];
//    forthViewController.title=@"device";
//    forthViewController.tabBarItem=[[UITabBarItem alloc] initWithTitle:@"SOS" image:[[UIImage imageNamed:@"sosg.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] selectedImage:[[UIImage imageNamed:@"sos.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ];
//    forthNavigation = [[UINavigationController alloc]initWithRootViewController:forthViewController];
//    forthNavigation.navigationBarHidden = YES;

    mainTabBarController = [[UITabBarController alloc] init];
    mainTabBarController.viewControllers = [[NSArray alloc] initWithObjects:firstNavigation, thirdNavigation,forthNavigation, nil];
    mainTabBarController.tabBar.tintColor = [UIColor grayColor];
    mainTabBarController.delegate = self;
    mainTabBarController.tabBar.barTintColor = [UIColor blackColor];
    mainTabBarController.selectedIndex = 0;
    
    if (IS_IPHONE_X)
    {
        
    }
    else
    {
        //  The color you want the tab bar to be
        UIColor *barColor = [UIColor colorWithRed:1.0f/255.0 green:1.0f/255.0 blue:1.0f/255.0 alpha:0.2f];
        
        //  Create a 1x1 image from this color
        UIGraphicsBeginImageContext(CGSizeMake(1, 1));
        [barColor set];
        UIRectFill(CGRectMake(0, 0, 1, 1));
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //  Apply it to the tab bar
        [[UITabBar appearance] setBackgroundImage:image];
    }
   
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:CGRegular size:11],
                                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                                        } forState:UIControlStateSelected];
    
    
    // doing this results in an easier to read unselected state then the default iOS 7 one
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:CGRegular size:12],
                                                        NSForegroundColorAttributeName : [UIColor grayColor]
                                                        } forState:UIControlStateNormal];
    self.window.rootViewController = mainTabBarController;
}
-(void)movetoLogin
{
    [UIView beginAnimations:nil context:nil]; // context null
    [UIView setAnimationDuration:1.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[[UIApplication sharedApplication] keyWindow] cache:YES];
    [UIView commitAnimations];
    
    LoginVC * splash = [[LoginVC alloc] init];
    UINavigationController * navControl = [[UINavigationController alloc] initWithRootViewController:splash];
    navControl.navigationBarHidden=YES;
    self.window.rootViewController = navControl;
}
-(void)MoveToHomeVCAfterLogin
{
    [UIView beginAnimations:nil context:nil]; // context null
    [UIView setAnimationDuration:1.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[[UIApplication sharedApplication] keyWindow] cache:YES];
    [UIView commitAnimations];

    globalHomeVC = [[HomeVC alloc]init];
//    UINavigationController *navig = [[UINavigationController   alloc]initWithRootViewController:globalHomeVC];
//    self.window = [[UIWindow alloc]init];
//    self.window.frame = self.window.bounds;
//    self.window.rootViewController = navig;
    [self setUpTabBarController];
    [self.window makeKeyAndVisible];

}
#pragma mark Hud Method
-(void)startHudProcess:(NSString *)text
{
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.window];
    HUD.labelText = text;
    [self.window addSubview:HUD];
    [HUD show:YES];
}
#pragma mark  HIDE TAB BAR AT BOTTOM
- (void) hideTabBar:(UITabBarController *) tabbarcontroller
{
    tabbarcontroller.tabBar.hidden = YES;
    mainTabBarController.tabBar.hidden = YES;
}
-(void)movetoSelectedInex:(NSInteger)selectedIndex
{
    [mainTabBarController setSelectedIndex:selectedIndex];
}
#pragma mark  SHOW TAB BAR AT BOTTOM
- (void) showTabBar:(UITabBarController *) tabbarcontroller
{
    tabbarcontroller.tabBar.hidden = NO;
}
-(void)endHudProcess
{
    [HUD hide:YES];
}
// This code block is invoked when application is in foreground (active-mode)
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{


}
- (void)applicationWillResignActive:(UIApplication *)application
{

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    deviceTokenStr = [[[[deviceToken description]
                        stringByReplacingOccurrencesOfString: @"<" withString: @""]
                       stringByReplacingOccurrencesOfString: @">" withString: @""]
                      stringByReplacingOccurrencesOfString: @" " withString: @""] ;
    NSLog(@"My device token ============================>>>>>>>>>>>%@",deviceTokenStr);
}
#pragma mark Generate Pass Key Methods
-(void)generateSecretkey
{
    [[NSUserDefaults standardUserDefaults] setValue:@"3499ab12138898473308492112d46574" forKey:@"EncryptionKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end



// LIVE  https: //ws.succorfish.net/
// STAGING https: //ws.scstg.net/
// Staging updated  https: //ws.scstg.net/basic/v2/

