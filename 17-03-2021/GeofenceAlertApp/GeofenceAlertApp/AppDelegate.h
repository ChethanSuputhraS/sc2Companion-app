//
//  AppDelegate.h
//  GeofenceAlertApp
//
//  Created by srivatsa s pobbathi on 06/06/19.
//  Copyright © 2019 srivatsa s pobbathi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MBProgressHUD.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "HomeVC.h"
#import "HistoryVC.h"
#import "SettingVC.h"
#import "ChatVC.h"
#import "RadioButtonClass.h"
#import "SIMconfigurVC.h"
#import "ServerConfigVC.h"
#import "DeviceConfigurVC.h"
#import "IndustrySpeConfigVC.h"
#import "WifiSetupVC.h"
#import "RemotNavigMapVC.h"


HomeVC * globalHomeVC;
HistoryVC * globalHistoryVC;
SettingVC * globalSettings;
ChatVC * globalChatVC;

SIMconfigurVC * globalSIMvc;
ServerConfigVC * globalServerConfig;
DeviceConfigurVC *globalDeviceConfig;
IndustrySpeConfigVC * globalIndustVC;
WifiSetupVC * globalWiFiVC;
RemotNovigMapVC * globalRemoteNaviMapView;


double globalLatitude, globalLongitude;
double deviceLatitude, deviceLongitude;
NSInteger globalBadgeCount;
int textSize,updatedRSSI;
int globalStatusHeight;
BOOL isConnectedtoAdd;
BOOL isCheckforDashScann;
NSMutableArray * arrGlobalDevices, * arrGlobalGeofenceList, * arrGlobalDeviceNames, * arrGlobalChatHistory;
CLLocationManager * locationManager;
CBPeripheral * globalPeripheral;
NSString * strCurrentScreen;
NSString * globalSequence;
BOOL isReconnect;
CGFloat approaxSize;
 NSString * deviceTokenStr;
NSData * kpsData;
UIView * viewForNotification;

BOOL isMapNavigated;


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MBProgressHUD *HUD;
    UITabBarController * mainTabBarController;
    UINavigationController *firstNavigation;
    UINavigationController *secondNavigation;
    UINavigationController *thirdNavigation;
    UINavigationController *forthNavigation;


}
@property (strong, nonatomic) UIWindow *window;

#pragma mark - Helper Classes
-(NSString *)checkforValidString:(NSString *)strRequest;
-(void)startHudProcess:(NSString *)text;
-(void)endHudProcess;
-(void)updateBadgeCount;
-(void)hideTabBar:(UITabBarController *) tabbarcontroller;
-(void)showTabBar:(UITabBarController *) tabbarcontroller;
-(void)movetoSelectedInex:(NSInteger)selectedIndex;
//-(NSString *)GetDecrypedDataKeyforData:(NSString *)strData withKey:(NSString *)strKey withLength:(long)dataLength;
//-(NSData *)GetEncryptedKeyforData:(NSString *)strData withKey:(NSString *)strKey withLength:(long)dataLength;
//-(NSString *)SyncUserTextinfowithDevice:(NSString *)strName;
-(void)getPlaceholderText:(UITextField *)txtField  andColor:(UIColor*)color;
-(BOOL)isNetworkreachable;
-(void)movetoLogin;
-(void)MoveToHomeVCAfterLogin;
-(void)ShowNotificationView:(UIView *)view;
-(void)HideNotificationView:(UIView *)view;

@end


//AIzaSyCl_QnzYBK6eJW1CDQGaArWmQwdqg2XvgA

