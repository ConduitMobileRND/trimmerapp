//
//  ViewController.m
//  Consumer Of Great Success
//
//  Created by Yossi Halevi on 1/29/15.
//  Copyright (c) 2015 Yossi Halevi. All rights reserved.
//

#import "MainViewController.h"
#import "QueueViewController.h"
#import "ServicesManager.h"
#import "ServicesManager.h"

@interface MainViewController () {
    UIButton *regButton;
    UIButton *scanButton;
    UIButton *goToqueueButton;
    UIButton *logoutButton;
    
    float screenWidth;
    float buttonsWidth;
    float buttonsHeight;
}

@property (nonatomic, assign) BOOL isRegistered;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupViews];
    
    [self registerUser];
}

- (void) setupViews {
    float yPosition = 150 ;

    screenWidth = self.view.frame.size.width;
    buttonsWidth = 150;
    buttonsHeight = 50;
    
    regButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth - buttonsWidth)/2, yPosition, buttonsWidth, buttonsHeight)];
    [regButton setTitle:@"Register" forState:UIControlStateNormal];
    regButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [regButton setBackgroundColor:[UIColor grayColor]];
    [regButton addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    regButton.hidden = _isRegistered;
    [self.view addSubview:regButton];
    
    yPosition += 80;

    scanButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth - buttonsWidth)/2, yPosition, buttonsWidth, buttonsHeight)];
    [scanButton setTitle:@"Scan" forState:UIControlStateNormal];
    scanButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [scanButton setBackgroundColor:[UIColor grayColor]];
    [scanButton addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    scanButton.hidden = !_isRegistered;
    [self.view addSubview:scanButton];
    

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    float yPosition = scanButton.frame.origin.y + 80;

    if([[NSUserDefaults standardUserDefaults] objectForKey:LATEST_SERVICE]) {
        
        
        goToqueueButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth - buttonsWidth)/2, yPosition, buttonsWidth, buttonsHeight)];
        [goToqueueButton setTitle:@"Go To latest Queue" forState:UIControlStateNormal];
        goToqueueButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        [goToqueueButton setBackgroundColor:[UIColor grayColor]];
        [goToqueueButton addTarget:self action:@selector(goToLatestQueue) forControlEvents:UIControlEventTouchUpInside];
        goToqueueButton.hidden = !_isRegistered;
        [self.view addSubview:goToqueueButton];
    }
    
    yPosition += 80;

    
    logoutButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth - buttonsWidth)/2, yPosition, buttonsWidth, buttonsHeight)];
    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    logoutButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [logoutButton setBackgroundColor:[UIColor grayColor]];
    [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    logoutButton.hidden = !_isRegistered;
    [self.view addSubview:logoutButton];
}

- (void) goToLatestQueue {
    
    NSString *urlPath = [NSString stringWithFormat:@"service/%@/queue",[[NSUserDefaults standardUserDefaults] objectForKey:LATEST_SERVICE]];
    
    [ServicesManager serverApiWithHttpMethod:getMethod andUrlPath:urlPath andParameters:nil completion:^(BOOL success, NSDictionary *data, NSString *errorString) {
        
        if (success) {
            @try {
                NSMutableArray * queueArray = [data objectForKey:@"queue"];
                
                QueueViewController *cont = [[QueueViewController alloc] initWithData:queueArray];
                [self.navigationController pushViewController:cont animated:YES];
            }
            @catch (NSException *exception) {
                NSLog(@"exception : %@",exception);
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed To Send scanned object, Please Try Again"
                                                            message:errorString
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }];
}

- (void) registerUser {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:REGISTERED]) {
        _isRegistered = YES;
        [self buttonsControl];
        return;
    }
    
    RegisterViewController *itemPage = [RegisterViewController new];
    itemPage.delegate = self;
    [self presentViewController:itemPage animated:NO completion:nil];
    _isRegistered = NO;

}

-(void)logout {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:REGISTERED];
    _isRegistered = NO;
    [self buttonsControl];

}

-(void)buttonsControl {
    scanButton.hidden = !_isRegistered;
    regButton.hidden = _isRegistered;
}

- (void) didSuccessfullyRegistered {
    
    _isRegistered = YES;
    [self buttonsControl];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void) scan {
    ItemPage_QRScan *itemPage = [ItemPage_QRScan new];
    itemPage.delegate = self;
    [self presentViewController:itemPage animated:YES completion:nil];

}

- (void) didSuccessfullyScan:(NSString *) scannedValue {
    
    [[NSUserDefaults standardUserDefaults] setObject:scannedValue forKey:LATEST_SERVICE];

    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID],@"user_id", nil];
    
    NSString *urlPath = [NSString stringWithFormat:@"service/%@/queue/add",scannedValue];
    
    [ServicesManager serverApiWithHttpMethod:postMethod andUrlPath:urlPath andParameters:dic completion:^(BOOL success, NSDictionary *data, NSString *errorString) {
                
        if (success) {
            @try {
                NSMutableArray * queueArray = [data objectForKey:@"queue"];
                
                QueueViewController *cont = [[QueueViewController alloc] initWithData:queueArray];
                [self.navigationController pushViewController:cont animated:YES];
            }
            @catch (NSException *exception) {
                NSLog(@"exception : %@",exception);
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed To Send scanned object, Please Try Again"
                                                            message:errorString
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }];

    
    
    /*
    NSLog(@"Scanned value : @%",scannedValue);
    
    NSDictionary *yossi = [[NSDictionary alloc] initWithObjectsAndKeys:@"Yossi",@"Name",@"19:30",@"Hour", nil];
    NSDictionary *shlomi = [[NSDictionary alloc] initWithObjectsAndKeys:@"Shlomi",@"Name",@"19:50",@"Hour", nil];
    NSDictionary *michael = [[NSDictionary alloc] initWithObjectsAndKeys:@"Michael",@"Name",@"20:30",@"Hour", nil];
    NSDictionary *stas = [[NSDictionary alloc] initWithObjectsAndKeys:@"Stas",@"Name",@"21:00",@"Hour", nil];
     
     */
  //  NSArray *queueArray = [[NSArray alloc] initWithObjects:yossi,shlomi,michael,stas, nil];
    
   
    
}

@end
