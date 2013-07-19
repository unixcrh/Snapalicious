//
//  SidePanelController.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 13/04/13.
//
//

#import "SidePanelController.h"
#import "YouViewController.h"

@interface SidePanelController ()
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSArray *results;
@end

@implementation SidePanelController

- (void)awakeFromNib
{
    [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
    [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"]];
    [self setRightPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
