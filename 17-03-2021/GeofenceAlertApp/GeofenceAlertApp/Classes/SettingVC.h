//
//  SettingVC.h
//  GeofenceAlertApp
//
//  Created by Ashwin on 8/31/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingVC : UIViewController
{
    UITableView * tblSetting ;
    UIView *viewAPNConifg,*viewAPNList;
    UILabel *lblHeader;
    bool isAPNViewSelect;

}
@property(nonatomic, strong) CBPeripheral * classPeripheral;

-(void)BuzzerTimeAcknowledgementfromDevice:(NSString *)strStatus;
-(void)ReceviedSuccesResponseFromDevice:(NSString *)strResponse;
@property(nonatomic, strong)NSString * strIdentifier;

@end


NS_ASSUME_NONNULL_END
