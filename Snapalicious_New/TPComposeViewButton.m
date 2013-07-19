//
//  TPComposeViewButton.m
//  ComposeView
//
//  Created by Damir Tursunovic on 1/13/12.
//  Copyright (c) 2012 Tappable Software. All rights reserved.
//

#import "TPComposeViewButton.h"

@interface TPComposeViewButton (Private)
-(CGColorRef)colorRefForButtonColor:(TPComposeViewButtonColor)buttonColor;
-(void)drawButtonGradientWithBaseColor:(CGColorRef)baseColor ref:(CGContextRef)ref;
-(CGColorRef)darkerColorFromColor:(CGColorRef)color;
@end

@implementation TPComposeViewButton

@synthesize buttonColor = _buttonColor;
@synthesize title = _title;

-(id)initWithTitle:(NSString *)title color:(TPComposeViewButtonColor)buttonColor
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        _title = [title retain];
        _buttonColor = buttonColor;
        
        self.backgroundColor = [UIColor clearColor];        
        
        CGSize labelSize = [_title sizeWithFont:[UIFont boldSystemFontOfSize:14]];
        self.frame = CGRectMake(0.0, 0.0, labelSize.width+20.0, 30.0);
    }
    return self;
}

+(TPComposeViewButton *)buttonWithTitle:(NSString *)title color:(TPComposeViewButtonColor)buttonColor
{
    return [[[self alloc] initWithTitle:title color:buttonColor] autorelease];
}






#pragma mark -
#pragma mark Drawing

-(void)drawRect:(CGRect)rect
{
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGColorRef buttonColor = [self colorRefForButtonColor:_buttonColor];

    UIBezierPath *strokePath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:6.0];
    CGContextSetFillColorWithColor(ref, [UIColor whiteColor].CGColor);
    [strokePath fill];
    
    UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-1.0) cornerRadius:6.0];
    CGContextSetFillColorWithColor(ref, buttonColor);
    [roundedPath addClip];
    [self drawButtonGradientWithBaseColor:buttonColor ref:ref];

    if (self.enabled)
    {
        [[UIColor whiteColor] set];
        CGContextSetShadowWithColor(ref, CGSizeMake(0.0, -1.0), 0.0, [UIColor colorWithWhite:0.0 alpha:0.6].CGColor);
    }
    else
    {
        [[UIColor colorWithWhite:1.0 alpha:0.3] set];
        CGContextSetShadowWithColor(ref, CGSizeMake(0.0, -1.0), 0.0, [UIColor colorWithWhite:0.0 alpha:0.1].CGColor);        
    }
    
    [_title drawInRect:CGRectMake(0.0, 5.0, rect.size.width, 30.0) withFont:[UIFont boldSystemFontOfSize:14] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
}


-(void)drawButtonGradientWithBaseColor:(CGColorRef)baseColor ref:(CGContextRef)ref
{
    CGColorRef lighterColor = CGColorCreateCopyWithAlpha(baseColor, .75);
    
    CGRect rect = self.bounds;    
    NSArray *colors = [NSArray arrayWithObjects:(id)lighterColor, baseColor, nil];
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, NULL);    
    CGContextDrawLinearGradient(ref, gradient, CGPointMake(0, 0), CGPointMake(0, rect.size.height), 0);
    
    CGColorSpaceRelease(space);
    CGGradientRelease(gradient);
    CGColorRelease(lighterColor);
}





#pragma mark -
#pragma mark Setters

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    (highlighted) ? [self setAlpha:0.6] : [self setAlpha:1.0];
}


-(void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled]; 
    [self setNeedsDisplay];
}


-(void)setTitle:(NSString *)title
{
    if (_title != title)
    {
        [_title release];
        _title = [title retain];
        
        CGSize labelSize = [_title sizeWithFont:[UIFont boldSystemFontOfSize:14]];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, labelSize.width+20.0, 30.0);        
        [self setNeedsDisplay];
    }
}






#pragma mark -
#pragma mark Private

-(CGColorRef)colorRefForButtonColor:(TPComposeViewButtonColor)buttonColor
{
    if (buttonColor == TPComposeViewButtonColorBlue)
        return [UIColor colorWithRed:0.122 green:0.431 blue:0.784 alpha:1.000].CGColor;
    
    if (buttonColor == TPComposeViewButtonColorGray)
        return [UIColor colorWithRed:0.584 green:0.588 blue:0.588 alpha:1.000].CGColor;
    
    return [UIColor colorWithRed:0.435 green:0.463 blue:0.494 alpha:1.000].CGColor;
}
@end
