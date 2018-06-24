//
//  NSDate+DateExtension.m
//  Paint
//
//  Created by Admin on 6/24/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import "NSDate+DateExtension.h"

@implementation NSDate (DateExtension)
+ (NSDate*) getCurrentDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd-MMM-YYYY";
    NSString *string = [formatter stringFromDate:[NSDate new]];
    return [formatter dateFromString:string];
}
@end
