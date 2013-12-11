
/************************************************
 *
 *	EGTInputCell.h
 *	Project: Valet Up
 *	Copyright © 2013 Evil Genius Technologies, LLC.  All Rights Reserved.
 *	v1.0.3 2013-09-26 by Jesse Lawler
 *
 ************************************************/


#import <UIKit/UIKit.h>

enum EGTInputCellType
{
    InputCellNoTypeSet      = 0,
    InputCellBoolean        = 1,
    InputCellString         = 2,
    InputCellInteger        = 3,
    InputCellDouble         = 4,
    InputCellMultipleChoice = 5
};


@interface EGTInputCell : UITableViewCell <UITextFieldDelegate, UIActionSheetDelegate>
{
    enum EGTInputCellType   _type;
    NSObject                *_object;
    NSArray                 *_multipleChoiceOptions;
    
    SEL                     _selectorToGetDisplayValue; // get value
    SEL                     _selectorToSetValue;        // set value
}

@property (nonatomic, strong) IBOutlet UILabel        *labelLabel;
@property (nonatomic, strong) IBOutlet UITextField    *valueTextField;
@property (nonatomic, strong) IBOutlet UIButton       *invisibleButton;

@property (nonatomic, assign) SEL selectorToObserveValueChanged;
@property (nonatomic, assign) id valueChangedObserver;
@property (nonatomic, assign) enum EGTInputCellType type;
@property (nonatomic, assign) UIView *viewForActionSheetsiPhone;
@property (nonatomic, assign) UITableView *containingTableView;
@property (nonatomic, assign) NSObject *objectStoringActiveIndexPath;
@property (nonatomic, retain) NSIndexPath *indexPath;

// User Interaction
- (IBAction)didTouchCell:(id)sender;

// Setters
- (void) setType:(enum EGTInputCellType)type;
- (void) refresh;
- (void) setObject:(NSObject *)object;
- (void) setLabel:(NSString *)name;
- (void) setPlaceholder:(NSString *)name;
- (void) setAutoCapitalizationType:(UITextAutocapitalizationType)autocapitalizationType;
- (void) setGetDisplayValueMethod:(SEL)selector;
- (void) setSetValueMethod:(SEL)selector;
- (void) setAsMultipleChoiceWithOptions:(NSArray *)options
                       andSelectedIndex:(NSNumber *)index;
- (void) setFontSize:(CGFloat)fontSize;
- (void) disableEditing;

@end