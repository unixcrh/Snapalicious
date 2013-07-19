//
//  MiscUtils.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 10/02/13.
//
//

#import "MiscUtils.h"

@implementation MiscUtils

+ (double)calculateHotnessForRepliesCount:(int)numOfReplies givenLastPostDate:(NSDate *)postDate {
    // Calculate how much time (in hours) is passed from the last post
    NSDate *now = [NSDate date];
    
    NSTimeInterval distanceBetweenDates = [now timeIntervalSinceDate:postDate];
    double secondsInAnHour = 3600;
    NSInteger timeSinceLastPost = distanceBetweenDates / secondsInAnHour;
    
    // Calculate the "hotness" of the post
    if (numOfReplies > 0) {
        double hotness = log10(numOfReplies * 20000 / pow(timeSinceLastPost, 1.3));
        NSLog(@"\"hotness\" value is %f", hotness);
        
        return numOfReplies;
    }
    
    return 0;
}

+ (NSURL *)createShortURLWithString:(NSString *)string {
    NSString *shortenedURL = [NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", string];
    NSLog(@"%@", shortenedURL);
    return [NSURL URLWithString:shortenedURL];
}

+ (NSArray *)createTagsFromTitle:(NSString *)dishName {
    NSArray *nameComps = [dishName componentsSeparatedByString:@" "];
    __block NSMutableArray *tags = [NSMutableArray new];
    for (NSString *comp in nameComps) {
        NSString *cleanComp = [self prepareString:comp];
        if (cleanComp.length > 3) {
            [tags addObject:cleanComp];
        }
    }
    
    return [NSArray arrayWithArray:tags];
}

+ (NSArray *)getUsersWhoAskedDetails:(PFObject *)post {
    NSMutableArray *users = [NSMutableArray new];
    
    PFQuery *query = [PFQuery queryWithClassName:kClassTypeRequest];
    [query whereKey:@"post" equalTo:post];
    [query includeKey:@"fromUser"];
    NSArray *results = [query findObjects];
    for (int i=0;i<results.count;i++) {
        PFObject *object = [results objectAtIndex:i];
        PFUser *user = [object objectForKey:@"fromUser"];
        [users addObject:user];
        return [NSArray arrayWithArray:users];
    }
    
    return nil;
}

+ (NSArray *)getUsersWhoLiked:(PFObject *)post {
    NSMutableArray *users = [NSMutableArray new];

    PFQuery *query = [PFQuery queryWithClassName:kClassTypeSnapalicious];
    [query whereKey:@"post" equalTo:post];
    [query includeKey:@"fromUser"];
    NSArray *results = [query findObjects];
    for (int i=0;i<results.count;i++) {
        PFObject *object = [results objectAtIndex:i];
        PFUser *user = [object objectForKey:@"fromUser"];
        [users addObject:user];
        return [NSArray arrayWithArray:users];
    }
    
    return nil;
}

+ (NSArray *)getRecipesForPost:(PFObject *)post {
    PFQuery *query = [PFQuery queryWithClassName:kClassTypeRecipe];
    [query whereKey:@"post" equalTo:post];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"fromUser"];
    return [query findObjects];
}

+ (NSArray *)getRecipeRequestsForPost:(PFObject *)post {
    PFQuery *query = [PFQuery queryWithClassName:kClassTypeRequest];
    [query whereKey:@"post" equalTo:post];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"fromUser"];
    return [query findObjects];
}

+ (NSArray *)getLikesForPost:(PFObject *)post {
    PFQuery *query = [PFQuery queryWithClassName:kClassTypeSnapalicious];
    [query whereKey:@"post" equalTo:post];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"flag" equalTo:[NSNumber numberWithBool:YES]];
    [query includeKey:@"fromUser"];
    return [query findObjects];
}

+ (NSString*)prepareString:(NSString*)a {
    
    a = [a stringByReplacingOccurrencesOfString:@" " withString:@""];
    a = [a stringByReplacingOccurrencesOfString:@"'" withString:@""];
    a = [a stringByReplacingOccurrencesOfString:@"`" withString:@""];
    a = [a stringByReplacingOccurrencesOfString:@"-" withString:@""];
    a = [a stringByReplacingOccurrencesOfString:@"_" withString:@""];
    a = [a lowercaseString];
    
    return a;
}

+ (NSArray *)queryForFriends {
    __block NSArray *friendUsers = [NSArray new];
    // Issue a Facebook Graph API request to get your user's friend list
    FBRequest *request = [FBRequest requestForMyFriends];
    [request startWithCompletionHandler:^(FBRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"fbId" containedIn:friendIds];
            
            // findObjects will return a list of PFUsers that are friends
            // with the current user
            friendUsers = [friendQuery findObjects];
        }
    }];
    return friendUsers;
}

+ (id<Recipe>)recipeObjectForRecipe:(NSString*)recipe
{
    // This URL is specific to this sample, and can be used to
    // create arbitrary OG objects for this app; your OG objects
    // will have URLs hosted by your server.
    NSString *format =
    @"https://vast-reef-6334.herokuapp.com/index.php?"
    @"fb:app_id=399610480079656&og:type=%@&"
    @"og:title=%@&og:description=%%22%@%%22&"
    @"og:image=https://s-static.ak.fbcdn.net/images/devsite/attachment_blank.png&"
    @"body=%@";
    
    // We create an FBGraphObject object, but we can treat it as
    // an SCOGMeal with typed properties, etc. See <FacebookSDK/FBGraphObject.h>
    // for more details.
    id<Recipe> result = (id<Recipe>)[FBGraphObject graphObject];
    
    // Give it a URL that will echo back the name of the meal as its title,
    // description, and body.
    result.url = [NSString stringWithFormat:format,
                  @"snapalicious:recipe", recipe, recipe, recipe];
    
    return result;
}

+ (id<Dish>)dishObjectForDish:(NSString*)dish
{
    // This URL is specific to this sample, and can be used to
    // create arbitrary OG objects for this app; your OG objects
    // will have URLs hosted by your server.
    NSString *format =
    @"https://vast-reef-6334.herokuapp.com/index.php?"
    @"fb:app_id=399610480079656&og:type=%@&"
    @"og:title=%@&og:description=%%22%@%%22&"
    @"og:image=https://s-static.ak.fbcdn.net/images/devsite/attachment_blank.png&"
    @"body=%@";
    
    // We create an FBGraphObject object, but we can treat it as
    // an SCOGMeal with typed properties, etc. See <FacebookSDK/FBGraphObject.h>
    // for more details.
    id<Dish> result = (id<Dish>)[FBGraphObject graphObject];
    
    // Give it a URL that will echo back the name of the meal as its title,
    // description, and body.
    result.url = [NSString stringWithFormat:format,
                  @"snapalicious:dish", dish, dish, dish];
    
    return result;
}

+ (bool)getPublishToFeedValue {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs stringForKey:@"publishToFeed"];
}

+ (void)setPublishToFeedValueTo:(bool)value {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:value forKey:@"publishToFeed"];
    [prefs synchronize];
}

@end
