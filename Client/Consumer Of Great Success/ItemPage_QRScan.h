//
//  ItemPage_QRScan.h
//  ConduitApplication
//
//  Created by Yoav Paskaro on 2/26/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ItemPage_QRScan_protocol <NSObject>
@required
- (void) didSuccessfullyScan:(NSString *) scannedValue;
@end



@interface ItemPage_QRScan : UIViewController <AVCaptureMetadataOutputObjectsDelegate> {
    UIImageView *outerFrame;
    
    //bottomBar
    IBOutlet UIView *viewBottomBar;
    IBOutlet UILabel *lblBottomBarTitle;
    
    UIView *overlayView;
    
    NSString *sUrl;
    BOOL bFlashOn;
}
@property (nonatomic, weak) id<ItemPage_QRScan_protocol> delegate;


@end
