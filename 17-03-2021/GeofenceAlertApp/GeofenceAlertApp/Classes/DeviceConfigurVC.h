//
//  DeviceConfigurVC.h
//  GeofenceAlertApp
//
//  Created by Ashwin on 10/12/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceConfigurVC : UIViewController
{
    UIScrollView * scrlContent;
    UITextField *customField;
}
@property(nonatomic, strong) CBPeripheral * classPeripheral;

-(void)ReceviedSuccesResponseFromDevice:(NSString *)strResponse;
-(void)setDeviceConfigurationValuetoUI:(NSArray *)arrData withType:(NSString *)strType;

@end

NS_ASSUME_NONNULL_END
