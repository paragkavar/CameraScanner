//
//  WebEngine.h
//  CameraScanner
//
//  Created by Rostislav Kobizskiy on 7/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WebEngineSuccess)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult);
typedef void (^WebEnginePaginationSucess)(RKPaginator *paginator, NSArray *objects, NSUInteger page);
typedef void (^WebEnginePaginationFailure)(RKPaginator *paginator, NSError *error);
typedef void (^WebEngineFaluire)(RKObjectRequestOperation *operation, NSError *error);

extern NSURL *VEND_STORE_API;

extern NSString *const VendCredentialsLogin;
extern NSString *const VendCredentialsPassword;
extern NSString *const VendCredentialsStore;

@class Product;
@class Tax;
@class Supplier;

@interface WebEngine : NSObject

+ (WebEngine *)sharedManager;

- (void)configureCoreDataWithLogin:(NSString *)login andPassword:(NSString *)password;

- (void)getProductsSuccess:(WebEngineSuccess)success
                   failure:(WebEngineFaluire)failure;
- (void)getProductsWithPagination:(WebEnginePaginationSucess)success
                          failure:(WebEnginePaginationFailure)failure
                         fromPage:(NSUInteger)fromPage;
- (void)getProductBySKU:(NSString *)sku
                success:(WebEngineSuccess)success
                failure:(WebEngineFaluire)failure;
- (void)postProduct:(Product *)product
            success:(WebEngineSuccess)success
            failure:(WebEngineFaluire)failure;
- (void)putProduct:(Product *)product
           success:(WebEngineSuccess)success
           failure:(WebEngineFaluire)failure;
- (void)deleteProduct:(Product *)product
              success:(WebEngineSuccess)success
              failure:(WebEngineFaluire)failure;

- (void) getTaxesSuccess: (WebEngineSuccess)success
                 failure: (WebEngineFaluire)failure;
- (void) postTax: (Tax *) tax
         success:(WebEngineSuccess)success
         failure:(WebEngineFaluire)failure;

- (void)getSupplierSuccess:(WebEngineSuccess)success
                   failure:(WebEngineFaluire)failure;
- (void)postSupplier:(Supplier *)supplier
             success:(WebEngineSuccess)success
             failure:(WebEngineFaluire)failure;
- (void)putSupplier:(Supplier *)supplier
            success:(WebEngineSuccess)success
            failure:(WebEngineFaluire)failure;
- (void)deleteSupplier:(Supplier *)supplier
               success:(WebEngineSuccess)success
               failure:(WebEngineFaluire)failure;

- (void)logout;

- (BOOL)hasInternet;
@end
