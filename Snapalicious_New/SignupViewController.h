//
//  SignupViewController.h
//  Snapalicious-iOS6
//
//  Created by Carlotta Tatti on 23/06/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)signup:(id)sender;

@end
