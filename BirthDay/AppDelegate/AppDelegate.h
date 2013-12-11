//  Created by Phuoc on 11/5/13.
//  Copyright (c) 2013 Phuoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


- (void) showAlertView:(NSString *)title withMessage:(NSString *)message inView:(UIView *)view;

@end
