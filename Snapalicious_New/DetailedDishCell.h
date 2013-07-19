//
//  DetailedDishCell.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 13/04/13.
//
//

#import <UIKit/UIKit.h>

#import "RoundProfilePictureView.h"

@interface DetailedDishCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *whiteView;

@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet RoundProfilePictureView *imageIcon;
@property (weak, nonatomic) IBOutlet UITextView *attributionLabel;

@property (nonatomic, weak) IBOutlet UILabel *likesCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *commentsCountLabel;

@end
