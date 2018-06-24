//
//  SecondViewDelegate.h
//  Paint
//
//  Created by Admin on 6/24/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaintMangedObject+CoreDataClass.h"
@protocol SecondViewDelegate <NSObject>

- (void) updateTableDataWith: (NSMutableDictionary<NSString*,NSMutableArray<PaintMangedObject*>*>*) data;

@end
