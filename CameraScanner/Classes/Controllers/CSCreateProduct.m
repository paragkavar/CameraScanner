//
//  CSCreateProduct.m
//  CameraScanner
//
//  Created by Rostislav Kobizskiy on 7/5/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CSCreateProduct.h"

#import "Product.h"
#import "Outlet.h"

#import "WebEngine.h"
#import "CSTextFieldCell.h"

#import "NSString+Validate.h"
#import "UIView+FindFirstResponder.h"

@interface CSCreateProduct () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *handle;
@property (nonatomic, copy) NSString *price;

- (IBAction)handleDone:(id)sender;

@end

@implementation CSCreateProduct

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.title = _itemForEdit ? NSLocalizedString(@"Edit Item", @"Edit Item") : NSLocalizedString(@"Create Item", @"Create Item");
    
    _sku = _itemForEdit ? _itemForEdit.sku : _sku;
    _name = _itemForEdit ? _itemForEdit.name : @"";
    _handle =  _itemForEdit ? _itemForEdit.handle : @"";
    _price = _itemForEdit ? [NSString stringWithFormat:@"%0.2f", (_itemForEdit.price.floatValue + _itemForEdit.tax.floatValue)] : @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (_itemForEdit != nil && _itemForEdit.inventory.count) ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return _itemForEdit ? 5 : 4;
    if (section == 1) return _itemForEdit.inventory.count;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CSTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        switch (indexPath.row) {
            case 0:
                cell.textField.text = _sku;
                cell.textField.enabled = NO;
                break;
            case 1:
                cell.textField.text = _name;
                cell.textField.placeholder = NSLocalizedString(@"Name", @"Name");
                cell.textField.returnKeyType = UIReturnKeyNext;
                break;
            case 2:
                cell.textField.text = _handle;
                cell.textField.placeholder = NSLocalizedString(@"Handle", @"Handle");
                cell.textField.returnKeyType = UIReturnKeyNext;
                break;
            case 3:
                cell.textField.text = _price;
                cell.textField.placeholder = NSLocalizedString(@"Price", @"Price");
                cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                cell.textField.returnKeyType = UIReturnKeyDone;
                break;
            case 4:
                cell.textField.text = _itemForEdit.taxName;
                cell.textField.placeholder = NSLocalizedString(@"Tax name", @"Tax name");
                cell.textField.enabled = NO;
                break;
            default:
                break;
        }
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InventoryCell" forIndexPath:indexPath];
        Outlet *outlet = [[_itemForEdit.inventory allObjects] objectAtIndex:indexPath.row];

        cell.textLabel.text = outlet.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", outlet.count.integerValue];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - TableView Delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return NSLocalizedString(@"Inventory", nil);
    }
    
    return nil;
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    switch (textField.returnKeyType) {
        case UIReturnKeyDone:
            // Last Row Done
            // Registaration here
            [textField resignFirstResponder];
            [self handleDone:nil];
            break;
        case UIReturnKeyNext:
        {
            CSTextFieldCell *prevCell = (CSTextFieldCell *) [[textField superview] superview];
            
            NSIndexPath *prevIndexPath = [_tableView indexPathForCell:prevCell];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:prevIndexPath.row+1 inSection:prevIndexPath.section];

            CSTextFieldCell *cell = (CSTextFieldCell *)[_tableView cellForRowAtIndexPath:indexPath];
            [cell.textField becomeFirstResponder];
        }
        default:
            break;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CSTextFieldCell *cell = (CSTextFieldCell *) [[textField superview] superview];
    [self.tableView scrollToRowAtIndexPath:[_tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(CSTextFieldCell *)[[textField superview] superview]]; // this should return you your current indexPath
    
    // From here on you can (switch) your indexPath.section or indexPath.row
    // as appropriate to get the textValue and assign it to a variable, for instance:
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1) self.name = textField.text;
        if (indexPath.row == 2) self.handle = textField.text;
        if (indexPath.row == 3) self.price = textField.text;
    }
}

- (IBAction)handleDone:(id)sender
{
    [self.tableView resignAllResponder];
    if (!_name || _name.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Name should be not empty"
                                   delegate:self
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    }
    else if (!_handle || _handle.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Handle should be not empty"
                                   delegate:self
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    }
    else if (!_price.isFloat && !_price.isInteger)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Retail price should be numeric"
                                   delegate:self
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    }
    else
    {
        if (_itemForEdit)
        {
            _itemForEdit.name = self.name;
            _itemForEdit.handle = self.handle;
            _itemForEdit.retailPrice = @(self.price.floatValue);
            
            [[WebEngine sharedManager] putProduct:_itemForEdit success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                [[[UIAlertView alloc] initWithTitle:@"Store"
                                            message:NSLocalizedString(@"The Item was edited in your store", @"The Item was edited in your store")
                                           delegate:self
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil] show];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:error.localizedDescription
                                           delegate:self
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil] show];
                TFLog(@"%@", error);
            }];
             
        }
        else
        {
            Product *newProduct = [Product createEntity];
            newProduct.name = _name;
            newProduct.handle = _handle;
            newProduct.retailPrice = @(_price.floatValue);
            newProduct.sku = _sku;
            
            [[WebEngine sharedManager] postProduct:newProduct success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                [[[UIAlertView alloc] initWithTitle:@"Store"
                                            message:NSLocalizedString(@"The Item was added in your store", @"The Item was added in your store")
                                           delegate:self
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil] show];
                [self.navigationController popViewControllerAnimated:YES];
                
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:error.localizedDescription
                                           delegate:self
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil] show];
                
                [newProduct deleteEntity];
                
                TFLog(@"%@", error);
                NSError *saveError = nil;
                if (![[NSManagedObjectContext contextForCurrentThread] save:&saveError])
                {
                    TFLog(@"%@", saveError);
                }
            }];
        }
    }
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
