//
//  Model.h
//  Paint
//
//  Created by Admin on 6/24/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaintEntity.h"
@interface Model : NSObject


+ (instancetype)sharedInstance;
- (void) savePaintNamed:(NSString*) name savedAtPath:(NSString*)path onDate:(NSDate*) date;
- (NSArray*) getDataFromCDOfEntity:(id)entity;
@end
