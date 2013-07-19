//
//  SmallCell.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 09/02/13.
//
//

#import "SmallCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SmallCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    self.view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.view.layer.shadowRadius = 2;
    self.view.layer.shadowOffset = CGSizeMake(0, 2);
    self.view.layer.shadowOpacity = 0.66;
    self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    self.view.layer.masksToBounds = NO;
    
    self.imgView.layer.masksToBounds = YES;

    self.img1.clipsToBounds = YES;
    self.img2.clipsToBounds = YES;
    self.img3.clipsToBounds = YES;

    self.img1.contentMode = UIViewContentModeScaleAspectFill;
    self.img2.contentMode = UIViewContentModeScaleAspectFill;
    self.img3.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
