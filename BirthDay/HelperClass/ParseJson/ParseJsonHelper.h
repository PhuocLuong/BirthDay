//  Created by Phuoc on 11/19/13.
//  Copyright (c) 2013 Phuoc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShopCard;

@interface ParseJsonHelper : NSObject

- (NSMutableArray *) parseJsonShopCards:(NSData *)data;

@end
