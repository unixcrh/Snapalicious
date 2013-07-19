//
//  GoogleImagesPickerViewController.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 10/04/13.
//
//

#import "GoogleImagesPickerViewController.h"
#import "GoogleImagesUtils.h"
#import "GoogleImageCell.h"

#import "UIImage+ResizeAdditions.h"

@interface GoogleImagesPickerViewController () {
    NSMutableArray *_objects;
    NSDictionary *_selectedItem;
    UIImage *_imageToUpload;
    PFGeoPoint *_location;
    NSString *_locationName;
    
    CGPoint svos;
}
@end

@implementation GoogleImagesPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dismissKeyboard {
    [self.infoView resignFirstResponder];
    [self.textField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    _objects = [NSMutableArray new];
    self.attributionLabel.text = @"";
    
    CGRect backgroundRect = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height);
    self.bgView.frame = backgroundRect;
        
    self.parallaxView = [[MDCParallaxView alloc] initWithBackgroundView:self.bgView foregroundView:self.contentView];
    
    self.parallaxView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44);
    self.parallaxView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.parallaxView.backgroundHeight = 200.0f;
    self.parallaxView.scrollView.showsVerticalScrollIndicator = NO;
    self.parallaxView.scrollView.showsHorizontalScrollIndicator = NO;
    self.parallaxView.scrollView.scrollsToTop = YES;
    self.parallaxView.scrollView.directionalLockEnabled = YES;
    CGSize contentSize = self.parallaxView.scrollView.contentSize;
    contentSize.height += 30;
    self.parallaxView.scrollView.contentSize = contentSize;
    self.parallaxView.scrollViewDelegate = self;

    self.bgView.image = [UIImage imageNamed:@"Camera"];
    self.bgView.contentMode = UIViewContentModeCenter;
    self.bgView.backgroundColor = [UIColor darkGrayColor];
    
    self.view = self.parallaxView;
    self.view.backgroundColor = self.contentView.backgroundColor;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.cameraPicker = [UIImagePickerController new];
    self.cameraPicker.delegate = self;
    self.cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.cameraPicker.editing = NO;
    
    self.imagePicker = [UIImagePickerController new];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.editing = NO;
}

- (IBAction)addLocation:(id)sender {
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            _location = geoPoint;
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:_location.latitude longitude:_location.longitude];
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                if (!error) {
                    CLPlacemark *placemark = [placemarks lastObject];
                    _locationName = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.administrativeArea];
                    self.locationLabel.text = _locationName;
                }
            }];
        }
    }];
}

- (IBAction)removeLocation:(id)sender {
    _location = nil;
    self.locationLabel.text = @"No location added";
}

- (void)findImagesWithTerm:(NSString *)searchTerm {
    [self.textField resignFirstResponder];
    
    [_objects removeAllObjects];
    NSArray *items = [GoogleImagesUtils getImagesForTerm:searchTerm];
    if (items) {
        for (NSDictionary *item in items) {
            [_objects addObject:item];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Can't find an image!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
    }

    
    [self.collectionView reloadData];
}

- (IBAction)searchTapped:(id)sender {
    if (self.textField.text.length != 0) {
        [self findImagesWithTerm:self.textField.text];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops!" message:@"You need to enter the name of dish before searching for images!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)cameraTapped:(id)sender {
    [self presentViewController:self.cameraPicker animated:YES completion:nil];
}

- (IBAction)libraryTapped:(id)sender {
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSData *)prepareImageForUpload:(UIImage *)theImage {
    // Resize the image to be square (what is shown in the preview)
    UIImage *resizedImage = [theImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                       bounds:CGSizeMake(640, 588)
                                         interpolationQuality:kCGInterpolationMedium];
    
    // Get an NSData representation of our images. We use JPEG for the larger image
    // for better compression and PNG for the thumbnail to keep the corner radius transparency
    return UIImageJPEGRepresentation(resizedImage, 0.8f);
}

- (IBAction)publish:(id)sender {
    if (self.textField.text.length != 0 && _imageToUpload != nil) {
        [SVProgressHUD show];
        self.view.userInteractionEnabled = NO;
        
        Dish *post = [Dish object];
        post.title = self.textField.text;
        post.author = [PFUser currentUser];
        post.momentThumb = [PFFile fileWithData:[self prepareImageForUpload:_imageToUpload]];
        
        if (_selectedItem && _selectedItem[@"displayLink"])
            post.attribution = [NSString stringWithFormat:@"%@", _selectedItem[@"displayLink"]];
        
        if (_location != nil) {
            post.location = _location;
            post.placeName = _locationName;
        }
        
        if (self.infoView.text.length != 0) {
            Recipe *recipe = [Recipe object];
            recipe.content = self.infoView.text;
            recipe.fromUser = [PFUser currentUser];
            recipe.toUser = [PFUser currentUser];
            recipe.post = post;
            recipe.dishName = post.title;
            
            [recipe saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        [SVProgressHUD dismiss];
                    }];
                }
            }];
        } else {
            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        [SVProgressHUD dismiss];
                    }];
                }
            }];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops!" message:@"You need to enter a title and/or image before uploading the dish!" delegate:nil cancelButtonTitle:@"Got it!" otherButtonTitles:nil];
        [alert showWithHandler:nil];
    }
}

#pragma mark - UICollectionView Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _objects.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoogleImageCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"GoogleImageCell" forIndexPath:indexPath];
    
    NSDictionary *item = _objects[indexPath.row];
    NSString *urlString = item[@"link"];
    [cell.imageView setImageWithURL:[NSURL URLWithString:urlString]];
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = _objects[indexPath.row];
    _selectedItem = item;
    NSString *urlString = item[@"link"];
    self.attributionLabel.hidden = NO;
    self.attributionLabel.text = [NSString stringWithFormat:@"Copyright © %@", item[@"displayLink"]];
    [self.bgView setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        self.bgView.contentMode = UIViewContentModeScaleAspectFill;
        _imageToUpload = image;
    }];
}

#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    svos = self.parallaxView.scrollView.contentOffset;
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:self.parallaxView.scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    [self.parallaxView.scrollView setContentOffset:pt animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.parallaxView.scrollView setContentOffset:svos animated:YES];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    _imageToUpload = image;
    self.attributionLabel.text = @"";
    self.attributionLabel.hidden = YES;
    [_objects removeAllObjects];
    [self.collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:^{
        self.bgView.contentMode = UIViewContentModeScaleAspectFill;
        self.bgView.image = image;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
