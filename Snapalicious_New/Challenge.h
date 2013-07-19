//
//  Challenge.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 17/04/13.
//
//

#import <Foundation/Foundation.h>

@interface Challenge : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (retain) NSString *details;
@property (retain) Dish *parent;
@property (retain) PFUser *fromUser;
@property (retain) NSDate *endDate;
@property int bounty;

@end
