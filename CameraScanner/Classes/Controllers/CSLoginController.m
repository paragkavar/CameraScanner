//
//  CSLoginController.m
//  CameraScanner
//
//  Created by Rostislav Kobizskiy on 7/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CSLoginController.h"

#define DEBUG_LOGIN NO

NSString *const VendHQ_COM = @".vendhq.com";

@interface CSLoginController () <UITextFieldDelegate>

@end

@implementation CSLoginController

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
    
    _storeName.text = VendHQ_COM;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (DEBUG_LOGIN)
    {
        _storeName.text = @"roststore.vendhq.com";
        _loginTextField.text = @"kobizsky@gmail.com";
        _passwordTextField.text = @"cd46779cd";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Textfield delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) {
        return YES;
    }
    if (range.location > textField.text.length - VendHQ_COM.length) {
        return NO;
    }
    
    return YES;
}

- (void)viewDidUnload {
    [self setPasswordTextField:nil];
    [self setLoginTextField:nil];
    [self setLoginButton:nil];
    [self setStoreName:nil];
    [super viewDidUnload];
}

- (IBAction)handleLogin:(id)sender {
    
    VEND_STORE_API = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@/api/", _storeName.text]];
    
    [self performSegueWithIdentifier:@"Login" sender:sender];
    
}
@end
