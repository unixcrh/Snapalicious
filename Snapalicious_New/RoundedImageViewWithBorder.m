//
//  RoundedImageViewWithBorder.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 14/04/13.
//
//

#import "RoundedImageViewWithBorder.h"

@implementation RoundedImageViewWithBorder

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 4.0f;
    self.layer.cornerRadius = self.frame.size.width / 2;
}

@end
