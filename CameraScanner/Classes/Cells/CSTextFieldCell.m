//
//  CSTextFieldCell.m
//  CameraScanner
//
//  Created by Rostislav Kobizskiy on 7/6/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CSTextFieldCell.h"

@implementation CSTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end