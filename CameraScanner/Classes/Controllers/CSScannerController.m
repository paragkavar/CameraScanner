//
//  CSScannerController.m
//  CameraScanner
//
//  Created by Rostislav Kobizskiy on 7/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CSScannerController.h"
#import "ZBarSDK.h"
#import "Product.h"
#import "CSProductDetail.h"
#import "CSCreateProduct.h"

@interface CSScannerController () <ZBarReaderDelegate>

@property (nonatomic, copy) NSString *sku;
@property (nonatomic, strong) Product *scannedProduct;

@end

@implementation CSScannerController

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



}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    
    
    // EXAMPLE: do something useful with the barcode image
    //    resultImage.image =
    //    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    _sku = symbol.data;

    [reader dismissViewControllerAnimated:YES completion:^{
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [[WebEngine sharedManager] getProductsSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [self findProductWithSKU:_sku];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//            [self findProductWithSKU:_sku];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        }];
    }];

}

- (void)findProductWithSKU:(NSString *)sku
{
    //_scannedProduct = [Product findFirstByAttribute:@"sku" withValue:sku];
    // Perfom to create Product
    __weak typeof(self) weakSelf = self;
    [[WebEngine sharedManager] getProductBySKU:sku success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.firstObject);
        if (!mappingResult.firstObject)
        {
            [weakSelf performSegueWithIdentifier:@"createProduct" sender:nil];
        }
        else
        {
            weakSelf.scannedProduct = mappingResult.firstObject;
            [weakSelf performSegueWithIdentifier:@"showProduct" sender:nil];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"Warning")
                                    message:error.localizedDescription
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"Ok", @"Ok")
                          otherButtonTitles:nil] show];
        
        TFLog(@"%@", error);
        
        weakSelf.scannedProduct = [Product findFirstByAttribute:@"sku" withValue:sku];
        if (!_scannedProduct)
        {
            
            [self performSegueWithIdentifier:@"createProduct" sender:self];
        }
        else
        {
            // Show exist product
            [self performSegueWithIdentifier:@"showProduct" sender:self];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scanHandle:(id)sender {
    _sku = @"";
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    
    [self presentViewController:reader animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showProduct"]) {
        [segue.destinationViewController setProductItem:_scannedProduct];
        _scannedProduct = nil;
    } else if ([segue.identifier isEqualToString:@"createProduct"]) {
        [segue.destinationViewController setSku:_sku];
        _sku = nil;
    }
}

@end
