//
//  FlatBlueButton.m
//  Snapalicious-iOS6
//
//  Created by Carlotta Tatti on 28/06/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import "FlatBlueButton.h"

@implementation FlatBlueButton

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
    UIColor *blueColor = [UIColor colorFromHexCode:@"3b5998"];
    UIColor *blueColorLight = [UIColor colorFromHexCode:@"8b9dc3"];
    self.buttonColor = blueColor;
    self.shadowColor = blueColorLight;
    self.shadowHeight = 2.0f;
    self.cornerRadius = 4.0f;
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [self setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
}

@end
