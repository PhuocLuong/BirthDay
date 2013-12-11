//  Created by Phuoc on 11/19/13.
//  Copyright (c) 2013 Phuoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPRequestHelper : NSObject

- (NSData *) sendRequestWithMethod:(NSString *)nameMethod;

- (void) postRequestWithMethod:(NSString *)nameMethod withParametersBody:(NSString *)params;

- (NSString *) setParametersBody:(NSString *)cardID withEmail:(NSString *)email;

@end
