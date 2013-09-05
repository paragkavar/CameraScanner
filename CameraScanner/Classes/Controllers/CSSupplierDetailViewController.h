//
//  CSSupplierDetailViewController.h
//  CameraScanner
//
//  Created by Владимир on 05.09.13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Supplier.h"

@interface CSSupplierDetailViewController : UITableViewController
@property (nonatomic, strong) Supplier *supplier;
@end
