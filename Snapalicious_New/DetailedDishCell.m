//
//  DetailedDishCell.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 13/04/13.
//
//

#import "DetailedDishCell.h"

@implementation DetailedDishCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (void)layoutSubviews {
//    self.whiteView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
//    self.whiteView.layer.shadowRadius = 2;
//    self.whiteView.layer.shadowOffset = CGSizeMake(0, 2);
//    self.whiteView.layer.shadowOpacity = 0.66;
//    self.whiteView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.whiteView.bounds].CGPath;
//    self.whiteView.layer.masksToBounds = NO;
//
//    self.imgView.clipsToBounds = YES;
//    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
//    
//    self.imageIcon.clipsToBounds = YES;
//    self.imageIcon.layer.masksToBounds = YES;
//    self.imageIcon.contentMode = UIViewContentModeScaleAspectFill;
//    
//    self.imageIcon.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.imageIcon.layer.borderWidth = 4.0f;
//    self.imageIcon.layer.cornerRadius = self.imageIcon.frame.size.width / 2;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
