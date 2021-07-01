//
//  RemotNovigMapVC.m
//  GeofenceAlertApp
//
//  Created by Vithamas Technologies on 11/02/21.
//  Copyright © 2021 srivatsa s pobbathi. All rights reserved.
//

#import "RemotNavigMapVC.h"
#import "URLManager.h"
#import "CustomAnnotation.h"
#import "CustomAnnotationView.h"


@interface RemotNovigMapVC ()<MKMapViewDelegate,URLManagerDelegate>
{
    CLLocationManager*locationManager;
     MKMapView*mapView;
    MKPointAnnotation *annotation1;
    NSMutableDictionary * dictLatlong;
    NSTimer * timerEvery1mint,*timerForEndProgressBar;
    double latestLat,latestLong;
    NSString * strScreenMode;
    MKCircle *_radialCircle;
    bool isPinAdded, isViewDisappeared;

    CustomAnnotation * annotationPin;
    CustomAnnotationView* custannotationView;
    
}
@end

@implementation RemotNovigMapVC
@synthesize strDEviceID,strDeviceName,strDeviceType;
- (void)viewDidLoad
{
    isViewDisappeared = NO;
    
    strScreenMode = @"Light";
    if (@available(iOS 12.0, *))
    {
            switch (UIScreen.mainScreen.traitCollection.userInterfaceStyle) {
                case UIUserInterfaceStyleDark:
                    // put your dark mode code here
                    strScreenMode = @"Dark";
                    break;
                case UIUserInterfaceStyleLight:
                case UIUserInterfaceStyleUnspecified:
                    break;
                default:
                    break;
            }
    }
    

    dictLatlong = [[NSMutableDictionary alloc] init];
    [self setNavigationViewFrames];
    [self setContentViewFrames];
    
    [APP_DELEGATE startHudProcess:@"Loading..."];
    
//    [self GetLatLongFromSelectedDevice:strDEviceID];


    [timerEvery1mint invalidate];
    timerEvery1mint = nil;
    timerEvery1mint = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timerForCallAPI) userInfo:nil repeats:YES];
    
//    timerForEndProgressBar = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(endProgressBar) userInfo:nil repeats:NO];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    isViewDisappeared = NO;
    
    [APP_DELEGATE hideTabBar:self.tabBarController];
    [self GetLatLongFromSelectedDevice:strDEviceID];
    
    if (isMapNavigated == YES)
    {
        isMapNavigated = NO;
        if (mapView)
        {
            [mapView removeAnnotations:mapView.annotations];
        }

    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [timerEvery1mint invalidate];
    timerEvery1mint = nil;
    isViewDisappeared = YES;
}
#pragma mark - Set Frames
-(void)setNavigationViewFrames
{
    int  yy = 64;
    if (IS_IPHONE_X)
    {
        yy = 84;
    }
    UIImageView * imgLogo = [[UIImageView alloc] init];
    imgLogo.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    imgLogo.image = [UIImage imageNamed:@"Splash_bg.png"];
    imgLogo.userInteractionEnabled = YES;
    [self.view addSubview:imgLogo];
    
    UIView * viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, yy+30)];
    [viewHeader setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:viewHeader];
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, DEVICE_WIDTH-100, 40)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"Remote Tracking"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGRegular size:textSize+1]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
    UILabel * lblSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, lblTitle.frame.size.height, DEVICE_WIDTH-100, 20)];
    [lblSubTitle setBackgroundColor:[UIColor clearColor]];
    [lblSubTitle setText:strDeviceName];
    [lblSubTitle setTextAlignment:NSTextAlignmentCenter];
    [lblSubTitle setFont:[UIFont fontWithName:CGRegular size:textSize-2]];
    [lblSubTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblSubTitle];
    
    
    UIImageView * imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(10,20+11, 14, 22)];
    imgBack.image = [UIImage imageNamed:@"back_icon.png"];
    imgBack.backgroundColor = UIColor.clearColor;
    [viewHeader addSubview:imgBack];
    
    UIButton * btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 80, yy)];
    [btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnBack];
    
    if (IS_IPHONE_X)
    {
        lblTitle.frame = CGRectMake(50, 40, DEVICE_WIDTH-100, 44);
        imgBack.frame = CGRectMake(10,40+11, 14, 22);
    }
}
-(void)GetLatLongFromSelectedDevice:(NSString *)strDeviceId
{
    NSLog(@"GetLatLongFromSelectedDevice====>>>>>%@",strDeviceId);

    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:CURRENT_USER_EMAIL forKey:@"email"];
    [dict setValue:CURRENT_USER_PASS forKey:@"password"];
    
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"GetLatLong";
    manager.delegate = self;
    NSString *strServerUrl = @"https://ws.succorfish.net/basic/v2/waypoint/getLatest/"; // IMEI for remote tracking
//    NSString *strServerUrl = @"https://ws.succorfish.net/basic/v2/asset/search?view=BASIC"; // IMEI for remote tracking

    [manager getUrlCall:[NSString stringWithFormat:@"%@%@",strServerUrl,strDeviceId] withParameters:nil];//  curent device Id
}
-(void)setContentViewFrames
{
    int yy = 64;
    if (IS_IPHONE_X)
    {
        yy = 84;
    }
    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, yy, DEVICE_WIDTH,DEVICE_HEIGHT-yy)];
    [mapView setDelegate:self];
    mapView.showsUserLocation = false;
    mapView.mapType = MKMapTypeStandard;
    [self.view addSubview:mapView];
    
    BOOL isDeviceLocationAvail = NO;
//    double latestLat = 0;
//    double latestLong = 0;
//
//    if ([dictLatlong count] > 0 )
//    {
//        latestLat = [[dictLatlong valueForKey:@"lat"] doubleValue];
//        latestLong = [[dictLatlong valueForKey:@"lng"] doubleValue];
//    }
//
//    CLLocationCoordinate2D sourceCoords = CLLocationCoordinate2DMake(latestLat, latestLong);
//
//    MKPlacemark *placemark  = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
//    [mapView removeAnnotation:annotation1];
//    annotation1 = [[MKPointAnnotation alloc] init];
//    annotation1.coordinate = sourceCoords;
//    annotation1.title = @"Device Location";
//    [mapView addAnnotation:annotation1];
//    [mapView addAnnotation:placemark];
    
    if (isDeviceLocationAvail)
    {
       /* CLLocationCoordinate2D deviceCords = CLLocationCoordinate2DMake(9.9252, 78.1198);
        MKPlacemark *placemark2  = [[MKPlacemark alloc] initWithCoordinate:deviceCords addressDictionary:nil];
        annotation2 = [[MKPointAnnotation alloc] init];
        annotation2.coordinate = deviceCords;
        annotation2.title = @"Device Location";
        [mapView addAnnotation:annotation2];
        [mapView addAnnotation:placemark2];*/

    }
}
#pragma mark - Map View Delegates
-(void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    if([views count]>0)
    {
        MKAnnotationView *annotationView = [views objectAtIndex:0];
        if (annotationView)
        {
            id <MKAnnotation> mp = [annotationView annotation];
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance
            ([mp coordinate], 1000, 1000);
            if (region.center.latitude > -89 && region.center.latitude < 89 && region.center.longitude > -179 && region.center.longitude < 179 )
            {
                [mv setRegion:region animated:YES];
                [mv selectAnnotation:mp animated:YES];
            }
        }
    }
}
//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
//{
//    MKAnnotationView *annotationView = [views objectAtIndex:0];
//    id <MKAnnotation> mp = [annotationView annotation];
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance
//    ([mp coordinate], 100, 100);
//    [mapView setRegion:region animated:YES];
//    [mapView selectAnnotation:mp animated:YES];
//
//}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    UIColor * overlayColor = [UIColor blackColor];
    
    if ([strScreenMode isEqualToString:@"Dark"])
    {
        overlayColor = [UIColor blueColor]; 
    }
    MKCircleRenderer * renderer = [[MKCircleRenderer alloc] initWithCircle:_radialCircle];
    renderer.strokeColor = overlayColor;
    renderer.fillColor = overlayColor;
    renderer.alpha = .4f;
    renderer.lineWidth = 1;
    return renderer;
}
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{    
    if ([annotation coordinate].latitude != latestLat && [annotation coordinate].longitude != latestLong)
       {
           return [MKAnnotationView new];
       }
  
    static NSString * const identifier = @"CustomAnnotation";
    custannotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    
    if (custannotationView)
    {
        custannotationView.annotation = annotation;
    }
    else
    {
        custannotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
        
    custannotationView.canShowCallout = NO;
    custannotationView.image = [UIImage imageNamed:@"map_pin.png"];
    
    custannotationView.subtitle1 = [NSString stringWithFormat:@"Device Name : %@",strDeviceName];
    custannotationView.subtitle2 = @"" ;
    custannotationView.subtitle3 = [NSString stringWithFormat:@"Device Type : %@",strDeviceType];
     custannotationView.subtitle4 = [NSString stringWithFormat:@"Updated by : %@",[self getCurrentTime]];
    
    [self TostNotification:@"Locaton updated."];
    
    if ([strScreenMode isEqualToString:@"Dark"])
    {
        custannotationView.image = [UIImage imageNamed:@"MapPinWhite.png"];
    }
    
    return custannotationView;
}

-(void)btnBackClick
{
    isViewDisappeared = YES;
    [timerEvery1mint invalidate];
    timerEvery1mint = nil;
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UrlManager Delegate
- (void)onResult:(NSDictionary *)result
{
    NSLog(@"RESULT====>>>>>%@",result);
    [APP_DELEGATE endHudProcess];
//    if ([[result valueForKey:@"result"] isKindOfClass:[NSString class]]) //[[result valueForKey:@"result"] valueForKey:@"deviceId"]
    {
        if ([[result valueForKey:@"commandName"] isEqualToString:@"GetLatLong"])
        {
          dictLatlong = [result valueForKey:@"result"];
            latestLat = [[dictLatlong valueForKey:@"lat"] doubleValue];
            latestLong  = [[dictLatlong valueForKey:@"lng"] doubleValue];

            CLLocationCoordinate2D sourceCoords = CLLocationCoordinate2DMake(latestLat, latestLong);
            
            MKPlacemark *placemark  = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
            
            [mapView removeAnnotations:mapView.annotations];
            [mapView removeAnnotation:annotation1];
            annotation1 = [[MKPointAnnotation alloc] init];
            annotation1.coordinate = sourceCoords;
            annotation1.title = @"SC2 device location";
            [mapView addAnnotation:annotation1];
            [mapView addAnnotation:placemark];
            
            
            NSLog(@"Lat ====>>>>%f long===>>>><<%f ",latestLat,latestLong);
            [mapView reloadInputViews];
//            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            [mapView showAnnotations:mapView.annotations animated:YES];

            
           
        }
    }
}
- (void)onError:(NSError *)error
{
    [APP_DELEGATE endHudProcess];
    NSLog(@"The error is...%@", error);
}
-(void)timerForCallAPI
{
    if (isViewDisappeared == NO)
    {
        [self GetLatLongFromSelectedDevice:strDEviceID];
    }
}
-(void)endProgressBar
{
    [APP_DELEGATE endHudProcess];
}
-(void)TostNotification:(NSString *)StrToast
    {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = StrToast;
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.9];
}
-(NSString *)getCurrentTime
{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
    [DateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSString * currentDateAndTime = [NSString stringWithFormat:@"%@",[DateFormatter stringFromDate:[NSDate date]]];
    return currentDateAndTime;
}
@end
