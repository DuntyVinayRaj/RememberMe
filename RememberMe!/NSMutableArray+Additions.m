//
//  NSMutableArray+Additions.m
//  RememberMe!
//
//  Created by Vinay Raj on 28/07/14.
//  Copyright (c) 2014 Vinay Raj. All rights reserved.
//

#import "NSMutableArray+Additions.h"

@implementation NSMutableArray (RemMeAdditions)

-(id)randomObject
{
    uint32_t rnd = arc4random_uniform([self count]);
    return [self objectAtIndex:rnd];
}

@end
