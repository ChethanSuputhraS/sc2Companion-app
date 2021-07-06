//
//  URATConfigVC.m
//  GeofenceAlertApp
//
//  Created by Ashwin on 10/14/20.
//  Copyright © 2020 srivatsa s pobbathi. All rights reserved.
//

#import "URATConfigVC.h"
#import "SettingCell.h"

@interface URATConfigVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arrAPNList;
    UITableView *tblListAPN;
    NSInteger  selectedCell;
    NSString * strSelectedData;
    NSMutableArray * arrSelectedValue;
}
@property(strong)NSIndexPath *selectedIndex;
@end

@implementation URATConfigVC
@synthesize strUARTSelected;

- (void)viewDidLoad
{
    arrAPNList =[[NSMutableArray alloc]initWithObjects:@"LTE Cat M1",@"LTE Cat NB1",@"GPRS / eGPRS",@"GPRS / eGPRS & LTE Cat NB1",@"GPRS / eGPRS & LTE Cat M1",@"LTE Cat NB1 & LTE Cat M1",@"LTE Cat NB1 & GPRS / eGPRS",@"LTE Cat M1 & LTE Cat NB1",@"LTE Cat M1 & GPRS / eGPRS",@"GPRS / eGPRS & LTE Cat NB1 & LTE Cat M1",@"GPRS / eGPRS & LTE Cat M1 & LTE Cat NB1",@"LTE Cat NB1 & GPRS / eGPRS & LTE Cat M1",@"LTE Cat NB1 & LTE Cat M1 & GPRS / eGPRS",@"LTE Cat M1 & LTE Cat NB1 & GPRS / eGPRS",@"LTE Cat M1 & GPRS / eGPRS & LTE Cat NB1", nil];
    
    arrSelectedValue = [[NSMutableArray alloc] init];
    NSString * sqlquery = [NSString stringWithFormat:@"select * from tbl_SIMConfig"];
    [[DataBaseManager dataBaseManager] execute:sqlquery resultsArray:arrSelectedValue];
  
    [self setNavigationViewFrames];
    
    if ([strUARTSelected isEqualToString:@"NA"])
    {
        selectedCell = -1;
    }
    else
    {
        if ([arrAPNList containsObject:strUARTSelected])
        {
            NSInteger foundIndex = [arrAPNList indexOfObject:strUARTSelected];
            if (foundIndex != NSNotFound)
            {
                if ([arrAPNList count] > foundIndex)
                {
                    selectedCell = foundIndex;
                }
            }
        }
    }
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
    [lblTitle setText:@"URAT Configuration"];
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

    
    tblListAPN = [[UITableView alloc]initWithFrame: CGRectMake(0, 64, DEVICE_WIDTH, DEVICE_HEIGHT-64) style:UITableViewStylePlain];
//    tblListAPN.frame = CGRectMake(0, 120, DEVICE_WIDTH, DEVICE_HEIGHT-120);
    tblListAPN.backgroundColor = UIColor.clearColor;
    tblListAPN.delegate= self;
    tblListAPN.dataSource = self;
    tblListAPN.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:tblListAPN];
    
}
#pragma mark-Tavbleview method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrAPNList.count;
    // array have to pass
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellReuseIdentifier = @"cellIdentifier";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (cell == nil)
    {
        cell = [[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    [cell.lblForSetting setFont:[UIFont fontWithName:CGRegular size:textSize-2]];
    cell.lblForSetting.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row+1, [arrAPNList objectAtIndex:indexPath.row]];
    cell.imgArrow.hidden = true;

    if (selectedCell == indexPath.row)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.tintColor = UIColor.whiteColor;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell.backgroundColor = UIColor.clearColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self->selectedCell = indexPath.row;
    strSelectedData = [arrAPNList objectAtIndex:indexPath.row];
    [tblListAPN reloadData];
}
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)btnSaveChClick
{
//    if ([strSelectedData  isEqual: @""])
//    {
//        // error
//
//    }
//    else
//    {
    [globalSIMvc RecevieTheSelectedURAT:strSelectedData withIndexPath:selectedCell];
    [self.navigationController popViewControllerAnimated:true];
//    }

}
@end
