//
//  TPComposeView.h
//  ComposeView
//
//  Created by Damir Tursunovic on 1/13/12.
//  Copyright (c) 2012 Tappable Software. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    TPComposeViewResultCancelled        = 0,    // Called when the user taps on the left button
    TPComposeViewResultDone             = 1     // Called when the user taps on the right button
}TPComposeViewResult;

@class TPComposeViewButton;

// Completion handler. Returns the result and the text.
typedef void (^TPComposeViewCompletionHandler)(TPComposeViewResult result, NSString *text); 

@interface TPComposeView : UIView

@property (nonatomic, retain) NSString *initialText;
@property (nonatomic, copy) TPComposeViewCompletionHandler completionHandler;
@property (nonatomic, assign) NSUInteger maxChars;   // Max chars limit (default = 0). Any other value enables the max chars limiter

// Initializer with initial text 
-(id)initWithInitialText:(NSString *)initialText;

// Sets the title
-(void)setTitle:(NSString *)title;

// Sets the initial text to be displayed
-(void)setInitialText:(NSString *)initialText;

// Sets the title for left button
-(void)setCancelButtonTitle:(NSString *)title;

// Sets the title for right button
-(void)setComposeButtonTitle:(NSString *)title;

// Presents the compose view
-(void)presentComposeView;

// Dismisses the compose view
-(void)dismissComposeView;

@end