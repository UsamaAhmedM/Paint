//
//  FirstViewController.m
//  Paint
//
//  Created by Admin on 6/22/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import "FirstViewController.h"
#import "UIImage+UIImageExtension.h"
#import "NKOColorPickerView.h"
#import "Model.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *sketchArea;
@property (weak, nonatomic) IBOutlet UIButton *colorBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *redoBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (atomic) SketchBoard *sketchBoard;
@end

@implementation FirstViewController

NKOColorPickerView *colorPickerView;
UISlider *slider;

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

- (IBAction)didTapOnClear:(id)sender {
    [self.sketchBoard clear];
}

- (IBAction)didTapOnDone:(id)sender {
    if(colorPickerView != nil){
        self.sketchBoard.drawingColor=[colorPickerView color];
        [colorPickerView removeFromSuperview];
        colorPickerView = nil;
    }
    
    if(slider != nil){
        [self changeWidth:slider];
        [slider removeFromSuperview];
        slider=nil;
        [self.view setNeedsLayout];
    }
    [self.doneBarButton setEnabled:NO];
    [self.sketchArea setUserInteractionEnabled:YES];
}

- (IBAction)didTapToSelectWidth:(UIButton*)sender {
    if(slider == nil){
        CGRect frame = CGRectMake(CGRectGetMinX(sender.frame) ,CGRectGetMinY(sender.frame)-50.0, self.view.frame.size.width, 50.0);
        slider = [[UISlider alloc] initWithFrame:frame];
        [slider setBackgroundColor:[UIColor whiteColor]];
        slider.minimumValue = 0.0;
        slider.maximumValue = 50.0;
        slider.continuous = YES;
        slider.value = self.sketchBoard.drawingWidth;
        [self.view addSubview:slider];
        [self.doneBarButton setEnabled:YES];
        [self.sketchArea setUserInteractionEnabled:NO];
    }}

-(void)changeWidth:(UISlider*)slider
{
    self.sketchBoard.drawingWidth = slider.value;
}

- (IBAction)didTapOnColorPalette:(id)sender {
    if(colorPickerView == nil){
        colorPickerView = [[NKOColorPickerView alloc] initWithFrame:self.sketchArea.frame color:nil andDidChangeColorBlock:nil];
        [self.view addSubview:colorPickerView];
        [self.doneBarButton setEnabled:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sketchBoard=[[SketchBoard alloc]initWithView:self.sketchArea];
    [self.sketchArea becomeFirstResponder];
    self.sketchBoard.delagate=self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) redoStatus:(BOOL)isEnabled{
    [self.redoBarButton setEnabled:isEnabled];
}
- (void) undoStatus:(BOOL)isEnabled{
    [self.undoBarButton setEnabled:isEnabled];
}
@end
