//
//  RemMeHelper.m
//  RememberMe!
//
//  Created by Vinay Raj on 28/07/14.
//  Copyright (c) 2014 Vinay Raj. All rights reserved.
//

#import "RemMeHelper.h"

@implementation RemMeHelper

NSString* RemMe_wideNonWideSegue(NSString *segueName)
{
    NSString *segueName_ = segueName;
    if(IS_IPHONE_5)
        segueName_ = [segueName_ stringByAppendingFormat:@"Wide"];
    DLog(@"Log : Returning value - %@", segueName_);
    return segueName_;
}

// Function to display alert with options in any controller

+(void)displayAlertWithTitle:(NSString*)titleString
                 messageBody:(NSString*)body
              viewController:(UIViewController*)controller
              cancelBtnTitle:(NSString*)cancelBtnTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleString
                                                    message:body
                                                   delegate:controller
                                          cancelButtonTitle:cancelBtnTitle
                                          otherButtonTitles:nil];
    [alert show];
    alert = nil;
}

// Functions for url encoding the params used in API calls

+ (NSString *)stringBySerializingQueryParameters:(NSDictionary *)queryParameters
{
    NSMutableString *queryString = [[NSMutableString alloc] init] ;
    BOOL hasParameters = NO;
    if (queryParameters) {
        for (NSString *key in queryParameters) {
            if (hasParameters) {
                [queryString appendString:@"&"];
            }
            [queryString appendFormat:@"%@=%@",
             key,
             [self stringByURLEncodingString:queryParameters[key]]];
            hasParameters = YES;
        }
    }
    
    return [queryString copy] ;
}

+ (NSString*)stringByURLEncodingString:(NSString*)unescapedString {
    NSString* result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                             kCFAllocatorDefault,
                                                                                             (CFStringRef)unescapedString,
                                                                                             NULL, // characters to leave unescaped
                                                                                             (CFStringRef)@":!*();@/&?#[]+$,='%’\"",
                                                                                             kCFStringEncodingUTF8));
    return result;
}

// Image download manager

+ (void)downloadImageWithURLString:(NSString *)urlString completion:(void (^)(UIImage *image, NSError *error))completion
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    [manager downloadImageWithURL:[NSURL URLWithString:urlString]
                          options:SDWebImageCacheMemoryOnly
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageurl)
                        {
                            completion(image, error);
                        }];

}

+(NSError*)getCustomErrorWithMessage:(NSString*)errMsg withCode:(NSUInteger)code
{
    DLog(@"Log : The error message to be shown in the custom object is - %@", errMsg);
    NSMutableDictionary *details = [[NSDictionary dictionary] mutableCopy];
    [details setValue:errMsg forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:ERROR_DOMAIN code:code userInfo:details];
    
}

@end
