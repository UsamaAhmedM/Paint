//
//  SketchBoard.h
//  Paint
//
//  Created by Admin on 6/22/18.
//  Copyright © 2018 Thirdwayv.Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SketchBoard : NSObject
// line color
@property (nonatomic, assign) UIColor* drawingColor;
// line width
@property (nonatomic, assign) CGFloat drawingWidth;

- (instancetype) initWithView : (UIImageView*) view;

- (void)startDrawingWithPoint: (CGPoint) point;
- (void)continueDrawingWithPoint: (CGPoint) point;
- (void)endDrawingWithPoint: (CGPoint) point;

- (BOOL)redo;
- (BOOL)undo;
@end
