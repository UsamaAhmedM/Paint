//
//  SecondViewController.m
//  Paint
//
//  Created by Admin on 6/22/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import "SecondViewController.h"
#import "SecondViewPresenter.h"
#import "PaintCustomCell.h"
@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SecondViewController
SecondViewPresenter *presenter;
UIAlertController *alertController;
NSMutableDictionary<NSString*,NSMutableArray<PaintMangedObject*>*> *dataDictinary;

- (void)viewDidLoad {
    [super viewDidLoad];
    presenter=[[SecondViewPresenter alloc]initWithDelagate:self];
    dataDictinary=[NSMutableDictionary new];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [presenter getDataFromDB];
}
# pragma  Delagate
- (void) updateTableDataWith: (NSMutableDictionary<NSString*,NSMutableArray<PaintMangedObject*>*>*) data{
    dataDictinary=data;
    [self.tableView reloadData];
    
}
# pragma Table view section

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataDictinary.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataDictinary objectForKey:[[dataDictinary allKeys]objectAtIndex:section]].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [[dataDictinary allKeys]objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaintCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaintCustomCell"];
    PaintMangedObject *currentDisplayed =[[dataDictinary objectForKey:[[dataDictinary allKeys]objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    cell.paintImageView.image= [[UIImage alloc] initWithContentsOfFile:[currentDisplayed valueForKey:@"path"]];
    cell.paintName.text=currentDisplayed.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!alertController){
        alertController =  [UIAlertController alertControllerWithTitle:@"Select" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete drawing" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [presenter deletePaintFromCD:[[dataDictinary objectForKey:[[dataDictinary allKeys]objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
            alertController=nil;
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            alertController=nil;
        }];
        [alertController addAction:delete];
        [alertController addAction:cancel];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
