//
//  ViewController.h
//  Consumer Of Great Success
//
//  Created by Yossi Halevi on 1/29/15.
//  Copyright (c) 2015 Yossi Halevi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemPage_QRScan.h"
#import "RegisterViewController.h"

@interface MainViewController : UIViewController <ItemPage_QRScan_protocol, RegisterProtocol>


@end

