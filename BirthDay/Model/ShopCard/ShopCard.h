//  Created by Phuoc on 11/19/13.
//  Copyright (c) 2013 Phuoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCard : NSObject

@property (nonatomic, assign) NSInteger iD;
@property (nonatomic, assign) NSInteger merchant_id;
@property (nonatomic, strong) NSString *merchant_name;

@property (nonatomic, strong) NSString *card_currency_code;
@property (nonatomic, assign) NSInteger opening_balance;
@property (nonatomic, strong) NSString *cover_image_url_hd;
@property (nonatomic, strong) NSString *merchant_icon_image_url_hd;

@end
