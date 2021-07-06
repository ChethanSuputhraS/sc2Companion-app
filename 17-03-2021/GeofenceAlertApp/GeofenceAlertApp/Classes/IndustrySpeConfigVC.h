//
//  IndustrySpeConfigVC.h
//  GeofenceAlertApp
//
//  Created by Ashwin on 10/14/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IndustrySpeConfigVC : UIViewController
{
    
}
@property (nonatomic, strong) CBPeripheral * classPeripheral;
-(void)ReceviedSuccesResponseFromDevice:(NSString *)strResponse;
-(void)SetIndustrySpecificionValuetoUI:(NSArray *)arrData;

@end

NS_ASSUME_NONNULL_END
