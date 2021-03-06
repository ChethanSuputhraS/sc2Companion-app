//
//  RadioButtonClass.m
//  GeofenceAlertApp
//
//  Created by Ashwin on 10/12/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import "RadioButtonClass.h"

@implementation RadioButtonClass
@synthesize delegate, viewTag;

-(void)setButtonFrame:(CGRect)frame withNumberofItems:(NSArray *)arrItemsfromView withSelectedIndex:(NSInteger)selectedIndex
{
    self.frame = frame;
    CGFloat btnWidth = frame.size.width / arrItemsfromView.count;
    CGFloat btnHeight = frame.size.height;
    arrItems = [arrItemsfromView mutableCopy];
    
    for (int i =0; i < arrItems.count; i++)
    {
        UIView * containterview  = [[UIView alloc] initWithFrame:CGRectMake(btnWidth * i, 0, btnWidth, btnHeight)];
        [self addSubview:containterview];
        
        UIImageView * imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radiobuttonUnselected"]];
        imgLogo.frame = CGRectMake(0, (btnHeight - 20) / 2, 20 , 20);
        imgLogo.userInteractionEnabled = YES;
        imgLogo.tag = 100 + i;
        imgLogo.backgroundColor = [UIColor clearColor];
        [containterview addSubview:imgLogo];
        
        UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, (btnHeight - 20) / 2, btnWidth-20 , 20)];
        lblTitle.userInteractionEnabled = YES;
        lblTitle.tag = 300 + i;
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.text = [arrItems objectAtIndex:i];
        lblTitle.textColor = UIColor.lightGrayColor;
        [containterview addSubview:lblTitle];
        lblTitle.font = [UIFont fontWithName:CGRegular size:textSize-1];

        UIButton * btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnRadio setFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
        btnRadio.tag = 200 + i;
        [btnRadio addTarget:self action:@selector(btnRadioClick:) forControlEvents:UIControlEventTouchUpInside];
        [containterview addSubview:btnRadio];
        
        if (selectedIndex == i)
        {
            [imgLogo setImage:[UIImage imageNamed:@"radiobuttonSelected"]];
        }
    }
}
-(void)btnRadioClick:(id)sender
{
    UIButton * tmpBtn = (UIButton *)sender;
    selectedIndex = tmpBtn.tag - 200;

    [delegate RadioButtonClickEventDelegate:selectedIndex withRadioButton:viewTag];
    
    for (int i = 0; i< [arrItems count]; i++)
    {
        UIImageView * img = [self viewWithTag:i + 100];
        if (tmpBtn.tag - 100 == i + 100)
        {
            [img setImage:[UIImage imageNamed:@"radiobuttonSelected"]];
        }
        else
        {
            [img setImage:[UIImage imageNamed:@"radiobuttonUnselected"]];
        }
    }
}
-(NSInteger)getSelectedIndex
{
    return selectedIndex;
}
-(void)SetButtonSelectedwithIndex:(int)selectedIndex withObject:(RadioButtonClass *)radioObject
{
    long tagVal = self.tag - 500;
    if (tagVal < 0)
    {
        tagVal = 0;
    }
    UIImageView * img1 = [radioObject viewWithTag:0 + 100];
    img1.image = [UIImage imageNamed:@"radiobuttonUnselected"];
    
    UIImageView * img2 = [radioObject viewWithTag:1 + 100];
    img2.image = [UIImage imageNamed:@"radiobuttonUnselected"];

    UIImageView * img3 = [radioObject viewWithTag:2 + 100];
    img3.image = [UIImage imageNamed:@"radiobuttonUnselected"];

    if (selectedIndex == 0)
    {
        [img1 setImage:[UIImage imageNamed:@"radiobuttonSelected"]];
    }
    else if (selectedIndex == 11)
    {
        [img2 setImage:[UIImage imageNamed:@"radiobuttonSelected"]];
    }

}
-(void)UpdateButtonsforSIMConfiguration:(int)selectedIndex withObject:(RadioButtonClass *)radioObject
{
    UIImageView * img1 = [radioObject viewWithTag:0 + 100];
    img1.image = [UIImage imageNamed:@"radiobuttonUnselected"];
    
    UIImageView * img2 = [radioObject viewWithTag:1 + 100];
    img2.image = [UIImage imageNamed:@"radiobuttonUnselected"];

    if (selectedIndex == 0)
    {
        [img1 setImage:[UIImage imageNamed:@"radiobuttonSelected"]];
    }
    else if (selectedIndex == 1)
    {
        [img2 setImage:[UIImage imageNamed:@"radiobuttonSelected"]];
    }

}
-(void)UpdateButtonsforIndustryConfiguration:(int)selectedIndex withObject:(RadioButtonClass *)radioObject
{
    long tagVal = self.tag - 500;
    if (tagVal < 0)
    {
        tagVal = 0;
    }
    UIImageView * img1 = [radioObject viewWithTag:0 + 100];
    img1.image = [UIImage imageNamed:@"radiobuttonUnselected"];
    
    UIImageView * img2 = [radioObject viewWithTag:1 + 100];
    img2.image = [UIImage imageNamed:@"radiobuttonUnselected"];

    UIImageView * img3 = [radioObject viewWithTag:2 + 100];
    img3.image = [UIImage imageNamed:@"radiobuttonUnselected"];

    if (selectedIndex == 1)
    {
        [img2 setImage:[UIImage imageNamed:@"radiobuttonSelected"]];
    }
    else if (selectedIndex == 0)
    {
        [img1 setImage:[UIImage imageNamed:@"radiobuttonSelected"]];
    }
    else if (selectedIndex == 2)
    {
        [img3 setImage:[UIImage imageNamed:@"radiobuttonSelected"]];
    }
}

@end
