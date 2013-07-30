//
//  CSProductDetail.m
//  CameraScanner
//
//  Created by Rostislav Kobizskiy on 7/5/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CSProductDetail.h"
#import "Product.h"
#import "CSCreateProduct.h"

@interface CSProductDetail () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CSProductDetail

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    self.navigationItem.title = _productItem.name;
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"Handle", @"Handle");
            cell.detailTextLabel.text = _productItem.handle;
            break;
        case 1:
            cell.textLabel.text = NSLocalizedString(@"Price", @"Price");
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02f", _productItem.price.floatValue];
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editProduct"])
    {
        [segue.destinationViewController setSku:_productItem.sku];
        [segue.destinationViewController setItemForEdit:_productItem];
    }
}



@end
