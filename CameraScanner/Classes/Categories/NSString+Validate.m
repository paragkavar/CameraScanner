//
//  NSString+Validate.m
//  CameraScanner
//
//  Created by Rostislav Kobizskiy on 7/6/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "NSString+Validate.h"

@implementation NSString (Validate)

- (BOOL)isFloat
{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    //Set the locale to US
    [numberFormatter setLocale:[NSLocale currentLocale]];
    //Set the number style to Scientific
    [numberFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    NSNumber* number = [numberFormatter numberFromString:self];
    if (number != nil)
    {
        return true;
    }
    return false;
}

- (BOOL)isInteger
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

@end
