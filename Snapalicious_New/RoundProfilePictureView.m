//
//  RoundProfilePictureView.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 02/03/13.
//
//

#import "RoundProfilePictureView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundProfilePictureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 4.0f;
    self.layer.cornerRadius = self.frame.size.width / 2;
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
