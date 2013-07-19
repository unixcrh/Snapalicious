//
//  ScrollView.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 08/02/13.
//
//

#import "ScrollView.h"
#import "RTLabel.h"

@implementation ScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)login {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidTapLogin" object:nil];
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
