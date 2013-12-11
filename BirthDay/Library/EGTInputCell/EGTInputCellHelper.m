
/************************************************
 *
 *	EGTInputCellHelper.m
 *	Project: Valet Up
 *	Copyright © 2013 Evil Genius Technologies, LLC.  All Rights Reserved.
 *	v1.0.3 2013-09-26 by Jesse Lawler
 *
 ************************************************/


#import "EGTInputCellHelper.h"
#import "EGTInputCell.h"


#define kPixelBufferBetweenKeyboardAndImportantView     6
#define kAnimationDuration          0.35

@interface EGTInputCellHelper()

- (int) overlapOfKeyboardOnCellInTable:(UITableView *)table
                           atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation EGTInputCellHelper

static EGTInputCellHelper *_instance;


+ (EGTInputCellHelper *) instance
{
	if (!_instance)
	{
		_instance = [[EGTInputCellHelper alloc] init];
	}
	
	return _instance;
}


#pragma mark - Public Operations Methodsr


- (void) handleKeyboardAppearanceOverViewController:(UIViewController *)viewController
                                     affectingTable:(UITableView *)table
                          withActiveCellAtIndexPath:(NSIndexPath *)indexPath
{
    assert(table != nil);
    
    CGFloat overlap = [self overlapOfKeyboardOnCellInTable:table
                                           atIndexPath:indexPath];
    
    if (overlap > 0)
    {
        CGRect oldFrame = viewController.view.frame;
        
        //NSLog(@"appear oldFrame: %f, %f, %f x %f", oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
        
        CGRect newFrame = CGRectMake(oldFrame.origin.x,
                                     oldFrame.origin.y - overlap,
                                     oldFrame.size.width,
                                     oldFrame.size.height);
        
        //NSLog(@"appear newFrame: %f, %f, %f x %f", newFrame.origin.x, newFrame.origin.y, newFrame.size.width, newFrame.size.height);
        
        [UIView animateWithDuration:kAnimationDuration
                         animations:^{
                             
                             viewController.view.frame = newFrame;
                             //NSLog(@"Scooting center to %f, %f", self.view.center.x, self.view.center.y);
                         }];
    }
}


- (void) handleKeyboardDisappearanceOverViewController:(UIViewController *)viewController
                                        affectingTable:(UITableView *)table
                             withActiveCellAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CGRect oldFrame = viewController.view.frame;
 /*
    BOOL hasVisibleNavigationBar = (viewController.navigationController != nil && !viewController.navigationController.navigationBar.hidden);
    
    CGRect newFrame = CGRectMake(oldFrame.origin.x,
                                 hasVisibleNavigationBar ? [UIDevice navigationBarHeightInCurrentOrientation] : 0.0,
                                 oldFrame.size.width,
                                 oldFrame.size.height);
 */
    CGRect newFrame = CGRectMake(0, 0, oldFrame.size.width, oldFrame.size.height);
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         
                         viewController.view.frame = newFrame;
                     }];
}


#pragma mark - Public Getter Methods


- (NSString *) displayValue:(NSObject *)object
{
    if (!object)
    {
        return nil;
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        return (NSString *)object;
    }
    else if ([object respondsToSelector:@selector(name)])
    {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return (NSString *)[object performSelector:@selector(name)];
        #pragma clang diagnostic pop
    }
    else
    {
        NSLog(@"Passed object of class %@ to EGTInputCell, but this class does not implement method 'name'.", [[object class] description]);
        assert(NO);
    }
}


#pragma mark - Private Methods


- (int) overlapOfKeyboardOnCellInTable:(UITableView *)table
                                  atIndexPath:(NSIndexPath *)indexPath
{
    // Get (essentially) the screen height, ignoring the Status Bar
    int usableScreenHeight = [UIDevice fullscreenLayoutDimensionsInCurrentOrientation].height;
    
    // Get the primary view for the entire app...
    UIView *topView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    
    // Get the relevant cell
    UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    
    // Get the position of the cell on the screen...
    CGRect cellFrameOnScreen = [table convertRect:cell.frame toView:topView];
    //NSLog(@"cellFrameOnScreen: %f, %f, %f x %f", cellFrameOnScreen.origin.x, cellFrameOnScreen.origin.y, cellFrameOnScreen.size.width, cellFrameOnScreen.size.height);
    
    // Get the bottom of the cell on the screen...
    int cellBottomOnScreen = cellFrameOnScreen.origin.y + cellFrameOnScreen.size.height;
    //NSLog(@"cellBottomOnDevice: %d", cellBottomOnScreen);
    
    // Get the distance from the bottom of the cell to the floor of the screen...
    NSUInteger distanceFromScreenBottom = usableScreenHeight - cellBottomOnScreen;
    //NSLog(@"distanceFromScreenBottom: %d", distanceFromScreenBottom);
    
    // Get the overlap that will appear once the keyboard pops up
    int overlap = [UIDevice keyboardHeightInCurrentOrientation] - distanceFromScreenBottom + kPixelBufferBetweenKeyboardAndImportantView;
    
    return (overlap > 0) ? overlap : 0;
}


@end