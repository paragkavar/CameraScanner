//
//  Tax.h
//  CameraScanner
//
//  Created by Владимир on 04.09.13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Product;

@interface Tax : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSString * name;
@end
