//
//  CenterViewController.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 13/04/13.
//
//

#import <UIKit/UIKit.h>
#import "WSCoachMarksView.h"

@interface CenterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIButton *centerButton;

@property (strong, nonatomic) WSCoachMarksView *coachMarksView;

@end
