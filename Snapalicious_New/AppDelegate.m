//
//  AppDelegate.m
//  momentsapp
//
//  Created by M.A.D on 3/3/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "AppDelegate.h"
#import "iRate.h"
#import "Harpy.h"
#import "LoginViewController.h"
#import "Flurry.h"
#import "Recipe.h"
#import "SidePanelController.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)customizeGlobalTheme {
    [[UINavigationBar appearance] configureFlatNavigationBarWithColor:[UIColor pumpkinColor]];
    [UIBarButtonItem configureFlatButtonsWithColor:[UIColor pomegranateColor]
                                  highlightedColor:[UIColor pomegranateColor]
                                      cornerRadius:3];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    // Override point for customization after application launch.
//    [Flurry startSession:@"FLURRY_KEY"];
    
    [self customizeGlobalTheme];
    
    [Dish registerSubclass];
    [Challenge registerSubclass];
    [Like registerSubclass];
    [Recipe registerSubclass];
    
    [Parse errorMessagesEnabled:YES];
    [Parse offlineMessagesEnabled:YES];
    
    [Parse setApplicationId:@"PARSE_APPLICATION_ID" clientKey:@"PARSE_CLIENT_KEY"];

    [PFFacebookUtils initializeFacebook];
    
//    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        // app already launched
        if (![PFUser currentUser])
            [self showWelcomeScreen];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // This is the first launch ever
        [self showWelcomeScreen];
    }
    
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    // Register for push notifications
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];

    /*
     Check AppStore for your application's current version. If newer version exists, prompt user.
     Declare immediatley after you call makeKeyAndVisible on your UIWindow iVar
     */
    [Harpy checkVersion];

    return YES;
}

- (void)showWelcomeScreen {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    UINavigationController *vc = (UINavigationController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"startNav"];
    
    self.window.rootViewController = vc;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    NSLog(@"Device token is %@", newDeviceToken);
    [PFPush storeDeviceToken:newDeviceToken]; // Send parse the device token
    // Subscribe this user to the broadcast channel, ""
    [[PFInstallation currentInstallation] addUniqueObject:@"" forKey:@"channels"];
    [[PFInstallation currentInstallation] saveEventually];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // We can determine whether an application is launched as a result of the user tapping the action
    // button or whether the notification was delivered to the already-running application by examining
    // the application state.
    
    if (application.applicationState == UIApplicationStateActive)
    {
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
    } else {
        [PFPush handlePush:userInfo];
       
        // Show photo view controller
        if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            // Create empty post object
            NSString *postId = [userInfo objectForKey:@"p"];
            Dish *targetPost = (Dish *)[PFQuery getObjectOfClass:@"Post" objectId:postId];
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
            SidePanelController *vc = (SidePanelController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"Main"];
            [[UIApplication sharedApplication] keyWindow].rootViewController = vc;
            
            [vc performSegueWithIdentifier:@"showDetail" sender:targetPost];
        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
