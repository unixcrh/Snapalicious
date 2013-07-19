//
//  LeftMapViewController.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 21/04/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import "LeftMapViewController.h"

#import "DetailViewController.h"
#import "CenterViewController.h"

#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
//#import "RMMapView+LayoutMethods.h"

#import "GeoPointAnnotation.h"

@interface LeftMapViewController ()
@property (strong, nonatomic) NSArray *objects;
@end

@implementation LeftMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.layer.masksToBounds = NO;
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navigationController.navigationBar.layer.shadowRadius = 25.0f;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, -5.0f);
    self.navigationController.navigationBar.layer.shadowOpacity = 0.95f;
    self.navigationController.navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.navigationController.navigationBar.bounds].CGPath;
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.mapView];
    
    [self refresh:nil];
}

- (IBAction)refresh:(id)sender {
    [SVProgressHUD show];
    
    CLLocationCoordinate2D cornerCoordinateNE = [self.mapView convertPoint:CGPointMake(self.mapView.frame.size.width, 0) toCoordinateFromView:self.mapView];
    CLLocationCoordinate2D cornerCoordinateSW = [self.mapView convertPoint:CGPointMake(0, self.mapView.frame.size.height) toCoordinateFromView:self.mapView];
    
    PFQuery *query = [Dish query];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    [query whereKeyExists:@"location"];
    PFGeoPoint *southWest = [PFGeoPoint geoPointWithLatitude:cornerCoordinateSW.latitude longitude:cornerCoordinateSW.longitude];
    PFGeoPoint *northEast = [PFGeoPoint geoPointWithLatitude:cornerCoordinateNE.latitude longitude:cornerCoordinateNE.longitude];
    [query whereKey:@"location" withinGeoBoxFromSouthwest:southWest toNortheast:northEast];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *annotationsToRemove = [self.mapView.annotations mutableCopy];
            [annotationsToRemove removeObject:self.mapView.userLocation];
            [self.mapView removeAnnotations:annotationsToRemove];
            for (Dish *dish in objects) {
                GeoPointAnnotation *annotation = [[GeoPointAnnotation alloc] initWithObject:dish];

                [self.mapView addAnnotation:annotation];
            }
            [SVProgressHUD dismiss];
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *GeoPointAnnotationIdentifier = @"RedPinAnnotation";
    
    if ([annotation isKindOfClass:[GeoPointAnnotation class]]) {
        GeoPointAnnotation *ann = (GeoPointAnnotation *)annotation;
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView
                                dequeueReusableAnnotationViewWithIdentifier:GeoPointAnnotationIdentifier];
        
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc]
                              initWithAnnotation:annotation
                              reuseIdentifier:GeoPointAnnotationIdentifier];
            annotationView.tag = 0;
            annotationView.canShowCallout = YES;
            annotationView.pinColor = MKPinAnnotationColorRed;
            annotationView.animatesDrop = YES;
            annotationView.draggable = NO;
            
            // Image View
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 31, 31)];
            imageView.layer.cornerRadius = 4.0;
            imageView.layer.masksToBounds = YES;
            imageView.layer.borderColor = [[UIColor blackColor] CGColor];
            imageView.layer.borderWidth = 1;
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageView setImageWithURL:[NSURL URLWithString:ann.object.momentThumb.url]];
            
            annotationView.leftCalloutAccessoryView = imageView;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    GeoPointAnnotation *annotation = (GeoPointAnnotation *)view.annotation;
    [self.sidePanelController showCenterPanelAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDetail" object:self userInfo:@{@"dish": (Dish *)annotation.object}];
}

//- (void)tapOnCalloutAccessoryControl:(UIControl *)control forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map {
//    [self.sidePanelController showCenterPanelAnimated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDetail" object:self userInfo:@{@"dish": (Dish *)annotation.userInfo}];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
