//
//  CameraViewController.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 27/04/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *vImage;

- (IBAction)captureNow;

@end
