//
//  HomeController.m
//  RememberMe!
//
//  Created by Vinay Raj on 28/07/14.
//  Copyright (c) 2014 Vinay Raj. All rights reserved.
//

#import "HomeController.h"
#import "FlickrPhotoCell.h"
#import "FlickrPhoto.h"
#import "UIImageView+AFNetworking.h"
#import "NSMutableArray+Additions.h"


@interface HomeController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSMutableArray *photos;
@property (weak, nonatomic) IBOutlet UICollectionView *vwCollectionFlickrPhotos;
@property (assign) int imagesDownloaded;
@property (nonatomic, strong)NSTimer *timer;
@property (assign) BOOL showOverLay;

// View elements used for count down
@property (weak, nonatomic) IBOutlet UILabel *lblCountDown;
@property (weak, nonatomic) IBOutlet UIView *vwCountDown;

// Elements used for representing random selected image
@property (weak, nonatomic) IBOutlet UIView *vwSelectedImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgVwSelectedImage;
@property (nonatomic, strong) FlickrPhoto *selectedPhoto;

// Elements for representing view consisting play again and attempts taken
@property (nonatomic, strong)NSMutableArray *unrevealedObjects;
@property (weak, nonatomic) IBOutlet UIView *vwPlayAgain;
@property (weak, nonatomic) IBOutlet UILabel *lblAttempts;
@property (nonatomic, assign) int attempts;

@end

@implementation HomeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setUp];
    [[RemMeServices sharedClient] getPublicImagesFromFlickrWithSuccessCallBack:^(NSMutableArray *flickrPhotos)
     {
        self.photos = [flickrPhotos mutableCopy];
        self.unrevealedObjects = [flickrPhotos mutableCopy];
         
        [self.vwCollectionFlickrPhotos reloadData];
        
    }failureBack:^(NSError *error)
    {
        // Generic failure case handling for all kinds of failures. Failures can be more descriptive based on the codes.
        
        NSString *errMsg;
        if( error.code == 100 )
            errMsg = error.localizedDescription;
        else
            errMsg = @"Problem loading the dashboard. Would you please try again.";
        
        [RemMeHelper displayAlertWithTitle:@"Error" messageBody:errMsg viewController:self cancelBtnTitle:@"Ok"];
        
    }];
}

-(void)setUp
{
    // Setting up the objects and variables needed to load images into dashboard
    
    if( self.unrevealedObjects != nil )
    {
        [self.unrevealedObjects removeAllObjects];
        self.unrevealedObjects = nil;
    }
    self.unrevealedObjects = [[NSMutableArray alloc]init];
    
    self.attempts = 0;
    self.showOverLay = NO;
    
    if( self.photos != nil )
    {
        [self.photos removeAllObjects];
        self.photos = nil;
    }
    
    // Used to keep track of asynchronous image downloads to start the timer after all are downloaded
    self.imagesDownloaded = 0;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collection view delegates

/*--------------------------------- Delegates for UICollection view for dashboard --------------------------------*/

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FlickrPhotoCell *cell = (FlickrPhotoCell*)[cv dequeueReusableCellWithReuseIdentifier:@"flickrcell" forIndexPath:indexPath];
    FlickrPhoto *photo = (FlickrPhoto*)self.photos[indexPath.row];
    
    if( self.showOverLay )
    {
        [cell.overlay setHidden:NO];
        cell.lblPosition.text = [NSString stringWithFormat:@"Position-%ld", (long)indexPath.row+1];
    }
    else
    {
        [cell.overlay setHidden:YES];
        [self downloadImageWithString:photo.media inCell:cell];
    }
    
    return cell;
}


-(void)downloadImageWithString : (NSString*)urlstring inCell : (FlickrPhotoCell*)cell
{
    [RemMeHelper downloadImageWithURLString:urlstring completion:^(UIImage *image, NSError *error)
     {
         if( error == nil )
         {
             self.imagesDownloaded++;
             cell.photo.image = image;
             
             if( self.imagesDownloaded >= Image_Count )
             {
                 // Initiate the timer to show count down
                 [self.activityIndicator stopAnimating];
                 [self startTimer];
             }
         }
         else
         {
             [self downloadImageWithString:urlstring inCell:cell];
         }
     }];
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.attempts++;
    if( self.selectedPhoto.tag == indexPath.row )
    {
        FlickrPhotoCell *cell = (FlickrPhotoCell*)[collectionView cellForItemAtIndexPath:indexPath];
        [cell.photo setImageWithURL:[NSURL URLWithString:self.selectedPhoto.media]];
        [cell.overlay setHidden:YES];
        
        [self removeTheObjectFromUnrevealedObjectArray];
        if( self.unrevealedObjects.count > 0  )
        {
            [self showRandomImage];
        }
        else
        {
            [self.vwSelectedImage setHidden:YES];
            [self.vwPlayAgain setHidden:NO];
            self.lblAttempts.text = [NSString stringWithFormat:@"%d", self.attempts];
        }
    }
    else
    {
        [RemMeHelper displayAlertWithTitle:@"Alert" messageBody:@"Oops.. Not this one.. Try a different location" viewController:nil cancelBtnTitle:@"Ok"];
    }
}


/* ----------------------------- Functions related to count down timer and flipping of images to detect them -------------------------------------------*/

-(void)startTimer
{
    if( self.timer != nil )
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [self.vwCountDown setHidden:NO];
    self.vwCountDown.tag = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

-(void)countDown
{
    self.vwCountDown.tag++;
    
    self.lblCountDown.text = [NSString stringWithFormat:@"Time Remaining : %lds", Timer_Count - self.vwCountDown.tag];
    
    if( self.vwCountDown.tag == Timer_Count )
    {
        [self hideImages];
        [self.vwCountDown setHidden:YES];
    }
}

-(void)hideImages
{
    [self.timer invalidate];
    self.timer = nil;
    
    self.showOverLay = YES;
    [self.vwCollectionFlickrPhotos reloadData];
    
    [self.vwSelectedImage setHidden:NO];
    [self showRandomImage];
}

/*--------------------- Functions to show random images and reload a fresh image after one is detected properly ---------------------------*/

-(void)showRandomImage
{
    self.selectedPhoto = [self.unrevealedObjects randomObject];
    [self.imgVwSelectedImage setImageWithURL:[NSURL URLWithString:self.selectedPhoto.media]];
}

-(void)removeTheObjectFromUnrevealedObjectArray
{
    int deleteIndex = 0;
    for( FlickrPhoto *photo in self.unrevealedObjects )
    {
        if( photo == self.selectedPhoto )
        {
            break;
        }
        deleteIndex++;
    }
    [self.unrevealedObjects removeObjectAtIndex:deleteIndex];
}


/*----------------------------------- Functions to handle game end logic -------------------------------------- */

- (IBAction)playAgainClicked:(id)sender {
    
    self.lblCountDown.text = @"Count Down";
    [self.activityIndicator startAnimating];
    [self clearCells];
    [self.vwCountDown setHidden:NO];
    [self.vwPlayAgain setHidden:YES];
    [self viewDidLoad];
}

-(void)clearCells
{
    for ( int i=0 ; i<self.photos.count; i++ )
    {
        FlickrPhotoCell *cell = (FlickrPhotoCell *)[self.vwCollectionFlickrPhotos cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        cell.photo.image = nil;
    }
}

/*--------------------------- Status bar rendering ---------------------*/

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
