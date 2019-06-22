//
//  RootTableViewCell.m
//  HollywoodGenius
//
//  Created by Ekam Singh Dhaliwal on 2019-06-19.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "RootTableViewCell.h"

@implementation RootTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.layer setMasksToBounds: YES];
    [self.layer setBorderColor:[[UIColor colorWithRed:255/255.0 green:215/255.0 blue:0/255.0 alpha:1] CGColor]];
    [self.layer setBorderWidth:4.0];
    [self.layer setCornerRadius: 20];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
