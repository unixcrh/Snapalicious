//
//  Like.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 10/04/13.
//
//

#import <Parse/Parse.h>
#import "Dish.h"

@interface Like : PFObject <PFSubclassing>

@property bool flag;
@property (retain) PFUser *fromUser;
@property (retain) PFUser *toUser;
@property (retain) Dish *post;

@end
