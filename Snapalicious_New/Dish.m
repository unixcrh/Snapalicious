//
//  Dish.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 10/04/13.
//
//

#import "Dish.h"
#import <Parse/PFObject+Subclass.h>

@implementation Dish
@dynamic title, attribution, placeName, location, author, momentThumb, tags, thumbnail;

+ (NSString *)parseClassName {
    return @"Post";
}

@end
