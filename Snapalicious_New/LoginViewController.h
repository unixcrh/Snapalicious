//
//  LoginViewController.h
//  Snapalicious-iOS6
//
//  Created by Carlotta Tatti on 23/06/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginViewController : UIViewController <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)login:(id)sender;

@end
