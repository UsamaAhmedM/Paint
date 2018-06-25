//
//  SketchBoard.h
//  Paint
//
//  Created by Admin on 6/22/18.
//  Copyright © 2018 Thirdwayv.Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewDelegate.h"
@interface SketchBoard : NSObject
// line color
@property (nonatomic) UIColor* drawingColor;
// line width
@property (nonatomic) CGFloat drawingWidth;

@property (nonatomic) UIImage *backGroundImage;
@property (nonatomic) BOOL isErasingModeEnabled ;
@property (nonatomic) BOOL isRedoEnabled ;
@property (nonatomic) BOOL isUndoEnabled ;

@property id<FirstViewDelegate> delagate ;

- (instancetype) initWithView : (UIImageView*) view;

- (void)startDrawingWithPoint: (CGPoint) point;
- (void)continueDrawingWithPoint: (CGPoint) point;
- (void)endDrawingWithPoint: (CGPoint) point;
- (void)saveImageWithName:(NSString*)name;
- (void)redo;
- (void)undo;
- (void)clear;
@end
