//
//  Product.h
//  CameraScanner
//
//  Created by Rostislav Kobizskiy on 7/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


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
@property (nonatomic, retain) NSDate * updatedAt;

@end
