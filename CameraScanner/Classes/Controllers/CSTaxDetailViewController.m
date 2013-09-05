//
//  CSDetailViewController.m
//  CameraScanner
//
//  Created by Владимир on 05.09.13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CSTaxDetailViewController.h"
#import "CSTextFieldCell.h"

@interface CSTaxDetailViewController ()

@end

@implementation CSTaxDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Tax", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CSTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textField.enabled = NO;
    switch (indexPath.row) {
        case 0:
            cell.textField.text = [NSLocalizedString(@"Tax name: ", nil) stringByAppendingString: _tax.name];
            break;
        case 1:
            cell.textField.text = [NSLocalizedString(@"Tax rate: ", nil) stringByAppendingString:[_tax.rate stringValue]];
            break;                        
        default:
            break;
    }   
    
    return cell;
}


@end
