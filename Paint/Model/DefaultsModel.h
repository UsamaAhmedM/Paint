//
//  DefaultsModel.h
//  Paint
//
//  Created by Admin on 6/24/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultsModel : NSObject

+ (instancetype)sharedInstance;
- (int) getPaintNumber;
@end
