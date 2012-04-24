//
//  RMPDownloadedImageVC.m
//  TogglingCells
//
//  Created by mdeveloper on 16/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RMPDownloadedImageVC.h"

@interface RMPDownloadedImageVC ()

@end

@implementation RMPDownloadedImageVC

@synthesize imageView = _imageView;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  
  NSString *filename = @"Storm.png";
  NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
  
  NSLog(@"%@", filePath);
  
  self.imageView.image = [UIImage imageWithContentsOfFile:filePath];  
}

- (void)viewDidUnload {
  [self setImageView:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

@end
