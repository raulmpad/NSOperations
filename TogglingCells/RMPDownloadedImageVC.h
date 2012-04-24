//
//  RMPDownloadedImageVC.h
//  TogglingCells
//
//  Created by mdeveloper on 16/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMPDownloadedImageVC : UIViewController {
  __weak IBOutlet UIImageView *_imageView;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
