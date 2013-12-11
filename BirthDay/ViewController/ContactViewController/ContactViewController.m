//  Created by Phuoc on 11/5/13.
//  Copyright (c) 2013 Phuoc. All rights reserved.
//

#import "ContactViewController.h"

#import <AddressBook/AddressBook.h>
#import "EGTInputCellHelper.h"
#import <AddressBookUI/AddressBookUI.h>

#import "EGTInputCell.h"
#import "Contact.h"
#import "MBProgressHUD.h"


@interface ContactViewController ()<ABNewPersonViewControllerDelegate, MBProgressHUDDelegate>
{
//    NSArray *fields;
    NSArray *sel_SetValue;
    NSArray *sel_GetValue;
    
    NSMutableArray *names;
    NSMutableArray *birthdays;
}

// Handle Keyboard
- (void) handleKeyboardAppearance;
- (void) handleKeyboardDisappearance;

@end

@implementation ContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title             = @"Contacts";
        UIImage *homeImage     = [UIImage imageNamed:@"Home.png"];
        self.tabBarItem.image  = homeImage;
        
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                     target:self
                                     action:@selector(Add:)];
        self.navigationItem.rightBarButtonItem = rightBar;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setValueDefault];
    [self notificationCenter];
    [self getContacts];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_table reloadData];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [names count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InputCell";
    
    EGTInputCell *cell = (EGTInputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EGTInputCell"
                                                     owner:self
                                                   options:nil];
        cell            = [nib firstObject];
    }
    
    cell.type       = InputCellString;
    cell.indexPath  = indexPath;
    cell.objectStoringActiveIndexPath = self;
    
    [cell setLabel:[names objectAtIndex:indexPath.row]];
    [cell setPlaceholder:[birthdays objectAtIndex:indexPath.row]];
    
    if (!HUD.isHidden)
    {
        [HUD hide:YES];
    }
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:_table
                      cellForRowAtIndexPath:indexPath];
    if ([cell class] == [EGTInputCell class])
    {
        [cell setSelected:YES animated:YES];
    }
}


#pragma mark - IBAction Methods

-(IBAction)Add:(id)sender
{
    [self addContact];
    /*
    EKEventStore *_eventStore = [[EKEventStore alloc] init];
    [_eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (granted)
        {
            [_eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
                if (granted)
                {
                    EKEventStore * eventStore = [[EKEventStore alloc] init];
                    
                    EKEvent * event = [EKEvent eventWithEventStore:eventStore];
                    event.title     = @"test";
                    event.startDate = [[NSDate alloc] init];
                    event.endDate   = [[NSDate alloc] init];
                    event.notes     = @"note";
                    
                    EKEventEditViewController *controller = [[EKEventEditViewController alloc] init];
                    
                    controller.eventStore       = eventStore;
                    controller.event            = event;
                    controller.editViewDelegate = self;
                    
                    [self presentViewController:controller animated:YES completion:nil];
                }
            }];
        }
    }];
     */
}


#pragma mark - Private Methods

- (void) setValueDefault
{
    sel_SetValue    = [NSArray arrayWithObjects:@"setBirthday:", nil];
    sel_GetValue    = [NSArray arrayWithObjects:@"birthday", nil];
    
    names       = [NSMutableArray new];
    birthdays   = [NSMutableArray new];
}


- (void) notificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardAppearance)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDisappearance)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


- (void) getContacts
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
        || ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        HUD             = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText   = @"Loading";
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
                                                 {
                                                     CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
                                                     CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBookRef);
                                                     
                                                     for(int i = 0; i < numberOfPeople; i++)
                                                     {
                                                         ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
                                                         if (ABRecordCopyValue(person, kABPersonBirthdayProperty))
                                                         {
                                                             NSString    *firstName   = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
                                                             NSString    *lastName    = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
                                                             NSDate      *birthDay    = (__bridge NSDate *)(ABRecordCopyValue(person, kABPersonBirthdayProperty));
                                                             
                                                             
                                                             NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                                                             if (!firstName && !lastName)
                                                             {
                                                                 name = @"No Name";
                                                             }
                                                             [names addObject:name];
                                                             NSString *stringBirthday = [NSDateFormatter localizedStringFromDate:birthDay dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
                                                             [birthdays addObject:stringBirthday];
                                                             [_table reloadData];
                                                         }
                                                     }
                                                 });
    }
    else
    {
        [kAppDelegate showAlertView:@"You denied to access contacts!"
                        withMessage:@"Turn on: Setting -> Privacy -> Contacts."
                             inView:self.view];
    }
}


- (void) addContact
{
    ABNewPersonViewController *view = [[ABNewPersonViewController alloc] init];
    view.newPersonViewDelegate      = self;
    
    UINavigationController *newNavigationController = [[UINavigationController alloc]
                                                       initWithRootViewController:view];
    [self presentViewController:newNavigationController
                            animated:YES completion:nil];
   /*
    ABRecordRef person = ABPersonCreate();
    
    // set name and other string values
    NSString *venueName = @"venueName";
    NSString *venueUrl = @"venueUrl";
    NSString *venueEmail = @"venueEmail";
    NSString *venuePhone = @"venuePhone";
    NSString *venueAddress1 = @"venueAddress1";
    NSString *venueAddress2 = @"venueAddress2";
    NSString *venueState = @"venueState";
     NSString *venueCity = @"venueCity";
     NSString *venueZip = @"venueZip";
    NSString *venueCountry = @"venueCountry";
    ABRecordSetValue(person, kABPersonOrganizationProperty, (__bridge CFStringRef) venueName, NULL);
    
    if (venueUrl)
    {
        ABMutableMultiValueRef urlMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(urlMultiValue, (__bridge CFStringRef) venueUrl, kABPersonHomePageLabel, NULL);
        ABRecordSetValue(person, kABPersonURLProperty, urlMultiValue, nil);
        CFRelease(urlMultiValue);
    }
    
    if (venueEmail)
    {
        ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFStringRef) venueEmail, kABWorkLabel, NULL);
        ABRecordSetValue(person, kABPersonEmailProperty, emailMultiValue, nil);
        CFRelease(emailMultiValue);
    }
    
    if (venuePhone)
    {
        ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        NSArray *venuePhoneNumbers = [venuePhone componentsSeparatedByString:@" or "];
        for (NSString *venuePhoneNumberString in venuePhoneNumbers)
            ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFStringRef) venuePhoneNumberString, kABPersonPhoneMainLabel, NULL);
        ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
        CFRelease(phoneNumberMultiValue);
    }
    
    // add address
    
    ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    
    if (venueAddress1)
    {
        if (venueAddress2)
            addressDictionary[(NSString *) kABPersonAddressStreetKey] = [NSString stringWithFormat:@"%@\n%@", venueAddress1, venueAddress2];
        else
            addressDictionary[(NSString *) kABPersonAddressStreetKey] = venueAddress1;
    }
    if (venueCity)
        addressDictionary[(NSString *)kABPersonAddressCityKey] = venueCity;
    if (venueState)
        addressDictionary[(NSString *)kABPersonAddressStateKey] = venueState;
    if (venueZip)
        addressDictionary[(NSString *)kABPersonAddressZIPKey] = venueZip;
    if (venueCountry)
        addressDictionary[(NSString *)kABPersonAddressCountryKey] = venueCountry;
    
    ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFDictionaryRef) addressDictionary, kABWorkLabel, NULL);
    ABRecordSetValue(person, kABPersonAddressProperty, multiAddress, NULL);
    CFRelease(multiAddress);
    
    // let's show view controller
    
    ABUnknownPersonViewController *controller = [[ABUnknownPersonViewController alloc] init];
    
    controller.displayedPerson = person;
    controller.allowsAddingToAddressBook = YES;
    
    // current view must have a navigation controller
    
    [self.navigationController pushViewController:controller animated:YES];
    
    CFRelease(person);
    */
}


- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    if (person)
    {
        if (ABRecordCopyValue(person, kABPersonBirthdayProperty))
        {
            NSString    *firstName   = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            NSString    *lastName    = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
            NSDate      *birthDay    = (__bridge NSDate *)(ABRecordCopyValue(person, kABPersonBirthdayProperty));
            
            NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            if (!firstName && !lastName)
            {
                name = @"No Name";
            }
            [names addObject:name];
            NSString *stringBirthday = [NSDateFormatter localizedStringFromDate:birthDay dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
            [birthdays addObject:stringBirthday];
            [_table reloadData];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Handle Keyboard

- (void) handleKeyboardAppearance
{
    [[EGTInputCellHelper instance] handleKeyboardAppearanceOverViewController:self
                                                               affectingTable:_table
                                                    withActiveCellAtIndexPath:self.activeIndexPath];
}


- (void) handleKeyboardDisappearance
{
    [[EGTInputCellHelper instance] handleKeyboardDisappearanceOverViewController:self
                                                                  affectingTable:_table
                                                       withActiveCellAtIndexPath:self.activeIndexPath];
}


#pragma mark - MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    HUD = nil;
}

@end
