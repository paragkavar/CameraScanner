//
//  CSLoginController.h
//  CameraScanner
//
//  Created by Rostislav Kobizskiy on 7/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString *const VendHQ_COM;

@interface CSLoginController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *storeName;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)handleLogin:(id)sender;

@end
