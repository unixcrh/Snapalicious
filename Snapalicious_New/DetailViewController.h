//
//  DetailViewController.h
//  FoodSnap
//
//  Created by Carlotta Tatti on 31/10/12.
//
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "MDCParallaxView.h"
#import "TPComposeView.h"

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapHeight;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profileImage;

@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *fbButton;
@property (weak, nonatomic) IBOutlet UIButton *twButton;

@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;

@property (strong, nonatomic) MDCParallaxView *parallaxView;
@property (strong, nonatomic) Dish *detailItem;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSMutableArray *postActivitiesArray;
@property (strong, nonatomic) NSArray *likes;
@property (strong, nonatomic) NSMutableArray *activityArray;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) SLComposeViewController *controller;

@property (nonatomic) int requestsCount;

- (IBAction)postOnTwitter:(id)sender;
- (IBAction)postOnFB:(id)sender;

- (IBAction)addToSnapalicious:(id)sender;
- (IBAction)showUserProfile:(id)sender;

- (IBAction)writeRecipe:(id)sender;
- (IBAction)askRecipe:(id)sender;

- (IBAction)dismiss:(id)sender;

@end
