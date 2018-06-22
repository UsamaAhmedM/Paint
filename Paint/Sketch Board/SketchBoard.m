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
@property (atomic) NSNumber* drawingsCount;
@property (atomic) NSMutableDictionary <NSNumber*,NSMutableArray*> *drawingHistory;
@property (atomic) NSMutableArray *lines;
@end

@implementation SketchBoard

CGFloat red,green,blue,alpha;

- (instancetype) initWithView : (UIImageView*) view{
    self = [super init];
    if (self && view != nil) {
        UIImage *image = [UIImage new];
        self.sketch = view;
        self.sketch.image=image;
        UIPanGestureRecognizer *dragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragGestureTriggered:)];
        [self.sketch addGestureRecognizer:dragGesture];
        self.drawingsCount=[NSNumber numberWithInt:0];
        self.drawingHistory=[NSMutableDictionary new];
        self.drawingColor = UIColor.blackColor;
        self.drawingWidth = 5.0;
    }else
    {
        return nil;
    }
    return self;
}

- (void) setDrawingColor:(UIColor *)drawingColor{
    [drawingColor getRed:&red green:&green blue:&blue alpha:&alpha];
}

- (void)startDrawingWithPoint: (CGPoint) point{
    [self.drawingHistory setObject: [NSMutableArray new] forKey:self.drawingsCount];
    NSMutableArray *currentArray=[self.drawingHistory objectForKey:self.drawingsCount];
    [currentArray addObject: NSStringFromCGPoint(point)];
}


- (void)continueDrawingWithPoint: (CGPoint) point{
    NSMutableArray *currentArray=[self.drawingHistory objectForKey:self.drawingsCount];
    [currentArray addObject: NSStringFromCGPoint(point)];
    [self draw];
}


- (void)endDrawingWithPoint: (CGPoint) point{
    self.drawingsCount = [NSNumber numberWithInt:[self.drawingsCount intValue]+1];
}

- (void) draw {
    NSMutableArray *currentArray=[self.drawingHistory objectForKey:self.drawingsCount];
    if (currentArray.count >= 2){
        CGPoint startPoint =  CGPointFromString([currentArray objectAtIndex:currentArray.count-2]);
        CGPoint endPoint =  CGPointFromString([currentArray objectAtIndex:currentArray.count-1]);
        
        UIGraphicsBeginImageContext(self.sketch.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [ self.sketch.image drawInRect:CGRectMake(0, 0, self.sketch.frame.size.width, self.sketch.frame.size.height)];
        
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.drawingWidth);
        CGContextSetRGBStrokeColor(context,red , green, blue,alpha);
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGContextStrokePath(context);
        
        self.sketch.image = UIGraphicsGetImageFromCurrentImageContext();
      //  self.sketch.alpha = 0.0 ;
        UIGraphicsEndImageContext();
    }
}


- (BOOL)redo{
    BOOL res = YES;
    
    return res;
}


- (BOOL)undo{
    BOOL res = YES;
    
    return res;
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

@end
