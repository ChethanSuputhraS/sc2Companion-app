//
//  HomeVC.h
//  GeofenceAlertApp
//
//  Created by Ashwin on 7/16/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNMPullToRefreshManager.h"
#import "BLEManager.h"
#import "FCAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeVC : UIViewController
{
    UILabel *lblNoDevice,*lblError ,* lblScanning ;
    MNMPullToRefreshManager * topPullToRefreshManager;
    FCAlertView * geofenceAlertPopup;
    UIView * viewBg,*viewAlert;
    UITableView * tblDeviceList;
    UIButton * btn1, *btn2;
    UITextField *customField;
    NSString * strSelectedBLEAddress;
    NSMutableDictionary * globalDict, * notificationDict, * currentAlertDict;
    NSMutableArray * arrActons, * arrPolygon, * arrRules, * arrAllSavedRules, * arrTempListGeofence, * arrIMEITokens;
    
    NSTimer * connectionTimer, * advertiseTimer,* timerForbattryRequest,*timerForNotification;
    CBPeripheral * tempSelectedPeripheral, * classPeripheral;
    CBCentralManager*centralManager;
    NSInteger selectedMoreIndex;
}


-(void)ReceivedFirstPacketofGeofence:(NSString *)strID withSize:(NSString *)strSize withType:(NSString *)strType  withRadius:(NSString *)strRadius withTime:(NSString *)strTimeStamp;
-(void)ReceivedSecondPacketLatLong:(NSString *)latitude withLongitude:(NSString *)longitude;

-(void)ReceivedThirdPacketofGeofenceData:(NSString *)strLength withGSMTime:(NSString *)strGsmTime withIrridiumTime:(NSString *)strIrridmTime withRuleId:(NSString *)strRuleId;
-(void)ReceivedFourthPacketofGeofenceData:(NSString *)strruleID withValue:(NSString *)strValue withNoOfAction:(NSString *)strNoAction;
-(void)ReceivedFifthPacketofGeofenceData;
-(void)ReceivedPolygonLatLongsofGeofenceData:(NSMutableArray *)arrLatLong;
-(void)ReceivedGeofenceAlert:(NSMutableDictionary *)datDict isGeoAvailable:(BOOL)isAvail ;
-(void)SaveAllGeofenceListwithTimeStamp:(NSMutableArray *)arrGeoTimeStamp;
-(void)StartSyncingGeofence;
-(void)ReceievedGeofenceDatafromBLE;
-(void)ConnectionSuccessfulStatSyncGeofence;
-(void)AuthenticationCompleted;
-(void)ReceievedGeofenceDatafromBLEIMEInumber:(NSString *)strIMEI;
-(void)ReceviedValidTokenFromDevice:(NSString *)strVAlidate;

@end

NS_ASSUME_NONNULL_END
