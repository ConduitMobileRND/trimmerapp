//
//  RegisterViewController.m
//  Consumer Of Great Success
//
//  Created by Yossi Halevi on 1/29/15.
//  Copyright (c) 2015 Yossi Halevi. All rights reserved.
//

#import "RegisterViewController.h"
#import "ServicesManager.h"


NSString * const namePlaceHolder = @"Full Name";
NSString * const phonePlaceHolder = @"Phone Number";


@interface RegisterViewController (){
    UITextView *nameTextView;
    UITextView *phoneNumberTextView;
    UIButton *submitButton;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255 green:229 blue:204 alpha:1];
    
    [self setupView];
}


- (void) setupView {
    float yPosition = 100 ;
    
    float screenWidth = self.view.frame.size.width;
    float buttonsWidth = 150;
    float buttonsHeight = 50;
    
    
    nameTextView = [[UITextView alloc] initWithFrame:CGRectMake((screenWidth - buttonsWidth)/2, yPosition, buttonsWidth, buttonsHeight)];
    nameTextView.tag = 1;
    nameTextView.text = namePlaceHolder;
    nameTextView.delegate = self;
    nameTextView.backgroundColor = [UIColor lightGrayColor];
    nameTextView.textColor = [UIColor grayColor];
    [phoneNumberTextView setKeyboardType:UIKeyboardTypeAlphabet];
    [self.view addSubview:nameTextView];
    
    yPosition += 80;
    phoneNumberTextView = [[UITextView alloc] initWithFrame:CGRectMake((screenWidth - buttonsWidth)/2, yPosition, buttonsWidth, buttonsHeight)];
    phoneNumberTextView.tag = 2;
    phoneNumberTextView.text = phonePlaceHolder;
    phoneNumberTextView.delegate = self;
    phoneNumberTextView.backgroundColor = [UIColor lightGrayColor];
    phoneNumberTextView.textColor = [UIColor grayColor];
    [phoneNumberTextView setKeyboardType:UIKeyboardTypeNumbersAndPunctuation ];
    [self.view addSubview:phoneNumberTextView];
    
    yPosition += 80;

    
    submitButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth - buttonsWidth)/2, yPosition, buttonsWidth, buttonsHeight)];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [submitButton setBackgroundColor:[UIColor grayColor]];
    [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];

}

- (void) submit {
    
    if ([nameTextView.text length] == 0 || [nameTextView.text isEqualToString:namePlaceHolder]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Massage"
                                                        message:@"Please fill your Name"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([phoneNumberTextView.text length] == 0 || [phoneNumberTextView.text isEqualToString:phonePlaceHolder]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Massage"
                                                        message:@"Please fill your Phone number"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    submitButton.enabled = FALSE;
    
    [[NSUserDefaults standardUserDefaults] setObject:nameTextView.text forKey:USER_NAME];
    [[NSUserDefaults standardUserDefaults] setObject:phoneNumberTextView.text forKey:USER_PHONE];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:nameTextView.text , @"name", phoneNumberTextView.text , @"telephone", nil];
    
    [ServicesManager serverApiWithHttpMethod:postMethod andUrlPath:@"user/register" andParameters:dic completion:^(BOOL success, NSDictionary *data, NSString *errorString) {

        submitButton.enabled = TRUE;

        if (success) {
            @try {
                [[NSUserDefaults standardUserDefaults] setObject:[data objectForKey:@"id"] forKey:USER_ID];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:REGISTERED];

                if([self.delegate respondsToSelector:@selector(didSuccessfullyRegistered)])
                    [self.delegate didSuccessfullyRegistered];

            }
            @catch (NSException *exception) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed To Register, Please Try Again"
                                                                message:@"Problem with data"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
  
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed To Register, Please Try Again"
                                                            message:errorString
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }];
}



- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString: textView.tag==1 ? namePlaceHolder : phonePlaceHolder]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = textView.tag==1 ? namePlaceHolder : phonePlaceHolder;
        textView.textColor = [UIColor grayColor];
    }
    [textView resignFirstResponder];
}

@end
