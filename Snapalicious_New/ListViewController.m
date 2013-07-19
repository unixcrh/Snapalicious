//
//  ListViewController.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 25/04/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import "ListViewController.h"
#import "SmallCell.h"

@interface ListViewController ()
@property (strong, nonatomic) NSArray *objects;
@end

@implementation ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setClassType:(NSString *)classType {
    if (_classType != classType) {
        _classType = classType;
    }
}

- (void)setUser:(PFUser *)user {
    if (_user != user) {
        _user = user;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([_classType isEqualToString:@"User"]) {
        PFQuery *query = [PFUser query];
        
    } else {
        PFQuery *query = [PFQuery queryWithClassName:_classType];
        
        if ([_classType isEqualToString:kClassTypeRecipe]) {
            self.title = @"Recipes";
            [query whereKey:@"fromUser"equalTo:_user];
            [query includeKey:@"post"];
        }
        
        if ([_classType isEqualToString:kClassTypeSnapalicious]) {
            self.title = @"Likes";
            [query whereKey:@"fromUser"equalTo:_user];
            [query includeKey:@"post"];
        }
        
        if ([_classType isEqualToString:kClassTypePost]) {
            self.title = @"Dishes";
            [query whereKey:@"author"equalTo:_user];
        }
        
        if ([_classType isEqualToString:kClassTypePost]) {
            self.title = @"Dishes";
            [query whereKey:@"author"equalTo:_user];
        }
        
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        if (self.objects.count == 0) {
            query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        }
        
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                self.objects = objects;
                
                [self.tableView reloadData];
            }
        }];
    }

}

- (IBAction)popToRoot:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (CGFloat)calculateCellHeightForIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = self.objects[indexPath.row];

    int height;
    if ([object.parseClassName isEqualToString:kClassTypeRecipe]) {
        NSString *string = [object objectForKey:@"content"];
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:17]; //Font used in the resizable label
        CGFloat maxWidth = 292; //Width of label in the custom cell
        CGFloat maxHeight = 9999;
        
        CGSize maximumLabelSize = CGSizeMake(maxWidth,maxHeight);
        
        CGSize cellSize = [string sizeWithFont:font constrainedToSize:maximumLabelSize];
        
        height = cellSize.height+64; //+24 for rest of the cell (stuff that doesn't resize)
    } else {
        height = 198;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self calculateCellHeightForIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFObject *object = self.objects[indexPath.row];
    
    if ([object.parseClassName isEqualToString:kClassTypePost]) {
        static NSString *CellIdentifier = @"DishCell";
        SmallCell *cell = (SmallCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if ( cell == nil ){
            NSArray *topObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            for (id obj in topObjects) {
                if ([obj isKindOfClass:[SmallCell class]]) {
                    cell = (SmallCell*)obj;
                    break;
                }
            }
        }
        
        cell.titleLabel.text = object[@"title"];
        if (object[@"placeName"])
            cell.placeLabel.text = object[@"placeName"];
        else
            cell.placeLabel.text = @"";
        
        PFFile *file = object[@"momentThumb"];
        [cell.imgView setImageWithURL:[NSURL URLWithString:file.url]];
        return cell;
    }
    if ([object.parseClassName isEqualToString:kClassTypeRecipe]) {
        static NSString *CellIdentifier = @"RecipeCell";
        SmallCell *cell = (SmallCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if ( cell == nil ){
            NSArray *topObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            for (id obj in topObjects) {
                if ([obj isKindOfClass:[SmallCell class]]){
                    cell = (SmallCell*)obj;
                    break;
                }
            }
        }
        
        CGRect frame = cell.contentView.frame;
        frame.size.height = [self calculateCellHeightForIndexPath:indexPath];
        cell.contentView.frame = frame;
        
        cell.titleLabel.text = [object objectForKey:@"dishName"];
        cell.placeLabel.text = @"";
        cell.infoView.text = [object objectForKey:@"content"];
        return cell;
    }
    
    if ([object.parseClassName isEqualToString:kClassTypeSnapalicious]) {
        static NSString *CellIdentifier = @"DishCell";
        SmallCell *cell = (SmallCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if ( cell == nil ){
            NSArray *topObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            for (id obj in topObjects) {
                if ([obj isKindOfClass:[SmallCell class]]){
                    cell = (SmallCell*)obj;
                    break;
                }
            }
        }
        
        PFObject *post = [object objectForKey:@"post"];
        cell.titleLabel.text = [post objectForKey:@"title"];
        cell.placeLabel.text = @"";
        PFFile *file1 = [post objectForKey:@"momentThumb"];
        [cell.imgView setImageWithURL:[NSURL URLWithString:file1.url]];
        
        return cell;
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
