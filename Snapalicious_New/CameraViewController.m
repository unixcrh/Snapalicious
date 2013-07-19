//
//  CameraViewController.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 27/04/13.
//  Copyright (c) 2013 Carlotta Tatti. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraViewController ()
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@end

@implementation CameraViewController

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
	// Do any additional setup after loading the view.
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetMedium];
    
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    if ( [session canAddInput:deviceInput] )
        [session addInput:deviceInput];
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer *rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    [previewLayer setFrame:CGRectMake(-70, 0, rootLayer.bounds.size.height, rootLayer.bounds.size.height)];
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:self.stillImageOutput];
    
	[session startRunning];
}

- (IBAction)captureNow
{
	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in self.stillImageOutput.connections)
	{
		for (AVCaptureInputPort *port in [connection inputPorts])
		{
			if ([[port mediaType] isEqual:AVMediaTypeVideo] )
			{
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) { break; }
	}
	
	NSLog(@"about to request a capture from: %@", self.stillImageOutput);
	[self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
		 CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, NULL, NULL);
		 if (exifAttachments)
		 {
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
		 }
         else
             NSLog(@"no attachments");
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         self.vImage.image = image;
	 }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
