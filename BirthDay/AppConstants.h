//

//  Created by Phuoc on 11/10/13.
//  Copyright (c) 2013 Phuoc. All rights reserved.
//

#ifndef BirthDay_AppConstants_h
#define BirthDay_AppConstants_h

#define kAppDelegate	(AppDelegate *)[[UIApplication sharedApplication] delegate]

#define IS_IPHONE_5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define iOS            [[[UIDevice currentDevice] systemVersion] floatValue]


#define kUserDefaults               [NSUserDefaults standardUserDefaults]

#define kName           @"kName"
#define kBirthday       @"kBirthday"


//Gyft
#define API_KEY         @"ekntjgcq8qs7wn8mu2uhu7rk"
#define API_SECRET      @"rzP8gHcEhG"


// Shop Cards
#define kIDShopCard                 @"id"
#define kMerchantID                 @"merchant_id"
#define kMerchantName               @"merchant_name"

#define kCardCurrencyCode           @"card_currency_code"
#define kOpeningBalance             @"opening_balance"
#define kCoverImageUrlHD            @"cover_image_url_hd"
#define kMerchantIconImageUrlHD     @"merchant_icon_image_url_hd"

#endif
