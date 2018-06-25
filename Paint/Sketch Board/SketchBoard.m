//
//  SketchBoard.m
//  Paint
//
//  Created by Admin on 6/22/18.
//  Copyright © 2018 Thirdwayv.Co. All rights reserved.
//

#import "SketchBoard.h"
#import "UIImage+UIImageExtension.h"
#import "UIColor+ColorExtension.h"
#import <Photos/Photos.h>
#import "Model.h"
#import "PhotoGallaryModel.h"
#import "NSDate+DateExtension.h"
@interface SketchBoard ()
@property (weak,atomic) UIImageView *sketch;
// Current index of drawings
@property (atomic,strong) NSNumber* currentLineNumber;
// Drawings tracking
@property (nonatomic,strong) NSMutableDictionary <NSNumber*,NSMutableArray*> *drawingHistory;
@end

@implementation SketchBoard

CGFloat red,green,blue,alpha;
NSMutableArray<UIColor*> *drawingColors;
int maxDrawingsCount;


- (instancetype) initWithView : (UIImageView*) view{
    self = [super init];
    if (self && view != nil) {
        self.sketch = view;
        [self.sketch setUserInteractionEnabled:YES];
        self.sketch.image=[UIImage getImage:[UIImage new] WithSize:self.sketch.bounds.size];
        UIPanGestureRecognizer *dragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragGestureTriggered:)];
        [self.sketch addGestureRecognizer:dragGesture];
        self.currentLineNumber=[NSNumber numberWithInt:0];
        self.drawingHistory=[NSMutableDictionary new];
        drawingColors=[NSMutableArray new];
        self.drawingColor = UIColor.blackColor;
        self.drawingWidth = 5.0;
        self.isUndoEnabled=self.isRedoEnabled=self.isErasingModeEnabled=NO;
        maxDrawingsCount=0;
    }else
    {
        return nil;
    }
    return self;
}
// set background image
- (void)setBackGroundImage:(UIImage *)backGroundImage{
    if(backGroundImage !=nil){
    _backGroundImage= [UIImage getImage:backGroundImage WithSize:self.sketch.bounds.size];
        CGSize newSize = self.sketch.bounds.size;
    UIGraphicsBeginImageContext( newSize );
    [_backGroundImage drawInRect:CGRectMake(self.sketch.bounds.origin.x,self.sketch.bounds.origin.y,self.sketch.bounds.size.width,self.sketch.bounds.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.sketch.image drawInRect:CGRectMake(self.sketch.bounds.origin.x,self.sketch.bounds.origin.y,self.sketch.bounds.size.width,self.sketch.bounds.size.height) blendMode:kCGBlendModeColor alpha:0.5];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        [self.sketch setImage:newImage];
    
    for (int j=0; j<[self.currentLineNumber intValue]; j++) {
        NSMutableArray *currentArray=[self.drawingHistory objectForKey:[NSNumber numberWithInt:j]];
        self.drawingColor=[drawingColors objectAtIndex:j];
        for(int i=0;i<currentArray.count-2;i++){
            [self drawStartingFrom:CGPointFromString([currentArray objectAtIndex:i]) andEndPoint:CGPointFromString([currentArray objectAtIndex:i+1])onImage:self.sketch.image];
        }
    }
    }
    
    
}
// Change color
- (void) setDrawingColor:(UIColor *)color{
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    _drawingColor=color;
}

// Change Erasing mode
-(void)setIsErasingModeEnabled:(BOOL)isErasingModeEnabled{
    _isErasingModeEnabled=isErasingModeEnabled;
    if(isErasingModeEnabled){
         self.drawingColor=UIColor.whiteColor;
    }else{
        for(int i=drawingColors.count-1;i>=0;i--){
                if(![[drawingColors objectAtIndex:i] compareWithColor:UIColor.whiteColor ]){
                    self.drawingColor=[drawingColors objectAtIndex:i];
                    return;
            }
    }
    }
}

// Check if can redo
- (void)setIsRedoEnabled:(BOOL)isRedoEnabled{
    _isRedoEnabled=isRedoEnabled;
    if (self.delagate) {
        [self.delagate redoStatus:isRedoEnabled];
    }
}

// Check if can undo
- (void)setIsUndoEnabled:(BOOL)isUndoEnabled{
    _isUndoEnabled=isUndoEnabled;
    if (self.delagate) {
        [self.delagate undoStatus:isUndoEnabled];
    }
}

// fired when first start to draw
- (void)startDrawingWithPoint: (CGPoint) point{
    self.currentLineNumber = [NSNumber numberWithInt:[self.currentLineNumber intValue]+1];
    if(self.currentLineNumber.intValue<maxDrawingsCount){
        for (int i=maxDrawingsCount ; i >= self.currentLineNumber.intValue; i--) {
            [self.drawingHistory removeObjectForKey:[NSNumber numberWithInt:i]];
            [drawingColors removeObjectAtIndex:i-1];
        }
        if(self.currentLineNumber.intValue<maxDrawingsCount){
            maxDrawingsCount=self.currentLineNumber.intValue-1;
        }}
    
    [self.drawingHistory setObject: [NSMutableArray new] forKey:[NSNumber numberWithInt:self.currentLineNumber.intValue]];
    NSMutableArray *currentArray=[self.drawingHistory objectForKey:self.currentLineNumber];
    [currentArray addObject: NSStringFromCGPoint(point)];
    [drawingColors addObject:self.drawingColor];
    self.isRedoEnabled=NO;
}

// fired when dragging to draw
- (void)continueDrawingWithPoint: (CGPoint) point{
    NSMutableArray *currentArray=[self.drawingHistory objectForKey:([NSNumber numberWithInt: self.drawingHistory.count])];
    [currentArray addObject: NSStringFromCGPoint(point)];
    [self drawStartingFrom:CGPointFromString([currentArray objectAtIndex:currentArray.count-2]) andEndPoint:point onImage:self.sketch.image];
}

// fired user left tap from screen
- (void)endDrawingWithPoint: (CGPoint) point{
    NSMutableArray *currentArray=[self.drawingHistory objectForKey:([NSNumber numberWithInt: self.drawingHistory.count])];
    [currentArray addObject: NSStringFromCGPoint(point)];
    [self drawStartingFrom:CGPointFromString([currentArray objectAtIndex:currentArray.count-1]) andEndPoint:point onImage:self.sketch.image];
    self.isUndoEnabled=YES;
    maxDrawingsCount++;
}

// Drawing function
- (void) drawStartingFrom: (CGPoint) startPoint andEndPoint: (CGPoint) endPoint onImage: (UIImage*) image{
    
    UIGraphicsBeginImageContext(self.sketch.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [image drawAtPoint:CGPointZero];
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.drawingWidth);
    CGContextSetRGBStrokeColor(context,red , green, blue,alpha);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextStrokePath(context);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.sketch.image=image;
}

// Redo next drawing
- (void)redo{
    
    self.currentLineNumber = [NSNumber numberWithInt:[self.currentLineNumber intValue]+1];
    
    NSMutableArray *currentArray=[self.drawingHistory objectForKey:self.currentLineNumber];
    self.drawingColor=[drawingColors objectAtIndex:self.currentLineNumber.intValue-1];
    for(int i=0;i<currentArray.count-2;i++){
        [self drawStartingFrom:CGPointFromString([currentArray objectAtIndex:i]) andEndPoint:CGPointFromString([currentArray objectAtIndex:i+1])onImage:self.sketch.image];
    }
    
    self.drawingColor=[drawingColors lastObject];
    if (self.currentLineNumber.intValue == maxDrawingsCount) {
        self.isRedoEnabled=NO;
        self.isUndoEnabled=YES;
    }
}

// Undo a drawing
- (void)undo{
    if (self.currentLineNumber.intValue==1) {
        self.isUndoEnabled=NO;
    }
    self.isRedoEnabled=YES;
    self.sketch.image=[UIImage getImage:self.backGroundImage WithSize:self.sketch.bounds.size];
    for(int i=0;i<self.currentLineNumber.intValue-1;i++){
        NSMutableArray *currentArray=[self.drawingHistory objectForKey:[NSNumber numberWithInt:i+1]];
        self.drawingColor=[drawingColors objectAtIndex:i];
        for(int j=0;j<currentArray.count-2;j++){
            [self drawStartingFrom:CGPointFromString([currentArray objectAtIndex:j]) andEndPoint:CGPointFromString([currentArray objectAtIndex:j+1]) onImage:self.sketch.image];
        }
    }
    self.currentLineNumber = [NSNumber numberWithInt:[self.currentLineNumber intValue]-1];
    self.drawingColor=[drawingColors lastObject];
}

// Drag recognizer keeping track on taps on the screen

- (void)dragGestureTriggered:(UIPanGestureRecognizer *)recognizer
{
    CGPoint currentPoint = [recognizer locationInView:self.sketch];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self startDrawingWithPoint: currentPoint];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self continueDrawingWithPoint: currentPoint];
    }else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded) {
        [self endDrawingWithPoint: currentPoint];
    }
    
}

// clear sketch and start over
- (void)clear{
    self.sketch.image=[UIImage getImage:[UIImage new] WithSize:self.sketch.bounds.size];
    self.currentLineNumber=[NSNumber numberWithInt:0];
    self.drawingHistory=[NSMutableDictionary new];
    drawingColors=[NSMutableArray new];
    self.isUndoEnabled=self.isRedoEnabled=self.isErasingModeEnabled=NO;
    [self.sketch setNeedsLayout];
    maxDrawingsCount=0;
}

// save sketch in CoreData along with Galary
- (void) saveImage{
    UIImage *image =self.sketch.image;   
    [[PhotoGallaryModel sharedInstance] savePhoto:image onComplete:^(NSURL *url) {
        [[Model sharedInstance]savePaintNamed:[[url.absoluteString componentsSeparatedByString:@"/"] lastObject] andPath:[[url.absoluteString componentsSeparatedByString:@":"]lastObject] CreatedOn:[NSDate getCurrentDate]];
        [self.delagate showAlertWithTitle:@"Success" andMsg:@"Image saved successfully"];
    }];
    
}



@end
