//
//  SmallCell.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 09/02/13.
//
//

#import <UIKit/UIKit.h>
#import "MyUIView.h"
#import "RoundProfilePictureView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SmallCell : UITableViewCell

@property (nonatomic, weak) IBOutlet MyUIView       *view;

@property (nonatomic, weak) IBOutlet UIImageView *imgView;

@property (nonatomic, weak) IBOutlet UIImageView       *img1;
@property (nonatomic, weak) IBOutlet UIImageView       *img2;
@property (nonatomic, weak) IBOutlet UIImageView       *img3;
@property (nonatomic, weak) IBOutlet RoundProfilePictureView *profileImage;

@property (nonatomic, weak) IBOutlet UILabel       *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *placeLabel;
@property (nonatomic, weak) IBOutlet UITextView *infoView;

@end
