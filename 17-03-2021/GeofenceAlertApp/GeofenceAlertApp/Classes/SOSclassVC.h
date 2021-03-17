//
//  SOSclassVC.h
//  GeofenceAlertApp
//
//  Created by Vithamas Technologies on 26/12/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SOSclassVC : UIViewController
{
    UITableView *tblchat;
    int viewWidth;
    UITableView * tblMessages;
    UIView * viewOverLay, * viewMore,*viewBack;
    int headerhHeight, bottomHeight;
    NSMutableArray * arrMessages;
    NSString * msgIndex, * msgTxt;
    UITextField * txtChat;
    UIImageView * backContactView;
    UIView * viewMessage;
    int xx,intkeyboardHeight;
}
@property (nonatomic , strong)NSString * userNano;
@property (nonatomic , strong)NSString * userName;
@property (nonatomic , strong)NSString * isFrom;
@property (nonatomic , strong)NSString * sc4NanoId;
@property (strong, nonatomic) TableArray *tableArray;
-(void)GotMessagefromDiver:(NSMutableDictionary *)strDict;
-(void)GotMessageSendAck:(NSString *)strStatus;
-(void)GotSentMessageAcknowledgement:(NSString *)strSeqence withStatus:(NSString *)strStatus;
-(void)MessageReceivedFromDevice:(NSMutableDictionary *)dictMessage;

@end

NS_ASSUME_NONNULL_END
