//
//  GuessAnswersViewCell.m
//  HollywoodGenius
//
//  Created by Ekam Singh Dhaliwal on 2019-06-19.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "GuessAnswersViewCell.h"

@implementation GuessAnswersViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.layer setMasksToBounds: YES];
    [self.layer setBorderColor:[[UIColor colorWithRed:255/255.0 green:122/255.0 blue:0/255.0 alpha:1] CGColor]];
    [self.layer setBorderWidth:4.0];
    [self.layer setCornerRadius: 10];
    self.backgroundColor = [UIColor darkTextColor];
    [self.answer.titleLabel setTextColor:[UIColor colorWithRed:255/255.0 green:122/255.0 blue:0/255.0 alpha:1]];
}

@end


