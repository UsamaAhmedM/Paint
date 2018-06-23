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
@property (nonatomic) UIColor* drawingColor;
// line width
@property (nonatomic) CGFloat drawingWidth;


@property BOOL isRedoEnabled ;
@property BOOL isUndoEnabled ;

- (instancetype) initWithView : (UIImageView*) view;

- (void)startDrawingWithPoint: (CGPoint) point;
- (void)continueDrawingWithPoint: (CGPoint) point;
- (void)endDrawingWithPoint: (CGPoint) point;
- (void)saveImage;
- (void)redo;
- (void)undo;
@end
