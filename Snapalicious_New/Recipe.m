//
//  Recipe.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 10/04/13.
//
//

#import "Recipe.h"
#import <Parse/PFObject+Subclass.h>

@implementation Recipe
@dynamic content, post, dishName, fromUser, toUser;

+ (NSString *)parseClassName {
    return @"Recipe";
}

@end
