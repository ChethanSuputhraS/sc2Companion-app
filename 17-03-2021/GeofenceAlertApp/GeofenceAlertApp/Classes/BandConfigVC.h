//
//  BandConfigVC.h
//  GeofenceAlertApp
//
//  Created by Ashwin on 10/14/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SIMBandConfigureDelegate <NSObject>
-(void)SentBandConfiguration:(NSInteger )intConfigValue withArray:(NSArray *)arrData;
@end


@interface BandConfigVC : UIViewController

@property (nonatomic, weak)id<SIMBandConfigureDelegate>delegate;
@property(nonatomic, strong) NSString * strBandValue;
@end

NS_ASSUME_NONNULL_END
