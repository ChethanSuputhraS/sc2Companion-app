//
//  HomeCell.h
//  GeofenceAlertApp
//
//  Created by srivatsa s pobbathi on 12/06/19.
//  Copyright © 2019 srivatsa s pobbathi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell : UITableViewCell
{
    
}
@property(nonatomic,strong)UILabel * lblAddress,*lblline2,*lblline3;
@property(nonatomic,strong)UILabel * lblDeviceName;
@property(nonatomic,strong)UILabel * lblConnect,* lbllineSetting,*lblBadgeCount;
@property(nonatomic,strong)UILabel * lblBack;
@property(nonatomic,strong)UIButton * btnMore;
@property(nonatomic,strong)UIButton * btnConnect,*btnmessage,*btnmap,*btnLivelocation,*btnMore1,*btnGeofence,*btnSetting,*btnSOS;
@property(nonatomic,strong)UIImageView * imgviewMoreButton,*imageViewBattery;
@property(nonatomic,strong)UIView * optionView,*settingView;


@end
