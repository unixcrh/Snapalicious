//
//  WelcomeViewController.h
//  Snapalicious-iOS6
//
//  Created by Carlotta Tatti on 21/06/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RTLabel.h"
#import <Parse/Parse.h>

@interface WelcomeViewController : UIViewController <UIScrollViewDelegate, RTLabelDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutletCollection(RTLabel) NSArray *labelsTOS;

- (IBAction)changePage:(id)sender;

- (IBAction)loginUsingFacebook:(id)sender;

@end
