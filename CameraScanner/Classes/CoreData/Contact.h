//
//  Contact.h
//  CameraScanner
//
//  Created by Владимир on 04.09.13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Supplier;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * company_name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * twitter;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * physical_address1;
@property (nonatomic, retain) NSString * physical_address2;
@property (nonatomic, retain) NSString * physical_suburb;
@property (nonatomic, retain) NSString * physical_city;
@property (nonatomic, retain) NSString * physical_postcode;
@property (nonatomic, retain) NSString * physical_state;
@property (nonatomic, retain) NSString * physical_country_id;
@property (nonatomic, retain) NSString * postal_address1;
@property (nonatomic, retain) NSString * postal_address2;
@property (nonatomic, retain) NSString * postal_suburb;
@property (nonatomic, retain) NSString * postal_city;
@property (nonatomic, retain) NSString * postal_postcode;
@property (nonatomic, retain) NSString * postal_state;
@property (nonatomic, retain) NSString * postal_country_id;
@property (nonatomic, retain) Supplier *supplier;

@end
