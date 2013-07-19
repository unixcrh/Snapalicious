//
//  Dish.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 10/04/13.
//
//

#import <Parse/Parse.h>

@interface Dish : PFObject <PFSubclassing>

@property (retain) NSString *title;
@property (retain) NSString *attribution;
@property (retain) NSString *placeName;
@property (retain) PFGeoPoint *location;
@property (retain) PFUser *author;
@property (retain) PFFile *momentThumb;
@property (retain) PFFile *thumbnail;
@property (retain) NSArray *tags;

@end
