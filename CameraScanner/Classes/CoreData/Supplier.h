//
//  Supplier.h
//  CameraScanner
//
//  Created by Владимир on 04.09.13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact;

@interface Supplier : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * retailer_id;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * supplierDescription;
@property (nonatomic, retain) Contact *contact;

@end
