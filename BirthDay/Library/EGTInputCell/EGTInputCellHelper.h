
/************************************************
 *
 *	EGTInputCellHelper.h
 *	Project: Valet Up
 *	Copyright © 2013 Evil Genius Technologies, LLC.  All Rights Reserved.
 *	v1.0.3 2013-09-26 by Jesse Lawler
 *
 ************************************************/


#import <Foundation/Foundation.h>

@interface EGTInputCellHelper : NSObject

// Initializer
+ (EGTInputCellHelper *) instance;

// Operations
- (void) handleKeyboardAppearanceOverViewController:(UIViewController *)viewController
                                     affectingTable:(UITableView *)table
                          withActiveCellAtIndexPath:(NSIndexPath *)indexPath;
- (void) handleKeyboardDisappearanceOverViewController:(UIViewController *)viewController
                                        affectingTable:(UITableView *)table
                             withActiveCellAtIndexPath:(NSIndexPath *)indexPath;

// Getters
- (NSString *) displayValue:(NSObject *)object;

@end