
//
//  ItemPage_QRScan.m
//  ConduitApplication
//
//  Created by Yoav Paskaro on 2/26/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ItemPage_QRScan.h"

#define _P_OuterFrameWidth 188
#define _P_InnerFrameWidth 188



@interface ItemPage_QRScan ()

@property (strong, nonatomic) AVCaptureDevice* device;
@property (strong, nonatomic) AVCaptureDeviceInput* input;
@property (strong, nonatomic) AVCaptureMetadataOutput* output;
@property (strong, nonatomic) AVCaptureSession* session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* preview;

@end

@implementation ItemPage_QRScan

- (UIColor*)inverseColor:(UIColor*)color {
	CGColorRef oldCGColor = color.CGColor;
	
	size_t numberOfComponents = CGColorGetNumberOfComponents(oldCGColor);
	
	// can not invert - the only component is the alpha
	if (numberOfComponents == 1) {
		return [UIColor colorWithCGColor:oldCGColor];
	}
	
	const CGFloat *oldComponentColors = CGColorGetComponents(oldCGColor);
	CGFloat newComponentColors[numberOfComponents];
	
	int i = (int)numberOfComponents - 1;
	newComponentColors[i] = oldComponentColors[i]; // alpha
	while (--i >= 0) newComponentColors[i] = 1 - oldComponentColors[i];
	
	CGColorRef newCGColor = CGColorCreate(CGColorGetColorSpace(oldCGColor), newComponentColors);
	UIColor *newColor = [UIColor colorWithCGColor:newCGColor];
	CGColorRelease(newCGColor);
	
	return newColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // set transparent navigation bar
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
}


- (void) viewDidLoad
{
    [super viewDidLoad];
	
    lblBottomBarTitle.text = @"Scan";
    lblBottomBarTitle.textColor = [UIColor whiteColor];
    lblBottomBarTitle.textAlignment = NSTextAlignmentCenter;
    lblBottomBarTitle.backgroundColor = [UIColor clearColor];
    lblBottomBarTitle.font = [UIFont boldSystemFontOfSize:24];
    lblBottomBarTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lblBottomBarTitle.clipsToBounds = YES;
    
    viewBottomBar.backgroundColor = [UIColor blackColor];
    viewBottomBar.alpha = 0.7;
    
    //init scan process
    if([self isCameraAvailable]) {
        [self setupScanner];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self stopScanning];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.preview.frame = self.view.bounds;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if (self.session)
        self.preview.connection.videoOrientation = (AVCaptureVideoOrientation)toInterfaceOrientation;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    CGRect frame = CGRectMake((self.view.frame.size.width - _P_OuterFrameWidth)/2,
                       (self.view.frame.size.height - viewBottomBar.frame.size.height - _P_OuterFrameWidth)/2,
                       _P_OuterFrameWidth, _P_OuterFrameWidth);
    outerFrame.frame = frame;
}

- (void) setupScanner;
{
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    self.session = [[AVCaptureSession alloc] init];
    
	self.output = [[AVCaptureMetadataOutput alloc] init];
	[self.output setMetadataObjectsDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
	
    [self.session addOutput:self.output];
    [self.session addInput:self.input];
	
	self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = self.view.bounds;
    
    AVCaptureConnection *con = self.preview.connection;
    
    con.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    [self startScanning];
}


-(void) addOverlay
{
    [self removeOverlay];
    if(!overlayView)
    {
        overlayView = [[UIView alloc]init];
        overlayView.backgroundColor = [UIColor blackColor];
        overlayView.alpha = 0.25;
        overlayView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    }
    overlayView.frame = self.view.bounds;
    [self.view.layer addSublayer: overlayView.layer];
}

-(void) removeOverlay
{
    [overlayView.layer removeFromSuperlayer];
}

-(void) addOuterFrame
{
    [self removeOuterFrame];
    if(!outerFrame)
        outerFrame = [[UIImageView alloc] init];
    
    CGRect frame = CGRectMake((self.view.frame.size.width - _P_OuterFrameWidth)/2,
                              (self.view.frame.size.height - viewBottomBar.frame.size.height - _P_OuterFrameWidth)/2,
                              _P_OuterFrameWidth, _P_OuterFrameWidth);
    
    outerFrame = [[UIImageView alloc] initWithFrame:frame];
    outerFrame.image = [UIImage imageNamed:@"qr-frame.png"];
    [self.view.layer addSublayer: outerFrame.layer];
}

-(void) removeOuterFrame
{
    [outerFrame.layer removeFromSuperlayer];
}

-(void) addBottomBar
{
    [self removeBottomBar];
    [self.view.layer addSublayer: viewBottomBar.layer];
}

-(void) removeBottomBar
{
    [viewBottomBar.layer removeFromSuperlayer];
}

#pragma mark - Helper Methods

- (BOOL) isCameraAvailable;
{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    return [videoDevices count] > 0;
}

- (void)startScanning;
{
    bFlashOn = NO;
    
    [self addOuterFrame];
//    [self addOverlay];
    [self addBottomBar];
	
    viewBottomBar.hidden = NO;
    
    [self.session startRunning];
    
}

- (void) stopScanning;
{
    if (self.session.isRunning)
        [self.session stopRunning];
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    for(AVMetadataObject *current in metadataObjects) {
        if([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            NSString *scannedValue = [((AVMetadataMachineReadableCodeObject *) current) stringValue];
            NSURL *url = [NSURL URLWithString:scannedValue];
            if (url) {
				dispatch_async(dispatch_get_main_queue(), ^{
					[self stopScanning];
					[self.delegate didSuccessfullyScan:scannedValue];
					[self dismissViewControllerAnimated:YES completion:nil];
				});
            }
        }
    }
}


@end

