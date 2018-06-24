//
//  Model.h
//  Paint
//
//  Created by Admin on 6/24/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaintMangedObject+CoreDataClass.h"
#import "DefaultsModel.h"
@interface Model : NSObject


+ (instancetype)sharedInstance;
- (void) savePaintNamed:(NSString*) name andPath:(NSString*)path CreatedOn:(NSDate*)date;
- (NSArray<PaintMangedObject*>*) getPaintsFromCD;
@end
