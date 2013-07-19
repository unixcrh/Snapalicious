//
//  NSString+FormattedUsername.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 13/04/13.
//
//

#import "NSString+FormattedUsername.h"

@implementation NSString (FormattedUsername)

+ (NSString *)formattedUsernameWithFirstName:(NSString *)firstName lastName:(NSString *)lastName {
    NSString *username = [NSString stringWithFormat:@"%@ %@.", firstName, [lastName substringToIndex:1]];
    return username;
}

@end
