//
//  TPComposeView.m
//  ComposeView
//
//  Created by Damir Tursunovic on 1/13/12.
//  Copyright (c) 2012 Tappable Software. All rights reserved.
//

#import "TPComposeView.h"
#import "TPComposeViewButton.h"

static NSString *kComposeViewButtonCancelTitle = @"Cancel";
static NSString *kComposeViewButtonComposeTitle = @"Post";

static NSInteger kComposeViewButtonCancel   = 0;
static NSInteger kComposeViewButtonCompose  = 1;

@interface TPComposeView ()

@property (nonatomic, retain) TPComposeViewButton *composeButton;
@property (nonatomic, retain) TPComposeViewButton *cancelButton;
@property (nonatomic, retain) UIWindow *overlayWindow;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *charsIndicatorLabel;

-(void)configureSubviews;
-(void)drawGradientInRect:(CGRect)rect contextRef:(CGContextRef)ref;
-(BOOL)characterLimitEnabled;
-(void)updateCharacterIndicator;
-(UIInterfaceOrientation)currentInterfaceOrientation;
-(CGAffineTransform)transformForInterfaceOrientation:(UIInterfaceOrientation)orientation;
@end

@implementation TPComposeView

@synthesize initialText = _initialText;
@synthesize textView = _textView;
@synthesize titleLabel = _titleLabel;
@synthesize completionHandler = _completionHandler;
@synthesize maxChars = _maxChars;
@synthesize charsIndicatorLabel = _charsIndicatorLabel;
@synthesize composeButton = _composeButton;
@synthesize cancelButton = _cancelButton;
@synthesize overlayWindow = _overlayWindow;

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setCompletionHandler:nil];
    [_overlayWindow release];
    [_composeButton release];
    [_cancelButton release];
    [_charsIndicatorLabel release];
    [_titleLabel release];
    [_textView release];
    [_initialText release];
    [super dealloc];
}

-(id)init
{
    return [self initWithInitialText:@""];
}

-(id)initWithInitialText:(NSString *)initialText
{
    self = [super initWithFrame:CGRectMake(0.0, -200.0, 320.0, 236.0)];
    if (self)
    {
        _initialText = [initialText retain];
        
        // Create subviews
        [self configureSubviews];
        [_overlayWindow addSubview:self];
        
        // Add observer for the textfield to update the character limiter (if enabled)
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(didUpdateText:) 
                                                     name:UITextViewTextDidChangeNotification 
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willChangeStatusBarOrientation:)
                                                     name:UIApplicationWillChangeStatusBarOrientationNotification
                                                   object:nil];
      
    }
    return self;
}








#pragma mark -
#pragma mark Subview configuration

-(void)configureSubviews
{
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0.0;
    
    _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _overlayWindow.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    _overlayWindow.alpha = 0.0;
    _overlayWindow.transform = [self transformForInterfaceOrientation:[self currentInterfaceOrientation]];
  
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 10.0, self.frame.size.width, 45.0)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.userInteractionEnabled = NO;
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.shadowColor = [UIColor whiteColor];
    _titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    _titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [self addSubview:_titleLabel];
    
    // TextView
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15.0, 62.0, self.frame.size.width-30.0, self.frame.size.height-90.0)];
    _textView.font = [UIFont systemFontOfSize:18];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = [UIColor darkGrayColor];
    _textView.text = _initialText;
    [_textView becomeFirstResponder];
    [self addSubview:_textView];
    
    _charsIndicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-60.0, 190, 40.0, 25.0)];
    _charsIndicatorLabel.backgroundColor = [UIColor clearColor];
    _charsIndicatorLabel.font = [UIFont boldSystemFontOfSize:17];
    _charsIndicatorLabel.textColor = [UIColor grayColor];
    _charsIndicatorLabel.textAlignment = NSTextAlignmentCenter;
    _charsIndicatorLabel.shadowColor = [UIColor whiteColor];
    _charsIndicatorLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    _charsIndicatorLabel.alpha = 0.0;
    [self addSubview:_charsIndicatorLabel];    
     
    // Compose button
    _composeButton = [[TPComposeViewButton buttonWithTitle:kComposeViewButtonComposeTitle color:TPComposeViewButtonColorBlue] retain];
    _composeButton.tag = kComposeViewButtonCompose;
    _composeButton.frame = CGRectMake((self.frame.size.width-20.0)-_composeButton.frame.size.width, 18.0, _composeButton.frame.size.width, _composeButton.frame.size.height);
    [_composeButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];        
    [self addSubview:_composeButton];
    
    // Cancel button
    _cancelButton = [[TPComposeViewButton buttonWithTitle:kComposeViewButtonCancelTitle color:TPComposeViewButtonColorGray] retain];
    _cancelButton.tag = kComposeViewButtonCancel;    
    _cancelButton.frame = CGRectMake(20.0, 18.0, _cancelButton.frame.size.width, _cancelButton.frame.size.height);
    [_cancelButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];    
    [self addSubview:_cancelButton];  
}






#pragma mark -
#pragma mark Drawing

-(void)drawRect:(CGRect)rect
{
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    CGRect composerRect = CGRectMake(10.0, 10.0, 300.0, 216.0);
    
    // Draw the rounded view
    UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:composerRect cornerRadius:10.0];
    CGContextSetFillColorWithColor(ref, [UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.000].CGColor);
    CGContextSaveGState(ref);
    CGContextSetShadowWithColor(ref, CGSizeMake(0.0, 0.0), 8.0, [UIColor blackColor].CGColor);
    [roundedPath fill];
    [roundedPath addClip];
    
    // Draw the navigationBar
    CGContextRestoreGState(ref);
    [roundedPath addClip];
    CGContextSetFillColorWithColor(ref, [UIColor colorWithRed:0.857 green:0.857 blue:0.857 alpha:1.000].CGColor);
    CGContextFillRect(ref, CGRectMake(10.0, 10.0, 300.0, 44.0));
    
    // Draw the highlight on the navigation bar
    CGContextSetStrokeColorWithColor(ref, [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:0.6].CGColor);
    CGContextSetLineWidth(ref, 1.0);
    CGContextMoveToPoint(ref, 0.0, 10.0);
    CGContextAddLineToPoint(ref, 320.0, 10.0);
    CGContextStrokePath(ref);    
    
    // Draw the seperators below the bar
    CGContextSetStrokeColorWithColor(ref, [UIColor colorWithRed:0.804 green:0.804 blue:0.804 alpha:1.000].CGColor);
    CGContextSetLineWidth(ref, 1.0);
    CGContextMoveToPoint(ref, 0.0, 53.0);
    CGContextAddLineToPoint(ref, 320.0, 53.0);
    CGContextStrokePath(ref);    
    
    // Draw the white seperator below the gray one
    CGContextSetStrokeColorWithColor(ref, [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000].CGColor);
    CGContextSetLineWidth(ref, 1.0);
    CGContextMoveToPoint(ref, 0.0, 54.0);
    CGContextAddLineToPoint(ref, 320.0, 54.0);
    CGContextStrokePath(ref);
    
    // Add a subtle gradient
    [self drawGradientInRect:CGRectMake(10.0, 10.0, 320.0, 52.0) contextRef:ref];
}


-(void)drawGradientInRect:(CGRect)rect contextRef:(CGContextRef)ref
{
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0};
    CGFloat components[8] = { 1.0, 1.0, 1.0, 0.6, 1.0, 1.0, 1.0, 0.1 }; 
	
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
	
    CGPoint startPosition = CGPointMake(0.0, 0.0f);
    CGPoint endPosition = CGPointMake(0.0, CGRectGetMaxY(rect));
    CGContextDrawLinearGradient(ref, glossGradient, startPosition, endPosition, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);   
}








#pragma mark -
#pragma mark Public

-(void)setTitle:(NSString *)title
{   
    _titleLabel.text = title;
}

-(void)setCancelButtonTitle:(NSString *)title
{
    _cancelButton.title = title;
}


-(void)setComposeButtonTitle:(NSString *)title
{
    _composeButton.title = title;
    _composeButton.frame = CGRectMake((self.frame.size.width-20.0)-_composeButton.frame.size.width, _composeButton.frame.origin.y, _composeButton.frame.size.width, _composeButton.frame.size.height);
}


-(void)setMaxChars:(NSUInteger)maxChars
{
    _maxChars = maxChars;
    [_charsIndicatorLabel setAlpha:(_maxChars > 0)];
    [self updateCharacterIndicator];
}


-(void)presentComposeView
{
    [_overlayWindow makeKeyAndVisible];
    
    [UIView animateWithDuration:0.24 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.0;      
        _overlayWindow.alpha = 1.0;        
        self.frame = CGRectMake(self.frame.origin.x, 34.0, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) 
    {
        [UIView animateWithDuration:0.18 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.frame = CGRectMake(self.frame.origin.x, 20.0, self.frame.size.width, self.frame.size.height); 
        } completion:^(BOOL finished) {
        }];
    }];
}


-(void)dismissComposeView
{
    [UIView animateWithDuration:0.3 delay:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(self.frame.origin.x, -self.frame.size.height, self.frame.size.width, self.frame.size.height);  
        self.alpha = 0.0;
        _overlayWindow.alpha = 0.0;
    } completion:^(BOOL finished) 
     {
         [self removeFromSuperview];
         [_overlayWindow release], _overlayWindow = nil;
         [[UIApplication sharedApplication].windows.lastObject makeKeyAndVisible];         
     }];
}








#pragma mark -
#pragma mark Button handlers

-(void)didPressButton:(TPComposeViewButton *)button
{
    _completionHandler(button.tag, _textView.text);
    [self setCompletionHandler:nil];
    [self dismissComposeView];
}







#pragma mark -
#pragma mark NSNotification

-(void)didUpdateText:(NSNotification *)notification
{
    if ([self maxChars])
        [self updateCharacterIndicator];
}

-(void)willChangeStatusBarOrientation:(NSNotification *)notification
{
    // Retrieve the new orientation
    NSNumber *orientationNumber = [notification.userInfo objectForKey:UIApplicationStatusBarOrientationUserInfoKey];
    if (nil == orientationNumber)
    {
        return;
    }
    
    UIInterfaceOrientation orientation = [orientationNumber integerValue];
    CGAffineTransform transform = [self transformForInterfaceOrientation:orientation];
    [_overlayWindow setTransform:transform];
}




#pragma mark -
#pragma mark Private

-(BOOL)characterLimitEnabled
{
    return (_maxChars > 0);
}


-(void)updateCharacterIndicator
{
    // Update indicator text
    _charsIndicatorLabel.text = [NSString stringWithFormat:@"%i", _textView.text.length];
    
    // Check if the max nr of characters are reached
    BOOL hasReachedCharacterLimit = (_textView.text.length > _maxChars);
    
    // Disable the compose button and change the color of the char indicator label to red
    _composeButton.enabled = !hasReachedCharacterLimit;        
    (hasReachedCharacterLimit) ? [_charsIndicatorLabel setTextColor:[UIColor colorWithRed:(150.0/255.0) green:(20.0/255.0) blue:(20.0/255.0) alpha:1.0]] : [_charsIndicatorLabel setTextColor:[UIColor grayColor]];
}

-(UIInterfaceOrientation)currentInterfaceOrientation
{
    return [UIApplication sharedApplication].statusBarOrientation;
}

-(CGAffineTransform)transformForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (orientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            transform = CGAffineTransformMakeRotation(M_PI);
            break;
          
        case UIInterfaceOrientationLandscapeLeft:
            transform = CGAffineTransformMakeRotation(M_PI_2);
            break;
          
        case UIInterfaceOrientationLandscapeRight:
            transform = CGAffineTransformMakeRotation(-M_PI_2);
            break;
          
        case UIInterfaceOrientationPortrait:
        default:
            transform = CGAffineTransformMakeRotation(0);
            break;
    }
    
    return transform;
}

@end
