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
#import "CSAddressDetailViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
@interface CSSupplierDetailViewController () <MFMailComposeViewControllerDelegate>

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
                cell.textField.text = [NSLocalizedString(@"Website: ", nil) stringByAppendingFormat:@"%@", _supplier.contact.website? _supplier.contact.website: @""];
                break;
            case 6:
                cell.textField.text = [NSLocalizedString(@"Twitter: ", nil) stringByAppendingFormat:@"%@", _supplier.contact.twitter? _supplier.contact.twitter: @""];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3 && _supplier.contact.phone)
    {
        NSLog(@"calling...");
        NSString *phoneNumber = [@"telprompt://" stringByAppendingString:_supplier.contact.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
    if (indexPath.row == 4 && _supplier.contact.email)
    {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:@[_supplier.contact.email]];
        [controller setSubject:@""];
        [controller setMessageBody:@"" isHTML:NO];
        if (controller) [self presentViewController:controller animated:YES completion:nil];
    }
    if (indexPath.row == 5 && _supplier.contact.website)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: _supplier.contact.website]];
    }
    if (indexPath.row == 7 || indexPath.row == 8)
    {
        [self performSegueWithIdentifier:@"addressDetail" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    CSAddressDetailViewController *addressController = segue.destinationViewController;
    if (indexPath.row == 7)
    {
        addressController.isPostal = YES;
    }
    addressController.contact = _supplier.contact;
}

#pragma mark - Mail controller delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"mail was sent");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
