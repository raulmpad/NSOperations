//
//  RMPCustomCell.m
//  TogglingCells
//
//  Created by mdeveloper on 12/03/12.
//  Copyright (c) 2012 deceroainfinito.es . All rights reserved.
//

#import "RMPCustomCell.h"

@implementation RMPCustomCell

@synthesize lblTitle = _lblTitle;
@synthesize state;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.state = 0;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
