//
//  CSLoginSegue.m
//  CameraScanner
//
//  Created by Rostislav Kobizskiy on 7/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CSLoginSegue.h"
#import "WebEngine.h"

#import "CSLoginController.h"

@implementation CSLoginSegue

- (void)perform {
    CSLoginController *loginController = (CSLoginController *)self.sourceViewController;   
    [loginController.navigationController pushViewController:self.destinationViewController animated:YES];
    loginController.loginTextField.text = @"";
    loginController.passwordTextField.text = @"";
    loginController.storeName.text = VendHQ_COM;
}

@end
