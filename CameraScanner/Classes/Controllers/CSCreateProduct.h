//
//  CSCreateProduct.h
//  CameraScanner
//
//  Created by Rostislav Kobizskiy on 7/5/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product;
@class Tax;
@class Supplier;

@interface CSCreateProduct : UIViewController

@property (nonatomic, copy) NSString *sku;
@property (nonatomic, strong) Product *itemForEdit;
@property (nonatomic, strong) Tax *tax;
@property (nonatomic, strong) Supplier *supplier;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)findProductWithSKU:(NSString *)sku;
- (IBAction)backToScaner:(id)sender;
@end
