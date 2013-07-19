//
//  ScrollView.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 08/02/13.
//
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface ScrollView : UIView <RTLabelDelegate>

@property (weak, nonatomic) IBOutlet UIButton *fadingButton;
@property (weak, nonatomic) IBOutlet UILabel *fadingLabel;
@property (weak, nonatomic) IBOutlet UITextView *fadingTextView;

@property (weak, nonatomic) IBOutlet RTLabel *label1;
@property (weak, nonatomic) IBOutlet RTLabel *label2;

- (IBAction)login;

@end
