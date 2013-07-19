//
//  Recipe.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 10/04/13.
//
//

#import <Parse/Parse.h>
#import "Dish.h"

@interface Recipe : PFObject <PFSubclassing>

@property (retain) NSString *content;
@property (retain) NSString *dishName;
@property (retain) PFUser *fromUser;
@property (retain) PFUser *toUser;
@property (retain) Dish *post;

@end
