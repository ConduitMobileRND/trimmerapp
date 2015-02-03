//
//  QueueViewController.h
//  Consumer Of Great Success
//
//  Created by Yossi Halevi on 1/29/15.
//  Copyright (c) 2015 Yossi Halevi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueueViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
- (id) initWithData :(NSArray *)data;

@end
