//
//  RemMeHelper.h
//  RememberMe!
//
//  Created by Vinay Raj on 28/07/14.
//  Copyright (c) 2014 Vinay Raj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemMeHelper : NSObject

NSString* RemMe_wideNonWideSegue(NSString *segueName);
+(void)displayAlertWithTitle:(NSString*)titleString
                 messageBody:(NSString*)body
              viewController:(UIViewController*)controller
              cancelBtnTitle:(NSString*)cancelBtnTitle;

+ (NSString *)stringBySerializingQueryParameters:(NSDictionary *)queryParameters;
+ (void)downloadImageWithURLString:(NSString *)urlString completion:(void (^)(UIImage *image, NSError *error))completion;
+(NSError*)getCustomErrorWithMessage:(NSString*)errMsg withCode:(NSUInteger)code;

@end
