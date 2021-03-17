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

NS_ASSUME_NONNULL_BEGIN

@interface HomeVC : UIViewController
{
    UITableView * tblDeviceList;
      UILabel *lblNoDevice,*lblError ,* lblScanning,*lblBadgeHistry;
    NSMutableDictionary * globalDict;
     MNMPullToRefreshManager * topPullToRefreshManager;
    UIView * viewBg,*viewAlert; 
    UIButton* btn1,*btn2;
}


-(void)SendFirstPacketToHomeVC:(NSString *)strID withSize:(NSString *)strSize withType:(NSString *)strType  withRadius:(NSString *)strRadius withTime:(NSString *)strTimeStamp;
-(void)SendSecondPacketLatLongtoHomeVC:(float)latitude withLongitude:(float)longitude;

-(void)ThirdPackettoHomeVC:(NSString *)strLength withGSMTime:(NSString *)strGsmTime withIrridiumTime:(NSString *)strIrridmTime withRuleId:(NSString *)strRuleId;
-(void)FourthPacketToHomeVC:(NSString *)strruleID withValue:(NSString *)strValue withNoOfAction:(NSString *)strNoAction;
-(void)FifthPockeToHome:(NSMutableArray *)arrFithPacktData;
-(void)FifthPacketoHomeBLE;
-(void)PolygonLatLongtoHomeLatlonArray:(NSMutableArray *)arrLatLong;
-(void)SendAlertInfoGeoID:(NSMutableDictionary *)datDict isGeoAvailable:(BOOL)isAvail ;
-(void)SaveAllGeofenceListwithTimeStamp:(NSMutableArray *)arrGeoTimeStamp;
-(void)StartSyncingGeofence;
-(void)ReceievedGeofenceDatafromBLE;
-(void)GetTimeFromSettingVc:(NSString *)strTime;
-(void)ConnectionSuccessfulStatSyncGeofence;
-(void)AuthenticationCompleted;
-(void)ReceievedGeofenceDatafromBLEIMEInumber:(NSString *)strIMEI;
-(void)ReceviedValidTokenFromDevice:(NSString *)strVAlidate;

@end

NS_ASSUME_NONNULL_END
