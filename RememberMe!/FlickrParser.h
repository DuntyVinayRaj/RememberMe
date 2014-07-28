//
//  FlickrParser.h
//  RememberMe!
//
//  Created by Vinay Raj on 28/07/14.
//  Copyright (c) 2014 Vinay Raj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrParser : NSObject

+(NSMutableArray*)getParsedFlickrPhotos : (NSDictionary*)response;

@end
