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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraBarButton;
@property (weak, nonatomic) IBOutlet UIButton *colorBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *redoBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
@property (atomic) SketchBoard *sketchBoard;
@end

@implementation FirstViewController

NKOColorPickerView *colorPickerView;
UIImagePickerController *imagePickerController;
UIAlertController *alertController ;
UISlider *slider;

- (IBAction)didTapOnUndo:(id)sender {
    if (self.sketchBoard.isUndoEnabled) {
        [self.sketchBoard undo];
    }
}

- (IBAction)didTapOnCamera:(id)sender {

    [self.sketchBoard clear];
    [self.cameraBarButton setEnabled:NO];
    if(!imagePickerController){
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (IBAction)didTapOnRedo:(id)sender {
    
    if (self.sketchBoard.isRedoEnabled) {
        [self.sketchBoard redo];
    }
}
- (IBAction)didTapOnEraser:(id)sender {
    if(! self.sketchBoard.isErasingModeEnabled){
        self.sketchBoard.isErasingModeEnabled=YES;
        [self.doneBarButton setEnabled:YES];
    }else{
        self.sketchBoard.isErasingModeEnabled=NO;
    }
}


- (IBAction)didTapOnSave:(id)sender {
    [self.saveBarButton setEnabled:NO];
    [self.sketchBoard saveImage];
}

- (IBAction)didTapOnClear:(id)sender {
    if(!alertController){
        alertController =  [UIAlertController alertControllerWithTitle:@"Select" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
     
        UIAlertAction *clearALL = [UIAlertAction actionWithTitle:@"Clear all drawing" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.sketchBoard clear];
            alertController=nil;
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            alertController=nil;
        }];
        [alertController addAction:clearALL];
        [alertController addAction:cancel];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
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
    if( self.sketchBoard.isErasingModeEnabled){
        self.sketchBoard.isErasingModeEnabled=NO;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.reuseImage){
        [self.sketchBoard clear];
        self.sketchBoard.backGroundImage=[[UIImage alloc] initWithContentsOfFile:self.reuseImage];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma view delegate

- (void) redoStatus:(BOOL)isEnabled{
    [self.redoBarButton setEnabled:isEnabled];
}
- (void) undoStatus:(BOOL)isEnabled{
    [self.undoBarButton setEnabled:isEnabled];
}

- (void) showAlertWithTitle:(NSString*)title andMsg:(NSString*)msg{
    
    [self.saveBarButton setEnabled:YES];
    UIAlertController *alert =  [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

# pragma Image picker delagate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.sketchBoard.backGroundImage=image;
    [picker dismissViewControllerAnimated:YES completion:nil];
    imagePickerController=nil;
    [self.cameraBarButton setEnabled:YES];
}
@end
