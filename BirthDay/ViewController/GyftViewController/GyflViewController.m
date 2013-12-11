//  Created by Phuoc on 11/14/13.
//  Copyright (c) 2013 Phuoc. All rights reserved.
//

#import "GyflViewController.h"
#import "HTTPRequestHelper.h"
#import "ParseJsonHelper.h"
#import "ShopCardViewController.h"

@interface GyflViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *datas;
}

@end

@implementation GyflViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        UIImage *gyftImage     = [UIImage imageNamed:@"Card.png"];
        self.tabBarItem.image  = gyftImage;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (iOS >= 7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;

        CGRect rect = _table.frame;
        rect.origin.y += [UIDevice statusBarHeight];
        rect.size.height -= [UIDevice statusBarHeight];
        _table.frame = rect;
    }
    
    datas = [NSArray arrayWithObjects:@"Shop Cards", @"Account", @"Transactions",
             @"Recent Transactions", @"Initial Transactions", @"Purchase Cards", nil];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Public Methods

- (IBAction)recent:(id)sender
{
/*
    int numberOfRecords = 3;// Change it
    NSString *url = [NSString stringWithFormat:@"transactions/last/%i", numberOfRecords];
    //[httpHelper sendRequestWithMethod:url];
 */
}

- (IBAction)initial:(id)sender
{
 /*
    int numberOfRecords = 3;// Change it
    NSString *url = [NSString stringWithFormat:@"transactions/first/%i", numberOfRecords];
   // [httpHelper sendRequestWithMethod:url];
  */
}
- (IBAction)purchase:(id)sender
{
    

    //NSString *params = [httpHelper setParametersBody:@"28" withEmail:@"phuoc@evilgeniustechnologies.com"];
    //[httpHelper postRequestWithMethod:@"purchase/card" withParametersBody:params];
}



#pragma mark - Table

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [datas count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [datas objectAtIndex:indexPath.row];
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc;
    if (indexPath.row == 0)
    {
        vc = [[ShopCardViewController alloc] init];
    }
    if (vc)
    {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
