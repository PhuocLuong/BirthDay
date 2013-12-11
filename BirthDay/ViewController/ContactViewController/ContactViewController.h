//  Created by Phuoc on 11/5/13.
//  Copyright (c) 2013 Phuoc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  MBProgressHUD;


@interface ContactViewController : UIViewController
{
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) NSIndexPath *activeIndexPath;

@end
