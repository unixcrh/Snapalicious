//
//  LoginViewController.m
//  Snapalicious-iOS6
//
//  Created by Carlotta Tatti on 23/06/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import "LoginViewController.h"

#import "TextFieldCell.h"

#import "SidePanelController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (IBAction)login:(id)sender {
    [self.activityIndicator startAnimating];
    TextFieldCell *usernameCell = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    TextFieldCell *passwordCell = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    [PFUser logInWithUsernameInBackground:usernameCell.textField.text password:passwordCell.textField.text
                                    block:^(PFUser *user, NSError *error) {
                                        [self.activityIndicator stopAnimating];
                                        if (user) {
                                            // Do stuff after successful login.
                                            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                                            SidePanelController *vc = (SidePanelController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"Main"];
                                            [[UIApplication sharedApplication] keyWindow].rootViewController = vc;
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSString *errorString = [[error userInfo] objectForKey:@"error"];
                                            // Show the errorString somewhere and let the user try again.
                                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                                            [alertView show];
                                        }
                                    }];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    TextFieldCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.row == 0) {
        cell.textField.placeholder = @"Username";
    }
    
    if (indexPath.row == 1) {
        cell.textField.placeholder = @"Password";
        cell.textField.secureTextEntry = YES;
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
