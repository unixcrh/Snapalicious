//
//  YouViewController.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 03/12/12.
//
//

#import "YouViewController.h"
#import "SmallCell.h"
#import "LoginViewController.h"
#import "DetailViewController.h"
#import "NSString+FormattedUsername.h"
#import "UIViewController+JASidePanel.h"

@interface YouViewController ()

@end

@implementation YouViewController

#pragma mark - View lifecycle
- (void)setUser:(PFUser *)newUser {
    if (_user != newUser) {
        _user = newUser;

        // Update the view.
        [self configureView];
    }
}

- (void)configureView {    
    if (!_user) {
        _user = [PFUser currentUser];
    }
    
    [SVProgressHUD show];
    
    [self fillUserInfo:self.user];
    [self fetchData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Dishes", @"Comments", @"Likes"]];
    [self.segmentedControl setFrame:CGRectMake(self.tv.frame.origin.x, 144, self.tv.frame.size.width, 45)];
    self.segmentedControl.selectionIndicatorColor = [UIColor darkGrayColor];
    self.segmentedControl.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.segmentedControl];
    
    self.navigationController.navigationBar.layer.masksToBounds = NO;
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navigationController.navigationBar.layer.shadowRadius = 25.0f;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, -5.0f);
    self.navigationController.navigationBar.layer.shadowOpacity = 0.95f;
    self.navigationController.navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.navigationController.navigationBar.bounds].CGPath;
    
    [self configureView];
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    UINavigationController *vc = (UINavigationController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"startNav"];
    [[UIApplication sharedApplication] keyWindow].rootViewController = vc;
}

- (void)updateFollowStatusForUser:(PFUser *)user {
    PFQuery *query = [PFQuery queryWithClassName:kClassTypeFollow];
    [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"toUser" equalTo:user];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        bool status = [[object objectForKey:@"flag"] boolValue];
        if (status) {
            self.followStatus = @"Unfollow";
            [self.navigationItem.rightBarButtonItem setTitle:self.followStatus];
        } else {
            self.followStatus = @"Follow";
            [self.navigationItem.rightBarButtonItem setTitle:self.followStatus];
        }
    }];
}

// Follows user
- (IBAction)follow:(id)sender {
    PFQuery *follows = [PFQuery queryWithClassName:kClassTypeFollow];
    [follows whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [follows whereKey:@"toUser" equalTo:_user];
    
    PFObject *object = [follows getFirstObject];
    
    bool status = [[object objectForKey:@"flag"] boolValue];
    if (!object) {
        PFObject *obj = [PFObject objectWithClassName:kClassTypeFollow];
        [obj setObject:[PFUser currentUser] forKey:@"fromUser"];
        [obj setObject:_user forKey:@"toUser"];
        [obj setObject:[NSNumber numberWithBool:YES] forKey:@"flag"];
        [obj save];
        _followStatus = @"Unfollow";
        [SVProgressHUD showSuccessWithStatus:@"Followed"];
        [self.navigationItem.rightBarButtonItem setTitle:self.followStatus];
    } else {
        if (status == YES) {
            [object setObject:[NSNumber numberWithBool:NO] forKey:@"flag"];
            [object save];
            _followStatus = @"Follow";
            [SVProgressHUD showSuccessWithStatus:@"Unfollowed"];
            [self.navigationItem.rightBarButtonItem setTitle:self.followStatus];
        } else if (status == NO) {
            [object setObject:[NSNumber numberWithBool:YES] forKey:@"flag"];
            [object save];
            _followStatus = @"Unfollow";
            [SVProgressHUD showSuccessWithStatus:@"Followed"];
            [self.navigationItem.rightBarButtonItem setTitle:self.followStatus];
        }
    }
}

- (void)fillUserInfo:(PFUser *)user {
    self.userName.text = [NSString formattedUsernameWithFirstName:_user[@"firstName"] lastName:_user[@"lastName"]];
    NSString *facebookID = [_user objectForKey:@"fbId"];
    if (facebookID)
        self.userPicture.profileID = facebookID;
    
    self.bioTextView.text = [user objectForKey:@"bio"];
    dispatch_queue_t queue = dispatch_queue_create("com.Blocks.task",NULL);
    dispatch_queue_t main = dispatch_get_main_queue();
    
    dispatch_async(queue,^{
        // Get data
        PFQuery *query1 = [PFQuery queryWithClassName:kClassTypePost];
        [query1 whereKey:@"author" equalTo:user];
        int dishes = [query1 countObjects];
        
        PFQuery *query2 = [PFQuery queryWithClassName:kClassTypeFollow];
        [query2 whereKey:@"flag" equalTo:[NSNumber numberWithBool:YES]];
        [query2 whereKey:@"fromUser" equalTo:user];
        int following = [query2 countObjects];
        
        PFQuery *query3 = [PFQuery queryWithClassName:kClassTypeFollow];
        [query3 whereKey:@"flag" equalTo:[NSNumber numberWithBool:YES]];
        [query3 whereKey:@"toUser" equalTo:user];
        int followers = [query3 countObjects];
        dispatch_async(main,^{
            // Update UI
            NSString *userInfo = [NSString stringWithFormat:@"%i dishes | %i following | %i followers", dishes, following, followers];
//            self.userInfo.text = userInfo;
        });
    });

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        return self.dishesArray.count;
    }
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        return self.recipesArray.count;
    }
    if (self.segmentedControl.selectedSegmentIndex == 2) {
        return self.favsArray.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self calculateCellHeightForIndexPath:indexPath];
}

- (void)textFieldDidResize:(id)sender
{
    [self.tv beginUpdates];
    [self.tv endUpdates];
}

- (CGFloat)calculateCellHeightForIndexPath:(NSIndexPath *)indexPath {
    int height;
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        PFObject * object = [self.recipesArray objectAtIndex:indexPath.row];
        NSString *string = [object objectForKey:@"content"];
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:17]; //Font used in the resizable label
        CGFloat maxWidth = 292; //Width of label in the custom cell
        CGFloat maxHeight = 9999;
        
        CGSize maximumLabelSize = CGSizeMake(maxWidth,maxHeight);
        
        CGSize cellSize = [string sizeWithFont:font constrainedToSize:maximumLabelSize];
        
        height = cellSize.height+64; //+24 for rest of the cell (stuff that doesn't resize)
    } else {
        height = 198;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        static NSString *CellIdentifier = @"DishCell";
        SmallCell *cell = (SmallCell*)[self.tv dequeueReusableCellWithIdentifier:CellIdentifier];
        if ( cell == nil ){
            NSArray *topObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            for (id obj in topObjects) {
                if ([obj isKindOfClass:[SmallCell class]]) {
                    cell = (SmallCell*)obj;
                    break;
                }
            }
        }
        
        Dish *object = [self.dishesArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = object.title;
      
        if (object.placeName)
            cell.placeLabel.text = object.placeName;
        else
            cell.placeLabel.text = @"";
        
        PFFile *file = object.momentThumb;
        [cell.imgView setImageWithURL:[NSURL URLWithString:file.url]];
        return cell;
    }
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        static NSString *CellIdentifier = @"RecipeCell";
        SmallCell *cell = (SmallCell*)[self.tv dequeueReusableCellWithIdentifier:CellIdentifier];
        if ( cell == nil ){
            NSArray *topObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            for (id obj in topObjects) {
                if ([obj isKindOfClass:[SmallCell class]]){
                    cell = (SmallCell*)obj;
                    break;
                }
            }
        }
        
        CGRect frame = cell.contentView.frame;
        frame.size.height = [self calculateCellHeightForIndexPath:indexPath];
        cell.contentView.frame = frame;
        
        PFObject *object = [self.recipesArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = [object objectForKey:@"dishName"];
        cell.placeLabel.text = @"";
        cell.infoView.text = [object objectForKey:@"content"];
        return cell;
    }
    
    if (self.segmentedControl.selectedSegmentIndex == 2) {
        static NSString *CellIdentifier = @"DishCell";
        SmallCell *cell = (SmallCell*)[self.tv dequeueReusableCellWithIdentifier:CellIdentifier];
        if ( cell == nil ){
            NSArray *topObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            for (id obj in topObjects) {
                if ([obj isKindOfClass:[SmallCell class]]){
                    cell = (SmallCell*)obj;
                    break;
                }
            }
        }
                
        PFObject *object = [self.favsArray objectAtIndex:indexPath.row];
        PFObject *post = [object objectForKey:@"post"];
        cell.titleLabel.text = [post objectForKey:@"title"];
        cell.placeLabel.text = [object objectForKey:@"placeName"];
        PFFile *file1 = [post objectForKey:@"momentThumb"];
        [cell.imgView setImageWithURL:[NSURL URLWithString:file1.url]];
        
        return cell;
    }
    
    return nil;
}

- (void)resetProfile:(id)sender {
    [self setUser:nil];
}

- (void)fetchData {
    // Get data
    dispatch_queue_t queue = dispatch_queue_create("com.Blocks.task",NULL);
    dispatch_queue_t main = dispatch_get_main_queue();
    
    dispatch_async(queue,^{
        // Get data
        PFQuery *posts = [PFQuery queryWithClassName:kClassTypePost];
        [posts orderByDescending:@"createdAt"];
        [posts includeKey:@"author"];
        [posts whereKey:@"author" equalTo:self.user];
        self.dishesArray = [posts findObjects];

        dispatch_async(main,^{
            // Update UI
            [self.tv reloadData];
            
            [SVProgressHUD dismiss];
        });
    });
    
    // Get data
    dispatch_queue_t queue2 = dispatch_queue_create("com.Blocks.task",NULL);
    dispatch_queue_t main2 = dispatch_get_main_queue();
    
    dispatch_async(queue2,^{
        // Get data
        PFQuery *recipes = [PFQuery queryWithClassName:kClassTypeRecipe];
        [recipes orderByDescending:@"createdAt"];
        [recipes includeKey:@"post"];
        [recipes includeKey:@"fromUser"];
        [recipes whereKey:@"fromUser" equalTo:self.user];
        self.recipesArray = [recipes findObjects];
        
        dispatch_async(main2,^{
            // Update UI
            [self.tv reloadData];
        });
    });
    
    // Get data
    dispatch_queue_t queue3 = dispatch_queue_create("com.Blocks.task",NULL);
    dispatch_queue_t main3 = dispatch_get_main_queue();
    
    dispatch_async(queue3,^{
        // Get data
        
        PFQuery *favs = [PFQuery queryWithClassName:kClassTypeSnapalicious];
        [favs orderByDescending:@"createdAt"];
        [favs whereKey:@"fromUser" equalTo:self.user];
        [favs includeKey:@"post"];
        [favs includeKey:@"fromUser"];
        self.favsArray = [favs findObjects];
        
        dispatch_async(main3,^{
            // Update UI
            [self.tv reloadData];
        });
    });
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDetail" object:self userInfo:@{@"dish": self.dishesArray[indexPath.row]}];
    }
    if (self.segmentedControl.selectedSegmentIndex == 1) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDetail" object:self userInfo:@{@"dish": self.recipesArray[indexPath.row][@"post"]}];
    }
    if (self.segmentedControl.selectedSegmentIndex == 2) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDetail" object:self userInfo:@{@"dish": self.favsArray[indexPath.row][@"post"]}];
    }
}

- (void)segmentedControlChangedValue:(id)sender {
    [self.tv reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {    
    if ([[segue identifier] isEqualToString:@"showDish"]) {
        NSIndexPath *indexPath = sender;
        Dish *post = self.dishesArray[indexPath.row];
        DetailViewController *vc = [segue destinationViewController];
        [vc setDetailItem:post];
    }
    
    if ([[segue identifier] isEqualToString:@"showRecipe"]) {
        NSIndexPath *indexPath = sender;
        PFObject *obj = self.recipesArray[indexPath.row];
        Dish *thePost = [obj objectForKey:@"post"];
        DetailViewController *vc = [segue destinationViewController];
        [vc setDetailItem:thePost];
    }
    
    if ([[segue identifier] isEqualToString:@"showFav"]) {
        NSIndexPath *indexPath = sender;
        PFObject *fav = self.favsArray[indexPath.row];
        Dish *thePost = [fav objectForKey:@"post"];
        DetailViewController *vc = [segue destinationViewController];
        [vc setDetailItem:thePost];
    }
}

@end
