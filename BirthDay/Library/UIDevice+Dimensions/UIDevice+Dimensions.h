
/************************************************
 *
 *	UIDevice+Dimensions.h
 *	Project: Valet Up
 *	Copyright © 2013 Evil Genius Technologies, LLC.  All Rights Reserved.
 *	v1.1.2 2013-09-22 by Jesse Lawler
 *
 ************************************************/

#import <UIKit/UIKit.h>

#define kStatusBarHeight                        20
#define kNavigationBarHeightiPhonePortrait      44
#define kNavigationBarHeightiPhoneLandscape     32
#define kNavigationBarHeightiPadPortrait        44
#define kNavigationBarHeightiPadLandscape       44
#define kToolBarHeightiPhone                    44
#define kToolBarHeightiPad                      44
#define kTabBarHeightiPhone                     49
#define kTabBarHeightiPad                       56
#define kPixelDifferenceBetweeniPhone4and5      88
#define kKeyboardHeightiPhonePortrait           216
#define kKeyboardHeightiPhoneLandscape          162
#define kKeyboardHeightiPadPortrait             352
#define kKeyboardHeightiPadLandscape            264
#define kPickerViewHeight                       216.0
#define CURRENT_INTERFACE_ORIENTATION           [[UIApplication sharedApplication] statusBarOrientation]

enum {
    UIDevice_iPhoneStandardRes      = 1,    // iPhone 1,3,3GS Standard Resolution   (320x480px)
    UIDevice_iPhoneHiRes            = 2,    // iPhone 4,4S High Resolution          (640x960px)
    UIDevice_iPhoneTallerHiRes      = 3,    // iPhone 5 High Resolution             (640x1136px)
    UIDevice_iPadStandardRes        = 4,    // iPad 1,2 Standard Resolution         (1024x768px)
    UIDevice_iPadHiRes              = 5     // iPad 3 High Resolution               (2048x1536px)
}; typedef NSUInteger AppleDeviceType;

@interface UIDevice (Dimensions) { }

+ (NSUInteger) longDimensionInPixels:(BOOL)actualPixels; // if parameter is "NO", use "layout pixels" rather than actual pixels
+ (NSUInteger) shortDimensionInPixels:(BOOL)actualPixels; // if parameter is "NO", use "layout pixels" rather than actual pixels
+ (AppleDeviceType) deviceType;
+ (CGSize) fullscreenLayoutDimensionsInCurrentOrientation;
+ (CGSize) fullscreenLayoutDimensionsInOrientation:(UIInterfaceOrientation)orientation;
+ (CGSize) layoutDimensionsInCurrentOrientationForViewController:(UIViewController *)viewController;
+ (CGSize) layoutDimensionsForViewController:(UIViewController *)viewController
                               inOrientation:(UIInterfaceOrientation)orientation;
+ (NSInteger) keyboardHeightInCurrentOrientation;
+ (NSInteger) keyboardHeightInOrientation:(UIInterfaceOrientation)orientation;
+ (NSInteger) navigationBarHeightInCurrentOrientation;
+ (NSInteger) navigationBarHeightInOrientation:(UIInterfaceOrientation)orientation;
+ (NSUInteger) statusBarHeight;
+ (NSUInteger) tabBarHeight;
+ (NSUInteger) toolBarHeight;
+ (BOOL) iPhone;
+ (BOOL) iPhone5;
+ (BOOL) iPad;
+ (BOOL) iOSVersionAtMinimum:(NSString *)versionNumber;

@end