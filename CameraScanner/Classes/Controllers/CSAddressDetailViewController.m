//
//  CSAddressDetailViewController.m
//  CameraScanner
//
//  Created by Владимир on 05.09.13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CSAddressDetailViewController.h"
#import "CSTextFieldCell.h"

@interface CSAddressDetailViewController ()

@end

@implementation CSAddressDetailViewController

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
    self.title = NSLocalizedString(_isPostal? @"Postal address": @"Physical address", nil);
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
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CSTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textField.enabled = NO;
    // Configure the cell...    
    switch (indexPath.row) {
        case 0:
            cell.textField.text = [NSLocalizedString(@"Address 1: ", nil) stringByAppendingFormat:@"%@", _isPostal? _contact.postal_address1: _contact.physical_address1];
            break;
        case 1:
            cell.textField.text = [NSLocalizedString(@"Address 2: ", nil) stringByAppendingFormat:@"%@", _isPostal? _contact.postal_address2: _contact.physical_address2];
            break;
        case 2:
            cell.textField.text = [NSLocalizedString(@"Suburb: ", nil) stringByAppendingFormat:@"%@", _isPostal? _contact.postal_suburb: _contact.physical_suburb];
            break;
        case 3:
            cell.textField.text = [NSLocalizedString(@"City: ", nil) stringByAppendingFormat:@"%@", _isPostal? _contact.postal_city: _contact.physical_city];
            break;
        case 4:
            cell.textField.text = [NSLocalizedString(@"Postcode: ", nil) stringByAppendingFormat:@"%@", _isPostal? _contact.postal_postcode: _contact.physical_postcode];
            break;
        case 5:
            cell.textField.text = [NSLocalizedString(@"State: ", nil) stringByAppendingFormat:@"%@", _isPostal? _contact.postal_state: _contact.physical_state];
            break;
        case 6:
            cell.textField.text = [NSLocalizedString(@"Country id: ", nil) stringByAppendingFormat:@"%@", _isPostal? _contact.postal_country_id: _contact.physical_country_id];
            break;              
        default:
            break;
    }
    NSString *checkForNull = [cell.textField.text substringFromIndex:cell.textField.text.length - 6];
    if ([checkForNull isEqualToString:@"(null)"])
    {
        cell.textField.text = [cell.textField.text substringToIndex:cell.textField.text.length - 6];
    }
    
    return cell;
}


@end
