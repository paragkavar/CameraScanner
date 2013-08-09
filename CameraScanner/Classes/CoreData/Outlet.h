//
//  Outlet.h
//  CameraScanner
//
//  Created by Rostislav Kobizskiy on 8/9/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Product;

@interface Outlet : NSManagedObject

@property (nonatomic, retain) NSNumber * restockLevel;
@property (nonatomic, retain) NSNumber * reorderPoint;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * ids;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Product *product;

@end
