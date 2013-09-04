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
#import "ZBarReaderViewController.h"
#import "WebEngine.h"
#import "CSTextFieldCell.h"

#import "NSString+Validate.h"
#import "UIView+FindFirstResponder.h"

@interface CSCreateProduct () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, ZBarReaderDelegate>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *handle;
@property (nonatomic, copy) NSString *price;
@property (nonatomic) BOOL firstLaunch;

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
    _firstLaunch = YES;
    [self backToScaner:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)findProductWithSKU:(NSString *)sku
{
    _sku = nil;
    _itemForEdit = nil;
    
    __weak MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;    
    
    __weak typeof(self) weakSelf = self;
    [[WebEngine sharedManager] getProductBySKU:sku success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.firstObject);
        if (!mappingResult.firstObject)
        {
            _sku = sku;
            [self reloadTable];
        }
        else
        {
            weakSelf.itemForEdit = mappingResult.firstObject;
            [self reloadTable];
        }
        [hud hide:YES];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"Warning")
                                    message:error.localizedDescription
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"Ok", @"Ok")
                          otherButtonTitles:nil] show];
        
        TFLog(@"%@", error);
        
        weakSelf.itemForEdit = [Product findFirstByAttribute:@"sku" withValue:sku];
       
        if (!_itemForEdit)
            _sku = sku;
        
        [self reloadTable];
        
        [hud hide:YES];
        
    }];    
}

- (void)reloadTable
{
    self.navigationItem.title = _itemForEdit ? NSLocalizedString(@"Edit Item", @"Edit Item") : NSLocalizedString(@"Create Item", @"Create Item");
    _sku = _itemForEdit ? _itemForEdit.sku : _sku;
    _name = _itemForEdit ? _itemForEdit.name : @"";
    _handle =  _itemForEdit ? _itemForEdit.handle : @"";
    _price = _itemForEdit ? [NSString stringWithFormat:@"%0.2f", (_itemForEdit.price.floatValue + _itemForEdit.tax.floatValue)] : @"";
    [self.tableView reloadData];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 4)
        {
            [self performSegueWithIdentifier:@"tax" sender:self];            
        }
    }
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

#pragma mark - scanner

- (IBAction)backToScaner:(id)sender
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;    
    ZBarImageScanner *scanner = reader.scanner;   
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];       
    [self presentViewController:reader animated:_firstLaunch? NO:YES completion:^{
        if (_firstLaunch)
        {
            [self showLoginOnViewController:reader];
            _firstLaunch = NO;
        }
    }];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    NSString *sku = symbol.data;
    [self findProductWithSKU:sku];
    [reader dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{    
    [self showLoginOnViewController:picker];
}

- (void) showLoginOnViewController: (UIViewController *) controller
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iphone" bundle:nil];
    UIViewController *loginController = [storyboard instantiateViewControllerWithIdentifier:@"loginController"];
    [controller presentModalViewController:loginController animated:NO];
}

- (IBAction)handleDone:(id)sender
{
    [self.tableView resignAllResponder];
    if (!_name || _name.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Name should be not empty"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    }
    else if (!_handle || _handle.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Handle should be not empty"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    }
    else if (!_price.isFloat && !_price.isInteger)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Retail price should be numeric"
                                   delegate:nil
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
                
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:error.localizedDescription
                                           delegate:nil
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
                
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:error.localizedDescription
                                           delegate:nil
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self backToScaner:nil];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
