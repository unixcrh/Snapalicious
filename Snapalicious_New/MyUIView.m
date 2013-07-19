//
//  MyUIView.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 11/02/13.
//
//

#import "MyUIView.h"
#import "UIBezierPath+ShadowPath.h"

@implementation MyUIView

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
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowRadius = 1;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.66;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:3].CGPath;
}

@end
