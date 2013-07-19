//
//  ChallengeView.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 19/04/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RoundProfilePictureView.h"

@interface ChallengeView : UIView

@property (weak, nonatomic) IBOutlet RoundProfilePictureView *userPicture;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *challengeDescriptionLabel;

@end
