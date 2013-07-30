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
    
    NSString *login = loginController.loginTextField.text;
    NSString *password = loginController.passwordTextField.text;
    
    [[WebEngine sharedManager] configureCoreDataWithLogin:login
                                              andPassword:password];
    

    [[WebEngine sharedManager] getProductsSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        __weak MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self.destinationViewController view] animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = NSLocalizedString(@"Loading products...", nil);
        [[WebEngine sharedManager] getProductsWithPagination:^(RKPaginator *paginator, NSArray *objects, NSUInteger page) {
            if (paginator.objectCount != NSNotFound)
            {
                hud.progress = ((float)paginator.perPage * (float)paginator.currentPage) / (float)paginator.objectCount;
                if (objects.count == paginator.perPage)
                {
                    [paginator loadNextPage];
                }
                else
                {
                    [hud hide:YES];
                }
            }
        } failure:^(RKPaginator *paginator, NSError *error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                        message:error.localizedDescription
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"Ok", @"Ok")
                              otherButtonTitles:nil] show];
        } fromPage:2];
        
        [self.sourceViewController presentViewController:self.destinationViewController animated:YES completion:^{
            loginController.loginTextField.text = @"";
            loginController.passwordTextField.text = @"";
            loginController.storeName.text = VendHQ_COM;
        }];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                    message:NSLocalizedString(@"The store name, e-mail or password you entered is incorrect", nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"Ok", @"Ok")
                          otherButtonTitles:nil] show];
    }];
}

@end
