//
//  MiscUtils.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 10/02/13.
//
//

#import <Foundation/Foundation.h>
#import "Protocols.h"

@interface MiscUtils : NSObject

+ (double)calculateHotnessForRepliesCount:(int)numOfReplies givenLastPostDate:(NSDate *)postDate;

+ (NSURL *)createShortURLWithString:(NSString *)string;
+ (NSArray *)createTagsFromTitle:(NSString *)dishName;
+ (NSArray *)queryForFriends;
+ (NSString*)prepareString:(NSString*)a;

+ (NSArray *)getUsersWhoAskedDetails:(PFObject *)post;
+ (NSArray *)getUsersWhoLiked:(PFObject *)post;

+ (NSArray *)getRecipesForPost:(PFObject *)post;
+ (NSArray *)getRecipeRequestsForPost:(PFObject *)post;
+ (NSArray *)getLikesForPost:(PFObject *)post;

+ (bool)getPublishToFeedValue;
+ (void)setPublishToFeedValueTo:(bool)value;

+ (id<Recipe>)recipeObjectForRecipe:(NSString*)recipe;
+ (id<Dish>)dishObjectForDish:(NSString*)dish;

@end
