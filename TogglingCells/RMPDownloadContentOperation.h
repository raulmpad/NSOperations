//
//  RMPDownloadContentOperation.h
//  TogglingCells
//
//  Created by mdeveloper on 14/03/12.
//  Copyright (c) 2012 deceroainfinito.es . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMPDownCell.h"

@interface RMPDownloadContentOperation : NSOperation {
  
  // Cell to uplooad status
  NSIndexPath *_indexPath;
  
  // Current status
  BOOL _finished;
  BOOL _executing;

  // Connection
  NSURLConnection *_conn;
  NSURL *_url;

  // To save to disk
  NSString *_filePath;
  NSOutputStream *_stream;
  
  // Progress values
  float _progressValue;
  long _downloadedContentLength;
  long _expectedContentLength;
  
  NSError * _error;
}

@property float progressValue;
@property long expectedContentValue;
@property long downloadedContentLength;

@property (strong) NSIndexPath *indexPath;
@property (strong) NSURLConnection *conn;
@property (strong) NSURL *url;
@property (strong) NSString *filePath;
@property (strong) NSOutputStream *stream;
@property (strong) NSError *error;

-(id)initWithUrl:(NSString *)aUrl saveToFilePath:(NSString *)aFilePath updatingCellAtRow:(NSIndexPath *)anIndexPath;

@end
