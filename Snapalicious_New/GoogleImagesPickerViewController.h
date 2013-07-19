//
//  GoogleImagesPickerViewController.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 10/04/13.
//
//

#import <UIKit/UIKit.h>
#import "MDCParallaxView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GoogleImagesPickerViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *resizedImage;
@property (strong, nonatomic) NSData *imageData;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *attributionLabel;
@property (weak, nonatomic) IBOutlet UITextView *infoView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) MDCParallaxView *parallaxView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIImagePickerController *cameraPicker;

- (IBAction)searchTapped:(id)sender;
- (IBAction)cameraTapped:(id)sender;
- (IBAction)libraryTapped:(id)sender;

- (IBAction)addLocation:(id)sender;
- (IBAction)removeLocation:(id)sender;

- (IBAction)dismiss:(id)sender;
- (IBAction)publish:(id)sender;

@end
