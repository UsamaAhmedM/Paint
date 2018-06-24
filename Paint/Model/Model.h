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
- (void) savePaint:(PaintEntity*)paint;
- (NSArray*) getPaintsFromCD;
@end
