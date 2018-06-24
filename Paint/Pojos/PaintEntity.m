//
//  PaintEntity.m
//  Paint
//
//  Created by Admin on 6/24/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import "PaintEntity.h"

@implementation PaintEntity

-(instancetype) initWithID:(int)ID withName:(NSString*) name withPath:(NSString*) path andDate:(NSDate*)date{
    self = [super init];
    if (self) {
        self.ID=ID;
        self.name=name;
        self.date=date;
        self.path=path;
    }
    return self;
}

+ (NSFetchRequest *)fetchRequest{
    return [[NSFetchRequest alloc]initWithEntityName:@"Paint"];
}

@end
