//
//  TPComposeViewButton.h
//  ComposeView
//
//  Created by Damir Tursunovic on 1/13/12.
//  Copyright (c) 2012 Tappable Software. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    TPComposeViewButtonColorGray        = 0,
    TPComposeViewButtonColorBlue        = 1
}TPComposeViewButtonColor;

@interface TPComposeViewButton : UIControl

@property (nonatomic, assign) TPComposeViewButtonColor buttonColor;
@property (nonatomic, retain) NSString *title;

-(id)initWithTitle:(NSString *)title color:(TPComposeViewButtonColor)buttonColor;
+(TPComposeViewButton *)buttonWithTitle:(NSString *)title color:(TPComposeViewButtonColor)buttonColor;

@end
