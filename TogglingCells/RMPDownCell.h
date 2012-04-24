//
//  RMPDownCell.h
//  TogglingCells
//
//  Created by mdeveloper on 12/03/12.
//  Copyright (c) 2012 deceroainfinito.es . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMPDownCell : UITableViewCell {
  UILabel *_lblTitle;
  UIProgressView *_downloadProgressView;
}

@property (nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic) IBOutlet UIProgressView *downloadProgressView;

@end
