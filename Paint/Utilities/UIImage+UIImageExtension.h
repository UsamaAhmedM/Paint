//
//  UIImage+UIImageExtension.h
//  Paint
//
//  Created by Admin on 6/23/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageExtension)
+ (UIImage *)imageFromColor:(UIColor *)color;
+ (UIImage *)getImage:(UIImage*)image WithSize:(CGSize)size;
@end
