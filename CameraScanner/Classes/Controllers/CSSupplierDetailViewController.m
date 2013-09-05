//
//  CSSupplierDetailViewController.m
//  CameraScanner
//
//  Created by Владимир on 05.09.13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CSSupplierDetailViewController.h"
#import "CSTextFieldCell.h"
#import "Contact.h"
@interface CSSupplierDetailViewController ()

@end

@implementation CSSupplierDetailViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0? 2:9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CSTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textField.enabled = NO;
    // Configure the cell...
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textField.text = [NSLocalizedString(@"Supplier name: ", nil) stringByAppendingFormat:@"%@", _supplier.name? _supplier.name: @""];
                break;
            case 1:
                cell.textField.text = [NSLocalizedString(@"Supplier description: ", nil) stringByAppendingFormat:@"%@", _supplier.supplierDescription? _supplier.supplierDescription: @""];
                break;
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:
                cell.textField.text = [NSLocalizedString(@"First name: ", nil) stringByAppendingFormat:@"%@", _supplier.contact.first_name? _supplier.contact.first_name: @""];
                break;
            case 1:
                cell.textField.text = [NSLocalizedString(@"Last name: ", nil) stringByAppendingFormat:@"%@", _supplier.contact.last_name? _supplier.contact.last_name: @""];
                break;
            case 2:
                cell.textField.text = [NSLocalizedString(@"Company name: ", nil) stringByAppendingFormat:@"%@", _supplier.contact.company_name? _supplier.contact.company_name: @""];
                break;
            case 3:
                cell.textField.text = [NSLocalizedString(@"Phone: ", nil) stringByAppendingFormat:@"%@", _supplier.contact.phone? _supplier.contact.phone: @""];
                break;
            case 4:
                cell.textField.text = [NSLocalizedString(@"Email: ", nil) stringByAppendingFormat:@"%@", _supplier.contact.email? _supplier.contact.email: @""];
                break;
            case 5:
                cell.textField.text = [NSLocalizedString(@"Twitter: ", nil) stringByAppendingFormat:@"%@", _supplier.contact.twitter? _supplier.contact.twitter: @""];
                break;
            case 6:
                cell.textField.text = [NSLocalizedString(@"Website: ", nil) stringByAppendingFormat:@"%@", _supplier.contact.website? _supplier.contact.website: @""];
                break;
            case 7:
                cell.textField.text = NSLocalizedString(@"Postal address", nil);
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 8:
                cell.textField.text = NSLocalizedString(@"Physical address", nil);
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;              
            default:
                break;
        }

    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
