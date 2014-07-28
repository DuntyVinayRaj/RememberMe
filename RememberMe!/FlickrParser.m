//
//  FlickrParser.m
//  RememberMe!
//
//  Created by Vinay Raj on 28/07/14.
//  Copyright (c) 2014 Vinay Raj. All rights reserved.
//

#import "FlickrParser.h"
#import "FlickrPhoto.h"

@implementation FlickrParser

+(NSMutableArray*)getParsedFlickrPhotos : (NSDictionary*)response
{
    if( response[@"items"] != nil  )
    {
        NSMutableArray *flickrPublicPhotos = [[NSMutableArray alloc]init];
        int count= 0;
        
        for(NSDictionary *photo in response[@"items"])
        {
            // Get only 9 photos. Break the loop thereafter
            if( flickrPublicPhotos.count >= Image_Count )
            {
                break;
            }
            
            // Parsing the response and mapping to array of flicker modal objects
            FlickrPhoto *flickrPhoto = [[FlickrPhoto alloc]init];
            flickrPhoto.title = photo[@"title"];
            flickrPhoto.media = ((NSDictionary*)photo[@"media"])[@"m"];
            flickrPhoto.tag = count;
            [flickrPublicPhotos addObject:flickrPhoto];
            flickrPhoto = nil;
            count++;
        }
        return flickrPublicPhotos;
    }
    return nil;
}

@end
