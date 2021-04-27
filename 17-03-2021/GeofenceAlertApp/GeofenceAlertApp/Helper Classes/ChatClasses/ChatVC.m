//
//  ChatVC.m
//  SC4App18
//
//  Created by stuart watts on 19/04/2018.
//  Copyright © 2018 Kalpesh Panchasara. All rights reserved.
//

#import "ChatVC.h"
#import "MessageCell.h"
#import "LeftMenuCell.h"
#import "FCAlertView.h"
#import "HomeVC.h"
#import "SettingCell.h"


@interface ChatVC ()<UITextViewDelegate>
{
    BOOL isFreeText;
    UILabel * lblChatText;
    NSString * strMSg;
    UILabel * lblPlceholdChat;
    UIView * viewBack;
    UIImageView * imgSend;
    UITextView *txtViewChat;
    CGSize newSize;
    UISwitch * switcGSMIRR;
    UIButton *btnGSM,*btnIrridium;
    CBPeripheral * classPeripheral;
    BOOL isGsmSeleted;
    NSInteger isSentVia;

}
@end

@implementation ChatVC
@synthesize userNano,isFrom,userName,sc4NanoId;

- (void)viewDidLoad
{
    isSentVia = -1;
    
//    NSString * strDeleteRules = [NSString stringWithFormat:@"delete from Rules_Table"];
//
//    NSString * strDeletePolygon = [NSString stringWithFormat:@"delete from Polygon_Lat_Long"];
//
//    NSString * alert = [NSString stringWithFormat:@"delete from Geofence_alert_Table"];
//    NSString * alertGefonce = [NSString stringWithFormat:@"delete from Geofence"];
//
//    [[DataBaseManager dataBaseManager] execute:strDeleteRules];
//    [[DataBaseManager dataBaseManager] execute:strDeletePolygon];
//    [[DataBaseManager dataBaseManager] execute:alert];
//    [[DataBaseManager dataBaseManager] execute:alertGefonce];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    self.navigationController.navigationBarHidden = YES;
//
    UIImageView * imgBack = [[UIImageView alloc] init];
    imgBack.frame = CGRectMake(0, 0, viewWidth, DEVICE_HEIGHT);
    imgBack.image = [UIImage imageNamed:@"Splash_bg.png"];
    [self.view addSubview:imgBack];

     headerhHeight = 64;
    if (IS_IPAD)
    {
        headerhHeight = 64;
        viewWidth = 704;
        imgBack.frame = CGRectMake(0, 0, 704, DEVICE_HEIGHT);
        imgBack.image = [UIImage imageNamed:@"right_bg.png"];
    }
    else
    {
        headerhHeight = 64;
        if (IS_IPHONE_X)
        {
            headerhHeight = 88;
        }
        viewWidth = DEVICE_WIDTH;
        imgBack.frame = CGRectMake(0, 0, viewWidth, DEVICE_HEIGHT);
    }
    
    UIView * viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_HEIGHT-200, headerhHeight+40)];
    [viewHeader setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewHeader];
    
    UILabel * lblBack = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,viewWidth,headerhHeight+40)];
    lblBack.backgroundColor = [UIColor blackColor];
    [viewHeader addSubview:lblBack];
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, viewWidth, 40)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"Messaging"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGRegular size:textSize+1]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
    UILabel * lblTitle1 = [[UILabel alloc] initWithFrame:CGRectMake((DEVICE_WIDTH-130)/2, 45, 130, 15)];
    [lblTitle1 setBackgroundColor:[UIColor clearColor]];
    [lblTitle1 setText:@"Send messaging via"];
    [lblTitle1 setTextAlignment:NSTextAlignmentCenter];
    [lblTitle1 setFont:[UIFont fontWithName:CGRegular size:textSize-3]];
    [lblTitle1 setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle1];
    
    btnGSM = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_WIDTH/2-70, 60, 70, 45)];
    btnGSM.backgroundColor = UIColor.clearColor;
    [btnGSM setTitle:@" GSM" forState:UIControlStateNormal];
    [btnGSM setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btnGSM addTarget:self action:@selector(btnGSMclick) forControlEvents:UIControlEventTouchUpInside];
    [btnGSM setImage:[UIImage imageNamed:@"radiobuttonUnselected.png"] forState:UIControlStateNormal];
    btnGSM.titleLabel.font = [UIFont fontWithName:CGRegular size:textSize-2];
    btnGSM.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;;
    [viewHeader addSubview:btnGSM];
    
    
    btnIrridium = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_WIDTH/2+5, 60, 80, 45)];
    btnIrridium.backgroundColor = UIColor.clearColor;
    [btnIrridium setTitle:@" IRIDIUM" forState:UIControlStateNormal];
    [btnIrridium setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btnIrridium addTarget:self action:@selector(btnIrridumClick) forControlEvents:UIControlEventTouchUpInside];
    [btnIrridium setImage:[UIImage imageNamed:@"radiobuttonUnselected.png"] forState:UIControlStateNormal];
    btnIrridium.titleLabel.font = [UIFont fontWithName:CGRegular size:textSize-2];
    btnIrridium.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [viewHeader addSubview:btnIrridium];


    UIImageView * imgDelete = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-40, 20+(headerhHeight-20-21)/2, 20, 21)];
    [imgDelete setImage:[UIImage imageNamed:@"delete.png"]];
    [imgDelete setContentMode:UIViewContentModeScaleAspectFit];
    imgDelete.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:imgDelete];

    UIButton *btnclose=[[UIButton alloc]initWithFrame:CGRectMake(10, globalStatusHeight+40, 50, 45)];
    btnclose.backgroundColor = UIColor.clearColor;
    btnclose.clipsToBounds = true;
    [btnclose setImage:[UIImage imageNamed:@"CloseWhite.png"] forState:UIControlStateNormal];
    [btnclose addTarget:self action:@selector(btncloseClick) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnclose];
    
    UIButton * btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDelete addTarget:self action:@selector(btnDeleteClick) forControlEvents:UIControlEventTouchUpInside];
    btnDelete.frame = CGRectMake(viewWidth-headerhHeight-40, 0, headerhHeight + 40, headerhHeight);
    btnDelete.backgroundColor = [UIColor clearColor];
//    [viewHeader addSubview:btnDelete];


      switcGSMIRR = [[UISwitch alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-60, 10, 44, 44)];
      switcGSMIRR.backgroundColor = UIColor.clearColor;
      switcGSMIRR.clipsToBounds = true;
    [switcGSMIRR addTarget:self action:@selector(SwitchVlueChange:) forControlEvents:UIControlEventValueChanged];
//      [self.view addSubview:switcGSMIRR];
    
    [self setupMainContentView:headerhHeight];

    if (IS_IPHONE_X)
    {
        viewHeader.frame = CGRectMake(0, 0, DEVICE_WIDTH, 88);
        lblTitle.frame = CGRectMake(0, 40, DEVICE_WIDTH, 44);
//        backImg.frame = CGRectMake(10, 12+44, 12, 20);
        imgDelete.frame = CGRectMake(viewWidth-40, 12+44, 20, 21);
        btnDelete.frame = CGRectMake(DEVICE_WIDTH-70, 0, 70, 88);
    }
    
//    NSLog(@"Css======%@",arrGlobalChatHistory);
    [APP_DELEGATE startHudProcess:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    strCurrentScreen = @"Chat";
    [APP_DELEGATE hideTabBar:self.tabBarController];
    [self getMessagesfromDatabase];

    [super viewWillAppear:YES];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    strCurrentScreen = @"Other";
    [super viewWillDisappear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    [APP_DELEGATE endHudProcess];
    [self getMessagesfromDatabase];
    [super viewDidAppear:YES];
}

-(void)getMessagesfromDatabase
{
    [APP_DELEGATE endHudProcess];
    NSMutableArray * chatDetailArr = [[NSMutableArray alloc]init];
    arrGlobalChatHistory = [[NSMutableArray alloc] init];
    
    NSString * strMessage = [NSString stringWithFormat:@"select * from NewChat where from_name = 'me' or to_name = 'Other'"];
    [[DataBaseManager dataBaseManager] execute:strMessage resultsArray:chatDetailArr];
    
    if ([chatDetailArr count]>0)
    {
        arrGlobalChatHistory = [chatDetailArr mutableCopy];
    }
    
//    NSLog(@"Message data=%@",chatDetailArr);
    self.tableArray = [[TableArray alloc] init];

    for (int i=0; i<[chatDetailArr count]; i++)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];// formate
        NSDate * dateInstalled = [dateFormatter dateFromString:[[chatDetailArr objectAtIndex:i]valueForKey:@"time"]];

        Message *message = [[Message alloc] init];
        message.text = [[chatDetailArr objectAtIndex:i]valueForKey:@"msg_txt"];
        message.sequences = [[chatDetailArr objectAtIndex:i]valueForKey:@"sequence"];
        message.date = dateInstalled;
        message.chat_id = @"1";
        
        if ([[[chatDetailArr objectAtIndex:i] objectForKey:@"from_name"] isEqualToString:@"Me"])
        {
            message.sender = MessageSenderMyself;
        }
        else
        {
            message.sender = MessageSenderSomeone;
        }
        message.status = MessageStatusSent;

        if ([[[chatDetailArr objectAtIndex:i] objectForKey:@"status"] isEqualToString:@"Broadcast"])
        {
            message.status = MessageStatusSent;
        }
        else if([[[chatDetailArr objectAtIndex:i] objectForKey:@"status"] isEqualToString:@"Read"])
        {
            message.status = MessageStatusRead;
        }
        else if([[[chatDetailArr objectAtIndex:i] objectForKey:@"status"] isEqualToString:@"Received"])
        {
            message.status = MessageStatusReceived;
        }
        else if([[[chatDetailArr objectAtIndex:i] objectForKey:@"status"] isEqualToString:@"Failed"])
        {
            message.status = MessageStatusFailed;
        }
        
        [self.tableArray addObject:message];
    }
    
    
    
    [tblchat reloadData];

    if ([chatDetailArr count]>0)
    {
        NSIndexPath *indexPath3 = [self.tableArray indexPathForLastMessage];
        [tblchat scrollToRowAtIndexPath:indexPath3 atScrollPosition:UITableViewScrollPositionBottom animated:false];
    }
}
-(void)setupMainContentView:(int)headerHeights
{
    self.tableArray = [[TableArray alloc] init];
     bottomHeight = 80;
    
    if (IS_IPHONE)
    {
        if (IS_IPHONE_X)
        {
            bottomHeight = 70 + 45;
        }
        else
        {
            bottomHeight = 60;
        }
    }
    if ([self.isFrom isEqualToString:@"History"])
    {
        bottomHeight = 0;
    }

    tblchat = [[UITableView alloc]initWithFrame:CGRectMake(0, headerHeights+40, viewWidth, DEVICE_HEIGHT-headerHeights-40)];
    tblchat.rowHeight=40;
    tblchat.delegate=self;
    tblchat.dataSource=self;
    tblchat.allowsSelection = NO;
    tblchat.backgroundColor=[UIColor clearColor];
    [tblchat setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblchat setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:tblchat];
    
    xx=headerHeights;
    
    viewMessage = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT, viewWidth, 100)];//100 == 80
    viewMessage.backgroundColor = UIColor.clearColor;
    [self.view addSubview:viewMessage];
    
    UIImageView * img = [[UIImageView alloc] init];
    img.frame = CGRectMake(0, 0, viewWidth-0, 80);
    img.image = [UIImage imageNamed:@"msg_main_bg.png"];
    img.userInteractionEnabled = YES;
//    [viewMessage addSubview:img];
    
    viewBack = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT-60, DEVICE_WIDTH, 60)];
    viewBack.backgroundColor = [UIColor lightGrayColor]; // lightGray
//    viewBack.alpha = 0.5;
    viewBack.userInteractionEnabled = YES;
 
    [self.view  addSubview:viewBack];
    
    UIImageView * imgMsg = [[UIImageView alloc] init];
    imgMsg.frame = CGRectMake(15, 20, 24, 20);
    imgMsg.image = [UIImage imageNamed:@"messsage_icon.png"];
//    [viewBack addSubview:imgMsg];
    
    imgSend = [[UIImageView alloc] init];
    imgSend.frame = CGRectMake(viewBack.frame.size.width-60-20, 15, 40, 40);
    imgSend.image = [UIImage imageNamed:@"send_icon.png"];
    [viewBack addSubview:imgSend];
    
    lblChatText = [[UILabel alloc] init];
    lblChatText.frame =CGRectMake(70, 100, viewWidth-120-75, 80);
    lblChatText.backgroundColor = [UIColor clearColor];
    lblChatText.userInteractionEnabled = YES;
    lblChatText.textColor = UIColor.whiteColor;
    lblChatText.font = [UIFont fontWithName:CGRegular size:textSize];
//    lblChatText.text = @"Enter message";
    [img addSubview:lblChatText];
    

    
        txtViewChat = [[UITextView alloc]initWithFrame:CGRectMake(10, 10,viewWidth-60, 40)];
        txtViewChat.textAlignment = NSTextAlignmentLeft;
        txtViewChat.autocorrectionType = UITextAutocorrectionTypeNo;
        txtViewChat.delegate = self;
        txtViewChat.autocapitalizationType = UITextAutocapitalizationTypeNone;
        txtViewChat.textColor = UIColor.whiteColor;
        txtViewChat.font = [UIFont fontWithName:CGRegular size:textSize+1];
        txtViewChat.keyboardType = UIKeyboardTypeDefault;
//        txtViewChat.returnKeyType = UIReturnKeyDone;
        txtViewChat.clipsToBounds = true;
        txtViewChat.layer.cornerRadius = 20;
        txtViewChat.backgroundColor = UIColor.blackColor; //[UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];
//        txtViewChat.translatesAutoresizingMaskIntoConstraints = false;
        txtViewChat.scrollEnabled = NO;
        [viewBack addSubview:txtViewChat];
    
    lblPlceholdChat = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, txtViewChat.frame.size.width, 20)];
    lblPlceholdChat.textColor = UIColor.whiteColor;
    lblPlceholdChat.text = @" Message";
    lblPlceholdChat.font = [UIFont fontWithName:@"Helvetica Neue" size:textSize];
    [txtViewChat addSubview:lblPlceholdChat];

//    [txtChat setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    UIButton * btnMsgSend = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMsgSend.frame = CGRectMake(viewWidth-60, 0, 60, 60);
    btnMsgSend.backgroundColor = UIColor.clearColor;
    [btnMsgSend addTarget:self action:@selector(btnSendClick) forControlEvents:UIControlEventTouchUpInside];
    [viewBack addSubview:btnMsgSend];
 
    if (IS_IPHONE)
    {
        viewMessage.frame = CGRectMake(0, DEVICE_HEIGHT-60, viewWidth-0, 60);
        img.frame = CGRectMake(0, 0, viewWidth-0, 60);
        if (IS_IPHONE_X)
        {
            tblchat.frame = CGRectMake(0, headerHeights, viewWidth, DEVICE_HEIGHT-headerHeights-bottomHeight+15);
            viewMessage.frame = CGRectMake(0, DEVICE_HEIGHT-100, viewWidth-0, 60);
        }
        imgMsg.frame = CGRectMake(5, 10, 24, 20);
        imgSend.frame = CGRectMake(viewBack.frame.size.width-45, 10, 40, 40);
        btnMsgSend.frame = CGRectMake(viewWidth-65, 0, 65, 60);
        txtChat.frame = CGRectMake(30, 0,DEVICE_WIDTH-65-30, 60);
    }
}
#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableArray numberOfSections];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableArray numberOfMessagesInSection:section]; // return [arrMessages count];//
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.message = [self.tableArray objectAtIndexPath:indexPath];
    
    cell.resendButton.tag = indexPath.row;
    [cell.resendButton addTarget:self action:@selector(btnResendClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg.png"]];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [self.tableArray objectAtIndexPath:indexPath];
    return message.heigh;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.tableArray titleForSection:section];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 40);
   
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    UILabel *label = [[UILabel alloc] init];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:CGRegular size:textSize+5];
    [label sizeToFit];
    label.center = view.center;
    label.font = [UIFont fontWithName:CGRegular size:textSize];
    label.backgroundColor = [UIColor colorWithRed:207/255.0 green:220/255.0 blue:252.0/255.0 alpha:1];
    label.layer.cornerRadius = 10;
    label.layer.masksToBounds = YES;
    label.autoresizingMask = UIViewAutoresizingNone;
    [view addSubview:label];

    if (IS_IPHONE)
    {
        label.font = [UIFont fontWithName:CGRegular size:textSize-1];
    }
    return view;
}
- (void)tableViewScrollToBottomAnimated:(BOOL)animated
{
    NSInteger numberOfSections = [self.tableArray numberOfSections];
    NSInteger numberOfRows = [self.tableArray numberOfMessagesInSection:numberOfSections];// -1
    
    if (numberOfRows)
    {
        [tblchat scrollToRowAtIndexPath:[self.tableArray indexPathForLastMessage]
                          atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}
#pragma mark- textview methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGFloat fixedWidth = txtViewChat.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAX_INPUT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height+5);
    textView.frame = newFrame;
    
      viewBack.frame = CGRectMake(0, DEVICE_HEIGHT-newSize.height-250, DEVICE_WIDTH, newSize.height+30);
      tblchat.frame = CGRectMake(0, DEVICE_HEIGHT-newSize.height-70, DEVICE_WIDTH, newSize.height+30);

    if (textView == txtViewChat)
    {
        msgIndex = @"NA";
        isFreeText = YES;
        [self ShowPicker:true andView:viewMessage];
        if ([txtChat.text isEqualToString:@"Enter message"])
        {
            txtChat.text = @"";
        }
        
        [self ShowPicker:true andView:tblchat];

//        NSIndexPath *indexPath3 = [self.tableArray indexPathForLastMessage];
//        [tblchat scrollToRowAtIndexPath:indexPath3 atScrollPosition:UITableViewScrollPositionBottom
//                               animated:YES];
    }

    if (IS_IPHONE_5)
    {
            viewBack.frame = CGRectMake(0, DEVICE_HEIGHT-newSize.height-245, DEVICE_WIDTH, newSize.height+30);
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if  ([textView.text isEqual:@""])
        {
            lblPlceholdChat.text = @" Message ";
        }
        else if ([textView.text isEqual:textView.text])
        {
            lblPlceholdChat.text = @"";
        }

     viewMessage.frame = CGRectMake(0, DEVICE_HEIGHT-bottomHeight-220, viewWidth-0, 60);
     tblchat.frame = CGRectMake(0, headerhHeight+40, viewWidth, DEVICE_HEIGHT-headerhHeight+40);

     CGFloat fixedWidth = txtViewChat.frame.size.width;
     newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAX_INPUT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height+10);
    textView.frame = newFrame;

    viewBack.frame = CGRectMake(0, DEVICE_HEIGHT-newSize.height-245, DEVICE_WIDTH, newSize.height+30);
    
    if (IS_IPHONE_5)
    {
            viewBack.frame = CGRectMake(0, DEVICE_HEIGHT-newSize.height-245, DEVICE_WIDTH, newSize.height+30);
    }
//    imgSend.frame = CGRectMake(viewBack.frame.size.width-60-20, newSize.height+15, 40, 40);
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == txtViewChat)
        {
            if ([text isEqualToString:@"\n"])
            {
                  [textView resignFirstResponder];
                
                if ([txtViewChat.text isEqual:@""])
                {
                    viewBack.frame = CGRectMake(0, DEVICE_HEIGHT-60, DEVICE_WIDTH, 60);
                }
                else
                {
                    viewBack.frame = CGRectMake(0, DEVICE_HEIGHT-newSize.height-30, DEVICE_WIDTH, newSize.height+30);
                }
                return NO;
            }
    if(range.length + range.location > textView.text.length)
    {
        return NO;
    }
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
        
    return (newLength > 160) ? NO : YES;
        }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
//    viewBack.frame = CGRectMake(0, DEVICE_HEIGHT-newSize.height-60, DEVICE_WIDTH, newSize.height-60);
    viewMessage.frame = CGRectMake(0, DEVICE_HEIGHT-60, viewWidth-0, 60);
//    tblchat.frame = CGRectMake(0, headerhHeight+40, viewWidth, DEVICE_HEIGHT-headerhHeight-60-44);
    
    
    tblchat.frame = CGRectMake(0, xx, viewWidth, DEVICE_HEIGHT-xx-bottomHeight);
    [self ShowPicker:false andView:viewMessage];

//    [self.view endEditing:true];
}
- (void)scrollToBottom
{
    CGFloat yOffset = 0;
    
    if (tblchat.contentSize.height > tblchat.bounds.size.height)
    {
        yOffset = tblchat.contentSize.height - tblchat.bounds.size.height;
    }
    [tblchat setContentOffset:CGPointMake(0, yOffset) animated:true];
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
    return strValid;
}
#pragma mark - Button EVent
-(void)btncloseClick
{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)btnDeleteClick
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeWarning];
    [alert addButton:@"Yes" withActionBlock:^{
        NSLog(@"Custom Font Button Pressed");
        // Put your action here
//        [self deleteMessagesfromDatabase];
    }];
    alert.firstButtonCustomFont = [UIFont fontWithName:CGRegular size:textSize];
    [alert showAlertInView:self
                 withTitle:@"SC2 Companion App"
              withSubtitle:@"Are you sure want to delete message history ?"
           withCustomImage:[UIImage imageNamed:@"Subsea White 180.png"]
       withDoneButtonTitle:@"No" andButtons:nil];
}
-(void)btnCancelClick
{
//    [self hideMorePopUpView:YES];
}
-(void)OverLayTaped:(id)sender
{
    NSLog(@"Tapped");
    [self hideMorePopUpView:YES];
}
-(void)msgSelectionClick
{
    [self ShowPicker:false andView:viewMessage];
//    [self showMessageList];
}
-(void)deleteMessagesfromDatabase
{
    NSString * strDelete = [NSString stringWithFormat:@"Delete from NewChat where from_name ='%@' or to_name = '%@'",sc4NanoId,sc4NanoId];
    [[DataBaseManager dataBaseManager]execute:strDelete];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"historyRefresh" object:nil];
    NSString * strUpdate = [NSString stringWithFormat:@"update NewContact set msg = '' where SC4_nano_id = '%@'",sc4NanoId];//KP13-04-2015.
    [[DataBaseManager dataBaseManager]execute:strUpdate];
    
    [self.tableArray removeAllObjects];
    self.tableArray = [[TableArray alloc] init];
    [tblchat reloadData];
}
-(void)btnSendClick
{
    NSString *probablyEmpty = [txtViewChat.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if ([txtViewChat.text isEqual:@""])
    {
        [self AlertPopUPCaution:@"Enter message to send"];
    }
    else if([probablyEmpty isEqualToString:@""])
    {
        [self AlertPopUPCaution:@"Please enter valid message"];
    }
    else
    {
        if (globalPeripheral.state == CBPeripheralStateConnected)
        {
            if (isSentVia == -1)
            {
                [self AlertPopUPCaution:@"Please select the send Message via GSM or IRIDIUM"];
                
                viewBack.frame = CGRectMake(0, DEVICE_HEIGHT-60, DEVICE_WIDTH, 60);
                txtViewChat.frame = CGRectMake(10, 10,viewWidth-60, 40);
                
                [self.view endEditing:true];
                
            }
            else
            {
                [self StartSendingMessagetoDevice];
                NSIndexPath *indexPath3 = [self.tableArray indexPathForLastMessage];
                [tblchat scrollToRowAtIndexPath:indexPath3 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
        else
        {
            [self AlertPopUPCaution:@"Please connect to the device to send message"];
        }
//        viewBack.frame = CGRectMake(0, DEVICE_HEIGHT-newSize.height-30, DEVICE_WIDTH, newSize.height+30);
      
        [self.view endEditing:true];
    }
}
-(void)StartSendingMessagetoDevice
{
    NSInteger totalPackets = [[BLEService sharedInstance] SendStartPacketofMessage:txtViewChat.text];
    [self SendMessageDataPacket:totalPackets];
    self->lblPlceholdChat.text = @"Message ";
    [self InsertMessagetoDatabase];
    
    viewBack.frame = CGRectMake(0, DEVICE_HEIGHT-60, DEVICE_WIDTH, 60);
    txtViewChat.frame = CGRectMake(10, 10,viewWidth-60, 40);
    
    [self.view endEditing:true];
    
              NSInteger sequenceInt = [globalSequence integerValue]; //Unique Sequence No
              NSData * sequencData = [[NSData alloc] initWithBytes:&sequenceInt length:4];
              NSString * strSqnc = [NSString stringWithFormat:@"%@",sequencData.debugDescription];
              strSqnc = [strSqnc stringByReplacingOccurrencesOfString:@" " withString:@""];
              strSqnc = [strSqnc stringByReplacingOccurrencesOfString:@"<" withString:@""];
              strSqnc = [strSqnc stringByReplacingOccurrencesOfString:@">" withString:@""];

              Message *message = [[Message alloc] init];
              message.text = txtViewChat.text;
              message.date = [NSDate date];
              message.sender = MessageSenderMyself;
              message.status = MessageStatusSent;
              message.sequences = [NSString stringWithFormat:@"%@",strSqnc];
              [self.tableArray addObject:message];
              txtViewChat.text = @"";
              [tblchat reloadData];
    
}
-(void)InsertMessagetoDatabase
{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithInteger: timeStamp];
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [DateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC+5:30"]];
    
    NSString * strDateAndTime = [NSString stringWithFormat:@"%@",[DateFormatter stringFromDate:[NSDate date]]];
    NSString * strTimeStamp = [NSString stringWithFormat:@"%@",timeStampObj];
    NSString * strIdentifier = [NSString stringWithFormat:@"%@",globalPeripheral.identifier] ;
    
//       NSInteger sequenceInt = [globalSequence integerValue]; //Unique Sequence No
//       NSData * sequencData = [[NSData alloc] initWithBytes:&sequenceInt length:4];
    
    NSMutableDictionary * dictChat  = [[NSMutableDictionary alloc] init];
     
     [dictChat setValue:txtViewChat.text forKey:@"msg_txt"];
     [dictChat setValue:strDateAndTime forKey:@"time"];
     [dictChat setValue:@"sent" forKey:@"status"];
     [dictChat setValue:strIdentifier forKey:@"identifier"];
     [dictChat setValue:strTimeStamp forKey:@"timeStamp"];
     [arrGlobalChatHistory addObject:dictChat];
    
    NSString * strFromName = @"Me";
    NSString * strToName =@"Other";
    NSString * strMSG = txtViewChat.text;
    NSString * strStatus = @"sent";
    NSString * strSequence = globalSequence;
    NSString * strIsGSM = [NSString stringWithFormat:@"%ld",isSentVia];

  

    NSString * strInsertQuery =  [NSString stringWithFormat:@"insert into 'NewChat' ('from_name','to_name','msg_txt','time','status','sequence','identifier','timeStamp','isGSM') values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",strFromName,strToName,strMSG,strDateAndTime,strStatus,strSequence,strIdentifier,strTimeStamp,strIsGSM];
    [[DataBaseManager dataBaseManager] executeSw:strInsertQuery];
    
}
-(void)SendMessageDataPacket:(NSInteger)totalPackets
{
    if (totalPackets == 1)
    {
        NSData* nsData = [txtViewChat.text dataUsingEncoding:NSUTF8StringEncoding];
        [[BLEService sharedInstance] sendMessageDataPacketToDevice:nsData paketNo:1 withPeripheral:globalPeripheral];
    }
    else
    {
        NSData* txtData = [txtViewChat.text dataUsingEncoding:NSUTF8StringEncoding];

        NSInteger totallength = txtData.length;
        NSString * strFullMsg = txtViewChat.text;
        for (int i = 0; i < totalPackets; i++)
        {
            
            if (totallength >= (i * 12) + 12)
            {
                NSData * strMsg = [txtData subdataWithRange:NSMakeRange(i * 12, 12)] ;
                [[BLEService sharedInstance] sendMessageDataPacketToDevice:strMsg paketNo: i + 1 withPeripheral:globalPeripheral];
                NSLog(@"Greater Than PocketLength 12======%@",strMsg);
            }
            else
            {
                if ((totallength >= (i * 12)))
                {
                    NSData * strMsg = [txtData subdataWithRange:NSMakeRange(i * 12, totallength - (i * 12))];
                    [[BLEService sharedInstance] sendMessageDataPacketToDevice:strMsg paketNo: i + 1 withPeripheral:globalPeripheral];
                    NSLog(@"Msg legth satisfied  12======%@",strMsg);
                }
            }
        }
    }
    [[BLEService sharedInstance] SendEndPacketofMessage:totalPackets withisGSM:isSentVia];
}
-(void)btnResendClick:(id)sender
{
    
}
-(void)btnGSMclick
{
    isSentVia = 1;
    [btnGSM setImage:[UIImage imageNamed:@"radiobuttonSelected.png"] forState:UIControlStateNormal];
    [btnIrridium setImage:[UIImage imageNamed:@"radiobuttonUnselected.png"] forState:UIControlStateNormal];
}
-(void)btnIrridumClick
{
    isSentVia = 2;
    [btnIrridium setImage:[UIImage imageNamed:@"radiobuttonSelected.png"] forState:UIControlStateNormal];
    [btnGSM setImage:[UIImage imageNamed:@"radiobuttonUnselected.png"] forState:UIControlStateNormal];

}
-(void)AlertPopUPCaution:(NSString *)strMessage
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeCaution];
    [alert showAlertInView:self
                 withTitle:@"SC2 Companion App"
              withSubtitle:strMessage
           withCustomImage:[UIImage imageNamed:@"logo.png"]
       withDoneButtonTitle:nil
                andButtons:nil];
}
#pragma mark - BLE Methods EVent
-(void)sendMessagetoDevice
{
//    if (isFreeText)
//    {
//        NSMutableArray * tmpArr = [[NSMutableArray alloc] init];
//        NSString * strQuery = [NSString stringWithFormat:@"select * from DiverMessage where Message = '%@'",lblChatText.text];
//        [[DataBaseManager dataBaseManager] execute:strQuery resultsArray:tmpArr];
//        if ([tmpArr count]>0)
//        {
//            isFreeText = NO;
//            msgIndex = [[tmpArr objectAtIndex:0] valueForKey:@"indexStr"];
//        }
//    }
    
    [self ShowPicker:false andView:viewMessage];
    
    NSInteger cmdInt = [@"05" integerValue]; //Command
    NSData * cmdData = [[NSData alloc] initWithBytes:&cmdInt length:1];

    NSInteger lengthInt = [@"06" integerValue]; //length of Message
    NSData * lengthData = [[NSData alloc] initWithBytes:&lengthInt length:1];

    NSInteger nanoInt = [sc4NanoId integerValue]; //Nano Modem ID
    NSData * nanoData = [[NSData alloc] initWithBytes:&nanoInt length:4];

    NSInteger opcodeInt = [@"01" integerValue]; //Opcode
    NSData * opcodeData = [[NSData alloc] initWithBytes:&opcodeInt length:1];

    NSInteger dataInt=  [msgIndex integerValue]; // Message data
    NSData * dataData = [[NSData alloc] initWithBytes:&dataInt length:1];
    
    NSInteger sequenceInt = [globalSequence integerValue]; //Unique Sequence No
    NSData * sequencData = [[NSData alloc] initWithBytes:&sequenceInt length:4];

    NSMutableData *completeData = [cmdData mutableCopy];
    [completeData appendData:lengthData];
    [completeData appendData:nanoData];
    [completeData appendData:opcodeData];
    [completeData appendData:dataData];
    [completeData appendData:sequencData];

//    [[BLEService sharedInstance] writeValuetoDevice:completeData with:globalPeripheral];
    NSLog(@"Sent Msg from Chat >>>%@",completeData);

    double dateStamp = [[NSDate date] timeIntervalSince1970];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString * timeStr =[dateFormatter stringFromDate:[NSDate date]];
    NSString * strSqnc = [NSString stringWithFormat:@"%@",sequencData.debugDescription];
    strSqnc = [strSqnc stringByReplacingOccurrencesOfString:@" " withString:@""];
    strSqnc = [strSqnc stringByReplacingOccurrencesOfString:@"<" withString:@""];
    strSqnc = [strSqnc stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSString * strNa = @"NA";

    NSString * strInsertCan = [NSString stringWithFormat:@"insert into 'tbl_Message' ('from','to','to_IMEI','msg_text','time','time_stamp','status','sequence','is_active') values ('%@','%@','%@','%@','%@','%f','%@','%@','%@')",@"Me",sc4NanoId,@"to imei",txtViewChat.text,timeStr,dateStamp,@"Sent",strSqnc,strNa];
    
    [[DataBaseManager dataBaseManager] execute:strInsertCan];
}
#pragma mark - View for Choosing Contacts
-(void)showMessageList
{
    [viewOverLay removeFromSuperview];
    viewOverLay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, DEVICE_HEIGHT)];
    [viewOverLay setBackgroundColor:[UIColor colorWithRed:97/255.0f green:97/255.0f blue:97/255.0f alpha:0.5]];
    viewOverLay.userInteractionEnabled = YES;
    [self.view addSubview:viewOverLay];
    
    backContactView = [[UIImageView alloc] init];
    backContactView.frame = CGRectMake(80, DEVICE_HEIGHT, viewWidth-160, 660);
    backContactView.image = [UIImage imageNamed:@"pop_up_bg.png"];
    backContactView.userInteractionEnabled = YES;
    [self.view addSubview:backContactView];
    
    UILabel * lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(0, 30, backContactView.frame.size.width, 50);
    lblTitle.font = [UIFont fontWithName:CGRegular size:textSize];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.text = @"Select Message";
    lblTitle.textAlignment = NSTextAlignmentCenter;
    [backContactView addSubview:lblTitle];
    
    UILabel * lblline = [[UILabel alloc] init];
    lblline.frame = CGRectMake(34, 30+49, backContactView.frame.size.width-68, 0.5);
    lblline.backgroundColor = [UIColor lightGrayColor];
    [backContactView addSubview:lblline];
    
    UIButton * btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(20, 30, 120, 50);
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    btnCancel.titleLabel.font = [UIFont fontWithName:CGRegular size:textSize-1];
    [btnCancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [backContactView addSubview:btnCancel];
    
    UIButton * btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.frame = CGRectMake(backContactView.frame.size.width-130, 30, 100, 50);
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    btnDone.titleLabel.font = [UIFont fontWithName:CGRegular size:textSize-1];
    [btnDone setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [btnDone addTarget:self action:@selector(btnDoneClick) forControlEvents:UIControlEventTouchUpInside];
    [backContactView addSubview:btnDone];
    
    tblMessages=[[UITableView alloc]init];
    tblMessages.delegate=self;
    tblMessages.dataSource=self;
    tblMessages.frame = CGRectMake(27, 80, backContactView.frame.size.width-54, backContactView.frame.size.height-60-60);
    tblMessages.backgroundColor=[UIColor blueColor];
    [tblMessages setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblMessages setSeparatorColor:[UIColor clearColor]];
//    [backContactView addSubview:tblMessages];
    
    if (IS_IPHONE)
    {
        backContactView.image = [UIImage imageNamed:@" "];
        backContactView.backgroundColor = [UIColor blackColor];
        backContactView.layer.cornerRadius = 10;
        backContactView.layer.borderWidth = 1.0;
        backContactView.layer.masksToBounds = YES;
//        backContactView.frame = CGRectMake(20, DEVICE_HEIGHT, viewWidth-40, DEVICE_HEIGHT-80);
        lblTitle.frame = CGRectMake(0, 0, backContactView.frame.size.width, 50);
        lblline.frame = CGRectMake(10, 49, backContactView.frame.size.width-20, 0.5);
        btnCancel.frame = CGRectMake(0, 0, 60, 50);
        btnDone.frame = CGRectMake(backContactView.frame.size.width-60, 0, 60, 50);
        tblMessages.frame = CGRectMake(0, 50, backContactView.frame.size.width-0, DEVICE_HEIGHT-80-50);
        
        if (IS_IPHONE_5 || IS_IPHONE_4)
        {
            backContactView.frame = CGRectMake(10, DEVICE_HEIGHT, viewWidth-20, DEVICE_HEIGHT-80);
            tblMessages.frame = CGRectMake(0, 50, backContactView.frame.size.width-0, DEVICE_HEIGHT-80-50);
        }
    }
    [self hideMorePopUpView:NO];
}
-(void)hideMorePopUpView:(BOOL)isHide
{
    if (isHide == YES)
    {
        [UIView animateWithDuration:0.4 delay:0.0 options: UIViewAnimationOptionOverrideInheritedCurve animations:^{
            if (IS_IPHONE)
            {
                if (IS_IPHONE_5 || IS_IPHONE_4)
                {
                   self-> backContactView.frame = CGRectMake(10, DEVICE_HEIGHT, self->viewWidth-20, DEVICE_WIDTH-80);
                }
                else
                    {
                        self->backContactView.frame = CGRectMake(20, DEVICE_HEIGHT, self->viewWidth-40, DEVICE_WIDTH-80);
                    }
                }
                else
                {
                    self->backContactView.frame = CGRectMake(80, DEVICE_HEIGHT, self->viewWidth-160, 660);
                }
              }
            completion:^(BOOL finished)
        {
            [self->viewOverLay removeFromSuperview];
            [self->backContactView removeFromSuperview];
            [self->tblMessages removeFromSuperview];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 delay:0.0   options: UIViewAnimationOptionOverrideInheritedCurve animations:^{
            if (IS_IPHONE)
            {
                if (IS_IPHONE_5 || IS_IPHONE_4)
                {
                    self->backContactView.frame = CGRectMake(10, 40, self->viewWidth-20, DEVICE_HEIGHT-80);
                }
                else
                {
                    self->backContactView.frame = CGRectMake(20, 40, self->viewWidth-40, DEVICE_HEIGHT-80);
                }
            }
            else
            {
                self->backContactView.frame = CGRectMake(80, 54, self->viewWidth-160, 660);
            }
            }
                 completion:^(BOOL finished)
         {
        }];
    }
}
#pragma mark - Animations
-(void)ShowPicker:(BOOL)isShow andView:(UIView *)myView
{
    if (isShow == YES)
    {
        [UIView transitionWithView:myView duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            if (myView == self->viewMessage)
            {
                self->viewMessage.frame = CGRectMake(0,DEVICE_HEIGHT-self->intkeyboardHeight-self->bottomHeight, self->viewWidth-0, 80);

                NSLog(@"hhh is %f",DEVICE_HEIGHT-self->intkeyboardHeight);
                }
            if (myView == self->tblchat)
            {
                self->tblchat.frame = CGRectMake(0, self->xx, self->viewWidth, DEVICE_HEIGHT-self->xx-self->bottomHeight-self->intkeyboardHeight);
//                                tblchat.backgroundColor = UIColor.redColor;
                            }
                        }
                        completion:^(BOOL finished)
         {
         }];
    }
    else
    {
        [UIView transitionWithView:myView duration:0.2
                           options:UIViewAnimationOptionCurveEaseOut
                        animations:^{
                            
            if (myView == self->viewMessage)
            {
                self->viewMessage.frame = CGRectMake(0,DEVICE_HEIGHT-self->bottomHeight, self->viewWidth-0, 80);
            }
            }
                        completion:^(BOOL finished)
         {
         }];
    }
}
- (void)keyboardWasShown:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Given size may not account for screen rotation
    intkeyboardHeight = MIN(keyboardSize.height,keyboardSize.width);
    //    int width = MAX(keyboardSize.height,keyboardSize.width);
    //your other code here..........
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString*)hexFromStr:(NSString*)str
{
    NSData* nsData = [str dataUsingEncoding:NSUTF8StringEncoding];
    const char* data = [nsData bytes];
    NSUInteger len = nsData.length;
    NSMutableString* hex = [NSMutableString string];
    for(int i = 0; i < len; ++i)
        [hex appendFormat:@"%02X", data[i]];
    return hex;
}
- (NSData *)dataFromHexString:(NSString*)hexStr
{
    const char *chars = [hexStr UTF8String];
    NSInteger i = 0, len = hexStr.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    return data;
}
-(void)GotMessageSendAck:(NSString *)strStatus;
{
    if ([strStatus isEqualToString:@"010130"])
    {
        FCAlertView *alert = [[FCAlertView alloc] init];
        alert.colorScheme = [UIColor blackColor];
        [alert makeAlertTypeSuccess];
        [alert showAlertInView:self
                     withTitle:@"SC2 Companion App"
                  withSubtitle:@"Message has been sent successfully."
               withCustomImage:[UIImage imageNamed:@"logo.png"]
           withDoneButtonTitle:nil
                    andButtons:nil];
    }
    else
    {
        FCAlertView *alert = [[FCAlertView alloc] init];
        alert.colorScheme = [UIColor blackColor];
        [alert makeAlertTypeWarning];
        [alert showAlertInView:self
                     withTitle:@"SC2 Companion App"
                  withSubtitle:@"Something went wrong. Please try again."
               withCustomImage:[UIImage imageNamed:@"logo.png"]
           withDoneButtonTitle:nil
                    andButtons:nil];
    }
}
-(void)GotSentMessageAcknowledgement:(NSString *)strSeqence withStatus:(NSString *)strStatus
{
    for (int i =0; i<[self.tableArray numberOfSections]; i++)
    {
        for (int k = 0; k < [self.tableArray numberOfMessagesInSection:i]; k++)
        {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:k inSection:i];
            Message * message = [[Message alloc] init];
            message = [self.tableArray objectAtIndexPath:indexPath];
            
//            NSLog(@"Sent Sqnc=%@ ArrSeqn=%@",strSeqence,message.sequences);
            if ([message.sequences isEqualToString:strSeqence])
            {
                if ([strStatus isEqualToString:@"ff"])
                {
                    [[self.tableArray objectAtIndexPath:indexPath] setStatus:MessageStatusRead];
                }
                else if([strStatus isEqualToString:@"01"])
                {
                    [[self.tableArray objectAtIndexPath:indexPath] setStatus:MessageStatusReceived];
                }
                else if([strStatus isEqualToString:@"00"] || [strStatus isEqualToString:@"fe"])
                {
                    [[self.tableArray objectAtIndexPath:indexPath] setStatus:MessageStatusFailed];
                    NSString * strUser = @"User";
                    if (![[self checkforValidString:userName] isEqualToString:@"NA"])
                    {
                        strUser = userName;
                    }
                    NSString * strMsg = [NSString stringWithFormat:@"%@ did not recieve message : %@. Please try again later.",strUser,message.text];
                    FCAlertView *alert = [[FCAlertView alloc] init];
                    alert.colorScheme = [UIColor blackColor];
                    [alert makeAlertTypeWarning];
                    [alert showAlertInView:self
                                 withTitle:@"Message Sent Failed"
                              withSubtitle:strMsg
                           withCustomImage:[UIImage imageNamed:@"logo.png"]
                       withDoneButtonTitle:nil
                                andButtons:nil];
                }
                break;
            }
        }
    }
    [tblchat reloadData];
}
-(NSString *)GetUniqueNanoModemId
{
    NSTimeInterval timeInSeconds = [[NSDate date] timeIntervalSince1970];
    NSString * strTime = [NSString stringWithFormat:@"%f",timeInSeconds];
    strTime = [strTime stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString * strData ;
    if ([strTime length]>=16)
    {
        strTime = [strTime substringWithRange:NSMakeRange([strTime length]-8, 8)];
        int intVal = [strTime intValue];
        NSData * lineLightNanoData = [[NSData alloc] initWithBytes:&intVal length:4];
        strData = [NSString stringWithFormat:@"%@",lineLightNanoData.debugDescription];
        strData = [strTime stringByReplacingOccurrencesOfString:@" " withString:@""];
        strData = [strTime stringByReplacingOccurrencesOfString:@"<" withString:@""];
        strData = [strTime stringByReplacingOccurrencesOfString:@">" withString:@""];
        
        NSLog(@"got starData=%@",strData);
        
        if([[strData substringWithRange:NSMakeRange(0,2)] isEqualToString:@"00"])
        {
            strTime = [NSString stringWithFormat:@"88%@",[strTime substringWithRange:NSMakeRange(2,6)]];
        }
        else if([[strData substringWithRange:NSMakeRange(6,2)] isEqualToString:@"00"])
        {
            strTime = [NSString stringWithFormat:@"%@99",[strTime substringWithRange:NSMakeRange(0,6)]];
        }
    }
    return strTime;
}

//-(void)setDummyDataforTable
//{
//    self.tableArray = [[TableArray alloc] init];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//
//    //    NSDate * dateInstalled = [dateFormatter dateFromString:@"2018-12-12 11:09:04"];
//    NSDate *today = [NSDate date];
//    NSData * yDate  = [today dateByAddingTimeInterval: -86400.0];
//
//    Message *message = [[Message alloc] init];
//    message.text = @"Go";
//    message.date = yDate;
//    message.chat_id =@"1";
//    message.sender = MessageSenderMyself;
//    message.status = MessageStatusReceived;
//    [self.tableArray addObject:message];
//
//    Message *message1 = [[Message alloc] init];
//    message1.text = @"Ok";
//    message1.date = yDate;
//    message1.chat_id =@"1";
//    message1.sender = MessageSenderSomeone;
//    [self.tableArray addObject:message1];
//
//    Message *message2 = [[Message alloc] init];
//    message2.text = @"Low Air";
//    message2.date = yDate;
//    message2.chat_id =@"1";
//    message2.sender = MessageSenderSomeone;
//    [self.tableArray addObject:message2];
//
//    Message *message3 = [[Message alloc] init];
//    message3.text = @"Stop";
//    message3.date = yDate;
//    message3.chat_id =@"1";
//    message3.sender = MessageSenderMyself;
//    message3.status = MessageStatusReceived;
//    [self.tableArray addObject:message3];
//
//    Message *message4 = [[Message alloc] init];
//    message4.text = @"Complete";
//    message4.date = yDate;
//    message4.chat_id =@"1";
//    message4.sender = MessageSenderSomeone;
//    [self.tableArray addObject:message4];
//
//    Message *message5 = [[Message alloc] init];
//    message5.text = @"Training Complete";
//    message5.date = yDate;
//    message5.chat_id =@"1";
//    message5.sender = MessageSenderMyself;
//    message5.status = MessageStatusReceived;
//    [self.tableArray addObject:message5];
//
//    Message *message6 = [[Message alloc] init];
//    message6.text = @"Training Complete";
//    message6.date = yDate;
//    message6.chat_id =@"1";
//    message6.sender = MessageSenderSomeone;
//    [self.tableArray addObject:message6];
//
//
//    //Store Message in memory
//}
-(void)MessageReceivedFromDevice:(NSMutableDictionary *)dictMessage
{
    NSLog(@"Message%@",dictMessage);
    
    NSInteger totalPackets = [[dictMessage valueForKey:@"totoalPacket"] integerValue];
    NSMutableString * newString = [[NSMutableString alloc] init];

    for (int i = 0; i < totalPackets - 2; i++)
    {
        NSString * strPacketKey = [NSString stringWithFormat:@"%d",i+1];
        NSMutableDictionary * dictPacket = [dictMessage objectForKey:strPacketKey];
        
        if (![[self checkforValidString:[dictPacket valueForKey:@"receivedData"]] isEqualToString:@"NA"])
        {
            NSString * strMsg = [dictPacket valueForKey:@"receivedData"];
            int indexs = 0;
            while (indexs < [strMsg length])
            {
                NSString * hexChar = [strMsg substringWithRange: NSMakeRange(indexs, 2)];
                int value = 0;
                sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
                [newString appendFormat:@"%c", (char)value];
                indexs+=2;
            }
        }
    }
    
    NSString * strTotolPacket = [self stringFroHex:[dictMessage valueForKey:@"totoalPacket"]];
    NSString * strtimeStamp = [self stringFroHex:[dictMessage valueForKey:@"timestamp"]];
    NSString * strSequence = [self stringFroHex:[dictMessage valueForKey:@"sequence"]];
    NSString * strPacketLength = [self stringFroHex:[dictMessage valueForKey:@"packetLength"]];
    NSString * strPacketNo = [self stringFroHex:[dictMessage valueForKey:@"packetNo"]];
    
    NSString * strFromName = @"Other";
    NSString * strToName = @"Me";
    NSString * strStatus = @"Received";
    
    
   NSString * strInsertQuery =  [NSString stringWithFormat:@"insert into 'NewChat' ('from_name','to_name','msg_txt','status','sequence','timeStamp') values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",strFromName,strToName,newString,strStatus,strSequence,strtimeStamp];
   [[DataBaseManager dataBaseManager] executeSw:strInsertQuery];

    NSLog(@"NewString =====>>>>%@",newString);
    NSLog(@"Message stringFromHex =====>>>>%@ \n===timestamp %@ \n=======Sequence %@ \n =======PacketLentgth %@\n  =======PacketNumber %@\n",strTotolPacket,strtimeStamp,strSequence,strPacketLength,strPacketNo);
}
-(NSString*)stringFroHex:(NSString *)hexStr
{
    unsigned long long startlong;
    NSScanner* scanner1 = [NSScanner scannerWithString:hexStr];
    [scanner1 scanHexLongLong:&startlong];
    double unixStart = startlong;
    NSNumber * startNumber = [[NSNumber alloc] initWithDouble:unixStart];
    return [startNumber stringValue];
}

@end


/*
 2020-02-28 18:06:07.422 Combat Diver[1211:302999] didUpdateValueForCharacteristic==<050b0469 301e0109 0c165c02 32>
 2020-02-28 18:06:07.423 Combat Diver[1211:302999] ----->>>>>>>Sequence No---->0c165c02
 2020-02-28 18:06:12.030 Combat Diver[1211:302999] didUpdateValueForCharacteristic==<050b0469 301e0109 71d7ad01 32>
 2020-02-28 18:06:12.031 Combat Diver[1211:302999] ----->>>>>>>Sequence No---->71d7ad01
 2020-02-28 18:06:16.004 Combat Diver[1211:302999] didUpdateValueForCharacteristic==<050b0469 301e0106 df5b6500 32>
 2020-02-28 18:06:16.006 Combat Diver[1211:302999] ----->>>>>>>Sequence No---->df5b6500
 2020-02-28 18:06:20.198 Combat Diver[1211:302999] didUpdateValueForCharacteristic==<050b0469 301e0107 a9391d00 32>
 2020-02-28 18:06:20.199 Combat Diver[1211:302999] ----->>>>>>>Sequence No---->a9391d00
 2020-02-28 18:06:24.218 Combat Diver[1211:302999] didUpdateValueForCharacteristic==<050b0469 301e0109 03cf9a05 32>
 2020-02-28 18:06:24.219 Combat Diver[1211:302999] ----->>>>>>>Sequence No---->03cf9a05
 2020-02-28 18:06:28.328 Combat Diver[1211:302999] didUpdateValueForCharacteristic==<050b0469 301e0106 effdb403 32>
 2020-02-28 18:06:28.329 Combat Diver[1211:302999] ----->>>>>>>Sequence No---->effdb403
 2020-02-28 18:06:32.348 Combat Diver[1211:302999] didUpdateValueForCharacteristic==<050b0469 301e0106 c7886302 32>
 2020-02-28 18:06:32.349 Combat Diver[1211:302999] ----->>>>>>>Sequence No---->c7886302
 2020-02-28 18:06:36.428 Combat Diver[1211:302999] didUpdateValueForCharacteristic==<050b0469 301e0102 b4d3d703 32>
 2020-02-28 18:06:36.429 Combat Diver[1211:302999] ----->>>>>>>Sequence No---->b4d3d703
 2020-02-28 18:06:50.288 Combat Diver[1211:302999] didUpdateValueForCharacteristic==<05060000 00000864>
 
 */
