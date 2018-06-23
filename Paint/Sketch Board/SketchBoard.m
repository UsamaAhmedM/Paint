//
//  SketchBoard.m
//  Paint
//
//  Created by Admin on 6/22/18.
//  Copyright © 2018 Thirdwayv.Co. All rights reserved.
//

#import "SketchBoard.h"

@interface SketchBoard ()
@property (weak,atomic) UIImageView *sketch;
@property (atomic,strong) NSNumber* currentLineNumber;
@property (atomic,strong) NSMutableDictionary <NSNumber*,NSMutableArray*> *drawingHistory;
@end

@implementation SketchBoard

CGFloat red,green,blue,alpha;
int maxDrawingsCount=-1;
BOOL isMainImage=YES;
- (instancetype) initWithView : (UIImageView*) view{
    self = [super init];
    if (self && view != nil) {
        self.sketch = view;
        self.sketch.image=[UIImage new];
        UIPanGestureRecognizer *dragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragGestureTriggered:)];
        [self.sketch addGestureRecognizer:dragGesture];
        self.currentLineNumber=[NSNumber numberWithInt:-1];
        self.drawingHistory=[NSMutableDictionary new];
        self.drawingColor = UIColor.blackColor;
        self.drawingWidth = 5.0;
        self.isUndoEnabled=self.isRedoEnabled=NO;
    }else
    {
        return nil;
    }
    return self;
}

- (void) setDrawingColor:(UIColor *)color{
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    _drawingColor=color;
}

- (void)startDrawingWithPoint: (CGPoint) point{
    maxDrawingsCount++;
    self.currentLineNumber = [NSNumber numberWithInt:[self.currentLineNumber intValue]+1];
    if(self.currentLineNumber.intValue<maxDrawingsCount){
        for (int i=self.currentLineNumber.intValue; i < maxDrawingsCount; i++) {
            [self.drawingHistory removeObjectForKey:[NSNumber numberWithInt:i]];
        }
        maxDrawingsCount=self.currentLineNumber.intValue;
        self.isRedoEnabled=NO;
    }
    [self.drawingHistory setObject: [NSMutableArray new] forKey:[NSNumber numberWithInt:self.currentLineNumber.intValue]];
    NSMutableArray *currentArray=[self.drawingHistory objectForKey:self.currentLineNumber];
    [currentArray addObject: NSStringFromCGPoint(point)];
}


- (void)continueDrawingWithPoint: (CGPoint) point{
    NSMutableArray *currentArray=[self.drawingHistory objectForKey:([NSNumber numberWithInt: self.drawingHistory.count-1])];
    [currentArray addObject: NSStringFromCGPoint(point)];
    [self drawStartingFrom:CGPointFromString([currentArray objectAtIndex:currentArray.count-2]) andEndPoint:point onImage:self.sketch.image];
}


- (void)endDrawingWithPoint: (CGPoint) point{
    NSMutableArray *currentArray=[self.drawingHistory objectForKey:([NSNumber numberWithInt: self.drawingHistory.count-1])];
    [currentArray addObject: NSStringFromCGPoint(point)];
    [self drawStartingFrom:CGPointFromString([currentArray objectAtIndex:currentArray.count-1]) andEndPoint:point onImage:self.sketch.image];
    self.isUndoEnabled=YES;
}

- (void) drawStartingFrom: (CGPoint) startPoint andEndPoint: (CGPoint) endPoint onImage: (UIImage*) image{
    
    UIGraphicsBeginImageContext(self.sketch.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [image drawAtPoint:CGPointZero];
    CGContextMoveToPoint(context, endPoint.x, endPoint.y);
    CGContextAddLineToPoint(context, startPoint.x, startPoint.y);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.drawingWidth);
    CGContextSetRGBStrokeColor(context,red , green, blue,alpha);
    CGContextSetBlendMode(context, kCGBlendModeColor);
    CGContextStrokePath(context);
    image = UIGraphicsGetImageFromCurrentImageContext();
    if(isMainImage){
        self.sketch.image=image;
    }
    UIGraphicsEndImageContext();
}

- (void)redo{
    
    self.currentLineNumber = [NSNumber numberWithInt:[self.currentLineNumber intValue]+1];
    
    NSMutableArray *currentArray=[self.drawingHistory objectForKey:self.currentLineNumber];
    for(int i=0;i<currentArray.count-2;i++){
        [self drawStartingFrom:CGPointFromString([currentArray objectAtIndex:i]) andEndPoint:CGPointFromString([currentArray objectAtIndex:i+1])onImage:self.sketch.image];
    }
    if (self.currentLineNumber.intValue >= maxDrawingsCount) {
        self.isRedoEnabled=NO;
    }
}


- (void)undo{
    if (self.currentLineNumber.intValue<0) {
        self.isUndoEnabled=NO;
        return;
    }
    isMainImage=NO;
    self.currentLineNumber = [NSNumber numberWithInt:[self.currentLineNumber intValue]-1];
    UIImage *tempImage=[UIImage new];
    self.sketch.image=nil;
    for(int i=0;i<self.currentLineNumber.intValue;i++){
        NSMutableArray *currentArray=[self.drawingHistory objectForKey:[NSNumber numberWithInt:i]];
        for(int j=0;j<currentArray.count-2;j++){
            [self drawStartingFrom:CGPointFromString([currentArray objectAtIndex:j]) andEndPoint:CGPointFromString([currentArray objectAtIndex:j+1]) onImage:tempImage];
        }
    }
        self.sketch.image=tempImage;
    isMainImage=YES;
    self.isRedoEnabled=YES;
}

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
- (void) saveImage{
    UIImageWriteToSavedPhotosAlbum(self.sketch.image, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void) image:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo:(NSDictionary*)info{
    NSLog(@"error %@ \n info %@",error,info);
}
@end
