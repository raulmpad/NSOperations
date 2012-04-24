//
//  RMPMainTVC.h
//  TogglingCells
//
//  Created by mdeveloper on 12/03/12.
//  Copyright (c) 2012 deceroainfinito.es . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMPCustomCell.h"
#import "RMPDownCell.h"
#import "RMPDownloadContentOperation.h"
#import "RMPDownloadedImageVC.h"

@interface RMPMainTVC : UITableViewController {

  NSArray *_courses;
  NSMutableArray *_states;
  NSArray *_urls;
  
  NSMutableData *_receivedData;
  
  NSOperationQueue *_operationQueue;
  NSOperation *_downloadContentToDiskOperation;
  
}

@property NSArray *courses;
@property NSMutableArray *states;
@property NSArray *urls;

@property NSMutableData *receivedData;

@property (strong) NSOperationQueue *operationQueue;
@property (strong) NSOperation *downloadContentToDiskOperation;

@end
