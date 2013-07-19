//
//  AppDelegate.h
//  momentsapp
//
//  Created by M.A.D on 3/3/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, PFLogInViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL appUsageCheckEnabled;
@property (nonatomic, strong) FBFriendPickerViewController *friendPicker;
@property (nonatomic, strong) NSArray *selectedFriends;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) NSURL *openedURL;

@end
