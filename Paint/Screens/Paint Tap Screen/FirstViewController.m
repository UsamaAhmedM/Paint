//
//  FirstViewController.m
//  Paint
//
//  Created by Admin on 6/22/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import "FirstViewController.h"
@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *sketchArea;
@property (atomic) SketchBoard *sketchBoard;
@end

@implementation FirstViewController
- (IBAction)didTapOnUndo:(id)sender {
    if (self.sketchBoard.isUndoEnabled) {
        [self.sketchBoard undo];
    }
}
- (IBAction)didTapOnRedo:(id)sender {
    
    if (self.sketchBoard.isRedoEnabled) {
        [self.sketchBoard redo];
    }
}
- (IBAction)didTapOnSave:(id)sender {
    [self.sketchBoard saveImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sketchBoard=[[SketchBoard alloc]initWithView:self.sketchArea];
    [self.sketchArea becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
