//
//  RadioButtonClass.h
//  GeofenceAlertApp
//
//  Created by Ashwin on 10/12/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RadioButtonDelegate
-(void)RadioButtonClickEventDelegate:(NSInteger)selectedIndex withRadioButton:(NSInteger)radioBtnTag;
@end
@interface RadioButtonClass : UIView
{
    NSInteger selectedIndex;
    NSArray * arrItems;
    NSArray * arrytxtitem;
    NSArray * arryLbl;
}

@property (nonatomic, weak) id<RadioButtonDelegate> delegate;
@property  NSInteger viewTag;

-(NSInteger)getSelectedIndex;
-(void)setButtonFrame:(CGRect)frame withNumberofItems:(NSArray *)arrItemsfromView withSelectedIndex:(NSInteger)selectedIndex;
-(void)SetButtonSelectedwithIndex:(int)selectedIndex withObject:(RadioButtonClass *)radioObject;

@end

NS_ASSUME_NONNULL_END
