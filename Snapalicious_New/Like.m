//
//  Like.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 10/04/13.
//
//

#import "Like.h"
#import <Parse/PFObject+Subclass.h>

@implementation Like
@dynamic flag, post, fromUser, toUser;

+ (NSString *)parseClassName {
    return @"Snapalicious";
}

@end
