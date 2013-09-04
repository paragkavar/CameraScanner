//
//  TaxesViewController.m
//  CameraScanner
//
//  Created by Владимир on 04.09.13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "TaxesViewController.h"
#import "Tax.h"
#import "Product.h"
#import "CSCreateProduct.h"

@interface TaxesViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TaxesViewController

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
    _fetchedResultsController = [Tax fetchAllSortedBy:@"name" ascending:YES withPredicate:nil groupBy:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return _fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    NSUInteger count = [sectionInfo numberOfObjects];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Tax *tax = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = tax.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Rate: %f", [tax.rate floatValue]];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSCreateProduct *productController = [self.navigationController.viewControllers objectAtIndex:0];
    Tax *tax = [_fetchedResultsController objectAtIndexPath:indexPath];
    productController.itemForEdit.taxName = tax.name;
    [productController.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
