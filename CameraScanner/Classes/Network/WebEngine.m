//
//  WebEngine.m
//  CameraScanner
//
//  Created by Rostislav Kobizskiy on 7/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//



#import "WebEngine.h"
#import "Product.h"
#import "Tax.h"
#import "Supplier.h"
#import <NSData+Base64/NSData+Base64.h>
#import "NSURLParser.h"
#import "Contact.h"

NSString *const VendCredentialsLogin = @"VendCredentialsLogin";
NSString *const VendCredentialsPassword = @"VendCredentialsPassword";
NSString *const VendCredentialsStore = @"VendCredentialsStore";

NSURL *VEND_STORE_API = nil;

@interface WebEngine ()


@property (nonatomic, strong) RKObjectManager *objectManager;
@property (nonatomic, strong) RKManagedObjectStore *objectStore;
@property (nonatomic, strong) RKPaginator *paginator;

@property (nonatomic, assign) BOOL isInternet;

@end

@implementation WebEngine

+ (WebEngine *)sharedManager {
    static WebEngine *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[WebEngine alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)configureCoreDataWithLogin:(NSString *)login andPassword:(NSString *)password {
    NSError *error = nil;
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
    if (! success) {
        RKLogError(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
    }
    NSString *databaseFilename = [NSString stringWithFormat:@"Store_%@.sqlite", login];
    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:databaseFilename];
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    if (! persistentStore) {
        RKLogError(@"Failed adding persistent store at path '%@': %@", path, error);
    }
    [managedObjectStore createManagedObjectContexts];
    
    [RKManagedObjectStore setDefaultStore:managedObjectStore];
    
    self.objectManager = [RKObjectManager managerWithBaseURL:VEND_STORE_API];
    self.objectStore = managedObjectStore;
    
    _objectManager.managedObjectStore = _objectStore;
    _objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    
    [RKObjectManager setSharedManager:_objectManager];
    
    [self configureMapping];
    [self configurateRouting];
    
    _isInternet = NO;

    __weak typeof(self) wSelf = self;
    
    [_objectManager.HTTPClient setDefaultHeader:@"Content-Type" value:RKMIMETypeJSON];
    [_objectManager.HTTPClient setAuthorizationHeaderWithUsername:login password:password];
    [_objectManager.HTTPClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                wSelf.isInternet = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:
                wSelf.isInternet = YES;
                break;
            default:
                break;
        }
    }];
}

+ (RKEntityMapping *)productMappingInManagedObjectStore:(RKManagedObjectStore *)store {
   RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Product" inManagedObjectStore:store];
    [mapping setIdentificationAttributes:@[@"ids"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id":             @"ids",
     @"source_id":      @"sourceId",
     @"handle":         @"handle",
     @"active":         @"active",
     @"name":           @"name",
     @"tags":           @"tags",
     @"description":    @"desc",
     @"image":          @"image",
     @"sku":            @"sku",
     @"brand_name":     @"brandName",
     @"supplier_name":  @"supplierName",
     @"price":          @"price",
     @"retail_price":   @"retailPrice",
     @"tax":            @"tax",
     @"tax_name":       @"taxName",
     @"tax_rate":       @"taxRate",
     @"updated_at":     @"updatedAt",
     @"deleted_at":     @"deletedAt"
     }];
    
    RKEntityMapping *inventoryMapping = [RKEntityMapping mappingForEntityForName:@"Outlet" inManagedObjectStore:store];
    [inventoryMapping setIdentificationAttributes:@[@"ids"]];
    [inventoryMapping addAttributeMappingsFromDictionary:@{
     @"outlet_id":      @"ids",
     @"outlet_name":    @"name",
     @"count":          @"count",
     @"reorder_point":  @"reorderPoint",
     @"restock_level":  @"restockLevel"
     }];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"inventory" toKeyPath:@"inventory" withMapping:inventoryMapping]];
    
    return mapping;
}

+ (RKEntityMapping *)taxMappingInManagedObjectStore:(RKManagedObjectStore *)store {
    
    RKEntityMapping *taxMapping = [RKEntityMapping mappingForEntityForName:@"Tax" inManagedObjectStore:store];
    [taxMapping setIdentificationAttributes:@[@"id"]];
    [taxMapping addAttributeMappingsFromArray:@[@"id", @"name", @"rate"]];
    return taxMapping;
}

+ (RKEntityMapping *)supplierMappingInManagedObjectStore:(RKManagedObjectStore *)store {
    
    RKEntityMapping *supplierMapping = [RKEntityMapping mappingForEntityForName:@"Supplier" inManagedObjectStore:store];
    [supplierMapping setIdentificationAttributes:@[@"id"]];
    [supplierMapping addAttributeMappingsFromArray:@[@"id", @"retailer_id", @"name", @"source"]];
    [supplierMapping addAttributeMappingsFromDictionary:@{ @"description": @"supplierDescription"}];
    
    RKEntityMapping *contactMapping = [RKEntityMapping mappingForEntityForName:@"Contact" inManagedObjectStore:store];
    NSEntityDescription *contactEntity = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:[NSManagedObjectContext contextForCurrentThread]];
    [contactMapping addAttributeMappingsFromArray: [contactEntity.attributesByName allKeys]];
    [supplierMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"contact" toKeyPath:@"contact" withMapping:contactMapping]];
    
    return supplierMapping;
}

- (void)configurateRouting {
    // Relationship Routing

    [_objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[Product class]
                                                         pathPattern:@"products/:ids"
                                                              method:RKRequestMethodDELETE]];
}

- (void)configureMapping {
    
    RKEntityMapping *productMapping = [WebEngine productMappingInManagedObjectStore:_objectStore];
    
    RKResponseDescriptor *productRespDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:productMapping
                                                                                       pathPattern:@"products"
                                                                                           keyPath:@"products"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKResponseDescriptor *productPostRespDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:productMapping
                                                                                          pathPattern:@"products"
                                                                                              keyPath:@"product"
                                                                                          statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    RKResponseDescriptor *productDeleteRespDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:productMapping
                                                                                              pathPattern:@"products/:ids"
                                                                                                  keyPath:nil
                                                                                              statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKRequestDescriptor *productReqDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[productMapping inverseMapping]
                                                                                      objectClass:[Product class]
                                                                                      rootKeyPath:nil];
    
    RKEntityMapping *taxMapping = [WebEngine taxMappingInManagedObjectStore:_objectStore];

    RKResponseDescriptor *taxGetRespDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:taxMapping
                                                                                         pathPattern:@"taxes"
                                                                                             keyPath:@"taxes"
                                                                                         statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKResponseDescriptor *taxPostRespDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:taxMapping
                                                                                         pathPattern:@"taxes"
                                                                                             keyPath:@"tax"
                                                                                         statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKRequestDescriptor *taxReqDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[taxMapping inverseMapping]
                                                                                  objectClass:[Tax class]
                                                                                  rootKeyPath:nil];
    
    RKEntityMapping *supplierMapping = [WebEngine supplierMappingInManagedObjectStore:_objectStore];
    
    RKResponseDescriptor *supplierGetRespDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:supplierMapping
                                                                                         pathPattern:@"supplier"
                                                                                             keyPath:@"suppliers"
                                                                                         statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKResponseDescriptor *supplierPostRespDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:supplierMapping
                                                                                          pathPattern:@"supplier"
                                                                                              keyPath:@"supplier"
                                                                                          statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKResponseDescriptor *supplierDeleteRespDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:supplierMapping
                                                                                                pathPattern:@"supplier/:id"
                                                                                                    keyPath:nil
                                                                                                statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKRequestDescriptor *supplierReqDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[supplierMapping inverseMapping]                                                  
                                                                                       objectClass:[Supplier class]                                                  
                                                                                       rootKeyPath:nil];
    
    
    [_objectManager addResponseDescriptorsFromArray:@[
         productRespDescriptor,
         productPostRespDescriptor,
         productDeleteRespDescriptor,
         taxGetRespDescriptor,
         taxPostRespDescriptor,
         supplierGetRespDescriptor,
         supplierPostRespDescriptor,
         supplierDeleteRespDescriptor
     ]];
    
    [_objectManager addRequestDescriptorsFromArray:@[
         productReqDescriptor,
         taxReqDescriptor,
         supplierReqDescriptor
     ]];
    
    
    // Cleanup products
    [_objectManager addFetchRequestBlock:^NSFetchRequest *(NSURL *URL) {
        RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:@"products"];
        
        NSDictionary *argsDict = nil;
        BOOL match = [pathMatcher matchesPath:[URL relativePath] tokenizeQueryStrings:NO parsedArguments:&argsDict];
        NSURLParser *urlParser = [[NSURLParser alloc] initWithURLString:URL.absoluteString];
        BOOL clear = [urlParser valueForVariable:@"sku"] == nil;
        
        NSString *productId;
        if (match && clear) {
            productId = [argsDict objectForKey:@"ids"];
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
            return fetchRequest;
        }
        return nil;
    }];
    
    // Pagination mapping
    RKObjectMapping *paginationMapping = [RKObjectMapping mappingForClass:[RKPaginator class]];
    
    [paginationMapping addAttributeMappingsFromDictionary:@{
         @"pagination.page_size":   @"perPage",
         @"pagination.pages":       @"pageCount",
         @"pagination.results":     @"objectCount",
         @"pagination.page":        @"currentPage"
     }];
    
    [_objectManager setPaginationMapping:paginationMapping];
    

}

- (void)getProductsSuccess:(WebEngineSuccess)success
                   failure:(WebEngineFaluire)failure
{
    [_objectManager getObjectsAtPath:@"products"
                          parameters:nil
                             success:success
                             failure:failure];
    

}

- (void)getProductBySKU:(NSString *)sku
                success:(WebEngineSuccess)success
                failure:(WebEngineFaluire)failure
{
        [_objectManager getObject:nil
                             path:@"products"
                       parameters:@{@"sku": sku}
                          success:success
                          failure:failure];
}

- (void)getProductsWithPagination:(WebEnginePaginationSucess)success
                          failure:(WebEnginePaginationFailure)failure
                         fromPage:(NSUInteger)fromPage
{
    RKPaginator *paginator = [_objectManager paginatorWithPathPattern:@"products?page=:currentPage"];
    
    [paginator setCompletionBlockWithSuccess:success
                                     failure:failure];
    
    paginator.perPage = 100;
    [paginator loadPage:fromPage];
}

- (void)postProduct:(Product *)product
            success:(WebEngineSuccess)success
            failure:(WebEngineFaluire)failure
{
    [_objectManager postObject:product
                          path:@"products"
                    parameters:nil
                       success:success
                       failure:failure];
}

- (void)putProduct:(Product *)product
           success:(WebEngineSuccess)success
           failure:(WebEngineFaluire)failure
{
    [_objectManager putObject:product
                         path:@"products"
                   parameters:nil
                      success:success
                      failure:failure];
}

- (void)deleteProduct:(Product *)product
              success:(WebEngineSuccess)success
              failure:(WebEngineFaluire)failure
{
    [_objectManager deleteObject:product
                            path:nil
                      parameters:nil
                         success:success
                         failure:failure];
}

- (void) getTaxesSuccess: (WebEngineSuccess)success
                 failure: (WebEngineFaluire)failure
{
    [_objectManager getObjectsAtPath:@"taxes"
                          parameters:nil
                             success:success
                             failure:failure];
}

- (void) postTax: (Tax *) tax
         success:(WebEngineSuccess)success
         failure:(WebEngineFaluire)failure
{
    [_objectManager postObject:tax
                          path:@"taxes"
                    parameters:nil
                       success:success
                       failure:failure];
}

- (void)getSupplierSuccess:(WebEngineSuccess)success
                   failure:(WebEngineFaluire)failure
{
    [_objectManager getObjectsAtPath:@"supplier"
                          parameters:nil
                             success:success
                             failure:failure];
    
    
}

- (void)postSupplier:(Supplier *)supplier
            success:(WebEngineSuccess)success
            failure:(WebEngineFaluire)failure
{
    [_objectManager postObject:supplier
                          path:@"supplier"
                    parameters:nil
                       success:success
                       failure:failure];
}

- (void)putSupplier:(Supplier *)supplier
           success:(WebEngineSuccess)success
           failure:(WebEngineFaluire)failure
{
    [_objectManager putObject:supplier
                         path:@"supplier"
                   parameters:nil
                      success:success
                      failure:failure];
}

- (void)deleteSupplier:(Supplier *)supplier
              success:(WebEngineSuccess)success
              failure:(WebEngineFaluire)failure
{
    [_objectManager deleteObject:supplier
                            path:nil
                      parameters:nil
                         success:success
                         failure:failure];
}

- (BOOL)hasInternet
{
    return _isInternet;
}

- (void)logout
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURL *url = [NSURL URLWithString:@"http://asdgsdgsdgwf.vendhq.com/api/products"];
        [NSData dataWithContentsOfURL:url];
    });
    _objectManager = nil;
    _objectStore = nil;
    VEND_STORE_API = nil;
    
}

@end
