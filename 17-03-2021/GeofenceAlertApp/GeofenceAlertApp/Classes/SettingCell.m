//
//  SettingCell.m
//  GeofenceAlertApp
//
//  Created by Ashwin on 8/31/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell
@synthesize lblForSetting,lblSetValue,imgArrow,lblMsg,swReconnect,lblBack,txtFld,lblRightLbl;


- (void)awakeFromNib
{
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
        
        lblBack = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,DEVICE_WIDTH,50)]; 
        lblBack.backgroundColor = [UIColor blackColor];
        lblBack.alpha = 0.7;
        [self.contentView addSubview:lblBack];
        
        lblForSetting = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, DEVICE_WIDTH-20, 50)];
        lblForSetting.numberOfLines = 0;
        [lblForSetting setBackgroundColor:[UIColor clearColor]];
        [lblForSetting setTextColor:[UIColor whiteColor]];
        [lblForSetting setFont:[UIFont fontWithName:CGRegular size:textSize]];
        [lblForSetting setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:lblForSetting];
        
        lblRightLbl = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_WIDTH/2, 0, DEVICE_WIDTH/2-20, 50)];
        lblRightLbl.numberOfLines = 0;
        [lblRightLbl setBackgroundColor:[UIColor clearColor]];
        [lblRightLbl setTextColor:[UIColor whiteColor]];
        [lblRightLbl setFont:[UIFont fontWithName:CGBold size:textSize-1]];
        lblRightLbl.hidden = true;
        [lblRightLbl setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:lblRightLbl];
        
        
        txtFld = [[UIFloatLabelTextField alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH-0, 50)];
        [txtFld setBackgroundColor:[UIColor clearColor]];
        [txtFld setTextColor:[UIColor whiteColor]];
        [txtFld setFont:[UIFont fontWithName:CGRegular size:textSize]];
        [txtFld setTextAlignment:NSTextAlignmentLeft];
        txtFld.hidden = true;
        txtFld.layer.borderWidth = 0.5;
        txtFld.layer.cornerRadius = 4;
        txtFld.layer.borderColor = UIColor.lightGrayColor.CGColor;
        txtFld.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [self.contentView addSubview:txtFld];
        
        lblSetValue = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DEVICE_WIDTH-40, 50)];
        lblSetValue.numberOfLines = 0;
        [lblSetValue setBackgroundColor:[UIColor clearColor]];
        [lblSetValue setTextColor:[UIColor whiteColor]];
        [lblSetValue setFont:[UIFont fontWithName:CGBold size:textSize]];
        [lblSetValue setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:lblSetValue];
        
             lblMsg = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, DEVICE_WIDTH-20, 50)];
             lblMsg.numberOfLines = 0;
             [lblMsg setBackgroundColor:[UIColor clearColor]];
             [lblMsg setTextColor:[UIColor whiteColor]];
             [lblMsg setFont:[UIFont fontWithName:CGRegular size:textSize -1 ]];
             [lblMsg setTextAlignment:NSTextAlignmentRight];
           lblMsg.hidden = true;
             [self.contentView addSubview:lblMsg];
        
        swReconnect = [[UISwitch alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-60, 10, 44, 44)];
        swReconnect.backgroundColor = UIColor.clearColor;
        swReconnect.clipsToBounds = true;
        swReconnect.hidden = true;
        [self.contentView addSubview:swReconnect];
        
        imgArrow = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-17, 20, 10, 12)];
        [imgArrow setImage:[UIImage imageNamed:@"right_icon.png"]];
        [imgArrow setContentMode:UIViewContentModeScaleAspectFit];
        imgArrow.hidden = false;
        [self.contentView addSubview:imgArrow];
          
            }
            return self;
        }
        
@end
