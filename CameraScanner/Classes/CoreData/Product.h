//
//  Product.h
//  CameraScanner
//
//  Created by Владимир on 04.09.13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Outlet, Supplier, Tax;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * brandName;
@property (nonatomic, retain) NSDate * deletedAt;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * handle;
@property (nonatomic, retain) NSString * ids;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * retailPrice;
@property (nonatomic, retain) NSString * sku;
@property (nonatomic, retain) NSString * sourceId;
@property (nonatomic, retain) NSString * supplierName;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSNumber * tax;
@property (nonatomic, retain) NSString * taxName;
@property (nonatomic, retain) NSNumber * taxRate;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *inventory;
@property (nonatomic, retain) Tax *productTax;
@property (nonatomic, retain) Supplier *supplier;
@end

@interface Product (CoreDataGeneratedAccessors)

- (void)addInventoryObject:(Outlet *)value;
- (void)removeInventoryObject:(Outlet *)value;
- (void)addInventory:(NSSet *)values;
- (void)removeInventory:(NSSet *)values;

@end
