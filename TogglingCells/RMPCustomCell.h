//
//  RMPCustomCell.h
//  TogglingCells
//
//  Created by mdeveloper on 12/03/12.
//  Copyright (c) 2012 deceroainfinito.es . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMPCustomCell : UITableViewCell {
  UILabel *_lblTitle;
  int state;
}

@property IBOutlet UILabel *lblTitle;
@property int state;

@end
