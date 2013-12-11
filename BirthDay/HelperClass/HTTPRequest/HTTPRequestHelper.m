//  Created by Phuoc on 11/19/13.
//  Copyright (c) 2013 Phuoc. All rights reserved.
//

#import "HTTPRequestHelper.h"
#import <CommonCrypto/CommonDigest.h>


@implementation HTTPRequestHelper
{
    NSURLConnection *connection;
    NSMutableData *buffers;
}


- (NSData *) sendRequestWithMethod:(NSString *)nameMethod
{
    int currentTime         = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp     = [NSString stringWithFormat:@"%i", currentTime];
    NSString *stringToSign  = [NSString stringWithFormat:@"%@%@%@", API_KEY, API_SECRET,timestamp];
    
    NSString *signature     = [self sha256HashFor:stringToSign];
    
    NSString *fullURLString = [NSString stringWithFormat:@"http://sandbox.gyft.com/v1/reseller/%@?api_key=%@&sig=%@",
                               nameMethod, API_KEY, signature];
    
    NSURL *URL              = [NSURL URLWithString:fullURLString];
    
    // Send a synchronous request
    NSMutableURLRequest *request    = [NSMutableURLRequest requestWithURL:URL];
    [request addValue:timestamp forHTTPHeaderField:@"x-sig-timestamp"];
    
    NSURLResponse * response    = nil;
    NSError * error             = nil;
    NSData * data               = [NSURLConnection sendSynchronousRequest:request
                                                        returningResponse:&response
                                                                    error:&error];
    if (error == nil)
    {
        return data;
    }
    else
    {
        return nil;
    }
}



- (void) postRequestWithMethod:(NSString *)nameMethod withParametersBody:(NSString *)params
{
    int currentTime         = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp     = [NSString stringWithFormat:@"%i", currentTime];
    NSString *stringToSign  = [NSString stringWithFormat:@"%@%@%@", API_KEY, API_SECRET,timestamp];
    
    NSString *signature     = [self sha256HashFor:stringToSign];
    
    NSString *strUrl = [NSString stringWithFormat:@"http://sandbox.gyft.com/v1/reseller/%@?api_key=%@&sig=%@",
                        nameMethod, API_KEY, signature];
    
    NSMutableURLRequest *request    = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    request.HTTPMethod              = @"POST";
    
    [request setValue:timestamp forHTTPHeaderField:@"x-sig-timestamp"];
    
    NSString* str = params;
    
    [request setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse * response    = nil;
    NSError * error             = nil;
    
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    if (error == nil)
    {
        if(data != nil)
        {
            NSError *errorJson = nil;
            
            NSDictionary* json =[NSJSONSerialization
                                 JSONObjectWithData:data
                                 options:kNilOptions
                                 error:&errorJson];
            
            if(errorJson != nil)
            {
                NSLog(@"json error:%@",errorJson);
            }
            else
            {
                NSLog(@"%@", json);
            }
        }
    }
}


- (NSString *) setParametersBody:(NSString *)cardID withEmail:(NSString *)email
{
    return [NSString stringWithFormat:@"shop_card_id=%@&to_email=%@", cardID, email];
}




- (NSString *) sha256HashFor:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

@end
