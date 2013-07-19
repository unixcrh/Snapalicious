//
//  ListViewController.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 25/04/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *classType;
@property (strong, nonatomic) PFUser *user;

- (IBAction)popToRoot:(id)sender;

@end
