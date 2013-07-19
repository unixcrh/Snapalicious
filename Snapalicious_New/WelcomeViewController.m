//
//  WelcomeViewController.m
//  Snapalicious-iOS6
//
//  Created by Carlotta Tatti on 21/06/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import "WelcomeViewController.h"

#import "SidePanelController.h"

@interface WelcomeViewController () {
    BOOL pageControlBeingUsed;
}

@end

@implementation WelcomeViewController

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
    pageControlBeingUsed = NO;
    
    NSString *sample_text = @"<font face='HelveticaNeue-Bold' size=12 color='#FFFFFF'>By creating an account you are agreeing to our <a href='http://www.privacychoice.org/policy/mobile?policy=0843ecdbbe5bd974770a7bd7c8b8fd76'>Terms of Service</a> and confirming you are at least 13 years old.</font>";
    
    for (RTLabel *label in self.labelsTOS) {
        label.delegate = self;
        [label setTextAlignment:RTTextAlignmentCenter];
        [label setText:sample_text];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*4, self.scrollView.frame.size.height);
}

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)changePage:(id)sender {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (IBAction)loginUsingFacebook:(id)sender {
    NSArray *permissions = @[@"publish_actions", @"user_about_me"];
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            SidePanelController *vc = (SidePanelController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"Main"];
            [[UIApplication sharedApplication] keyWindow].rootViewController = vc;
        } else {
            NSLog(@"User logged in through Facebook!");
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            SidePanelController *vc = (SidePanelController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"Main"];
            [[UIApplication sharedApplication] keyWindow].rootViewController = vc;
        }
    }];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
