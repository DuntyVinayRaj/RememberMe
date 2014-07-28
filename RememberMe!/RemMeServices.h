//
//  RemMeServices.h
//  RememberMe!
//
//  Created by Vinay Raj on 28/07/14.
//  Copyright (c) 2014 Vinay Raj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemMeServices : NSObject<NSURLConnectionDelegate>

@property (nonatomic, strong)NSMutableData *data;

+ (RemMeServices *)sharedClient;
-(void)getPublicImagesFromFlickrWithSuccessCallBack : (void (^)(NSMutableArray *flickrPhotos))success
                                        failureBack : (void(^)(NSError *error))failure;

@end
