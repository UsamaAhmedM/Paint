//
//  SecondViewPresenter.h
//  Paint
//
//  Created by Admin on 6/24/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaintMangedObject+CoreDataClass.h"
#import "SecondViewDelegate.h"
@interface SecondViewPresenter : NSObject
@property id<SecondViewDelegate> delagate;
- initWithDelagate:(id<SecondViewDelegate>) delagate;
-(void)getDataFromDB;
- (void) deletePaintFromCD:(PaintMangedObject*) paint ;
@end
