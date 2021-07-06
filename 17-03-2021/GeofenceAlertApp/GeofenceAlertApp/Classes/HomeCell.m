//
//  HomeCell.m
//  GeofenceAlertApp
//
//  Created by srivatsa s pobbathi on 12/06/19.
//  Copyright © 2019 srivatsa s pobbathi. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell
@synthesize lblDeviceName,lblConnect,lblAddress,lblBack,btnMore,btnConnect,imgviewMoreButton,optionView,btnmap,btnmessage,btnLivelocation,btnMore1,lblline2,lblline3,btnGeofence,btnSetting,settingView,btnSOS,lbllineSetting,lblBadgeCount,imageViewBattery;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {    // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        lblBack = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,DEVICE_WIDTH-0,60)];
        lblBack.backgroundColor = [UIColor blackColor];
        lblBack.alpha = 0.7;
//        lblBack.layer.cornerRadius = 10;
        lblBack.layer.masksToBounds = YES;
        lblBack.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.contentView addSubview:lblBack];
        
        lblDeviceName = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, DEVICE_WIDTH/1.5, 35)];
        lblDeviceName.numberOfLines = 2;
        [lblDeviceName setBackgroundColor:[UIColor clearColor]];
        lblDeviceName.textColor = UIColor.whiteColor;
        [lblDeviceName setFont:[UIFont fontWithName:CGRegular size:textSize+2]];
        [lblDeviceName setTextAlignment:NSTextAlignmentLeft];
        lblDeviceName.text = @"Device name";
        
        lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(18, 30,  DEVICE_WIDTH-36, 25)];
        lblAddress.numberOfLines = 2;
        [lblAddress setBackgroundColor:[UIColor clearColor]];
        [lblAddress setTextColor:[UIColor lightGrayColor]];
        [lblAddress setFont:[UIFont fontWithName:CGRegular size:textSize]];
        [lblAddress setTextAlignment:NSTextAlignmentLeft];
        lblAddress.text = @"Ble Address";

        lblConnect = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-100, 0,  80, 60)];
        [lblConnect setBackgroundColor:[UIColor clearColor]];
        [lblConnect setTextColor:[UIColor whiteColor]];
        [lblConnect setFont:[UIFont fontWithName:CGRegular size:textSize]];
        [lblConnect setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:lblConnect];

        imageViewBattery = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"battery.png"]];
        [imageViewBattery setFrame:CGRectMake(DEVICE_WIDTH-30, 0, 20, 15)];
        [imageViewBattery setContentMode:UIViewContentModeScaleAspectFit];
//        [imageViewBattery setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        imageViewBattery.hidden = true;
        [self.contentView addSubview:imageViewBattery];
        btnConnect = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_WIDTH/2, 5, DEVICE_WIDTH/2-10, 50)];
//        [btnConnect setTitle:@"Coonect" forState:UIControlStateNormal];
        [btnConnect setBackgroundColor:UIColor.clearColor];
        btnConnect.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.contentView addSubview:btnConnect];

        
        btnMore = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-50, 0, 50, 60)];
        [btnMore setBackgroundColor:[UIColor clearColor]];
//        [btnMore setBackgroundImage:[UIImage imageNamed:@"view-more.png"] forState: normal];
//        btnMore.hidden = true;
//        [self.contentView addSubview:btnMore];
        
        imgviewMoreButton = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
        imgviewMoreButton.image = [UIImage imageNamed:@"view-more.png"];
//        imgviewMoreButton.hidden = true;
        [btnMore addSubview:imgviewMoreButton];
        
        
        float btnWidth = (DEVICE_WIDTH)/4;
        
        optionView = [[UIView alloc]initWithFrame:CGRectMake(0, 61, DEVICE_WIDTH, 50)];
        optionView.backgroundColor = UIColor.blackColor;
        optionView.alpha = 0.7;
//        optionView.hidden = true;
        [self.contentView addSubview:optionView];
        
        btnmessage = [UIButton buttonWithType:UIButtonTypeCustom];
        btnmessage.frame = CGRectMake(0, 0, btnWidth, 40);
        btnmessage.backgroundColor = [UIColor clearColor];
        [btnmessage setImage:[UIImage imageNamed:@"active_messsage_icon.png"] forState:UIControlStateNormal];
        [optionView addSubview:btnmessage];
        
        UILabel * lblmessage = [[UILabel alloc] init];
        lblmessage.frame = CGRectMake(0, 35, btnmessage.frame.size.width, 15);
        lblmessage.backgroundColor= UIColor.clearColor;
        lblmessage.text = @"Message";
        lblmessage.textColor = UIColor.whiteColor;
        lblmessage.textAlignment = NSTextAlignmentCenter;
        lblmessage.font = [UIFont fontWithName:CGRegular size:10];
        [btnmessage addSubview:lblmessage];

        
        UILabel * lblmap = [[UILabel alloc] init];
        lblmap.frame = CGRectMake(btnWidth, 27.5,btnWidth, 23);
        lblmap.backgroundColor= UIColor.clearColor;
        lblmap.text = @"Geofence\nBreaches";
        lblmap.textColor = UIColor.whiteColor;
        lblmap.textAlignment = NSTextAlignmentCenter;
        lblmap.numberOfLines = 2;
        lblmap.font = [UIFont fontWithName:CGRegular size:8.5];
        [optionView addSubview:lblmap];
        
        btnGeofence = [UIButton buttonWithType:UIButtonTypeCustom];
        btnGeofence.frame = CGRectMake(btnWidth, 0, btnWidth, 40);
        btnGeofence.backgroundColor = [UIColor clearColor];
        [btnGeofence setImage:[UIImage imageNamed:@"map-marker.png"] forState:UIControlStateNormal];
        [optionView addSubview:btnGeofence];
        

        lblBadgeCount = [[UILabel alloc] init];
        lblBadgeCount.frame = CGRectMake(btnGeofence.frame.size.width/2+5, 2, 20, 20);
        lblBadgeCount.backgroundColor= UIColor.redColor;
        lblBadgeCount.text = @"20";
        lblBadgeCount.textColor = UIColor.whiteColor;
        lblBadgeCount.layer.cornerRadius = 10;
        lblBadgeCount.layer.masksToBounds = YES;
        lblBadgeCount.textAlignment = NSTextAlignmentCenter;
        lblBadgeCount.font = [UIFont fontWithName:CGRegular size:10];
        [btnGeofence addSubview:lblBadgeCount];
        
        
        
        btnLivelocation = [UIButton buttonWithType:UIButtonTypeCustom];
        btnLivelocation.frame = CGRectMake(btnWidth*2, 0, btnWidth, 40);
        btnLivelocation.backgroundColor = [UIColor clearColor];
        [btnLivelocation setImage:[UIImage imageNamed:@"liv.png"] forState:UIControlStateNormal];
        [optionView addSubview:btnLivelocation];
        
        UILabel * lbllivTrack = [[UILabel alloc] init];
        lbllivTrack.frame = CGRectMake(0, 35, btnLivelocation.frame.size.width, 10);
        lbllivTrack.backgroundColor= UIColor.clearColor;
        lbllivTrack.text = @"Live Track";
        lbllivTrack.textColor = UIColor.whiteColor;
        lbllivTrack.textAlignment = NSTextAlignmentCenter;
        lbllivTrack.font = [UIFont fontWithName:CGRegular size:10];
        [btnLivelocation addSubview:lbllivTrack];
        
    
        
        UILabel * lblsetting = [[UILabel alloc] init];
        lblsetting.frame = CGRectMake(0, 35, btnSetting.frame.size.width, 15);
        lblsetting.backgroundColor= UIColor.clearColor;
        lblsetting.text = @"Settings";
        lblsetting.textColor = UIColor.whiteColor;
        lblsetting.textAlignment = NSTextAlignmentCenter;
        lblsetting.font = [UIFont fontWithName:CGRegular size:10];
//        [btnSetting addSubview:lblsetting];
        
        
        btnMore1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnMore1 setImage:[UIImage imageNamed:@"view-more.png"] forState:UIControlStateNormal];
        btnMore1.frame = CGRectMake(btnWidth*3, 0, btnWidth+5, 40);
        btnMore1.backgroundColor = [UIColor clearColor];
        btnMore1.titleLabel.font = [UIFont fontWithName:CGRegular size:textSize-2];
        btnMore1.titleLabel.numberOfLines = 0;
        btnMore1.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btnMore1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [optionView addSubview:btnMore1];

        UILabel * lblMore = [[UILabel alloc] init];
        lblMore.frame = CGRectMake(0, 35, btnMore1.frame.size.width, 10);
        lblMore.backgroundColor= UIColor.clearColor;
        lblMore.text = @"More";
        lblMore.textColor = UIColor.whiteColor;
        lblMore.textAlignment = NSTextAlignmentCenter;
        lblMore.font = [UIFont fontWithName:CGRegular size:10];
        [btnMore1 addSubview:lblMore];
        
        lblline2 = [[UILabel alloc] initWithFrame:CGRectMake(btnWidth, 0, 0.5, 50)];
        [lblline2 setBackgroundColor:[UIColor lightGrayColor]];
        lblline2.alpha = 0.6;
        [optionView addSubview:lblline2];
        
        lblline3 = [[UILabel alloc] initWithFrame:CGRectMake(btnWidth*2, 0, 0.5, 50)];
        [lblline3 setBackgroundColor:[UIColor lightGrayColor]];
        lblline3.alpha = 0.6;
        [optionView addSubview:lblline3];
        
        UILabel * lblline4 = [[UILabel alloc] initWithFrame:CGRectMake((btnWidth*3)-7, 0, 0.5, 50)];
        [lblline4 setBackgroundColor:[UIColor lightGrayColor]];
        lblline4.alpha = 0.6;
        [optionView addSubview:lblline4];
        
        settingView = [[UIView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH - btnWidth-30, 110,btnWidth+30, 80)];
        settingView.backgroundColor = UIColor.blackColor;
        settingView.alpha = 0.7;
        settingView.hidden = true;
        [self.contentView addSubview:settingView];
    
        
        btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSetting.frame = CGRectMake(0, 0, settingView.frame.size.width, 40);
        btnSetting.backgroundColor = [UIColor clearColor];
//        [btnSetting setImage:[UIImage imageNamed:@"active_settings.png"] forState:UIControlStateNormal];
        [btnSetting setTitle:@" Settings" forState:UIControlStateNormal];
        btnSetting.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btnSetting.titleLabel.font = [UIFont fontWithName:CGRegular size:textSize];
        [settingView addSubview:btnSetting];
        
        lbllineSetting = [[UILabel alloc] initWithFrame:CGRectMake(2, 40.5,settingView.frame.size.width-4, 0.5)];
        lbllineSetting.backgroundColor = UIColor.lightGrayColor;
        [settingView addSubview:lbllineSetting];
        
        
        btnSOS = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSOS.frame = CGRectMake(0, 40, settingView.frame.size.width, 40);
        btnSOS.backgroundColor = [UIColor clearColor];
//        [btnSOS setImage:[UIImage imageNamed:@"active_settings.png"] forState:UIControlStateNormal];
        [btnSOS setTitle:@" SOS Messages" forState:UIControlStateNormal];
        btnSOS.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btnSOS.titleLabel.font = [UIFont fontWithName:CGRegular size:textSize-1];
        [settingView addSubview:btnSOS];
        
        
        UILabel * lbllineBelow = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, DEVICE_WIDTH, 0.5)];
        [lbllineBelow setBackgroundColor:[UIColor lightGrayColor]];
        lbllineBelow.alpha = 0.6;
//        [optionView addSubview:lbllineBelow];
        
        UILabel * lbllineabove = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0.5)];
        [lbllineabove setBackgroundColor:[UIColor lightGrayColor]];
        lbllineabove.alpha = 0.6;
        [optionView addSubview:lbllineabove];
        

        [self.contentView addSubview:lblDeviceName];
        [self.contentView addSubview:lblAddress];
    }
    return self;
}

@end
