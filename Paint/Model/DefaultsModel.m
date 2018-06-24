//
//  DefaultsModel.m
//  Paint
//
//  Created by Admin on 6/24/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//


#define numberKey @"paintNumber"

#import "DefaultsModel.h"

@implementation DefaultsModel

NSUserDefaults *defaults ;

+ (instancetype)sharedInstance
{
    static DefaultsModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DefaultsModel alloc] init];
        defaults=[NSUserDefaults standardUserDefaults];
    });
    return sharedInstance;
}
// get num to set as id in CoreData
- (int) getPaintNumber{
    int num = 0;
    if ([defaults integerForKey:numberKey]) {
    num=(int)[defaults integerForKey:numberKey];
    }
    num+=1;
    [defaults setInteger:num forKey:numberKey];
    return num;
}

@end
