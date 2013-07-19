//
//  NSString+FormattedUsername.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 13/04/13.
//
//

#import <Foundation/Foundation.h>

@interface NSString (FormattedUsername)

+ (NSString *)formattedUsernameWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;

@end
