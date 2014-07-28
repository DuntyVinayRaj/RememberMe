//
//  FlickrPhoto.m
//  RememberMe!
//
//  Created by Vinay Raj on 28/07/14.
//  Copyright (c) 2014 Vinay Raj. All rights reserved.
//

#import "FlickrPhoto.h"

@implementation FlickrPhoto

-(NSString*)description
{
    return [NSString stringWithFormat:@"Title : %@, Media : %@, Tag : %d", self.title, self.media, self.tag];
}

@end
