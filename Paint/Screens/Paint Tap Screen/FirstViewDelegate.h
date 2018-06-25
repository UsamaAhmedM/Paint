//
//  FirstViewDelegate.h
//  Paint
//
//  Created by Admin on 6/23/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FirstViewDelegate <NSObject>
- (void) redoStatus:(BOOL)isEnabled;
- (void) undoStatus:(BOOL)isEnabled;
- (void) showAlertWithTitle:(NSString*)title andMsg:(NSString*)msg;
@end
