//
//  RemMeServices.m
//  RememberMe!
//
//  Created by Vinay Raj on 28/07/14.
//  Copyright (c) 2014 Vinay Raj. All rights reserved.
//

#import "RemMeServices.h"
#import "FlickrParser.h"

@implementation RemMeServices

+ (RemMeServices *)sharedClient {
    static RemMeServices *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[RemMeServices alloc]init];
    });
    
    return _sharedClient;
}


-(void)getPublicImagesFromFlickrWithSuccessCallBack : (void (^)(NSMutableArray *flickrPhotos))success
                                        failureBack : (void(^)(NSError *error))failure
{
    
    NSDictionary *params = @{
                                @"nojsoncallback" : @"1",
                                @"format" : @"json"
                            };
    
    NSString *path = [NSString stringWithFormat:@"%@?%@", API_URL, [RemMeHelper stringBySerializingQueryParameters:params]];
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    // Adding content types that can be accepted in the response as x-javascript by default is not acceptable
    NSMutableSet *contentTypes =  [operation.responseSerializer.acceptableContentTypes mutableCopy];
    [contentTypes addObject:@"application/x-javascript"];
    operation.responseSerializer.acceptableContentTypes = [contentTypes copy];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        DLog(@"Log : The response obtained is - %@", responseObject);
        
        // Pass the response to the parser and send the result in the callback
        success( [FlickrParser getParsedFlickrPhotos:responseObject] );
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        DLog(@"Log : The response obtained is - %@", error);
        
        if( error.code == -1009 )
            failure([RemMeHelper getCustomErrorWithMessage:@"You dont seem to be connected to internet" withCode:100]);
        else
        {
            if( error.code == 3840 )
            {
                // This is to handle the invalid JSON format being sent as response from the Flicker Server. Invalid escape sequence being added which cannot be JSON parsed. Happening with plain NSURLConnectionDelegate too. So not the problem with response serializer of AFNetworking
                
                [self getPublicImagesFromFlickrWithSuccessCallBack:success failureBack:failure];
            }
            else
            {
                failure (error);
            }
        }
    }];
 
    [operation start];
}

@end
