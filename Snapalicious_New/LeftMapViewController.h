//
//  LeftMapViewController.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 21/04/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LeftMapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;

- (IBAction)refresh:(id)sender;

@end
