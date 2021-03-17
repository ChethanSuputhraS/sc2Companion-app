//
//  CollectionCustomCell.m
//  HQ-INC App
//
//  Created by Kalpesh Panchasara on 15/05/20.
//  Copyright © 2020 Kalpesh Panchasara. All rights reserved.
//

#import "CollectionCustomCell.h"

@implementation CollectionCustomCell
@synthesize lblName,lblTransView,lblCoreTmp,lblType1Tmp, lblBack , lblNo, lblBorder;
@synthesize imgViewpProfile;
@synthesize viewpProfileRed;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        imgViewpProfile = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        imgViewpProfile.image = [UIImage imageNamed:@"User.png"];
//        imgViewpProfile.contentMode = UIViewContentModeScaleAspectFit;
//        [self.contentView addSubview:imgViewpProfile];
        
        lblBack = [[UILabel alloc ]initWithFrame:CGRectMake(0, self.contentView.frame.size.height - 50, self.contentView.frame.size.width, 50)];
        lblBack.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:lblBack];

        lblName = [[UILabel alloc ]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width-50, 50)];
        lblName.font = [UIFont fontWithName:@"Helvetica" size:25];
        lblName.textColor = UIColor.whiteColor;
        lblName.backgroundColor = [UIColor blackColor];
        lblName.textAlignment = NSTextAlignmentCenter;
//        [lblBack addSubview:lblName];
        
        lblNo = [[UILabel alloc ]initWithFrame:CGRectMake(0, (self.contentView.frame.size.height-50)/2, self.contentView.frame.size.width, 50)];
        lblNo.font = [UIFont fontWithName:@"Helvetica" size:25];
        [lblNo setTextColor:UIColor.blackColor];
        lblNo.textAlignment = NSTextAlignmentCenter;
        lblNo.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:lblNo];

        lblTransView = [[UILabel alloc ]initWithFrame:CGRectMake(self.contentView.frame.size.width - 100, 0, 100, self.contentView.frame.size.height - 50)];
        lblTransView.backgroundColor = [UIColor colorWithRed:204.0/255.0f green:204.0/255.0f blue:204.0/255.0f alpha:0.7];
//        [self.contentView addSubview:lblTransView];

        lblCoreTmp = [[UILabel alloc ]initWithFrame:CGRectMake(self.contentView.frame.size.width - 100, 20, 100, 80)];
        lblCoreTmp.font = [UIFont fontWithName:@"Helvetica" size:20];
        lblCoreTmp.textColor = UIColor.blackColor;
        lblCoreTmp.numberOfLines = 0;
        lblCoreTmp.textAlignment = NSTextAlignmentCenter;
//        [self.contentView addSubview:lblCoreTmp];

        lblType1Tmp = [[UILabel alloc ]initWithFrame:CGRectMake(self.contentView.frame.size.width - 100, 100, 100, 80)];
        lblType1Tmp.font = [UIFont fontWithName:@"Helvetica" size:20];
        lblType1Tmp.textColor = UIColor.blackColor;
        lblType1Tmp.numberOfLines = 0;
        lblType1Tmp.textAlignment = NSTextAlignmentCenter;
//        [self.contentView addSubview:lblType1Tmp];

        lblBorder = [[UILabel alloc ]initWithFrame:CGRectMake(0, self.contentView.frame.size.height - 1, self.contentView.frame.size.width,1)];
        lblBorder.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:lblBorder];

        lblName.text = @"Name";
//        lblNo.text = @"#";
        lblCoreTmp.text = @"-NA-\nCore Temp";
        lblType1Tmp.text = @"-NA-\nSkin Temp";
        imgViewpProfile.image = [UIImage imageNamed:@"add.png"];
        
        lblCoreTmp.hidden = true;
        lblType1Tmp.hidden = true;
        
//        viewpProfileRed = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
//        [self.contentView addSubview:viewpProfileRed];

    }
    return self;
}
@end
