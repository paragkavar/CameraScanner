//
//  CSAddressDetailViewController.h
//  CameraScanner
//
//  Created by Владимир on 05.09.13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface CSAddressDetailViewController : UITableViewController
@property (nonatomic, strong) Contact *contact;
@property (nonatomic) BOOL isPostal;
@end
