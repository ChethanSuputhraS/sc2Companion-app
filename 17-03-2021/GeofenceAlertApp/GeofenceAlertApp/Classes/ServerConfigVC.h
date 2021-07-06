//
//  ServerConfigVC.h
//  GeofenceAlertApp
//
//  Created by Ashwin on 10/13/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServerConfigVC : UIViewController
{
    
}
@property(nonatomic, strong) CBPeripheral * classPeripheral;
-(void)ReceviedSuccesResponseFromDevice:(NSString *)strResponse;
-(void)ReceivedStartPacketfromDevice:(NSArray *)arrData;
-(void)ReceivedAddressPacketfromDevice:(NSDictionary *)dictPackets isLastPacket:(BOOL)isLastPacket;

@end

NS_ASSUME_NONNULL_END
