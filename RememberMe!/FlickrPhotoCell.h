//
//  FlickrPhotoCell.h
//  RememberMe!
//
//  Created by Vinay Raj on 28/07/14.
//  Copyright (c) 2014 Vinay Raj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UIView *overlay;
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;

@end
