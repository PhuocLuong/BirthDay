
/************************************************
 *
 *	UIDevice+Dimensions.m
 *	Project: Valet Up
 *	Copyright © 2013 Evil Genius Technologies, LLC.  All Rights Reserved.
 *	v1.1.2 2013-09-22 by Jesse Lawler
 *
 ************************************************/

#import "UIDevice+Dimensions.h"


@implementation UIDevice (Dimensions)


+ (NSUInteger) longDimensionInPixels:(BOOL)actualPixels
{
    switch ([UIDevice deviceType])
    {
        case UIDevice_iPhoneStandardRes :
            return 480;
            
        case UIDevice_iPhoneHiRes :
            return (actualPixels) ? 960 : 480;
    
        case UIDevice_iPhoneTallerHiRes :
            return (actualPixels) ? 1136 : 568;
        
        case UIDevice_iPadStandardRes :
            return 1024;
        
        case UIDevice_iPadHiRes :
            return (actualPixels) ? 2048 : 1024;
            
        default:
            return 0;
    }
}


+ (NSUInteger) shortDimensionInPixels:(BOOL)actualPixels
{
    switch ([UIDevice deviceType])
    {
        case UIDevice_iPhoneStandardRes :
            return 320;
            
        case UIDevice_iPhoneHiRes :
            return (actualPixels) ? 640 : 320;
    
        case UIDevice_iPhoneTallerHiRes :
            return (actualPixels) ? 640 : 320;
        
        case UIDevice_iPadStandardRes :
            return 768;
        
        case UIDevice_iPadHiRes :
            return (actualPixels) ? 1536 : 768;
            
        default:
            return 0;
    }
}


+ (AppleDeviceType) deviceType
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)])
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            
            result = CGSizeMake(result.width * [UIScreen mainScreen].scale,
                                result.height * [UIScreen mainScreen].scale);
            
            return (result.height > 960 ? UIDevice_iPhoneTallerHiRes : UIDevice_iPhoneHiRes);
        } else
            return UIDevice_iPhoneStandardRes;
    } else
        return (([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) ? UIDevice_iPadHiRes : UIDevice_iPadStandardRes);
}


+ (CGSize) fullscreenLayoutDimensionsInCurrentOrientation
{
    return [UIDevice fullscreenLayoutDimensionsInOrientation:CURRENT_INTERFACE_ORIENTATION];
}


+ (CGSize) fullscreenLayoutDimensionsInOrientation:(UIInterfaceOrientation)orientation
{
    BOOL isStatusBarVisible = ![UIApplication sharedApplication].statusBarHidden;
    
    CGSize fullscreenSize;
    
    if (UIInterfaceOrientationIsPortrait(orientation))
    {
        fullscreenSize = CGSizeMake([UIDevice shortDimensionInPixels:NO], [UIDevice longDimensionInPixels:NO]);
    }
    else // Landscape
    {
        fullscreenSize = CGSizeMake([UIDevice longDimensionInPixels:NO], [UIDevice shortDimensionInPixels:NO]);
    }
    
    if (![self iOSVersionAtMinimum:@"7.0"]) // version before iOS7
    {
        if (isStatusBarVisible)
        {
            fullscreenSize.height -= kStatusBarHeight;
        }
    }
    
    return fullscreenSize;
}


+ (CGSize) layoutDimensionsInCurrentOrientationForViewController:(UIViewController *)viewController
{
    return [UIDevice layoutDimensionsForViewController:viewController
                                         inOrientation:CURRENT_INTERFACE_ORIENTATION];
}


+ (CGSize) layoutDimensionsForViewController:(UIViewController *)viewController
                               inOrientation:(UIInterfaceOrientation)orientation;
{
    CGSize workingSize = [UIDevice fullscreenLayoutDimensionsInOrientation:orientation];
    
    // Handle reduction for NavigationController
    
    if (viewController.navigationController && !viewController.navigationController.navigationBarHidden) // Navigation Bar is visible...
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            if (UIInterfaceOrientationIsLandscape(CURRENT_INTERFACE_ORIENTATION))
            {
                workingSize.height -= kNavigationBarHeightiPhoneLandscape;
            }
            else
            {
                workingSize.height -= kNavigationBarHeightiPhonePortrait;
            }
        }
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            if (UIInterfaceOrientationIsLandscape(CURRENT_INTERFACE_ORIENTATION))
            {
                workingSize.height -= kNavigationBarHeightiPadLandscape;
            }
            else
            {
                workingSize.height -= kNavigationBarHeightiPadPortrait;
            }
        }
    }
    
    // Handle reduction for TabBarController...
    
    UIViewController *rootViewController = nil;
    
    if (viewController.navigationController)
    {
        rootViewController = [viewController.navigationController.viewControllers objectAtIndex:0];
    }
    
    if (viewController.tabBarController) // Tab Bar is visible...
    {
        workingSize.height -= [UIDevice tabBarHeight];
    }
    else if (rootViewController)
    {
        if (rootViewController.tabBarController) // Tab Bar is visible here too...
        {
            workingSize.height -= [UIDevice tabBarHeight];
        }
    }
    
    return workingSize;
}


+ (NSInteger) keyboardHeightInCurrentOrientation
{
    return [UIDevice keyboardHeightInOrientation:CURRENT_INTERFACE_ORIENTATION];
}


+ (NSInteger) keyboardHeightInOrientation:(UIInterfaceOrientation)orientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return (UIInterfaceOrientationIsPortrait(orientation)) ? kKeyboardHeightiPhonePortrait : kKeyboardHeightiPhoneLandscape;
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return (UIInterfaceOrientationIsPortrait(orientation)) ? kKeyboardHeightiPadPortrait : kKeyboardHeightiPadLandscape;
    }
    else
    {
        NSLog(@"UIDevice+Dimensions.m: ERROR - Unsupported Device");
        return 0;
    }
}


+ (NSInteger) navigationBarHeightInCurrentOrientation
{
    return [UIDevice navigationBarHeightInOrientation:CURRENT_INTERFACE_ORIENTATION];
}


+ (NSInteger) navigationBarHeightInOrientation:(UIInterfaceOrientation)orientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return (UIInterfaceOrientationIsPortrait(orientation)) ? kNavigationBarHeightiPhonePortrait : kNavigationBarHeightiPhoneLandscape;
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return (UIInterfaceOrientationIsPortrait(orientation)) ? kNavigationBarHeightiPadPortrait : kNavigationBarHeightiPadLandscape;
    }
    else
    {
        NSLog(@"UIDevice+Dimensions.m: ERROR - Unsupported Device");
        return 0;
    }
}


+ (NSUInteger) statusBarHeight
{
    return ([UIApplication sharedApplication].statusBarHidden) ? 0 : kStatusBarHeight;
}


+ (NSUInteger) tabBarHeight
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kTabBarHeightiPad : kTabBarHeightiPhone;
}


+ (NSUInteger) toolBarHeight
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kToolBarHeightiPad : kToolBarHeightiPhone;
}


+ (BOOL) iPhone
{
    AppleDeviceType deviceType = [UIDevice deviceType];
    return (deviceType == UIDevice_iPhoneStandardRes || deviceType == UIDevice_iPhoneHiRes || deviceType == UIDevice_iPhoneTallerHiRes);
}


+ (BOOL) iPhone5
{
    AppleDeviceType deviceType = [UIDevice deviceType];
    return (deviceType == UIDevice_iPhoneTallerHiRes);
}


+ (BOOL) iPad
{
    AppleDeviceType deviceType = [UIDevice deviceType];
    return (deviceType == UIDevice_iPadStandardRes || deviceType == UIDevice_iPadHiRes);
}


+ (BOOL) iOSVersionAtMinimum:(NSString *)versionNumber;
{
    return ([[[UIDevice currentDevice] systemVersion] compare:versionNumber
                                                      options:NSNumericSearch] != NSOrderedAscending);
}


@end