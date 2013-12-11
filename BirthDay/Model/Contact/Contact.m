//  Created by Phuoc on 11/10/13.
//  Copyright (c) 2013 Phuoc. All rights reserved.
//

#import "Contact.h"

@implementation Contact

@synthesize birthday    = _birthday;


static Contact *_sharedInstance;

+ (Contact *) shareContactInstance
{
	if (!_sharedInstance)
	{
		_sharedInstance = [[Contact alloc] init];
	}
	
	return _sharedInstance;
}


- (id) init
{
	self = [super init];
    
    if (self)
	{
    }
    return self;
}



- (void) setBirthday:(NSString *)birthday
{
    _birthday = birthday;
}

- (NSString *) birthday
{
    return _birthday;
}

@end