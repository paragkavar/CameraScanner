//
//  CSCreateProduct.h
//  CameraScanner
//
//  Created by Rostislav Kobizskiy on 7/5/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product;

@interface CSCreateProduct : UIViewController

@property (nonatomic, copy) NSString *sku;
@property (nonatomic, strong) Product *itemForEdit;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *taxName;
@property (nonatomic, copy) NSString *supplierName;
- (void)findProductWithSKU:(NSString *)sku;
- (IBAction)backToScaner:(id)sender;
@end
