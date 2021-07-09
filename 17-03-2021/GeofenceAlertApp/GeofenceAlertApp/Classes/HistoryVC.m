//
//  HistoryVC.m
//  GeofenceAlertApp
//
//  Created by Ashwin on 7/22/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import "HistoryVC.h"
#import "GeofencencAlertCell.h"
#import "ViewController.h"
#import "PolygonGeofenceVC.h"
#import "RadialGeofenceVC.h"
#import "RadialGeofenceVC.h"

@interface HistoryVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HistoryVC
{
    
}
- (void)viewDidLoad
{
    [self setNavigationViewFrames];
    arrGeofence = [[NSMutableArray alloc]init];
    NSString * str = [NSString stringWithFormat:@"Select * from Geofence_alert_Table order by timeStamp DESC"];
    [[DataBaseManager dataBaseManager] execute:str resultsArray:arrGeofence];
    

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [APP_DELEGATE hideTabBar:self.tabBarController];
    [super viewWillAppear:YES];
    [tblHistoryList reloadData];

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
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, globalStatusHeight, DEVICE_WIDTH, yy)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"Geofence Breaches"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGRegular size:textSize+2]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
    UIImageView * imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(10,globalStatusHeight+11, 14, 22)];
    imgBack.image = [UIImage imageNamed:@"back_icon.png"];
    imgBack.backgroundColor = UIColor.clearColor;
    [viewHeader addSubview:imgBack];
    
    UIButton * btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(5, 0, 80, yy+globalStatusHeight)];
    [btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnBack];
    
    UIButton * btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRefresh setFrame:CGRectMake(DEVICE_WIDTH-80, globalStatusHeight, 80, 44)];
    btnRefresh.backgroundColor = UIColor.clearColor;
//    [btnRefresh setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateNormal];
    [btnRefresh setTitle:@"Refresh" forState:UIControlStateNormal];
    [btnRefresh setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    btnRefresh.titleLabel.font = [UIFont fontWithName:CGRegular size:textSize-1];
    [btnRefresh addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnRefresh];
    
    tblHistoryList = [[UITableView alloc] initWithFrame:CGRectMake(0, yy+globalStatusHeight, DEVICE_WIDTH, DEVICE_HEIGHT-yy-globalStatusHeight)];
    tblHistoryList.delegate = self;
    tblHistoryList.dataSource= self;
    tblHistoryList.backgroundColor = UIColor.clearColor;
    tblHistoryList.separatorStyle = UITableViewCellSelectionStyleNone;
    tblHistoryList.hidden = false;
    [self.view addSubview:tblHistoryList];
    
}
#pragma mark- UITableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  arrGeofence.count; // array have to pass
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellReuseIdentifier = @"cellIdentifier";
        GeofencencAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
        if (cell == nil)
        {
            cell = [[GeofencencAlertCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
        }
    cell.lblDate.text = [[arrGeofence objectAtIndex:indexPath.row] valueForKey:@"date_Time"]; //@"date";  date and time
    cell.lblStateOfVoi.text = [[[arrGeofence objectAtIndex:indexPath.row] valueForKey:@"Rule_Name"] uppercaseString]; //@"voilate"
    NSString * strName = [self checkforValidString:[[arrGeofence objectAtIndex:indexPath.row] valueForKey:@"Geo_name"]];
    if ([strName isEqualToString:@"NA"])
    {
        strName = [self checkforValidString:[self stringFroHex:[[arrGeofence objectAtIndex:indexPath.row] valueForKey:@"geofence_ID"]]];
        if ([strName isEqualToString:@"NA"])
        {
            strName = [[arrGeofence objectAtIndex:indexPath.row] valueForKey:@"geofence"];
        }
    }
    if([[self checkforValidString:[[arrGeofence objectAtIndex:indexPath.row] valueForKey:@"Message"]] isEqualToString:@"NA"])
    {
        
    }
    else
    {
        cell.lblNote.text = [[arrGeofence objectAtIndex:indexPath.row] valueForKey:@"Message"]; //@"note"
    }
    cell.lblGeoFncID.text = [NSString stringWithFormat:@"Geofence ID : %@",strName] ; //@"geofence id"
//isViewed
    if ([[[arrGeofence objectAtIndex:indexPath.row] valueForKey:@"isViewed"] isEqualToString:@"1"])
    {
        cell.lblWhiteDot.hidden = YES;
    }
    else
    {
        cell.lblWhiteDot.hidden = NO;
    }
 
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrGeofence.count > 0)
    {
        if ([[[arrGeofence objectAtIndex:indexPath.row] valueForKey:@"isViewed"] isEqualToString:@"0"])
        {
            if (globalBadgeCount > 0)
            {
                globalBadgeCount = globalBadgeCount - 1;
                [UIApplication sharedApplication].applicationIconBadgeNumber = globalBadgeCount;
            }
            else
            {
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            }
            
            [[arrGeofence objectAtIndex:indexPath.row] setObject:@"1" forKey:@"isViewed"];
        }
        
         if ([[[arrGeofence objectAtIndex:indexPath.row] valueForKey:@"Geo_Type"] isEqualToString:@"00"])
           {
               RadialGeofenceVC *view1 = [[RadialGeofenceVC alloc]init];
               view1.isfromEdit = YES;
               view1.isfromHistory = YES;
               view1.dictGeofenceInfo = [arrGeofence objectAtIndex:indexPath.row];
               [self.navigationController pushViewController:view1 animated:true];
           }
           else
           {
               PolygonGeofenceVC *view1 = [[PolygonGeofenceVC alloc]init];
               view1.isfromEdit = YES;
               view1.isfromHistory = YES;
               view1.dictGeofenceInfo = [arrGeofence objectAtIndex:indexPath.row];
               [self.navigationController pushViewController:view1 animated:true];
           }
    }
}
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)refreshBtnClick
{
    [self TostNotification:@"History Refreshed..."];
    arrGeofence = [[NSMutableArray alloc]init];
    NSString * str = [NSString stringWithFormat:@"Select * from Geofence_alert_Table order by timeStamp DESC"];
    [[DataBaseManager dataBaseManager] execute:str resultsArray:arrGeofence];
    [tblHistoryList reloadData];
   
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
-(void)TostNotification:(NSString *)StrToast
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = StrToast;
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.9];
}
@end

