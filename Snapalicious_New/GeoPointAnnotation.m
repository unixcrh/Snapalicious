//
//  GeoPointAnnotation.m
//  Geolocations
//
//  Created by Héctor Ramos on 8/2/12.
//  Copyright (c) 2013 Parse, Inc. All rights reserved.
//

#import "GeoPointAnnotation.h"

@interface GeoPointAnnotation()
@end

@implementation GeoPointAnnotation


#pragma mark - Initialization

- (id)initWithObject:(Dish *)aObject {
    self = [super init];
    if (self) {
        _object = aObject;
        
        PFGeoPoint *geoPoint = self.object.location;
        [self setGeoPoint:geoPoint];
    }
    return self;
}


#pragma mark - MKAnnotation

// Called when the annotation is dragged and dropped. We update the geoPoint with the new coordinates.
//- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
//    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
//    [self setGeoPoint:geoPoint];
//    [self.object setObject:geoPoint forKey:@"location"];
//    [self.object saveEventually:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            // Send a notification when this geopoint has been updated. MasterViewController will be listening for this notification, and will reload its data when this notification is received.
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"geoPointAnnotiationUpdated" object:self.object];
//        }
//    }];
//}


#pragma mark - ()

- (void)setGeoPoint:(PFGeoPoint *)geoPoint {
    _coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    
    _title = self.object.title;
    _subtitle = self.object.placeName;
}

@end
