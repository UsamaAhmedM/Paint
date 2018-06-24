//
//  Model.m
//  Paint
//
//  Created by Admin on 6/24/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import "Model.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "PaintMangedObject+CoreDataClass.h"

@implementation Model

NSManagedObjectContext *context;

+ (instancetype)sharedInstance
{
    static Model *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Model alloc] init];
        context= ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void) savePaintNamed:(NSString*) name andPath:(NSString*)path CreatedOn:(NSDate*)date{
    
    PaintMangedObject *entityMangedObj = [[PaintMangedObject alloc]initWithContext:context];
    entityMangedObj.paint_id=[[DefaultsModel sharedInstance]getPaintNumber];
    entityMangedObj.name=name;
    entityMangedObj.path=path;
    entityMangedObj.date=date;
    [context insertObject:entityMangedObj];
    [self saveContext];
    
}
- (NSArray <PaintMangedObject* >* ) getPaintsFromCD{
    NSFetchRequest *fetchRequest = [PaintMangedObject fetchRequest];
    fetchRequest.returnsObjectsAsFaults=NO;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSError *error ;
    NSArray *resultArray= [context executeFetchRequest:fetchRequest error:&error];
    return resultArray;
}
- (void)saveContext{
[((AppDelegate*)[[UIApplication sharedApplication] delegate]) saveContext];
}
@end
