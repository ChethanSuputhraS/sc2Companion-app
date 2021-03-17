//
//  WifiSetupVC.h
//  GeofenceAlertApp
//
//  Created by Ashwin on 11/3/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WifiSetupVC : UIViewController

@property(nonatomic, strong) CBPeripheral * classPeripheral;
-(void)ReceviedSuccesResponseFromDevice:(NSString *)strResponse;

@end

NS_ASSUME_NONNULL_END
