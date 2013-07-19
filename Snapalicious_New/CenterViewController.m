//
//  CenterViewController.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 13/04/13.
//
//

#import "CenterViewController.h"

#import "DetailedDishCell.h"
#import "DetailViewController.h"

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

@interface CenterViewController () {
    BOOL isSearching;
}
@property (strong, nonatomic) NSMutableArray *objects;
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation CenterViewController

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
    
    isSearching = NO;
        
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToDetail:) name:@"ShowDetail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startCoachMarks) name:@"StartWalktrough" object:nil];
    
    // Initialize Refresh Control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    // Configure Refresh Control
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    // Configure View Controller
    [self.tableView addSubview:refreshControl];
    
    for (UIView *subview in self.searchBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    
    self.searchBar.backgroundColor = [UIColor pumpkinColor];
    
    [self refreshData:nil];
        
    if ([self isOriental]) {
        [self.centerButton setImage:[UIImage imageNamed:@"oriental"] forState:UIControlStateNormal];
    } else {
        [self.centerButton setImage:[UIImage imageNamed:@"occidental"] forState:UIControlStateNormal];
    }
        
    // Setup coach marks
    NSArray *coachMarks = @[
                            @{
                                @"rect": [NSValue valueWithCGRect:CGRectMake(0, 44, 320, 360)],
                                @"caption": @"Latest dishes"
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{0.0f,0.0f},{60.0f,45.0f}}],
                                @"caption": @"Show world map"
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{275.0f,0.0f},{320.0f,45.0f}}],
                                @"caption": @"Show profile view"
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:CGRectMake(self.centerButton.frame.origin.x-10, self.centerButton.frame.origin.y-10, self.centerButton.frame.size.width+20, self.centerButton.frame.size.height+20)],
                                @"caption": @"Share a dish"
                                }
                            ];
    self.coachMarksView = [[WSCoachMarksView alloc] initWithFrame:self.view.bounds coachMarks:coachMarks];
    [self.navigationController.view addSubview:self.coachMarksView];
    self.coachMarksView.maskColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void) hideKeyboard
{
    [self.searchBar endEditing:YES];
}

- (void)startCoachMarks {
    [self.coachMarksView start];
}

- (void)goToDetail:(id)sender {
    NSNotification *notif = (NSNotification *)sender;
    Dish *dish = notif.userInfo[@"dish"];
    [self performSegueWithIdentifier:@"showDetail" sender:dish];
}

- (BOOL)isOriental {
    NSArray *orientalCountryCodes = [NSArray arrayWithObjects:@"CN", @"TH", @"KP", @"KR", @"JP", @"NP", @"VN", nil];
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    if ([orientalCountryCodes containsObject:countryCode]) {        
        return YES;
    }
    
    return NO;
}

- (void)refreshData:(id)sender {
    [SVProgressHUD show];
    PFQuery *query = [Dish query];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.objects = [objects mutableCopy];
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            [(UIRefreshControl *)sender endRefreshing];
        }
    }];
}

#pragma mark - UISearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    isSearching = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;

    PFQuery *query = [Dish query];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"titleTokens" containsAllObjectsInArray:[searchText componentsSeparatedByString:@" "]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.searchBar endEditing:YES];
            _searchResults = objects;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewController Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailedDishCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Dish *dish = nil;
    
    if (isSearching == YES) {
        dish = _searchResults[indexPath.row];
    } else {
        dish = _objects[indexPath.row];
    }

    cell.titleLabel.text = dish.title;
    
    PFFile *file = dish.momentThumb;
    [cell.imgView setImageWithURL:[NSURL URLWithString:file.url]];
    
    PFUser *user = dish.author;
    
    cell.imageIcon.profileID = user[@"fbId"];

    PFQuery *likes = [PFQuery queryWithClassName:kClassTypeSnapalicious];
    [likes whereKey:@"post" equalTo:dish];
    [likes countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            cell.likesCountLabel.text = [NSString stringWithFormat:@"%i", number];
        }
    }];
    
    PFQuery *comments = [PFQuery queryWithClassName:kClassTypeRecipe];
    [comments whereKey:@"post" equalTo:dish];
    [comments countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            cell.commentsCountLabel.text = [NSString stringWithFormat:@"%i", number];
        }
    }];

    cell.attributionLabel.text = @"";
    cell.attributionLabel.hidden = YES;
    
    if (dish.attribution.length != 0) {
        cell.attributionLabel.text = [NSString stringWithFormat:@"Copyright © %@", dish.attribution];
        cell.attributionLabel.hidden = NO;
    }
    
    return cell;
}

#pragma mark - UITableViewController Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showDetail" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            DetailViewController *vc = (DetailViewController *)segue.destinationViewController;
            [vc setDetailItem:self.objects[indexPath.row]];
        }
        
        if ([sender isKindOfClass:[Dish class]]) {
            Dish *dish = (Dish *)sender;
            DetailViewController *vc = (DetailViewController *)segue.destinationViewController;
            [vc setDetailItem:dish];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
