//
//  LiveTrackingVC.m
//  GeofenceAlertApp
//
//  Created by srivatsa s pobbathi on 12/06/19.
//  Copyright © 2019 srivatsa s pobbathi. All rights reserved.
//

#import "LiveTrackingVC.h"
#import "CustomAnnotation.h"
#import "CustomAnnotationView.h"



@interface LiveTrackingVC ()<BLEServiceDelegate,MKMapViewDelegate>
{
    NSMutableDictionary * dictLatLong;
    NSString * strScreenMode;
    MKCircle *_radialCircle;
    double latestLat,latestLong;
    
    CustomAnnotation * annotationPin;
    CustomAnnotationView* custannotationView;

}
@end

@implementation LiveTrackingVC
@synthesize classPeripheral,strBLEaddress;
- (void)viewDidLoad
{
    
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
    
    [self setNavigationViewFrames];
    [self setContentViewFrames];
    [[BLEService sharedInstance] setDelegate:self];
    [APP_DELEGATE startHudProcess:@"Loading..."];
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
    
    UIView * viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, yy)];
    [viewHeader setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:viewHeader];
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, DEVICE_WIDTH-100, 44)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"Live Tracking"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGRegular size:textSize+2]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
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
//    if ([dictLatLong count]> 0)
//    {
//        latestLat =  [[dictLatLong valueForKey:@"Lat"] doubleValue];
//        latestLong = [[dictLatLong valueForKey:@"Long"] doubleValue];
//    }
//    else
//    {
//
//    }
    
//    if (globalPeripheral.state == CBPeripheralStateConnected)
    {
        if (deviceLatitude != 0)
        {
            isDeviceLocationAvail = YES;
//            latestLat = deviceLatitude;
//            latestLong = deviceLongitude;
        }
    }
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
-(void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    NSString *address = [NSString stringWithFormat:@"%@",theSearchBar.text];
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if(!error)
         {
             [self->searchBar resignFirstResponder];
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"%f",placemark.location.coordinate.latitude);
             NSLog(@"%f",placemark.location.coordinate.longitude);
             NSLog(@"%@",[NSString stringWithFormat:@"%@",[placemark description]]);
             
             CLLocationCoordinate2D destCoords = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
             [self->mapView removeAnnotation:self->annotation1];
             self->annotation1.coordinate = destCoords;
             self->annotation1.title = @"Live location";
             [self->mapView addAnnotation:self->annotation1];
         }
         else
         {
             //@"Searched Location is not available"
         }
     }
     ];}
#pragma mark - Map View Delegates
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
            ([mp coordinate], 100, 100);
            if (region.center.latitude > -89 && region.center.latitude < 89 && region.center.longitude > -179 && region.center.longitude < 179 )
            {
                [mv setRegion:region animated:YES];
                [mv selectAnnotation:mp animated:YES];
            }
        }
    }
}
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
    NSString * strName = @"";
    NSString * strAddress = @"";
    NSMutableArray * tmpArr = [[BLEManager sharedManager] foundDevices];
    if ([[tmpArr valueForKey:@"peripheral"] containsObject:self->classPeripheral])
    {
        NSInteger  foudIndex = [[tmpArr valueForKey:@"peripheral"] indexOfObject:self->classPeripheral];
        if (foudIndex != NSNotFound)
        {
            if ([tmpArr count] > foudIndex)
            {
//                NSString * strCurrentIdentifier = [NSString stringWithFormat:@"%@",self->classPeripheral.identifier];
                strName = [[tmpArr  objectAtIndex:foudIndex]valueForKey:@"name"];
                strAddress = [[tmpArr  objectAtIndex:foudIndex]valueForKey:@"bleAddress"];
            }
        }
    }
    
    custannotationView.canShowCallout = NO;
    custannotationView.image = [UIImage imageNamed:@"map_pin.png"];
    
    custannotationView.subtitle1 = [NSString stringWithFormat:@"Device Name:-%@",strName];
    custannotationView.subtitle2 =@"" ;
    custannotationView.subtitle3 = [NSString stringWithFormat:@"Device :-%@",strAddress];
    custannotationView.subtitle4 =@" ";
    
//    [self TostNotification:@"Locaton updated."];
  

    if ([strScreenMode isEqualToString:@"Dark"])
    {
        custannotationView.image = [UIImage imageNamed:@"MapPinWhite.png"];
    }
    
    return custannotationView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - All Button Clicks
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:true];
    [self RequestForStartLivetracking:@"00"];
}
-(void)RequestForStartLivetracking:(NSString *)strState
{
    NSInteger intCommond = [@"227" integerValue]; // E3 start and stop Live Tracking
    NSData * dataOpCmd = [[NSData alloc] initWithBytes:&intCommond length:1];

    NSInteger intLength = [@"01" integerValue];
    NSData * dataLength = [[NSData alloc] initWithBytes:&intLength length:1];

    NSInteger intLengthStart = [strState integerValue];
    NSData * dataLengthStart = [[NSData alloc] initWithBytes:&intLengthStart length:1];
    
    NSMutableData *completeData = [dataOpCmd mutableCopy];
    [completeData appendData:dataLength];
    [completeData appendData:dataLengthStart];

    [[BLEService sharedInstance] WriteNSDataforEncryptionAndthenSendtoPeripheral:completeData withPeripheral:classPeripheral];
}
-(void)ReceviedLatLongFromDevice:(NSMutableDictionary *)dict;
{
    dispatch_async(dispatch_get_main_queue(), ^{
    [APP_DELEGATE endHudProcess];
        self->latestLat = [[dict valueForKey: @"Lat"] doubleValue];
        self->latestLong = [[dict valueForKey: @"Long"] doubleValue];
        
        self->dictLatLong = [[NSMutableDictionary alloc] init];

        CLLocationCoordinate2D sourceCoords = CLLocationCoordinate2DMake(self->latestLat, self->latestLong);
        MKPlacemark *placemark  = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
        
        [self->mapView removeAnnotations:self->mapView.annotations];
        [self->mapView removeAnnotation:self->annotation1];
        self->annotation1 = [[MKPointAnnotation alloc] init];
        self->annotation1.coordinate = sourceCoords;
        self->annotation1.title = @"Device Location";
        [self->mapView addAnnotation:self->annotation1];
        [self->mapView addAnnotation:placemark];
 
        self->dictLatLong = dict;
        [self TostNotification:@"Location updated."];
        [self->mapView reloadInputViews];

    });
}
-(void)TostNotification:(NSString *)StrToast
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = StrToast;
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.tag = 9999;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.9];
}
@end
