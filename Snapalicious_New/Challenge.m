//
//  Challenge.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 17/04/13.
//
//

#import "Challenge.h"
#import <Parse/PFObject+Subclass.h>

@implementation Challenge
@dynamic endDate, fromUser, parent, bounty, details;

+ (NSString *)parseClassName {
    return @"Challenges";
}

@end
