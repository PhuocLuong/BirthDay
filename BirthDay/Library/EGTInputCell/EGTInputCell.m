
/************************************************
 *
 *	EGTInputCell.m
 *	Project: Valet Up
 *	Copyright © 2013 Evil Genius Technologies, LLC.  All Rights Reserved.
 *	v1.0.3 2013-09-26 by Jesse Lawler
 *
 ************************************************/


#import "EGTInputCell.h"
#import "EGTInputCellHelper.h"

#define kPostNotificationEGTInputCellDidBecomeFirstResponder        @"EGTInputCellDidBecomeFirstResponder"


@interface EGTInputCell()

- (void) handleNotification:(NSNotification *)notification;
- (void) presentMultipleChoiceOptions;
- (NSObject *) displayValue;
- (void) setValue:(NSObject *)object;
- (void) toggleValue;

@end


@implementation EGTInputCell

@synthesize type                            = _type;
@synthesize viewForActionSheetsiPhone       = _viewForActionSheetsiPhone;
@synthesize containingTableView             = _containingTableView;
@synthesize indexPath                       = _indexPath;
@synthesize objectStoringActiveIndexPath    = _objectStoringActiveIndexPath;
@synthesize valueChangedObserver            = _valueChangedObserver;
@synthesize selectorToObserveValueChanged   = _selectorToObserveValueChanged;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        // Initialization code
    }
    return self;
}


- (void) setSelected:(BOOL)selected
{
    // Always use the animated version of this method...
    [self setSelected:selected animated:YES];
}


- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if ([self type] == InputCellBoolean)
    {
        [self toggleValue];
    }
}


- (void) awakeFromNib
{
    _valueTextField.returnKeyType = UIReturnKeyDone;
    
    if ([UIDevice iPhone])
    {
        // Make some minor adjustments if we're on an iPhone (the XIB was designed for iPad)
        [self setFontSize:18];
        _labelLabel.center = CGPointMake(_labelLabel.center.x - 6, _labelLabel.center.y);
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:kPostNotificationEGTInputCellDidBecomeFirstResponder
                                               object:nil];
}


- (void) dealloc
{
    NSLog(@"dealloc in %@", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    

    
    // retained objects
    _object = nil;
    _multipleChoiceOptions = nil;
    
    self.indexPath = nil;
}


#pragma mark - User Interaction Methods


- (IBAction)didTouchCell:(id)sender
{
    [_valueTextField becomeFirstResponder];
}


#pragma mark - UIActionSheetDelegate Methods


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        // 'Cancel' was clicked; do nothing
    }
    else
    {
        if (buttonIndex < _multipleChoiceOptions.count && buttonIndex >= 0)
        {
            NSObject *chosenObject = [_multipleChoiceOptions objectAtIndex:buttonIndex];
            [self setValue:chosenObject];
        }
        
        [self refresh];
    }
}


#pragma mark - UITextFieldDelegate Methods


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL shouldShowKeyboard = NO;
    
    SEL selectorForSetActiveIndexPath = sel_registerName("setActiveIndexPath:");
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"

    [self.objectStoringActiveIndexPath performSelector:selectorForSetActiveIndexPath withObject:self.indexPath];
    #pragma clang diagnostic pop
    switch ([self type])
    {
        case InputCellBoolean:
            
            [self toggleValue];
            shouldShowKeyboard = NO;
            break;
            
        case InputCellString:
            
            shouldShowKeyboard =  YES;
            break;
            
        case InputCellInteger:
            
            shouldShowKeyboard =  YES;
            break;
            
        case InputCellDouble:
            
            shouldShowKeyboard =  YES;
            break;
            
        case InputCellMultipleChoice:
            
            [self presentMultipleChoiceOptions];
            shouldShowKeyboard =  NO;
            break;
            
        default:
            
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPostNotificationEGTInputCellDidBecomeFirstResponder
                                                        object:self];
    
    return shouldShowKeyboard;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (_type)
    {
        case InputCellDouble:
            
            [self setValue:[NSNumber numberWithDouble:[_valueTextField.text doubleValue]]];
            break;
            
        case InputCellInteger:
            
            [self setValue:[NSNumber numberWithInt:[_valueTextField.text intValue]]];
            break;
            
        default:
            
            [self setValue:_valueTextField.text];
            break;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_valueTextField resignFirstResponder];
    return YES;
}


#pragma mark - Public Setter Methods


- (void) setType:(enum EGTInputCellType)type
{
    _type = type;
}


- (void) refresh
{
    switch ([self type])
    {
        case InputCellNoTypeSet:
            
            self.accessoryType = UITableViewCellAccessoryNone;
            NSLog(@"Warning : EGTInputCell.m - No type has been set for this cell - remedy this before it is used...");
            break;
            
        case InputCellBoolean:
            
            if ([(NSNumber *)[self displayValue] boolValue])
            {
                self.accessoryType = UITableViewCellAccessoryCheckmark;
                _valueTextField.text = @"Yes";
            }
            else
            {
                self.accessoryType = UITableViewCellAccessoryNone;
                _valueTextField.text = @"No";
            }
            
            break;
            
        case InputCellString:
            
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            _valueTextField.text = (NSString *)[self displayValue];
            _valueTextField.keyboardType = UIKeyboardTypeAlphabet;
            
            break;
            
        case InputCellInteger:
            
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            _valueTextField.text = [NSString stringWithFormat:@"%d", [(NSNumber *)[self displayValue] integerValue]];
            _valueTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
            
        case InputCellDouble:
            
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            _valueTextField.text = [NSString stringWithFormat:@"%0.4f", [(NSNumber *)[self displayValue] doubleValue]];
            _valueTextField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
            
        case InputCellMultipleChoice:
            
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if ([self displayValue])
            {
                _valueTextField.text = [[EGTInputCellHelper instance] displayValue:[self displayValue]];
            }
            else
            {
                // auto-select the first object when the options only contain one object.
                if (_multipleChoiceOptions.count == 1)
                {
                    _valueTextField.text = [[EGTInputCellHelper instance] displayValue:[_multipleChoiceOptions objectAtIndex:0]];
                    [self setValue:[_multipleChoiceOptions objectAtIndex:0]];
                }
            }
            break;
            
        default:
            
            break;
    }
    
    // Kill the right-facing arrows - FIX - Decide in v1.2 if this should be the official choice
    if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator)
    {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}


- (void) setObject:(NSObject *)object
{
    if (_object)
        _object = nil;
    
    _object = object;
    
    [self refresh];
}


- (void) setLabel:(NSString *)name
{
    _labelLabel.text = name;
}

- (void) setPlaceholder:(NSString *)name
{
    _valueTextField.text = [name lowercaseString];
}


- (void) setAutoCapitalizationType:(UITextAutocapitalizationType)autocapitalizationType
{
    _valueTextField.autocapitalizationType = autocapitalizationType;
}


- (void) setGetDisplayValueMethod:(SEL)selector
{
    if ([_object respondsToSelector:selector])
    {
        _selectorToGetDisplayValue = selector;
    }
}


- (void) setSetValueMethod:(SEL)selector
{
    if ([_object respondsToSelector:selector])
    {
        _selectorToSetValue = selector;
    }
}


- (void) setAsMultipleChoiceWithOptions:(NSArray *)options
                       andSelectedIndex:(NSNumber *)index
{
    _type = InputCellMultipleChoice;
    
    _multipleChoiceOptions = nil;
    _multipleChoiceOptions = options;
    
    NSObject *selectedObject = nil;
    
    if (index != nil)
    {
        if ([index intValue] < _multipleChoiceOptions.count)
        {
            selectedObject =  [_multipleChoiceOptions objectAtIndex:[index intValue]];
        }
    }
    else if (_multipleChoiceOptions.count == 1) // there is only one option
    {
        selectedObject = [_multipleChoiceOptions objectAtIndex:0];
    }
    else // index == nil
    {
        _valueTextField.text = nil;
    }
    
    if (selectedObject)
    {
        _valueTextField.text = [[EGTInputCellHelper instance] displayValue:selectedObject];
    }
}


- (void) setFontSize:(CGFloat)fontSize
{
    [_labelLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [_valueTextField setFont:[UIFont systemFontOfSize:fontSize]];
}


- (void) disableEditing
{
    self.userInteractionEnabled = NO;
}


#pragma mark - Private Methods


- (void) handleNotification:(NSNotification *)notification
{
    if ((EGTInputCell *)[notification object] != self)
    {
        [_valueTextField resignFirstResponder];
    }
}


- (void) presentMultipleChoiceOptions
{
    UIActionSheet *multipleChoiceActionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Choose a %@", _labelLabel.text]
                                                                           delegate:self
                                                                  cancelButtonTitle:nil
                                                             destructiveButtonTitle:nil
                                                                  otherButtonTitles:nil];
    
    for (NSObject *choice in _multipleChoiceOptions)
    {
        if ([choice isKindOfClass:[NSString class]])
        {
            [multipleChoiceActionSheet addButtonWithTitle:(NSString*)choice];
        }
        else
        {
            if ([choice respondsToSelector:@selector(name)])
            {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [multipleChoiceActionSheet addButtonWithTitle:[choice performSelector:@selector(name)]];
                #pragma clang diagnostic pop
            }
        }
    }
    
    // Also add a cancel button
    [multipleChoiceActionSheet addButtonWithTitle:@"Cancel"];
    
    if ([UIDevice iPhone])
    {
        [multipleChoiceActionSheet showInView:_viewForActionSheetsiPhone];
    }
    else
    {
        [multipleChoiceActionSheet showFromRect:self.frame
                                         inView:_containingTableView
                                       animated:YES];
    }
}


- (NSObject *) displayValue
{
    if (_selectorToGetDisplayValue)
    {
        if ([_object respondsToSelector:_selectorToGetDisplayValue])
        {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            return [_object performSelector:_selectorToGetDisplayValue];
            #pragma clang diagnostic pop
            
        }
        else return nil;
    }
    else
    {
        NSLog(@"EGTInputCell instance has no value set for _selectorToGetDisplayValue");
        return nil;
    }
}


- (void) setValue:(NSObject *)object
{
    if (_selectorToSetValue)
    {
        if ([_object respondsToSelector:_selectorToSetValue])
        {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [_object performSelector:_selectorToSetValue withObject:object];
            #pragma clang diagnostic pop
            //if the cell has a connector, let's fuck it.
            if (self.selectorToObserveValueChanged && self.valueChangedObserver)
            {
                if ([self.valueChangedObserver respondsToSelector:self.selectorToObserveValueChanged])
                {
                    #pragma clang diagnostic push
                    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [self.valueChangedObserver performSelector:self.selectorToObserveValueChanged withObject:object];
                    #pragma clang diagnostic pop
                }
            }
        }
    }
    else
        NSLog(@"EGTInputCell instance has no value set for _selectorToSetValue");
}


- (void) toggleValue
{
    if ([self type] == InputCellBoolean)
    {
        [self setValue:[NSNumber numberWithBool:[(NSNumber *)[self displayValue] boolValue]]];
        [self refresh];
    }
}


@end