//
//  GoogleImagesUtils.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 10/04/13.
//
//

#import "GoogleImagesUtils.h"

@implementation GoogleImagesUtils

+ (NSArray *)getImagesForTerm:(NSString *)term {
    NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/customsearch/v1?q=%@&cx=015132964000596413452:p05ygwom354&imgSize=xxlarge&imgType=photo&num=9&rights=cc_attribution&safe=high&searchType=image&key=AIzaSyAzy5fI3iI5flh8kP46a51T2UBHHN7nnnU", term];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    int statusCode = response.statusCode;
    if (statusCode == 200) {
        NSArray *items = result[@"items"];
        return items;
    }
    return nil;
}
@end
