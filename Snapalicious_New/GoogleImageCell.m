//
//  GoogleImageCell.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 10/04/13.
//
//

#import "GoogleImageCell.h"

@implementation GoogleImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowRadius = 1;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.66;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
