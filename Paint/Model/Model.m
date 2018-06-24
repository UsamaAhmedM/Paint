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
- (void) savePaintNamed:(NSString*) name savedAtPath:(NSString*)path onDate:(NSDate*) date{
    NSManagedObject *entityNameObj = [NSEntityDescription insertNewObjectForEntityForName:@"Paint" inManagedObjectContext:context];
    [entityNameObj setValue:name forKey:@"name"];
    [entityNameObj setValue:path forKey:@"path"];
    [entityNameObj setValue:date forKey:@"date"];
    [context insertObject:entityNameObj];
    [self saveContext];
    
}
- (NSArray*) getDataFromCDOfEntity:(id)entity{
    NSFetchRequest *fetchRequest = [entity fetchRequest];
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
