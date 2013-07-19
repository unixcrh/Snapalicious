//
//  RoundUserCell.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 13/04/13.
//
//

#import <UIKit/UIKit.h>
#import "RoundProfilePictureView.h"

@interface RoundUserCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet RoundProfilePictureView *picture;
@property (weak, nonatomic) IBOutlet UILabel *username;

@end
