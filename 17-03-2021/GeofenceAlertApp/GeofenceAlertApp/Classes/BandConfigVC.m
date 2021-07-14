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
    NSMutableArray * arrSelectedBand;
    BOOL isBandSelect;
    
}
@end

@implementation BandConfigVC
@synthesize strBandValue;
- (void)viewDidLoad
{
    arrSelectedBand = [[NSMutableArray alloc] init];
    
    [self setNavigationViewFrames];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - Set Frames
-(void)setNavigationViewFrames
{
    int yy = 20;
      if (IS_IPHONE_X)
      {
          yy = 44;
      }

    UIImageView * imgLogo = [[UIImageView alloc] init];
    imgLogo.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    imgLogo.image = [UIImage imageNamed:@"Splash_bg.png"];
    imgLogo.userInteractionEnabled = YES;
    [self.view addSubview:imgLogo];
    
    UIView * viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, yy + 44)];
    [viewHeader setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:viewHeader];
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, globalStatusHeight, DEVICE_WIDTH-100, 44)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"Band Configuration"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont fontWithName:CGRegular size:textSize+2]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [viewHeader addSubview:lblTitle];
    
     UIButton * btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
     [btnBack setFrame:CGRectMake(10, 20, 60, 44)];
     [btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
     [btnBack setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
     btnBack.backgroundColor = UIColor.clearColor;
     btnBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
     [viewHeader addSubview:btnBack];
    
    UIButton * btnSaveCh = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSaveCh setFrame:CGRectMake((DEVICE_WIDTH-70), 20, 60, 44)];
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

    if (![[APP_DELEGATE checkforValidString:strBandValue] isEqualToString:@"NA"])
    {
        NSInteger bandIntvalue = [strBandValue integerValue];
        NSData * dataBandConfig = [[NSData alloc] initWithBytes:&bandIntvalue length:4];
        NSMutableData *pillowData = [dataBandConfig mutableCopy];

        uint32_t *bytes = pillowData.mutableBytes;
        *bytes = CFSwapInt32(*bytes);
        NSLog(@"%@", pillowData);
        
        NSString * strHexBandValue = [NSString stringWithFormat:@"%@",pillowData];

        strHexBandValue = [strHexBandValue stringByReplacingOccurrencesOfString:@" " withString:@""];
        strHexBandValue = [strHexBandValue stringByReplacingOccurrencesOfString:@"<" withString:@""];
        strHexBandValue = [strHexBandValue stringByReplacingOccurrencesOfString:@">" withString:@""];

        NSString * strBinary = [self GetBinaryfromHex:strHexBandValue];
        if ([strBinary length] >0)
        {
            for (int i =1 ; i < 29; i++)
            {
                NSMutableDictionary* dictBAndData = [[NSMutableDictionary alloc] init];
                 
                NSString * strIndex = [NSString stringWithFormat:@"%d",i];
                NSString * strName = [NSString stringWithFormat:@"B%d",i];
                
                [dictBAndData setObject:strIndex forKey:@"index"];
                [dictBAndData setObject:strName forKey:@"name"];
                [dictBAndData setObject:@"NO" forKey:@"isSelected"];
                if (strBinary.length > i)
                {
                    if ([[strBinary substringWithRange:NSMakeRange(strBinary.length - i - 1, 1)] isEqualToString:@"1"])
                    {
                        [dictBAndData setObject:@"YES" forKey:@"isSelected"];
                        [arrSelectedBand addObject:strName];
                    }
                }
                [arrayBand addObject:dictBAndData];
            }
        }
    }
    else
    {
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
    }
    
    if (IS_IPHONE_X)
    {
        int yt = viewHeader.frame.size.height+5;
        [btnBack setFrame:CGRectMake(10, 44, 60, 44)];
        [btnSaveCh setFrame:CGRectMake((DEVICE_WIDTH-70), 44, 60, 44)];
        _collectionView.frame = CGRectMake(5, yt, DEVICE_WIDTH-10, DEVICE_HEIGHT-yt);


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
            totalCount = pow(2,i+1) + totalCount;
        }
    }
    if (tmpBandArry.count == 0)
    {
        [self showErrorMessage:@"Please select the bands"];
    }
    else
    {
        [_delegate SentBandConfiguration:totalCount withArray:[tmpBandArry valueForKey:@"name"]];
        [self.navigationController popViewControllerAnimated:YES];
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
    
    
    if ([arrSelectedBand containsObject:[[arrayBand objectAtIndex:indexPath.item] valueForKey:@"name"]])
    {
        NSInteger foundIndex = [arrSelectedBand indexOfObject:[[arrayBand objectAtIndex:indexPath.item] valueForKey:@"name"]];
        if (foundIndex != NSNotFound)
        {
            if ([arrSelectedBand count] > foundIndex)
            {
                [arrSelectedBand removeObjectAtIndex:foundIndex];
                [[arrayBand objectAtIndex:indexPath.item] setObject:@"NO" forKey:@"isSelected"];
            }
        }
    }
    else
    {
        if ([arrSelectedBand count] ==3 )
        {
            [self TostNotification:@"Maximum 3 bands allowed."];
        }
        else
        {
            [arrSelectedBand addObject:[[arrayBand objectAtIndex:indexPath.item] valueForKey:@"name"]];
            
            if ([[[arrayBand objectAtIndex:indexPath.item] valueForKey:@"isSelected"] isEqualToString:@"NO"])
            {
                [[arrayBand objectAtIndex:indexPath.item] setObject:@"YES" forKey:@"isSelected"];
            }
            else if ([[[arrayBand objectAtIndex:indexPath.item] valueForKey:@"isSelected"] isEqual:@"YES"])
            {
                [[arrayBand objectAtIndex:indexPath.item] setObject:@"NO" forKey:@"isSelected"];
            }

        }
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
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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

-(NSString *)GetBinaryfromHex:(NSString *)strHex
{
    NSString *hex = strHex;
    long hexAsInt;
    [[NSScanner scannerWithString:hex] scanHexInt:&hexAsInt];
    NSString *binary = [NSString stringWithFormat:@"%@", [self toBinary:hexAsInt]];
    
//    NSLog(@"===========Binary==========%@",binary);
    return binary;
}
-(NSString *)toBinary:(NSUInteger)input
{
    if (input == 1 || input == 0)
        return [NSString stringWithFormat:@"%lu", (unsigned long)input];
    return [NSString stringWithFormat:@"%@%lu", [self toBinary:input / 2], input % 2];
}


@end

/*
 Heres a short example:

 unsigned char bytes[] = { 0x00, 0x00, 0x01, 0x02 };
 int intData = *((int *)bytes);
 int reverseData = NSSwapInt(intData);

 NSLog(@"integer:%d", intData);
 NSLog(@"bytes:%08x", intData);
 NSLog(@"reverse integer: %d", reverseData);
 NSLog(@"reverse bytes: %08x", reverseData);
 The output will be:

 integer:33619968
 bytes:02010000
 reverse integer: 258
 reverse bytes: 00000102

 */
