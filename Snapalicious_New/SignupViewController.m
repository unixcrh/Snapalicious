//
//  SignupViewController.m
//  Snapalicious-iOS6
//
//  Created by Carlotta Tatti on 23/06/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import "SignupViewController.h"

#import "TextFieldCell.h"
#import "SidePanelController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

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

- (IBAction)signup:(id)sender {
    [self.activityIndicator startAnimating];
    
    TextFieldCell *usernameCell = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    TextFieldCell *emailCell = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    TextFieldCell *passwordCell = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    if (passwordCell.textField.text.length > 5) {
        PFUser *user = [PFUser user];
        user.username = usernameCell.textField.text;
        user.password = passwordCell.textField.text;
        user.email = emailCell.textField.text;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self.activityIndicator stopAnimating];
            if (!error) {
                // Hooray! Let them use the app now.
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                SidePanelController *vc = (SidePanelController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"Main"];
                [[UIApplication sharedApplication] keyWindow].rootViewController = vc;
            } else {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                // Show the errorString somewhere and let the user try again.
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alertView show];
            }
        }];
    } else {
        [self.activityIndicator stopAnimating];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password needs to be at least 5 characters." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    TextFieldCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.row == 0) {
        cell.textField.placeholder = @"Username";
    }
    
    if (indexPath.row == 1) {
        cell.textField.placeholder = @"Email Address";
    }
    
    if (indexPath.row == 2) {
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
