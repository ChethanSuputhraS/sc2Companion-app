//
//  SIMconfigurVC.h
//  GeofenceAlertApp
//
//  Created by Ashwin on 10/13/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMconfigurVC : UIViewController
{
  UITableView  *tblListSIMstup;
    NSInteger bandConfigValue;
}
-(void)RecevieTheSelectedURAT:(NSString *)strSelectedURAT withIndexPath:(NSInteger)indexP;
@property(nonatomic, strong) CBPeripheral * classPeripheral;
-(void)ReceviedSuccesResponseFromDevice:(NSString *)strResponse;
-(void)ReceivedFirstPacketfromDevice:(NSArray *)arrFirstPacket;
-(void)ReceivedAPNSPacketfromDevice:(NSDictionary *)arrFirstPacket;
-(void)ReceivedUsernamePacketfromDevice:(NSDictionary *)arrFirstPacket;
-(void)ReceivedPasswordPacketfromDevice:(NSDictionary *)arrFirstPacket;
-(void)ReceivedEndPacketfromDevice;

@end

NS_ASSUME_NONNULL_END
