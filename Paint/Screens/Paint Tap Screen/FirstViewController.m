//
//  FirstViewController.m
//  Paint
//
//  Created by Admin on 6/22/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import "FirstViewController.h"
#import "SketchBoard.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *sketchArea;
@property (atomic) SketchBoard *sketchBoard;
@end

@implementation FirstViewController

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
