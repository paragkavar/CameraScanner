//
//  NSURLParser.h
//  CameraScanner
//
//  Created by Rostislav Kobizskiy on 8/1/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLParser : NSObject

@property (nonatomic, strong) NSArray *variables;

- (id)initWithURLString:(NSString *)url;
- (NSString *)valueForVariable:(NSString *)varName;


@end
