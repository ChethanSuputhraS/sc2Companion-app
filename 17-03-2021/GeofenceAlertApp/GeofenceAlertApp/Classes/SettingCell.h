//
//  SettingCell.h
//  GeofenceAlertApp
//
//  Created by Ashwin on 8/31/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFloatLabelTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingCell : UITableViewCell


@property(nonatomic,strong)UILabel * lblForSetting,*lblSetValue,*lblMsg,*lblBack,*lblRightLbl;
@property(nonatomic,strong)UIImageView * imgArrow;
@property(nonatomic,strong)UISwitch *swReconnect;
@property(nonatomic,strong)UIFloatLabelTextField *txtFld;


@end

NS_ASSUME_NONNULL_END
