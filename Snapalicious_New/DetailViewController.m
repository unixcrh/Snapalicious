//
//  DetailViewController.m
//  FoodSnap
//
//  Created by Carlotta Tatti on 31/10/12.
//
//

#import "DetailViewController.h"
#import "CommentCell.h"
#import "UIImage+ResizeAdditions.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "SmallCell.h"
#import "JASidePanelController.h"
#import "GeoPointAnnotation.h"

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

- (void)setDetailItem:(Dish *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    PFFile *file = self.detailItem.momentThumb;
    NSURL *url = [NSURL URLWithString:file.url];
    self.bgView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgView.clipsToBounds = YES;
    [self.bgView setImageWithURL:url];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont boldSystemFontOfSize: 14.0f];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = self.detailItem.title;
    
    self.navigationItem.titleView = label;
    
    PFUser *user = self.detailItem.author;
    NSString *facebookID = [user objectForKey:@"fbId"];
    if (facebookID)
        self.profileImage.profileID = facebookID;
    
    [self refreshActivity];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sharingStatus) name:ACAccountStoreDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:ACAccountStoreDidChangeNotification];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
    CGRect backgroundRect = CGRectMake(0, 44, self.view.frame.size.width, 300);
    self.bgView.frame = backgroundRect;
    self.parallaxView = [[MDCParallaxView alloc] initWithBackgroundView:self.bgView
                                                         foregroundView:self.contentView];
    self.parallaxView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.parallaxView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.parallaxView.backgroundHeight = 200.0f;
    self.parallaxView.scrollView.showsVerticalScrollIndicator = NO;
    self.parallaxView.scrollView.showsHorizontalScrollIndicator = NO;
    self.parallaxView.scrollView.scrollsToTop = YES;
        
    self.parallaxView.scrollViewDelegate = self;
    self.view = self.parallaxView;

    self.view.backgroundColor = self.contentView.backgroundColor;
    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImage.layer.borderWidth = 2.0;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.layer.masksToBounds = YES;
    
    [self configureView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    PFGeoPoint *geopoint = self.detailItem.location;
    if (geopoint) {
        GeoPointAnnotation *ann = [[GeoPointAnnotation alloc] initWithObject:self.detailItem];
        [self.mapView addAnnotation:ann];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(ann.coordinate, 5000, 5000);
        [self.mapView setRegion:region animated:NO];
    } else {
        self.mapView.hidden = YES;
        self.mapHeight.constant = 0;
    }
}

- (void)refreshActivity {
    dispatch_queue_t queue = dispatch_queue_create("com.Blocks.task",NULL);
    dispatch_queue_t main = dispatch_get_main_queue();
    
    dispatch_async(queue,^{
        // Get data
        NSArray *recipes = [MiscUtils getRecipesForPost:self.detailItem];
        NSArray *recipeRequests = [MiscUtils getRecipeRequestsForPost:self.detailItem];
        NSArray *likes = [MiscUtils getLikesForPost:self.detailItem];
        
//        self.commentsCountLabel.text = [NSString stringWithFormat:@"%i", recipes.count];
//        self.likesCountLabel.text = [NSString stringWithFormat:@"%i", likes.count];
        
        self.activityArray = [NSMutableArray new];
        [self.activityArray addObjectsFromArray:recipes];
        [self.activityArray addObjectsFromArray:recipeRequests];
        [self.activityArray addObjectsFromArray:likes];
        dispatch_async(main,^{
            // Update UI
            [self.tv reloadData];
            
            CGSize contentSize = self.parallaxView.scrollView.contentSize;
            if (self.activityArray.count != 0) {
                self.commentsLabel.text = [NSString stringWithFormat:@"%i ACTIVITY ITEMS", self.activityArray.count];
                for (int i=0;i<self.activityArray.count;i++) {
                    PFObject *object = [self.activityArray objectAtIndex:i];
                    NSString *string = [object objectForKey:@"content"];
                    CGFloat aHeight = [self calculateCellHeightForText:string];
                    contentSize.height = contentSize.height + aHeight;
                    self.parallaxView.scrollView.contentSize = contentSize;
                }
            } else {                
                CGSize contentSize = self.parallaxView.scrollView.contentSize;
                contentSize.height = self.parallaxView.backgroundHeight + self.contentView.frame.size.height;
                self.parallaxView.scrollView.contentSize = contentSize;
            }
        });
    });
}

- (void)sharingStatus {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        self.fbButton.enabled = YES;
        self.fbButton.alpha = 1.0f;
    } else {
        self.fbButton.enabled = NO;
        self.fbButton.alpha = 0.5f;
    }
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        self.twButton.enabled = YES;
        self.twButton.alpha = 1.0f;
    } else {
        self.twButton.enabled = NO;
        self.twButton.alpha = 0.5f;
    }
}

#pragma mark - UITableViewController Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self.activityArray objectAtIndex:indexPath.row];
    if ([object.parseClassName isEqualToString:kClassTypeRecipe]) {
        return [self calculateCellHeightForText:[object objectForKey:@"content"]];
    } else {
        return 60;
    }
    
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activityArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"RecipeWithoutTitleCell";
    static NSString *CellIdentifier2 = @"ActivityCell";

    SmallCell *cell;

    PFObject *object = [self.activityArray objectAtIndex:indexPath.row];

    if ([[object parseClassName] isEqualToString:kClassTypeSnapalicious]) {
        cell = (SmallCell*)[self.tv dequeueReusableCellWithIdentifier:CellIdentifier2];
        if ( cell == nil ){
            NSArray *topObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier2 owner:self options:nil];
            for (id obj in topObjects) {
                if ([obj isKindOfClass:[SmallCell class]]){
                    cell = (SmallCell*)obj;
                    break;
                }
            }
        }
        
        PFUser *fromUser = [object objectForKey:@"fromUser"];
        
        CGRect frame = cell.contentView.frame;
        frame.size.height = 60;
        cell.contentView.frame = frame;
        
        cell.profileImage.profileID = [fromUser objectForKey:@"fbId"];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ likes %@", [fromUser objectForKey:@"profileName"], self.detailItem.title];
    }

    if ([[object parseClassName] isEqualToString:kClassTypeRecipe]) {
        cell = (SmallCell*)[self.tv dequeueReusableCellWithIdentifier:CellIdentifier1];
        if ( cell == nil ){
            NSArray *topObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier1 owner:self options:nil];
            for (id obj in topObjects) {
                if ([obj isKindOfClass:[SmallCell class]]){
                    cell = (SmallCell*)obj;
                    break;
                }
            }
        }
        
        NSString *string = [object objectForKey:@"content"];

        CGRect frame = cell.contentView.frame;
        frame.size.height = [self calculateCellHeightForText:string];
        cell.contentView.frame = frame;
        
        PFUser *fromUser = [object objectForKey:@"fromUser"];

        cell.profileImage.profileID = [fromUser objectForKey:@"fbId"];
        cell.infoView.text = [object objectForKey:@"content"];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ said", [fromUser objectForKey:@"profileName"]];
    }

    if ([[object parseClassName] isEqualToString:kClassTypeRequest]) {
        cell = (SmallCell*)[self.tv dequeueReusableCellWithIdentifier:CellIdentifier2];
        if ( cell == nil ){
            NSArray *topObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier2 owner:self options:nil];
            for (id obj in topObjects) {
                if ([obj isKindOfClass:[SmallCell class]]){
                    cell = (SmallCell*)obj;
                    break;
                }
            }
        }
        
        PFUser *fromUser = [object objectForKey:@"fromUser"];
        
        CGRect frame = cell.contentView.frame;
        frame.size.height = 60;
        cell.contentView.frame = frame;
        
        cell.profileImage.profileID = [fromUser objectForKey:@"fbId"];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ wants details for %@", [fromUser objectForKey:@"profileName"], self.detailItem.title];
    }

    return cell;
}

- (NSString *)updateFavStatusForPost:(PFObject *)post {
    __block NSString *string;
    PFQuery *query = [PFQuery queryWithClassName:kClassTypeSnapalicious];
    [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"toUser" equalTo:[post objectForKey:@"author"]];
    [query whereKey:@"post" equalTo:post];
    PFObject *object = [query getFirstObject];
    bool status = [[object objectForKey:@"flag"] boolValue];
    if (status == TRUE) {
        string = @"Dislike";
    } else {
        string = @"Like!";
    }
    
    return string;
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)calculateCellHeightForText:(NSString *)string {
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:17]; //Font used in the resizable label
    CGFloat maxWidth = 292; //Width of label in the custom cell
    CGFloat maxHeight = 9999;
    
    CGSize maximumLabelSize = CGSizeMake(maxWidth,maxHeight);
    
    CGSize cellSize = [string sizeWithFont:font constrainedToSize:maximumLabelSize];
    
    return cellSize.height+64;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowUserProfile"]) {
        PFUser *user = (PFUser *)sender;
        ProfileViewController *vc = (ProfileViewController *)segue.destinationViewController;
        [vc setUser:user];
    }
}

- (IBAction)showUserProfile:(id)sender {
    [self performSegueWithIdentifier:@"ShowUserProfile" sender:self.detailItem.author];
}

- (IBAction)writeRecipe:(id)sender {
    TPComposeView *composeView = [[TPComposeView alloc] initWithInitialText:@""];
    [composeView setCancelButtonTitle:@"Cancel"];
    [composeView setComposeButtonTitle:@"Post it!"];
    composeView.title = @"Comment";
    PFObject *recipe = [PFObject objectWithClassName:kClassTypeRecipe];
    composeView.completionHandler = ^(TPComposeViewResult result, NSString *text){
        switch (result)
        {
            case TPComposeViewResultCancelled:
                NSLog(@"Cancelled!");
                break;
                
            case TPComposeViewResultDone:
                [recipe setObject:text forKey:@"content"];
                [recipe setObject:self.detailItem forKey:@"post"];
                [recipe setObject:[PFUser currentUser] forKey:@"fromUser"];
                [recipe setObject:self.detailItem.author forKey:@"toUser"];
                [recipe setObject:self.detailItem.title forKey:@"dishName"];
                [recipe saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        [self refreshActivity];
                    }
                }];
                break;
        }
    };
    [composeView presentComposeView];
}

- (IBAction)askRecipe:(id)sender {
    PFObject *request = [PFObject objectWithClassName:kClassTypeRequest];
    [request setObject:[PFUser currentUser] forKey:@"fromUser"];
    [request setObject:self.detailItem forKey:@"post"];
    [request setObject:self.detailItem.author forKey:@"toUser"];
    [request setObject:[NSNumber numberWithBool:NO] forKey:@"solved"];
    [request save];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want to send a recipe request to the author?" delegate:nil cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Done!" message:@"More info request sent!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert2 show];
        }
    }];
}

- (IBAction)postOnFB:(id)sender {    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSString *message = [NSString stringWithFormat:@"%@ on Snapalicious", [self.detailItem objectForKey:@"title"]];
        [mySLComposerSheet setInitialText:message];
        [mySLComposerSheet addImage:self.bgView.image];
        [mySLComposerSheet addURL:[NSURL URLWithString:@"appstore.com/snapalicious"]];
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    // NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    // NSLog(@"Post Successful");
                    break;
                    
                default:
                    break;
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
}

- (IBAction)postOnTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *message = [NSString stringWithFormat:@"%@ on Snapalicious", [self.detailItem objectForKey:@"title"]];
        [mySLComposerSheet setInitialText:message];
        [mySLComposerSheet addImage:self.bgView.image];
        [mySLComposerSheet addURL:[NSURL URLWithString:@"appstore.com/snapalicious"]];
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    // NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    // NSLog(@"Post Successful");
                    break;
                    
                default:
                    break;
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
}

- (IBAction)addToSnapalicious:(id)sender {
    UIBarButtonItem *item = sender;
    PFUser *user = [_detailItem objectForKey:@"author"];
    PFQuery *cookbook = [PFQuery queryWithClassName:kClassTypeSnapalicious];
    [cookbook whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [cookbook whereKey:@"toUser" equalTo:user];
    [cookbook whereKey:@"post" equalTo:_detailItem];
    [cookbook getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        bool status = [[object objectForKey:@"flag"] boolValue];
        if (!object) {
            PFObject *obj = [PFObject objectWithClassName:kClassTypeSnapalicious];
            [obj setObject:[PFUser currentUser] forKey:@"fromUser"];
            [obj setObject:self.detailItem forKey:@"post"];
            [obj setObject:self.detailItem.author forKey:@"toUser"];
            [obj setObject:self.detailItem.title forKey:@"dishName"];
            [obj setObject:[NSNumber numberWithBool:YES] forKey:@"flag"];
            [obj save];
            [sender setTitle:@"Dislike"];
        } else {
            if (status) {
                [object setObject:[NSNumber numberWithBool:NO] forKey:@"flag"];
                [object save];
                [item setTitle:@"Like!"];
            } else {
                [object setObject:[NSNumber numberWithBool:YES] forKey:@"flag"];
                [object save];
                [item setTitle:@"Dislike"];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
