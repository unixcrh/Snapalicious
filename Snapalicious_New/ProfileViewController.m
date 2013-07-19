//
//  ProfileViewController.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 25/04/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import "ProfileViewController.h"
#import "SidePanelController.h"
#import "LoginViewController.h"
#import "UIViewController+JASidePanel.h"
#import "ListViewController.h"
#import "AppDelegate.h"

@interface ProfileViewController () {
    int dishes;
    int comments;
    int likes;
    
    int following;
    int followers;
}
@property (nonatomic, strong) NSString *followStatus;

@end

@implementation ProfileViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self configureView];
    
    [self updateFollowStatusForUser:self.user];

    dispatch_queue_t queue = dispatch_queue_create("com.Blocks.task",NULL);
    dispatch_queue_t main = dispatch_get_main_queue();
    
    dispatch_async(queue,^{
        PFUser *user = self.user;
        
        // Get data
        PFQuery *query1 = [PFQuery queryWithClassName:kClassTypePost];
        [query1 whereKey:@"author" equalTo:user];
        dishes = [query1 countObjects];
        
        PFQuery *query2 = [PFQuery queryWithClassName:kClassTypeRecipe];
        [query2 whereKey:@"fromUser" equalTo:user];
        comments = [query2 countObjects];
        
        PFQuery *query3 = [PFQuery queryWithClassName:kClassTypeSnapalicious];
        [query3 whereKey:@"fromUser" equalTo:user];
        likes = [query3 countObjects];
        
        PFQuery *query4 = [PFQuery queryWithClassName:kClassTypeFollow];
        [query4 whereKey:@"flag" equalTo:[NSNumber numberWithBool:YES]];
        [query4 whereKey:@"fromUser" equalTo:user];
        following = [query4 countObjects];
        
        PFQuery *query5 = [PFQuery queryWithClassName:kClassTypeFollow];
        [query5 whereKey:@"flag" equalTo:[NSNumber numberWithBool:YES]];
        [query5 whereKey:@"toUser" equalTo:user];
        followers = [query5 countObjects];
        
        dispatch_async(main,^{
            self.userPicture.pictureCropping = FBProfilePictureCroppingOriginal;
            self.userPicture.profileID = user[@"fbId"];
            [self.tableView reloadData];
        });
    });
}

- (void)logout:(id)sender {
    [PFUser logOut];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    UINavigationController *vc = (UINavigationController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"startNav"];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = vc;
}

- (void)updateFollowStatusForUser:(PFUser *)user {
    PFQuery *query = [PFQuery queryWithClassName:kClassTypeFollow];
    [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"toUser" equalTo:user];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            bool status = [[object objectForKey:@"flag"] boolValue];
            if (status) {
                self.followStatus = @"Unfollow";
                [self.navigationItem.rightBarButtonItem setTitle:self.followStatus];
            } else {
                self.followStatus = @"Follow";
                [self.navigationItem.rightBarButtonItem setTitle:self.followStatus];
            }
        }
    }];
}

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
        [self.navigationItem.rightBarButtonItem setTitle:self.followStatus];
    } else {
        if (status == YES) {
            [object setObject:[NSNumber numberWithBool:NO] forKey:@"flag"];
            [object save];
            _followStatus = @"Follow";
            [self.navigationItem.rightBarButtonItem setTitle:self.followStatus];
        } else if (status == NO) {
            [object setObject:[NSNumber numberWithBool:YES] forKey:@"flag"];
            [object save];
            _followStatus = @"Unfollow";
            [self.navigationItem.rightBarButtonItem setTitle:self.followStatus];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
        return 3;
    
    if (section == 1)
        return 2;
    
    if (section == 3 && [_user isEqual:[PFUser currentUser]])
        return 2;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"Dishes";
            cell.textLabel.text = [NSString stringWithFormat:@"%i", dishes];
        }
        
        if (indexPath.row == 1) {
            cell.detailTextLabel.text = @"Comments";
            cell.textLabel.text = [NSString stringWithFormat:@"%i", comments];
        }
        
        if (indexPath.row == 2) {
            cell.detailTextLabel.text = @"Likes";
            cell.textLabel.text = [NSString stringWithFormat:@"%i", likes];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"Following";
            cell.textLabel.text = [NSString stringWithFormat:@"%i", following];
        }
        
        if (indexPath.row == 1) {
            cell.detailTextLabel.text = @"Followers";
            cell.textLabel.text = [NSString stringWithFormat:@"%i", followers];
        }
    }
    
    if ([_user isEqual:[PFUser currentUser]]) {
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Introduction Tour";
            }
            
            if (indexPath.row == 1) {
                cell.textLabel.text = @"Logout";
            }
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"showDetail" sender:[NSNumber numberWithInt:0]];
        }
        
        if (indexPath.row == 1) {
            [self performSegueWithIdentifier:@"showDetail" sender:[NSNumber numberWithInt:1]];
        }
        
        if (indexPath.row == 2) {
            [self performSegueWithIdentifier:@"showDetail" sender:[NSNumber numberWithInt:2]];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
//            [self performSegueWithIdentifier:@"showDetail" sender:[NSNumber numberWithInt:3]];
        }
        
        if (indexPath.row == 1) {
//            [self performSegueWithIdentifier:@"showDetail" sender:[NSNumber numberWithInt:4]];
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self.sidePanelController showCenterPanelAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"StartWalktrough" object:nil];
        }
        
        if (indexPath.row == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self logout:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ListViewController *vc = (ListViewController *)segue.destinationViewController;
    [vc setUser:_user];

    if ([sender isEqualToNumber:[NSNumber numberWithInt:0]]) {
        [vc setClassType:kClassTypePost];
    }
    
    if ([sender isEqualToNumber:[NSNumber numberWithInt:1]]) {
        [vc setClassType:kClassTypeRecipe];
    }
    
    if ([sender isEqualToNumber:[NSNumber numberWithInt:2]]) {
        [vc setClassType:kClassTypeSnapalicious];
    }
    
    if ([sender isEqualToNumber:[NSNumber numberWithInt:3]]) {
        [vc setClassType:@"User"];
    }
    
    if ([sender isEqualToNumber:[NSNumber numberWithInt:4]]) {
        [vc setClassType:@"User"];
    }
}

@end
