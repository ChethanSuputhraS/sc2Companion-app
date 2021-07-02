//
//  LoginVC.m
//  Succorfish Installer App
//
//  Created by stuart watts on 19/02/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import "LoginVC.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "FCAlertView.h"
#import "HomeVC.h"


@interface LoginVC ()<MFMailComposeViewControllerDelegate>
{
    int txtSizse;
}
@end

@implementation LoginVC

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = true;

    txtSizse = 16;
    if (IS_IPHONE_4 || IS_IPHONE_5)
    {
        txtSizse = 15;
    }
    
    self.title = @"Login";

    UIImageView * imgBack = [[UIImageView alloc] init];
    imgBack.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    imgBack.image = [UIImage imageNamed:@"Splash_bg.png"];
    [self.view addSubview:imgBack];

    isShowPassword = NO;
    
    [self setContentViewFrames];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - Set UI frames
-(void)setContentViewFrames
{
    scrlContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    scrlContent.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrlContent];
    
    UILabel * lblName =  [[UILabel alloc] init];
    lblName.frame = CGRectMake(15, 30, DEVICE_WIDTH-30, 30);
    lblName.textAlignment = NSTextAlignmentCenter;
    lblName.textColor = [UIColor whiteColor];
    lblName.text = @"Log in";
    lblName.font = [UIFont fontWithName:CGRegular size:txtSizse];
    [scrlContent addSubview:lblName];
    
    UIImageView * imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake((DEVICE_WIDTH-(170*approaxSize))/2, 87*approaxSize, 170*approaxSize, 34*approaxSize)];
    [imgLogo setImage:[UIImage imageNamed:@"logo.png"]];
    [imgLogo setClipsToBounds:YES];
    [imgLogo setContentMode:UIViewContentModeScaleAspectFit];
    [scrlContent addSubview:imgLogo];
    
   
    viewPopUp = [[UIView alloc] initWithFrame:CGRectMake(15, 150*approaxSize,DEVICE_WIDTH-30,300*approaxSize)];
    [viewPopUp setBackgroundColor:[UIColor clearColor]];
    viewPopUp.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    viewPopUp.layer.shadowOffset = CGSizeMake(0.1, 0.1);
    viewPopUp.layer.shadowRadius = 25;
    viewPopUp.layer.shadowOpacity = 0.5;
    [scrlContent addSubview:viewPopUp];
    
    if (IS_IPHONE_4)
    {
        imgLogo.frame = CGRectMake((DEVICE_WIDTH-204)/2, 25, 204, 42);
        viewPopUp.frame = CGRectMake(15, 110, DEVICE_WIDTH-30, 300);
        lblName.hidden = YES;
    }
    
    int yy = 30;
    
    UIImageView * imgPopUpBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewPopUp.frame.size.width, viewPopUp.frame.size.height)];
    [imgPopUpBG setBackgroundColor:[UIColor blackColor]];
    imgPopUpBG.alpha = 0.7;
    imgPopUpBG.layer.cornerRadius = 10;
    [viewPopUp addSubview:imgPopUpBG];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:imgPopUpBG.bounds];
    imgPopUpBG.layer.masksToBounds = NO;
    imgPopUpBG.layer.shadowColor = [UIColor whiteColor].CGColor;
    imgPopUpBG.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    imgPopUpBG.layer.shadowOpacity = 0.5f;
    imgPopUpBG.layer.shadowPath = shadowPath.CGPath;
    
    txtEmail = [[UITextField alloc] initWithFrame:CGRectMake(15, yy, viewPopUp.frame.size.width-30, 35)];
    txtEmail.placeholder = @"Username";
    txtEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txtEmail.delegate = self;
    txtEmail.autocorrectionType = UITextAutocorrectionTypeNo;
    txtEmail.keyboardType = UIKeyboardTypeEmailAddress;
    txtEmail.textColor = [UIColor whiteColor];
    [txtEmail setFont:[UIFont fontWithName:CGRegular size:txtSizse]];
//    [txtEmail setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [APP_DELEGATE getPlaceholderText:txtEmail andColor:[UIColor lightGrayColor]];
    txtEmail.returnKeyType  = UIReturnKeyNext;
    [viewPopUp addSubview:txtEmail];
    
    UILabel * lblEmailLine = [[UILabel alloc] initWithFrame:CGRectMake(0, txtEmail.frame.size.height-2, txtEmail.frame.size.width, 1)];
    [lblEmailLine setBackgroundColor:[UIColor lightGrayColor]];
    [txtEmail addSubview:lblEmailLine];
    
    yy = yy+60;
    
    txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(15, yy, viewPopUp.frame.size.width-30, 35)];
    txtPassword.placeholder = @"Password";
    txtPassword.delegate = self;
    txtPassword.secureTextEntry = YES;
    txtPassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txtPassword.textColor = [UIColor whiteColor];
    [txtPassword setFont:[UIFont fontWithName:CGRegular size:txtSizse]];
//    [txtPassword setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [APP_DELEGATE getPlaceholderText:txtPassword andColor:[UIColor lightGrayColor]];
    txtPassword.returnKeyType  = UIReturnKeyDone;
    [viewPopUp addSubview:txtPassword];
    
    UILabel * lblPasswordLine = [[UILabel alloc] initWithFrame:CGRectMake(0, txtPassword.frame.size.height-2, txtPassword.frame.size.width,1)];
    [lblPasswordLine setBackgroundColor:[UIColor lightGrayColor]];
    [txtPassword addSubview:lblPasswordLine];
    
    btnShowPass = [UIButton buttonWithType:UIButtonTypeCustom];
    btnShowPass.frame = CGRectMake(viewPopUp.frame.size.width-60, yy, 60, 35);
    btnShowPass.backgroundColor = [UIColor clearColor];
    [btnShowPass addTarget:self action:@selector(showPassclick) forControlEvents:UIControlEventTouchUpInside];
    [btnShowPass setImage:[UIImage imageNamed:@"passShow.png"] forState:UIControlStateNormal];
    [viewPopUp addSubview:btnShowPass];
    
    yy = yy+50*approaxSize;
    
    imgCheck = [[UIImageView alloc] init];
    imgCheck.image = [UIImage imageNamed:@"checkEmpty.png"];
    imgCheck.frame = CGRectMake(15, yy+5, 20, 20);
    [viewPopUp addSubview:imgCheck];
    
    UILabel * lblRemember =  [[UILabel alloc] init];
    lblRemember.frame = CGRectMake(45, yy, DEVICE_WIDTH-30, 30);
//    lblRemember.textAlignment = NSTextAlignmentCenter;
    lblRemember.textColor = [UIColor whiteColor];
    lblRemember.text = @"Remember Me";
    [lblRemember setFont:[UIFont fontWithName:CGRegular size:txtSizse-1]];
    [viewPopUp addSubview:lblRemember];
    
    btnRemember = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRemember setFrame:CGRectMake(0, yy, viewPopUp.frame.size.width, 44)];
    [btnRemember addTarget:self action:@selector(btnRememberClick) forControlEvents:UIControlEventTouchUpInside];
    btnRemember.backgroundColor = [UIColor clearColor];
    [viewPopUp addSubview:btnRemember];
    
    yy = yy+45*approaxSize;

    
    btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLogin setFrame:CGRectMake(15, yy, viewPopUp.frame.size.width-30, 44)];
    [btnLogin setTitle:@"Login" forState:UIControlStateNormal];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLogin.titleLabel setFont:[UIFont fontWithName:CGRegular size:txtSizse]];
    [btnLogin addTarget:self action:@selector(btnLoginClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewPopUp addSubview:btnLogin];
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"BTN.png"] forState:UIControlStateNormal];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setFrame:CGRectMake(btnLogin.frame.size.width-40, 5, 30, 30)];
    [btnLogin addSubview:activityIndicator];
      
    yy = yy+65*approaxSize;
    
    btnForgotPassword = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnForgotPassword setFrame:CGRectMake(40, yy, viewPopUp.frame.size.width-80, 40)];
    [btnForgotPassword setTitle:@"Forgot your password?" forState:UIControlStateNormal];
    [btnForgotPassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnForgotPassword setBackgroundColor:[UIColor clearColor]];
    [btnForgotPassword addTarget:self action:@selector(btnForgotPasswordClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnForgotPassword.titleLabel setFont:[UIFont fontWithName:CGBold size:txtSizse]];
    [viewPopUp addSubview:btnForgotPassword];
    
    if (CURRENT_USER_EMAIL != [NSNull null])
    {
        if (CURRENT_USER_EMAIL != nil && CURRENT_USER_EMAIL != NULL && ![CURRENT_USER_EMAIL isEqualToString:@""])
        {
            txtEmail.text = CURRENT_USER_EMAIL;
        }
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"IsRemember"] isEqualToString:@"Yes"])
    {
        if (CURRENT_USER_PASS != [NSNull null])
        {
            if (CURRENT_USER_PASS != nil && CURRENT_USER_PASS != NULL && ![CURRENT_USER_PASS isEqualToString:@""])
            {
                txtPassword.text = CURRENT_USER_PASS;
                imgCheck.image = [UIImage imageNamed:@"checked.png"];
            }
        }
    }
}
#pragma mark - ButtonClickevents
-(void)btnLoginClicked
{
    [self hideKeyboard];
    if ([txtEmail.text isEqualToString:@""])
    {
        [self AlertViewFCTypeCaution:@"Please enter your name."];
    }
    else if ([txtPassword.text isEqualToString:@""])
    {
        [self AlertViewFCTypeCaution:@"Please enter your password"];
    }
    else
    {
        if ([APP_DELEGATE isNetworkreachable]) 
        {
            [self VerifyUserWithServer];
        }
        else
        {
            [self AlertViewFCTypeCaution:@"There is no internet connection. Please connect to internet first then try again later."];
        }
    }
}
-(void)btnForgotPasswordClicked
{
    [self hideKeyboard];
    [self setMoreBtnPopUp];
}
-(void)btnSignupClick
{
}
-(void)showPassclick
{
    if (isShowPassword)
    {
        isShowPassword = NO;
        [btnShowPass setImage:[UIImage imageNamed:@"passShow.png"] forState:UIControlStateNormal];
        txtPassword.secureTextEntry = YES;
    }
    else
    {
        isShowPassword = YES;
        [btnShowPass setImage:[UIImage imageNamed:@"visible.png"] forState:UIControlStateNormal];
        txtPassword.secureTextEntry = NO;
    }
}
-(void)btnRememberClick
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"IsRemember"] isEqualToString:@"Yes"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"IsRemember"];
        imgCheck.image = [UIImage imageNamed:@"checkEmpty.png"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"IsRemember"];
        imgCheck.image = [UIImage imageNamed:@"checked.png"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)btnCallClick
{
    NSString *number = [NSString stringWithFormat:@"+441914476883"];
    NSURL* callUrl=[NSURL URLWithString:[NSString   stringWithFormat:@"tel:%@",number]];
    
    //check  Call Function available only in iphone
    if([[UIApplication sharedApplication] canOpenURL:callUrl])
    {
        [[UIApplication sharedApplication] openURL:callUrl];
    }
    else
    {
        [self AlertViewFCTypeCaution:@"This function is only available on the iPhone"];
    }
}
-(void)btnMailClick
{
    // Email Subject
    NSString *emailTitle = @"Forgot password";
    // Email Content
    
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"enquiries@succorfish.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:@"" isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    if (mc == nil)
    {
        URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:ALERT_TITLE message:@"Please set up a Mail account in order to send email." cancelButtonTitle:OK_BTN otherButtonTitles: nil, nil];
        
        [alertView setMessageFont:[UIFont fontWithName:CGRegular size:14]];
        [alertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
            [alertView hideWithCompletionBlock:^{
            }];
        }];
        [alertView showWithAnimation:URBAlertAnimationTopToBottom];
    if (IS_IPHONE_X){[alertView showWithAnimation:URBAlertAnimationDefault];}
    }
    else
    {
        [self.navigationController presentViewController:mc animated:YES completion:nil];
    }
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - Set Custom ActionSheet
-(void)setMoreBtnPopUp
{
    [viewOverLay removeFromSuperview];
    viewOverLay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [self.view addSubview:viewOverLay];
    
    backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    backView.backgroundColor = [UIColor blackColor];
    [backView setAlpha:0.4];
    [viewOverLay addSubview:backView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OverLayTaped:)];
    tapRecognizer.numberOfTapsRequired=1;
    [viewOverLay addGestureRecognizer:tapRecognizer];
    
    [viewMore removeFromSuperview];
    viewMore = [[UIView alloc] initWithFrame:CGRectMake(20, DEVICE_HEIGHT, self.view.frame.size.width-40, 280+20+20+10)];
    [viewMore setBackgroundColor:[UIColor blackColor]];
    viewMore.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    viewMore.layer.shadowOffset = CGSizeMake(0.1, 0.1);
    viewMore.layer.shadowRadius = 3;
    viewMore.layer.shadowOpacity = 0.5;
    [viewOverLay addSubview:viewMore];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:viewMore.bounds];
    viewMore.layer.masksToBounds = NO;
    viewMore.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    viewMore.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    viewMore.layer.shadowOpacity = 0.2f;
    viewMore.layer.shadowPath = shadowPath.CGPath;
    
    btncancel =[UIButton buttonWithType:UIButtonTypeCustom];
    [btncancel setFrame:CGRectMake(viewMore.frame.size.width-50,0, 50, 40)];
    btncancel.backgroundColor = [UIColor clearColor];
    [btncancel setImage:[UIImage imageNamed:@"wClose.png"] forState:UIControlStateNormal];
    [btncancel addTarget:self action:@selector(AlertCancleClicked:) forControlEvents:UIControlEventTouchUpInside];
    [viewMore addSubview:btncancel];
    
    int yy = 10;
    
    UILabel *lblTitle =[[UILabel alloc]initWithFrame:CGRectMake(0, 10, viewMore.frame.size.width, 20)];
    lblTitle.text= @"Forgot Password ?";
    lblTitle.textColor=[UIColor darkGrayColor];
    lblTitle.textAlignment=NSTextAlignmentCenter;
    lblTitle.clipsToBounds=NO;
    [lblTitle setFont:[UIFont fontWithName:CGRegular size:txtSizse]];
    lblTitle.shadowOffset= CGSizeMake(0.0, -1.0);
    lblTitle.shadowColor=[UIColor clearColor];
    [viewMore addSubview:lblTitle];
    
    yy = yy+25+5;
    
    UILabel *lblmessage =[[UILabel alloc]initWithFrame:CGRectMake(5, yy, viewMore.frame.size.width-10, 25)];
    lblmessage.text= @"Contact us on";
    lblmessage.textColor=[UIColor lightGrayColor];
    lblmessage.textAlignment=NSTextAlignmentCenter;
    lblmessage.clipsToBounds=NO;
    lblmessage.shadowOffset= CGSizeMake(0.0, -1.0);
    lblmessage.shadowColor=[UIColor clearColor];
    [lblmessage setFont:[UIFont fontWithName:CGRegular size:txtSizse-1]];
    [viewMore addSubview:lblmessage];
    
    yy = yy+25+5;

    UILabel *lblNumber =[[UILabel alloc]initWithFrame:CGRectMake(5, yy, viewMore.frame.size.width-10, 25)];
    lblNumber.text= @"+44 191 4476883";
    lblNumber.textColor=[UIColor redColor];
    lblNumber.textAlignment=NSTextAlignmentCenter;
    [lblNumber setFont:[UIFont fontWithName:CGRegular size:txtSizse+1]];
    [viewMore addSubview:lblNumber];
    
    yy = yy+25+5;

    UIButton * btnCall =[UIButton buttonWithType:UIButtonTypeSystem];
    [btnCall setFrame:CGRectMake(20, yy, viewMore.frame.size.width-40, 44)];
    [btnCall setTitle:@"Call Us" forState:UIControlStateNormal];
    [btnCall setBackgroundColor:[UIColor blackColor]];
    [btnCall setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCall.layer.borderWidth=0.5;
    btnCall.layer.borderColor=[UIColor darkGrayColor].CGColor;
    btnCall.titleLabel.font = [UIFont fontWithName:CGRegular size:txtSizse];
    [btnCall addTarget:self action:@selector(btnCallClick) forControlEvents:UIControlEventTouchUpInside];
    [viewMore addSubview:btnCall];
    
    yy = yy+25+5+ 44;

    UILabel * lblEmailLine = [[UILabel alloc] initWithFrame:CGRectMake(5,yy,viewMore.frame.size.width-10,1)];
    [lblEmailLine setBackgroundColor:[UIColor grayColor]];
    [viewMore addSubview:lblEmailLine];
    
    UILabel *lblOr =[[UILabel alloc]initWithFrame:CGRectMake((viewMore.frame.size.width-25)/2, yy-12.5, 25, 25)];
    lblOr.text= @"Or";
    lblOr.textColor=[UIColor whiteColor];
    lblOr.textAlignment=NSTextAlignmentCenter;
    [lblOr setFont:[UIFont fontWithName:CGRegular size:txtSizse]];
    lblOr.layer.cornerRadius = 12.5;
    lblOr.layer.masksToBounds = YES;
    lblOr.backgroundColor = [UIColor blackColor];
    [viewMore addSubview:lblOr];
    
    yy = yy+25;
    
    UILabel * lblMailHint =[[UILabel alloc]initWithFrame:CGRectMake(5, yy, viewMore.frame.size.width-10, 25)];
    lblMailHint.textAlignment=NSTextAlignmentCenter;
    [lblMailHint setFont:[UIFont fontWithName:CGRegular size:txtSizse-1]];
    lblMailHint.textColor=[UIColor lightGrayColor];
    lblMailHint.text=@"write mail us on";
    [viewMore addSubview:lblMailHint];
    
    yy = yy+25+5;

    UILabel * lblMail =[[UILabel alloc]initWithFrame:CGRectMake(5, yy, viewMore.frame.size.width-10, 25)];
    lblMail.textAlignment=NSTextAlignmentCenter;
    [lblMail setFont:[UIFont fontWithName:CGRegular size:txtSizse+1]];
    lblMail.textColor=[UIColor redColor];
    lblMail.text=@"enquiries@succorfish.com";
    [viewMore addSubview:lblMail];
    
    yy = yy+25+5;

    UIButton * btnMail =[UIButton buttonWithType:UIButtonTypeSystem];
    [btnMail setFrame:CGRectMake(20, yy, viewMore.frame.size.width-40, 44)];
    [btnMail setTitle:@"Mail Us" forState:UIControlStateNormal];
    [btnMail setBackgroundColor:[UIColor blackColor]];
    [btnMail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnMail.layer.borderWidth=0.5;
    btnMail.layer.borderColor=[UIColor darkGrayColor].CGColor;
    btnMail.titleLabel.font = [UIFont fontWithName:CGRegular size:txtSizse];
    [btnMail addTarget:self action:@selector(btnMailClick) forControlEvents:UIControlEventTouchUpInside];
    [viewMore addSubview:btnMail];
    
    [self hideMorePopUpView:NO];
}
-(void)hideMorePopUpView:(BOOL)isHide
{
    [txtForgotpasswordEmail resignFirstResponder];
    
    if (isHide == YES)
    {
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options: UIViewAnimationOptionOverrideInheritedCurve
                         animations:^{
            self->viewMore.frame = CGRectMake(20, DEVICE_HEIGHT , DEVICE_WIDTH-40, self->viewMore.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             [self->viewMore removeFromSuperview];
                             [self->viewOverLay removeFromSuperview];
                         }];
    }
    else
    {
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionOverrideInheritedCurve
                         animations:^{
                             self->viewMore.frame = CGRectMake(20, (DEVICE_HEIGHT-(self->viewMore.frame.size.height))/2 , DEVICE_WIDTH-40, self->viewMore.frame.size.height);
                         }
                         completion:^(BOOL finished)
        {
        }];
    }
}
#pragma mark - custome Alert Clicked
-(void)AlertCancleClicked:(id)sender
{
    NSLog(@"AlertCancleClicked");
    [self hideMorePopUpView:YES];
}
-(void)cancelBtnClicked:(id)sender
{
    [self hideMorePopUpView:YES];
}
-(void)OverLayTaped:(id)sender
{
    NSLog(@"Tapped");
}
#pragma mark - Web Service Call
-(void)VerifyUserWithServer
{
    [APP_DELEGATE endHudProcess];
    [APP_DELEGATE startHudProcess:@"Logging..."];
 
    dispatch_async(dispatch_get_main_queue(), ^(void){
        {
                NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
                //https://ws.succorfish.net/user/getOwn
                //https://ws.succorfish.net/basic/v2/user/getOwn
                NSString * strUrl = [NSString stringWithFormat:@"https://ws.succorfish.net/basic/v2/user/getOwn"];
                
                NSString * strbasicAuthToken;
    //            NSString * str = [NSString stringWithFormat:@"device_test:dac6hTQXJc"];
                NSString * str = [NSString stringWithFormat:@"%@:%@",self->txtEmail.text,self->txtPassword.text];
                NSString * simpleStr = [self base64String:str];
                strbasicAuthToken = simpleStr;
                
                AFHTTPRequestOperationManager *manager1 = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://server.url"]];
                NSString *authorization = [NSString stringWithFormat: @"Basic %@",strbasicAuthToken];
                [manager1.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
                
                AFHTTPRequestOperation *op = [manager1 GET:strUrl parameters:args success:^(AFHTTPRequestOperation *operation, id responseObject){
                    NSLog(@"Success Response with Result=%@",responseObject);
                    
                    NSMutableDictionary * dictID = [[NSMutableDictionary alloc] init];
                    dictID = [responseObject mutableCopy];

                    [[NSUserDefaults standardUserDefaults] setValue:self->txtEmail.text forKey:@"CURRENT_USER_EMAIL"];
                    [[NSUserDefaults standardUserDefaults] setValue:self->txtPassword.text forKey:@"CURRENT_USER_PASS"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"IS_LOGGEDIN"];
                    [[NSUserDefaults standardUserDefaults] setValue:[dictID valueForKey:@"accountId"] forKey:@"CURRENT_USER_ACCOUNT_ID"];

                    [dictID setObject:self->txtPassword.text forKey:@"localPassword"];
                    
                    if ([[self checkforValidString:[dictID valueForKey:@"firstName"]] isEqualToString:@"NA"])
                    {
                        
                    }
                    else
                    {
                        NSString * names = [NSString stringWithFormat:@"%@ %@",[dictID valueForKey:@"firstName"],[dictID valueForKey:@"lastName"]];
                        [[NSUserDefaults standardUserDefaults] setValue:names forKey:@"name"];
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"IS_LOGGEDIN"];
                    [[NSUserDefaults standardUserDefaults] setValue:self->txtEmail.text forKey:@"CURRENT_USER_NAME"];
                    [[NSUserDefaults standardUserDefaults] setValue:[dictID valueForKey:@"industry"] forKey:@"industry"];
                    [[NSUserDefaults standardUserDefaults] setValue:[dictID valueForKey:@"id"] forKey:@"CURRENT_USER_ID"];
    //                [[NSUserDefaults standardUserDefaults] setObject:dictID forKey:@"UserDict"];
                    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isNewVersionAvailable"];
                    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"TotalInstalls"];
                    NSString * str = [NSString stringWithFormat:@"%@:%@",self->txtEmail.text,self->txtPassword.text];
                    NSString * simpleStr = [self base64String:str];
                    [[NSUserDefaults standardUserDefaults] setObject:simpleStr forKey:@"BasicAuthToken"];
                
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
    //                [self getAccountdetailsofUser]; //To get industry from
                    
                    FCAlertView *alert = [[FCAlertView alloc] init];
                    [alert makeAlertTypeSuccess];
                    alert.firstButtonCustomFont = [UIFont fontWithName:CGRegular size:textSize];
                    [alert showAlertWithTitle:@"SC2 Companion App" withSubtitle:@"Logged in successfully." withCustomImage:[UIImage imageNamed:@"alert-round.png"] withDoneButtonTitle:@"OK" andButtons:nil];
                    [alert doneActionBlock:^{
                        
                        [APP_DELEGATE MoveToHomeVCAfterLogin];
                    }];

                    [APP_DELEGATE endHudProcess];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    if (error)
                    {
                        [APP_DELEGATE endHudProcess];
                        NSLog(@"Servicer error = %@", error);
                        [self ErrorMessagePopup];
                    }
                }];
                [op start];
            }
            // Perform async operation
            // Call your method/function here
            // Example:
        });
    }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Hide Keyboard
-(void)hideKeyboard
{
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtForgotpasswordEmail resignFirstResponder];
}
#pragma mark - Textfield Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtEmail)
    {
        [txtPassword becomeFirstResponder];
    }
    else if (textField == txtPassword)
    {
        [textField resignFirstResponder];
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField== txtEmail || textField == txtPassword)
    {
        [UIView animateWithDuration:0.3 animations:^{
            if (IS_IPHONE_4)
            {
//                [viewPopUp setFrame:CGRectMake(15, DEVICE_HEIGHT/2-160-70, DEVICE_WIDTH-30, 300)];
            }
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            if (IS_IPHONE_4)
            {
                [self->viewMore setFrame:CGRectMake(20, (DEVICE_HEIGHT-(self->viewMore.frame.size.height))/2 -140, DEVICE_WIDTH-40, self->viewMore.frame.size.height)];
            }else
            {
                [self->viewMore setFrame:CGRectMake(20, (DEVICE_HEIGHT-(self->viewMore.frame.size.height))/2- 100 , DEVICE_WIDTH-40, self->viewMore.frame.size.height)];
            }
        }];
    }
    lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, textField.frame.size.height-2, textField.frame.size.width, 2)];
    
    [lblLine setBackgroundColor:[UIColor whiteColor]];
    [textField addSubview:lblLine];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == txtEmail || textField == txtPassword)
    {
        [UIView animateWithDuration:0.3 animations:^{
            if (IS_IPHONE_4)
            {
//                [viewPopUp setFrame:CGRectMake(15, 110, DEVICE_WIDTH-30, 300)];
            }
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self->viewMore setFrame:CGRectMake(20, (DEVICE_HEIGHT-(self->viewMore.frame.size.height))/2 , DEVICE_WIDTH-40, self->viewMore.frame.size.height)];
        }];
    }
    [lblLine removeFromSuperview];
}
-(void)ErrorMessagePopup
{
    [APP_DELEGATE endHudProcess];
    [self AlertViewFCTypeCaution:@"Username/Password is incorrect. Please check your credential."];
}
-(NSString *)checkforValidString:(NSString *)strRequest
{
    NSString * strValid;
    if (![strRequest isEqual:[NSNull null]])
    {
        if (strRequest != nil && strRequest != NULL && ![strRequest isEqualToString:@""])
        {
            strValid = strRequest;
        }
        else
        {
            strValid = @"NA";
        }
    }
    else
    {
        strValid = @"NA";
    }
    strValid = [strValid stringByReplacingOccurrencesOfString:@"\"" withString:@""];

    return strValid;
}
-(NSString *)base64String:(NSString *)str
{
    NSData *theData = [str dataUsingEncoding: NSASCIIStringEncoding];
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++)
        {
            value <<= 8;
            if (j < length) {
                
                value |= (0xFF & input[j]);
                
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
-(void)AlertViewFCTypeCaution:(NSString *)strPopup
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeCaution];
    [alert showAlertInView:self
                 withTitle:@"SC2 Companion App"
              withSubtitle:strPopup
           withCustomImage:[UIImage imageNamed:@"logo.png"]
       withDoneButtonTitle:nil
                andButtons:nil];
}
@end
