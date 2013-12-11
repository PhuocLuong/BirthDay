//  Created by Phuoc on 11/19/13.
//  Copyright (c) 2013 Phuoc. All rights reserved.
//

#import "ShopCardViewController.h"
#import "HTTPRequestHelper.h"
#import "ParseJsonHelper.h"
#import "ShopCardCell.h"
#import "ShopCard.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"


@interface ShopCardViewController ()<UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>
{
    NSData *dataResult;
    HTTPRequestHelper *httpHelper;
    ParseJsonHelper *parseHelper;
    MBProgressHUD *HUD;
}
@end

@implementation ShopCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = NO;
    self.title = @"Shop Cards";
    
    httpHelper  = [[HTTPRequestHelper alloc] init];
    parseHelper = [[ParseJsonHelper alloc] init];
    
    HUD           = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"Loading...";
    
    [NSThread detachNewThreadSelector:@selector(startTheBackgroundJob)
                             toTarget:self withObject:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


# pragma mark - Thread

- (void)startTheBackgroundJob
{
    [NSThread sleepForTimeInterval:3];
    [self performSelectorOnMainThread:@selector(makeMyProgressBarMoving) withObject:nil waitUntilDone:NO];
    
}

- (void)makeMyProgressBarMoving
{
    dataResult = [httpHelper sendRequestWithMethod:@"shop_cards"];
    if (dataResult)
    {
        _responseData = [parseHelper parseJsonShopCards:dataResult];
        if (_responseData)
        {
            [_table reloadData];
            [HUD hide:YES afterDelay:1];
        }
    }
}



#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_responseData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ShopCardCell";
    ShopCardCell *cell = (ShopCardCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopCardCell"
                                                     owner:self options:nil];
        cell         = [nib objectAtIndex:0];
    }
    
    ShopCard *sc     = [_responseData objectAtIndex:indexPath.row];
    
    cell.nameCardLabel.text = sc.merchant_name;
    cell.priceLabel.text    = [NSString stringWithFormat:@"%i %@", sc.opening_balance,
                                                                   sc.card_currency_code];
    
    [cell.logoImgView setImageWithURL:[NSURL URLWithString:sc.cover_image_url_hd]
                     placeholderImage:nil];

    return cell;
}

#pragma mark - MBProgressHUD

- (void)hudWasHidden:(MBProgressHUD *)hud
{
	[HUD removeFromSuperview];
	HUD = nil;
}

@end
