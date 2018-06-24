//
//  UIColor+ColorExtension.m
//  Paint
//
//  Created by Admin on 6/24/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import "UIColor+ColorExtension.h"

@implementation UIColor (ColorExtension)

- (BOOL)compareWithColor:(UIColor *)color {
    return ([[[CIColor colorWithCGColor:self.CGColor] stringRepresentation] isEqualToString:[[CIColor colorWithCGColor:color.CGColor] stringRepresentation]]);
}
@end
