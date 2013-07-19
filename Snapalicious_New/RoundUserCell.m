//
//  RoundUserCell.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 13/04/13.
//
//

#import "RoundUserCell.h"

@implementation RoundUserCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    self.picture.contentMode = UIViewContentModeScaleAspectFill;
    self.picture.clipsToBounds = YES;
    self.picture.layer.borderColor = [UIColor whiteColor].CGColor;
    self.picture.layer.borderWidth = 4.0f;
    self.picture.layer.cornerRadius = self.picture.frame.size.width / 2;
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
