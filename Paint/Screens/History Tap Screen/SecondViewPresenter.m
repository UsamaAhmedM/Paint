//
//  SecondViewPresenter.m
//  Paint
//
//  Created by Admin on 6/24/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import "SecondViewPresenter.h"
#import "Model.h"
@implementation SecondViewPresenter
Model* model;
NSDateFormatter *formatter;

- initWithDelagate:(id<SecondViewDelegate>) delagate{
    self = [super init];
    if (self) {
        self.delagate=delagate;
        model=[Model sharedInstance];
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd/MMM/YYYY";
    }
    return self;
}
-(void)getDataFromDB{
    NSMutableDictionary<NSString*,NSMutableArray<PaintMangedObject*>*> *dataDictinary;
    NSArray<PaintMangedObject*> *coreDataArray=[model getPaintsFromCD];
    if (coreDataArray.count >0 ) {
        dataDictinary=[NSMutableDictionary new];
        for (PaintMangedObject* currentObj in coreDataArray) {
            NSString *dateKey=[formatter stringFromDate:currentObj.date];
            if([[dataDictinary allKeys]containsObject:dateKey]){
                [[dataDictinary objectForKey:dateKey] addObject:currentObj];
            }else{
                [dataDictinary setObject:[NSMutableArray new] forKey:dateKey];
                [[dataDictinary objectForKey:dateKey] addObject:currentObj];
            }
        }
        [self.delagate updateTableDataWith:dataDictinary];
    }
}

- (void) deletePaintFromCD:(PaintMangedObject*) paint {
    [model deletePaint:paint];
}
@end
