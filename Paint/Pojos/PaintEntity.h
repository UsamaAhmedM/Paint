//
//  PaintEntity.h
//  Paint
//
//  Created by Admin on 6/24/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface PaintEntity : NSObject

@property int ID;
@property (nullable, nonatomic) NSString *name;
@property (nullable, nonatomic) NSString *path;
@property (nullable, nonatomic) NSDate *date;

- (instancetype ) initWithID:(int)ID withName:(NSString*) name withPath:(NSString*) path andDate:(NSDate*)date;
+ (NSFetchRequest *_Nonnull)fetchRequest;

@end
