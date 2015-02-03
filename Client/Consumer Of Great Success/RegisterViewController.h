//
//  RegisterViewController.h
//  Consumer Of Great Success
//
//  Created by Yossi Halevi on 1/29/15.
//  Copyright (c) 2015 Yossi Halevi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterProtocol <NSObject>
@required
- (void) didSuccessfullyRegistered;
@end


@interface RegisterViewController : UIViewController <UITextViewDelegate>
@property (nonatomic, weak) id<RegisterProtocol> delegate;

@end
