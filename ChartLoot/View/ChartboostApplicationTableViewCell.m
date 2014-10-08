//
//  ChartboostApplicationTableViewCell.m
//  ChartLoot
//
//  Created by Arthur GUIBERT on 04/10/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import "ChartboostApplicationTableViewCell.h"

@implementation ChartboostApplicationTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    self.imageView.frame = CGRectMake(8, 8, 48, 48);
    self.imageView.clipsToBounds = YES;
    self.imageView.image = [UIImage imageNamed:@"default_cell.png"];
    self.imageView.layer.cornerRadius = 24;
    self.imageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(8,8,48,48);
    
    CGRect f = self.textLabel.frame;
    f.origin.x = 72;
    self.textLabel.frame = f;
    
    f = self.detailTextLabel.frame;
    f.origin.x = 72;
    self.detailTextLabel.frame = f;
}

@end
