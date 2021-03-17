//
//  BandConfigVC.m
//  GeofenceAlertApp
//
//  Created by Ashwin on 10/14/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import "BandConfigVC.h"
#import "CollectionCustomCell.h"


@interface BandConfigVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    NSMutableArray * arrayBand;
    NSInteger * selectedIndex;
    NSMutableArray * arrSelected;
    NSMutableDictionary * selectedDict;
    BOOL isBandSelect;
    
}
@end

@implementation BandConfigVC

- (void)viewDidLoad
{
    
    selectedDict = [[NSMutableDictionary alloc] init];
    arrSelected = [[NSMutableArray alloc] init];
    
    [self setNavigationViewFrames];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [lblTitle setText:@"Band Configuration"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGRegular size:textSize+2]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
     UIButton * btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
     [btnBack setFrame:CGRectMake(0, 20, 60, yy)];
     [btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
     [btnBack setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
     btnBack.backgroundColor = UIColor.clearColor;
     btnBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
     [viewHeader addSubview:btnBack];
    
    
    UIButton * btnSaveCh = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSaveCh setFrame:CGRectMake((DEVICE_WIDTH-70), 15, 60, 44)];
//    [btnSaveCh setBackgroundImage:[UIImage imageNamed:@"BTN.png"] forState:UIControlStateNormal];
    [btnSaveCh setTitle:@"Save" forState:UIControlStateNormal];
    [btnSaveCh setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btnSaveCh addTarget:self action:@selector(btnSaveChClick) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnSaveCh];

    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(5, 70, DEVICE_WIDTH-10, DEVICE_HEIGHT-64) collectionViewLayout:layout];
    _collectionView.clipsToBounds = true;
     [_collectionView setDataSource:self];
     [_collectionView setDelegate:self];

     [_collectionView registerClass:[CollectionCustomCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
     [_collectionView setBackgroundColor:[UIColor clearColor]];
    
    
     arrayBand = [[NSMutableArray alloc] init];

    for (int i =0 ; i < 28; i++)
    {
        NSMutableDictionary* dictBAndData = [[NSMutableDictionary alloc] init];
         
        NSString * strIndex = [NSString stringWithFormat:@"%d",i+1];
        NSString * strName = [NSString stringWithFormat:@"B%d",i+1];
        
        [dictBAndData setObject:strIndex forKey:@"index"];
        [dictBAndData setObject:strName forKey:@"name"];
        [dictBAndData setObject:@"NO" forKey:@"isSelected"];
        [arrayBand addObject:dictBAndData];

    }
    [self.view addSubview:_collectionView];
}
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)btnSaveChClick
{
    NSInteger totalCount = 0;
    NSMutableArray *  tmpBandArry = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [arrayBand count]; i++)
    {
        if ([[[arrayBand objectAtIndex:i] valueForKey:@"isSelected"] isEqualToString:@"YES"])
        {
            [tmpBandArry addObject:[arrayBand objectAtIndex:i]];
            // send the Value to the ble Service
            totalCount = pow(2,i) + totalCount;
        }
    }
    [_delegate SentBandConfiguration:totalCount];
    if (tmpBandArry.count == 0)
    {
        [self showErrorMessage:@"Please select the bands"];
    }
    else
    {
        [self showSuccesMessage:@"Band configuration saved"];
        [self InsertTodatabaseBandTbl:tmpBandArry];
    }
}
#pragma mark - Collection Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrayBand.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCustomCell *cell=[collectionView  dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor lightGrayColor];
    cell.layer.cornerRadius = 4;
    
    cell.lblNo.text = [[arrayBand objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    if ([[[arrayBand objectAtIndex:indexPath.item] valueForKey:@"isSelected"] isEqual:@"YES"])
    {
        cell.backgroundColor = [UIColor greenColor];
        cell.lblNo.textColor = UIColor.whiteColor;
    }
    else
    {
       cell.backgroundColor = [UIColor lightGrayColor];
       cell.lblNo.textColor = [UIColor blackColor];
    }
    
    NSMutableArray *  arryDatabase = [[NSMutableArray alloc] init];
    NSString * sqlquery = [NSString stringWithFormat:@"select * from tbl_bands"];
    [[DataBaseManager dataBaseManager] execute:sqlquery resultsArray:arryDatabase];
    
    
//    cell.lblNo.backgroundColor = UIColor.redColor;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat vWidth = (DEVICE_WIDTH/5)-10;
    return CGSizeMake(vWidth, vWidth + 10);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected index=%ld", (long)indexPath.item);
    
    if ([[[arrayBand objectAtIndex:indexPath.item] valueForKey:@"isSelected"] isEqualToString:@"NO"])
    {
        [[arrayBand objectAtIndex:indexPath.item] setObject:@"YES" forKey:@"isSelected"];
    }
    else if ([[[arrayBand objectAtIndex:indexPath.item] valueForKey:@"isSelected"] isEqual:@"YES"])
    {
        [[arrayBand objectAtIndex:indexPath.item] setObject:@"NO" forKey:@"isSelected"];
    }
    
    [_collectionView reloadData];
}
-(void)ErrorPopUP:(NSString *)strErrorMsg
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeWarning];
    [alert showAlertInView:self
                 withTitle:@"SC2 Companion App"
              withSubtitle:strErrorMsg
           withCustomImage:[UIImage imageNamed:@"logo.png"]
       withDoneButtonTitle:nil
                andButtons:nil];
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
-(void)showSuccesMessage:(NSString *)strMessage
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
-(void)showErrorMessage:(NSString *)strMessage
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = [UIColor blackColor];
    [alert makeAlertTypeWarning];
    [alert showAlertInView:self
                 withTitle:@"SC2 Companion App"
              withSubtitle:strMessage
           withCustomImage:[UIImage imageNamed:@"logo.png"]
       withDoneButtonTitle:nil
                andButtons:nil];
}
-(void)InsertTodatabaseBandTbl:(NSMutableArray *)arrData
{
    NSMutableArray *  arryDatabase = [[NSMutableArray alloc] init];
    NSString * sqlquery = [NSString stringWithFormat:@"select * from tbl_bands"];
    [[DataBaseManager dataBaseManager] execute:sqlquery resultsArray:arryDatabase];
    
    for (int i =0; i< [arrData count]; i++)
    {
        NSString * strIndex = [[arrData objectAtIndex:i] valueForKey:@"index"];
        NSString * strBandName = [[arrData objectAtIndex:i] valueForKey:@"name"];
        NSString * strSelected = [[arrData objectAtIndex:i] valueForKey:@"isSelected"];
        
        NSString * strBandConfigQuery = @"NA";
        
//        if (arryDatabase.count > 0)
//        {
//            strBandConfigQuery =  [NSString stringWithFormat:@"update tbl_bands set index = \"%@\",name =\"%@\",isselect =\"%@\"",strIndex,strBandName,strSelected];
//             [[DataBaseManager dataBaseManager] executeSw:strBandConfigQuery];
//        }
//        else
//        {
        strBandConfigQuery =  [NSString stringWithFormat:@"insert into 'tbl_bands'('index','name','isselect') values(\"%@\",\"%@\",\"%@\")",strIndex,strBandName,strSelected];
             [[DataBaseManager dataBaseManager] executeSw:strBandConfigQuery];
//        }
    }
    
}
@end
