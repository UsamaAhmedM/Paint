//
//  PaintEntity.m
//  Paint
//
//  Created by Admin on 6/24/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import "PaintEntity.h"

@implementation PaintEntity

@dynamic name;
@dynamic path;
@dynamic date;
+ (NSFetchRequest *)fetchRequest{
    return [[NSFetchRequest alloc]initWithEntityName:@"Paint"];
}

@end
