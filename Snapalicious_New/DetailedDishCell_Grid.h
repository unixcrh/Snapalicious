//
//  DetailedDishCell_Grid.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 21/04/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundProfilePictureView.h"

@interface DetailedDishCell_Grid : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet RoundProfilePictureView *imageIcon;
@property (weak, nonatomic) IBOutlet UITextView *attributionLabel;

@property (nonatomic, weak) IBOutlet UILabel *challengesCountLabel;

@end
