//
//  YouViewController.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 03/12/12.
//
//


#import <UIKit/UIKit.h>
#import "UIImage+StackBlur.h"
#import "HMSegmentedControl.h"
#import "RoundProfilePictureView.h"

@interface YouViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet RoundProfilePictureView *userPicture;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *selectedFriends;

@property (nonatomic, strong) NSArray *dishesArray;
@property (nonatomic, strong) NSArray *recipesArray;
@property (nonatomic, strong) NSArray *favsArray;

@property (nonatomic) int indexPosts;
@property (nonatomic) int indexRecipes;
@property (nonatomic) int indexFavs;

@property (nonatomic, strong) FBFriendPickerViewController *friendPicker;
@property (nonatomic, strong) NSString *followStatus;
@property (nonatomic, strong) PFObject *selectedObject;
@property (nonatomic, strong) PFUser *user;

@property (nonatomic) float progress;

- (IBAction)logout:(id)sender;
- (IBAction)follow:(id)sender;

@end
