//  Created by Phuoc on 11/10/13.
//  Copyright (c) 2013 Phuoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic, strong) NSString *birthday;

+ (Contact *) shareContactInstance;

- (id) init;
@end
