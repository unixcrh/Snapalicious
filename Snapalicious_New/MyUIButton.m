//
//  MyUIButton.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 11/04/13.
//
//

#import "MyUIButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyUIButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
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
