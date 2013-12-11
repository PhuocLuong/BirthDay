//  Created by Phuoc on 11/19/13.
//  Copyright (c) 2013 Phuoc. All rights reserved.
//

#import "ParseJsonHelper.h"
#import "ShopCard.h"

@implementation ParseJsonHelper

- (NSMutableArray *) parseJsonShopCards:(NSData *)data
{
    NSError* error;
    NSArray *shopCardArray = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
    
    NSMutableArray * results    = [NSMutableArray array];
    
    for (NSDictionary *shopCard in shopCardArray)
    {
        ShopCard *sc            = [[ShopCard alloc] init];
        
        sc.iD                   = [[shopCard objectForKey:kIDShopCard] integerValue];
        sc.merchant_id          = [[shopCard objectForKey:kMerchantID] integerValue];
        sc.merchant_name        = [shopCard objectForKey:kMerchantName];
        
        sc.card_currency_code           = [shopCard objectForKey:kCardCurrencyCode];
        sc.opening_balance              = [[shopCard objectForKey:kOpeningBalance] integerValue];
        sc.cover_image_url_hd           = [shopCard objectForKey:kCoverImageUrlHD];
        sc.merchant_icon_image_url_hd   = [shopCard objectForKey:kMerchantIconImageUrlHD];
        
        [results addObject:sc];
    }
    return results;
}


@end
