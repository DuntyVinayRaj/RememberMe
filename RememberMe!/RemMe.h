//
//  RemMe.h
//  RememberMe!
//
//  Created by Vinay Raj on 28/07/14.
//  Copyright (c) 2014 Vinay Raj. All rights reserved.
//

#ifndef RememberMe__RemMe_h
#define RememberMe__RemMe_h


#define VERBOSE_LOGS

// For writing pretty logs that can be removed easily while releasing

#ifdef DEBUG
#ifdef VERBOSE_LOGS
#define DLog(fmt, ...)  NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...) NSLog(__VA_ARGS__)
#endif
#else
#	define DLog(...)
#endif

// Server URL
#ifdef DEBUG
#define API_URL @"https://api.flickr.com/services/feeds/photos_public.gne"
#else
#define API_URL @"https://api.flickr.com/services/feeds/photos_public.gne"
#endif


// Hardware Detection Macros

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0f)


// Frameworks
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/SDWebImageManager.h>
#import "RemMeServices.h"
#import "RemMeHelper.h"

// Image count
#define Image_Count 9

// Timer Count
#define Timer_Count 15

// Error Domain
#define ERROR_DOMAIN @"com.RemMe.error"

#endif
