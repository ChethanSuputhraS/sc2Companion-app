//
//  RemotNavigationVC.m
//  GeofenceAlertApp
//
//  Created by Vithamas Technologies on 26/12/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.


#import "RemotNavigationVC.h"
#import "GeofencencAlertCell.h"
#import "SSSearchBar.h"
#import "URLManager.h"
#import "RemotNavigMapVC.h"


@interface RemotNavigationVC ()<UITableViewDelegate,UITableViewDataSource,URLManagerDelegate,SSSearchBarDelegate>
{
    UITableView * tblDeviceList;
    NSMutableArray * arryDeviceList,*arrSearchedResults;
    SSSearchBar * searchBarIMEi;
    BOOL  isSearching;
    UILabel * lblNoDevice;
    
}
@end

@implementation RemotNavigationVC

- (void)viewDidLoad
{
    arryDeviceList = [[NSMutableArray alloc] init];
    
    [self setNavigationViewFrames];

    [APP_DELEGATE startHudProcess:@"Getting devices..."];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([APP_DELEGATE isNetworkreachable])
    {
        [self GetIMEInumbersForRemotetrackingVC];
    }
    else
    {
        [self showErrorsMessage:@"Please connect to internet."];
    }
    [APP_DELEGATE showTabBar:self.tabBarController];
    [super viewWillAppear:YES];
}
-(void)viewDidDisappear:(BOOL)animated
{
//    [APP_DELEGATE hideTabBar:self.tabBarController];

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
    [lblTitle setText:@"Remote navigation"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGRegular size:textSize+2]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
     UIButton * btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
     [btnBack setFrame:CGRectMake(5, 20, 60, yy)];
     [btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
     [btnBack setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
     btnBack.backgroundColor = UIColor.clearColor;
     btnBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//     [viewHeader addSubview:btnBack];
    
    UIButton * btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRefresh setFrame:CGRectMake(DEVICE_WIDTH-60, globalStatusHeight-10, 60, 60)];
    [btnRefresh setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateNormal];
    [btnRefresh addTarget:self action:@selector(btnRefreshClick) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnRefresh];

    
    searchBarIMEi = [[SSSearchBar alloc] initWithFrame:CGRectMake(5, yy+globalStatusHeight, DEVICE_WIDTH-10, 50)];
    searchBarIMEi.delegate=self;
    searchBarIMEi.backgroundColor = [UIColor clearColor];
    searchBarIMEi.layer.cornerRadius = 26;
    searchBarIMEi.layer.borderWidth = .6;
    searchBarIMEi.layer.borderColor = UIColor.whiteColor.CGColor;
    self->searchBarIMEi.placeholder =@"Search by Name";
    [self.view addSubview:searchBarIMEi];
    
    tblDeviceList = [[UITableView alloc] initWithFrame:CGRectMake(0, yy+globalStatusHeight+55, DEVICE_WIDTH, DEVICE_HEIGHT-yy-globalStatusHeight-110)];
    tblDeviceList.delegate = self;
    tblDeviceList.dataSource= self;
    tblDeviceList.backgroundColor = UIColor.clearColor;
    tblDeviceList.separatorStyle = UITableViewCellSelectionStyleNone;
    tblDeviceList.hidden = false;
    [self.view addSubview:tblDeviceList];

    lblNoDevice = [[UILabel alloc]initWithFrame:CGRectMake(30, (DEVICE_HEIGHT/2)-90, (DEVICE_WIDTH)-60, 100)];
    lblNoDevice.backgroundColor = UIColor.clearColor;
    [lblNoDevice setTextAlignment:NSTextAlignmentCenter];
    [lblNoDevice setFont:[UIFont fontWithName:CGRegular size:textSize+2]];
    [lblNoDevice setTextColor:[UIColor whiteColor]];
    lblNoDevice.text = @"No Devices Found.";
    lblNoDevice.hidden = YES;
    [self.view addSubview:lblNoDevice];
}
-(void)GetIMEInumbersForRemotetrackingVC
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:CURRENT_USER_EMAIL forKey:@"email"];
    [dict setValue:CURRENT_USER_PASS forKey:@"password"];
    
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"RemoteTrack";
    manager.delegate = self;
    NSString *strServerUrl = @"https://ws.succorfish.net/basic/v2/asset/search?view=BASIC"; // IMEI for remote tracking
    [manager postUrlCall:strServerUrl withParameters:dict];
}
-(void)btnRefreshClick
{
    [APP_DELEGATE startHudProcess:@"Getting devices..."];
    [self GetIMEInumbersForRemotetrackingVC];
}

#pragma mark- UITableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching)
    {
        return [arrSearchedResults count];
    }
    else
    {
        return arryDeviceList.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellReuseIdentifier = @"cellIdentifier";
        GeofencencAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
        if (cell == nil)
        {
            cell = [[GeofencencAlertCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
        }
    
    cell.lblWhiteDot.hidden = true;
    cell.lblDate.hidden = true;
    cell.lblCellBgColor.frame = CGRectMake(0, 0, DEVICE_WIDTH, 60);
    cell.lblNote.hidden = false;
    cell.lblGeoFncID.frame = CGRectMake(10, 0, DEVICE_WIDTH-5, 30);
    cell.imgArrow.frame = CGRectMake(DEVICE_WIDTH-12, 25, 10, 12);
    cell.lblNote.frame = CGRectMake(10, 30, DEVICE_WIDTH-5, 30);
    cell.lblNote.text = [[arryDeviceList objectAtIndex:indexPath.row] valueForKey:@"type"];
    
    NSMutableDictionary * tmpDict = [[NSMutableDictionary alloc] init];

    if (isSearching)
    {
        tmpDict = [arrSearchedResults objectAtIndex:indexPath.row];
    }
    else
    {
        tmpDict = [arryDeviceList objectAtIndex:indexPath.row];
    }
    cell.lblGeoFncID.text = [tmpDict valueForKey:@"name"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([arryDeviceList count] > 0)
    {
        NSString * strID = [[arryDeviceList objectAtIndex:indexPath.row] valueForKey:@"deviceId"];
        
        if ([strID isKindOfClass:[NSNull class]])
        {
            [self TostNotification:@"Device data not available."];
        }
        else
        {
            globalRemoteNaviMapView= [[RemotNovigMapVC alloc] init];
            isMapNavigated = YES;
            globalRemoteNaviMapView.strDEviceID = [[arryDeviceList objectAtIndex:indexPath.row] valueForKey:@"deviceId"];
            globalRemoteNaviMapView.strDeviceName = [[arryDeviceList objectAtIndex:indexPath.row] valueForKey:@"name"];
            globalRemoteNaviMapView.strDeviceType = [[arryDeviceList objectAtIndex:indexPath.row] valueForKey:@"type"];

            [self.navigationController pushViewController:globalRemoteNaviMapView animated:true];
        }
    }
}
#pragma mark - SSSearchBarDelegate
- (void)searchBarCancelButtonClicked:(SSSearchBar *)searchBar
{
    [searchBarIMEi resignFirstResponder];
    searchBarIMEi.text = @"";
    isSearching = NO;
    [tblDeviceList reloadData];
}
- (void)searchBarSearchButtonClicked:(SSSearchBar *)searchBar
{
    [searchBarIMEi resignFirstResponder];
    [self filterContentForSearchText:searchBar.text];
}
- (void)searchBar:(SSSearchBar *)searchBar textDidChange:(NSString *)searchText
{
    isSearching = YES;
    [self filterContentForSearchText:searchText];
}
-(void)filterContentForSearchText:(NSString *)searchText
{
    [arrSearchedResults removeAllObjects];
    
    NSPredicate *predicate ;

    NSArray *tempArray =[[NSArray alloc] init];
    
    predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@",searchText];
    tempArray = [arryDeviceList filteredArrayUsingPredicate:predicate];

    if (arrSearchedResults)
    {
        arrSearchedResults = nil;
    }
    
    arrSearchedResults = [[NSMutableArray alloc] initWithArray:tempArray];
    
    if (searchText == nil || [searchText isEqualToString:@""])
    {
        isSearching = NO;
    }
    else
    {
        isSearching = YES;
    }
    
    [tblDeviceList reloadData];
}
#pragma mark - UrlManager Delegate
- (void)onResult:(NSDictionary *)result
{
    [APP_DELEGATE endHudProcess];
    if ([[result valueForKey:@"result"] isKindOfClass:[NSArray class]])
    {
        if ([[result valueForKey:@"commandName"] isEqualToString:@"RemoteTrack"])
        {
            lblNoDevice.hidden = YES;
            tblDeviceList.hidden = NO;

            arryDeviceList = [result valueForKey:@"result"];
            
            [tblDeviceList reloadData];
        }
    }
    else
    {
        lblNoDevice.hidden = NO;
        tblDeviceList.hidden = YES;
//        NSLog(@"show error popup");
    }
}
- (void)onError:(NSError *)error
{
    [APP_DELEGATE endHudProcess];
    NSLog(@"The error is...%@", error);
}
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:true];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)showTypeSuccessMessage:(NSString *)strMessage
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeSuccess];
    [alert showAlertInView:self
                 withTitle:@"SC2 Companion App"
              withSubtitle:strMessage
           withCustomImage:[UIImage imageNamed:@"logo.png"]
       withDoneButtonTitle:nil
                andButtons:nil];
}
-(void)showErrorsMessage:(NSString *)strMessage
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
-(void)TostNotification:(NSString *)StrToast
    {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = StrToast;
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.9];
}

@end
