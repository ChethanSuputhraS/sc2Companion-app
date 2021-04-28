//
//  SOSclassVC.m
//  GeofenceAlertApp
//
//  Created by Vithamas Technologies on 26/12/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import "SOSclassVC.h"
#import "MessageCell.h"
#import "LeftMenuCell.h"
#import "FCAlertView.h"
#import "HomeCell.h"

@interface SOSclassVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    UILabel * lblChatText;
    NSString * strMSg;
    UILabel * lblPlceholdChat;
    UIImageView * imgSend;
    UITextView *txtViewChat;
    CGSize newSize;
    UIView * viewPredfnMSgback,*viewPreDfnTblview;
    UITableView * tblPreDfnMsg;
    NSMutableArray * arrPreDfnmsg;
    UIButton * btnPredfnMsg;
}
@end

@implementation SOSclassVC

- (void)viewDidLoad
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    self.navigationController.navigationBarHidden = YES;
//
    UIImageView * imgBack = [[UIImageView alloc] init];
    imgBack.frame = CGRectMake(0, 0, viewWidth, DEVICE_HEIGHT);
    imgBack.image = [UIImage imageNamed:@"Splash_bg.png"];
    [self.view addSubview:imgBack];

    arrPreDfnmsg = [[NSMutableArray alloc] initWithObjects:@"Help...!",@"Call me",@"Location",@"Find me ?",@"Connect support", nil];
  
    
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
    

    UIImageView * imgDelete = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-40, 20+(headerhHeight-20-21)/2, 20, 21)];
    [imgDelete setImage:[UIImage imageNamed:@"delete.png"]];
    [imgDelete setContentMode:UIViewContentModeScaleAspectFit];
    imgDelete.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:imgDelete];

    
    [self setNavigationViewFrames];
    [self setupMainContentView:headerhHeight];

    if (IS_IPHONE_X)
    {
        viewHeader.frame = CGRectMake(0, 0, DEVICE_WIDTH, 88);
        lblTitle.frame = CGRectMake(0, 40, DEVICE_WIDTH, 44);
//        backImg.frame = CGRectMake(10, 12+44, 12, 20);
        imgDelete.frame = CGRectMake(viewWidth-40, 12+44, 20, 21);
    }
    


    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [APP_DELEGATE hideTabBar:self.tabBarController];
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
#pragma mark - Set Frames
-(void)setNavigationViewFrames
{
    int yy = 44;
    if (IS_IPHONE_X)
    {
        yy = 44;
    }

    UIImageView * imgLogo = [[UIImageView alloc] init];
    imgLogo.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    imgLogo.image = [UIImage imageNamed:@"Splash_bg.png"];
    imgLogo.userInteractionEnabled = YES;
    [self.view addSubview:imgLogo];
    
    UIView * viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, yy + globalStatusHeight)];
    [viewHeader setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:viewHeader];
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, globalStatusHeight, DEVICE_WIDTH-100, yy)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"SOS  Messages"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGRegular size:textSize+2]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
     UIButton * btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
     [btnBack setFrame:CGRectMake(10, 20, 60, yy)];
     [btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
     [btnBack setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
     btnBack.backgroundColor = UIColor.clearColor;
     btnBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
     [viewHeader addSubview:btnBack];
    


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

    tblchat=[[UITableView alloc]initWithFrame:CGRectMake(0, headerHeights, viewWidth, DEVICE_HEIGHT-headerHeights)];
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
//        [self.view addSubview:txtViewChat];
        [viewBack addSubview:txtViewChat];
    
    lblPlceholdChat = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, txtViewChat.frame.size.width, 20)];
    lblPlceholdChat.textColor = UIColor.whiteColor;
    lblPlceholdChat.text = @"Type a message ";
    lblPlceholdChat.font = [UIFont fontWithName:@"Helvetica Neue" size:textSize];
    [txtViewChat addSubview:lblPlceholdChat];

//    [txtChat setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    btnPredfnMsg = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPredfnMsg.frame = CGRectMake(txtViewChat.frame.size.width-60, 0, 60, 40);
    btnPredfnMsg.backgroundColor = UIColor.clearColor;
    [btnPredfnMsg setImage:[UIImage imageNamed:@"messsage_icon"] forState:UIControlStateNormal];
    [btnPredfnMsg addTarget:self action:@selector(btnPreDefineClick) forControlEvents:UIControlEventTouchUpInside];
    [txtViewChat addSubview:btnPredfnMsg];
    
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
#pragma mark- textview methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGFloat fixedWidth = txtViewChat.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAX_INPUT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height+5);
    textView.frame = newFrame;
    
    viewBack.frame = CGRectMake(0, DEVICE_HEIGHT-newSize.height-245, DEVICE_WIDTH, newSize.height+30);
//    tblchat.frame = CGRectMake(0, DEVICE_HEIGHT-newSize.height-60, DEVICE_WIDTH, newSize.height+30);

    if (IS_IPHONE_5)
    {
            viewBack.frame = CGRectMake(0, DEVICE_HEIGHT-newSize.height-245, DEVICE_WIDTH, newSize.height+30);
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if  ([textView.text isEqual:@""])
        {
            lblPlceholdChat.text = @"Type a message ";
        }
        else if ([textView.text isEqual:textView.text])
        {
            lblPlceholdChat.text = @"";
        }

     viewMessage.frame = CGRectMake(0, DEVICE_HEIGHT-bottomHeight-220, viewWidth-0, 60);
     tblchat.frame = CGRectMake(0, headerhHeight, viewWidth, DEVICE_HEIGHT-headerhHeight);

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
        
        if (textView.text.length == 0)
        {
            lblPlceholdChat.hidden = NO;
            btnPredfnMsg.hidden = false;
        }
        else
        {
            lblPlceholdChat.hidden = YES;
            btnPredfnMsg.hidden = true;

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
    tblchat.frame = CGRectMake(0, headerhHeight, viewWidth, DEVICE_HEIGHT-headerhHeight);
    [self.view endEditing:true];
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
- (void)keyboardWasShown:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    intkeyboardHeight = MIN(keyboardSize.height,keyboardSize.width);
}
#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == tblchat)
    {
        return [self.tableArray numberOfSections];
    }
    else
    {
        return 1;
    }

    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tblchat)
    {
        return [self.tableArray numberOfMessagesInSection:section]; // return [arrMessages count];//
    }
    else if (tableView == tblPreDfnMsg)
    {
        return arrPreDfnmsg.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";

    if (tableView == tblPreDfnMsg)
    {
        static NSString *CellIdentifierHome = @"Homecell";
        HomeCell *cellH = [tableView dequeueReusableCellWithIdentifier:CellIdentifierHome];
        if (!cellH)
        {
            cellH = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierHome];
        }
        
        cellH.lblBack.hidden = true;
        cellH.optionView.hidden = true;
        cellH.lblDeviceName.textColor = UIColor.blackColor;
        cellH.lblAddress.hidden = true;
        
        cellH.lblDeviceName.frame = CGRectMake(10, 0, DEVICE_WIDTH/2-20, 50);
        cellH.lblDeviceName.text = [arrPreDfnmsg objectAtIndex:indexPath.row];
        
        return cellH;
    }
    else if (tableView == tblchat)
    {
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
            cell.message = [self.tableArray objectAtIndexPath:indexPath];
            
            cell.resendButton.tag = indexPath.row;
        //    [cell.resendButton addTarget:self action:@selector(btnResendClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg.png"]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblPreDfnMsg)
    {
        txtViewChat.text = [arrPreDfnmsg objectAtIndex:indexPath.row];
        lblPlceholdChat.text = @"";
        
        [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^
         {
        self-> viewPreDfnTblview.frame = CGRectMake(20, DEVICE_HEIGHT, DEVICE_WIDTH-40, DEVICE_HEIGHT-120);
         }
            completion:(^(BOOL finished)
          {
            [self-> viewPredfnMSgback removeFromSuperview];
        })];
    }
    
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == tblchat)
    {
        Message *message = [self.tableArray objectAtIndexPath:indexPath];
        return message.heigh;
    }
    else
    {
        return 50;
    }
  
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == tblchat)
    {
        return 40.0;
    }
    else
    {
        return 25;
    }
    return 40.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == tblchat)
    {
        return [self.tableArray titleForSection:section];
    }
    
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 25);
   
    NSString * strheaderTitle = @"Select message to send";
    
    if (tableView == tblchat)
    {
        frame = CGRectMake(0, 0, tableView.frame.size.width, 40);
        strheaderTitle = [self tableView:tableView titleForHeaderInSection:section];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    UILabel *label = [[UILabel alloc] init];
    label.text = strheaderTitle;
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

        viewBack.frame = CGRectMake(0, DEVICE_HEIGHT-60, DEVICE_WIDTH, 60);
        txtViewChat.frame = CGRectMake(10, 10,viewWidth-60, 40);
        
        
        Message *message = [[Message alloc] init];
        message.text = txtViewChat.text;
        message.date = [NSDate date];
        message.sender = MessageSenderMyself;
        message.status = MessageStatusSent;
//        message.sequences = [NSString stringWithFormat:@"%@",strSqnc];
        [self.tableArray addObject:message];
        txtViewChat.text = @"";
        lblPlceholdChat.text = @"Type a message";
        [tblchat reloadData];
        
        [self.view endEditing:true];
    }
}
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)btnPreDefineClick
{
    [self SetupForPredefineMessaes];
}
-(void)btnCancelClick
{
    [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
    self-> viewPreDfnTblview.frame = CGRectMake(20, DEVICE_HEIGHT, DEVICE_WIDTH-40, DEVICE_HEIGHT-120);
     }
        completion:(^(BOOL finished)
      {
        [self-> viewPredfnMSgback removeFromSuperview];
    })];
}
-(void)SetupForPredefineMessaes
{
   [viewPredfnMSgback removeFromSuperview];
    viewPredfnMSgback = [[UIView alloc] init];
    viewPredfnMSgback.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    viewPredfnMSgback .backgroundColor = UIColor.blackColor;
    viewPredfnMSgback.alpha = 0.5;
    [self.view addSubview:viewPredfnMSgback];
    
    UIImageView * imgBack = [[UIImageView alloc] init];
    imgBack.contentMode = UIViewContentModeScaleAspectFit;
    imgBack.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    imgBack.image = [UIImage imageNamed:[[NSUserDefaults standardUserDefaults]valueForKey:@"globalBackGroundImage"]];
    imgBack.userInteractionEnabled = YES;
//        [self->viewSSIDback addSubview:imgBack];
    
    viewPreDfnTblview = [[UIView alloc] initWithFrame:CGRectMake(20, DEVICE_HEIGHT, DEVICE_WIDTH-40, DEVICE_HEIGHT-120)];
    viewPreDfnTblview.backgroundColor = UIColor.whiteColor;//[UIColor colorWithRed:1 green:1 blue:1 alpha:1]; // white
    viewPreDfnTblview.layer.cornerRadius = 6;
    viewPreDfnTblview.alpha = 1;
    viewPreDfnTblview.clipsToBounds = true;
   [self.view addSubview:viewPreDfnTblview];

    tblPreDfnMsg = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, viewPreDfnTblview.frame.size.width-10, viewPreDfnTblview.frame.size.height-50)];
    tblPreDfnMsg.backgroundColor = UIColor.clearColor;
    tblPreDfnMsg.delegate = self;
    tblPreDfnMsg.dataSource = self;
    [viewPreDfnTblview addSubview:tblPreDfnMsg];

    UIButton *  btnCancel = [[UIButton alloc]init];
    btnCancel.frame = CGRectMake(5, viewPreDfnTblview.frame.size.height-50, viewPreDfnTblview.frame.size.width-10, 45);
    [btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    btnCancel.backgroundColor = UIColor.blackColor;
    [btnCancel setTitle:@"Cancel" forState:normal];
    [btnCancel setTitleColor:UIColor.whiteColor forState:normal];
    btnCancel.titleLabel.font = [UIFont fontWithName:CGBold size:textSize+2];
    btnCancel.titleLabel.textAlignment = NSTextAlignmentCenter;
    [viewPreDfnTblview addSubview:btnCancel];

    [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^
    {
        self->viewPreDfnTblview.frame = CGRectMake(20, (DEVICE_HEIGHT-(DEVICE_HEIGHT-120))/2, DEVICE_WIDTH-40, DEVICE_HEIGHT-120);
    }
        completion:NULL];
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
@end
