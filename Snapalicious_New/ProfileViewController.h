//
//  ProfileViewController.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 25/04/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *userPicture;
@property (nonatomic, strong) PFUser *user;

- (IBAction)follow:(id)sender;

@end
