//
//  UserCell.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 10/02/13.
//
//

#import <UIKit/UIKit.h>

@interface UserCell : PFTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet FBProfilePictureView *userPicture;
@property (nonatomic, weak) IBOutlet UIButton *followButton;

@end
