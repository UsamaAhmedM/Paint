//
//  PhotoGallaryModel.h
//  Paint
//
//  Created by Admin on 6/24/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PhotoGallaryModel : NSObject

+ (instancetype)sharedInstance;

- (void) savePhoto:(UIImage*)image onComplete: ( void ( ^ )( NSURL *url) )completeBlock;
- (void) deletePhotoWithUrl:(NSString*)url;
@end
