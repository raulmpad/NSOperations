//
//  RMPDownloadContentOperation.m
//  TogglingCells
//
//  Created by mdeveloper on 14/03/12.
//  Copyright (c) 2012 deceroainfinito.es . All rights reserved.
//

#import "RMPDownloadContentOperation.h"

@implementation RMPDownloadContentOperation

@synthesize progressValue = _progressValue;
@synthesize expectedContentValue = _expectedContentLength;
@synthesize downloadedContentLength = _downloadedContentLength;
@synthesize indexPath = _indexPath;
@synthesize conn = _conn;
@synthesize url = _url;
@synthesize filePath = _filePath;
@synthesize stream = _stream;
@synthesize error = _error;

-(id)initWithUrl:(NSString *)aUrl saveToFilePath:(NSString *)aFilePath updatingCellAtRow:(NSIndexPath *)anIndexPath {
  if ((self = [super init])) {
    self.url = [NSURL URLWithString:aUrl];
    self.filePath = aFilePath;
    self.indexPath = anIndexPath;
    self.progressValue = 0.0;

    self.stream = [[NSOutputStream alloc] initToFileAtPath:aFilePath append:NO];
  }
 
  return self;
}

- (void)start {
  // Ensure this operation is not being restarted and that it has not been cancelled
  if (![NSThread isMainThread]) {
    [self performSelectorOnMainThread:@selector(start)
                           withObject:nil waitUntilDone:NO];
    return;
  }
  
  if( _finished || [self isCancelled] ) { 
//    [self done]; 
    return; 
  }  
  
  // KVO isExecuting
  [self willChangeValueForKey:@"isExecuting"];
  _executing = YES;
  [self didChangeValueForKey:@"isExecuting"];
	
  // Create the NSURLConnection
  self.conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:self.url 
                                                                        cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                                                    timeoutInterval:30.0] delegate:self];
}

- (void)done {
  if(self.conn) {
		[self.conn cancel];
    _conn = nil;
    
		[self.stream close];
		_stream = nil;
  }
	
  // KVO isFinished!
  [self willChangeValueForKey:@"isExecuting"];
  [self willChangeValueForKey:@"isFinished"];
  _executing = NO;
  _finished  = YES;
  [self didChangeValueForKey:@"isFinished"];
  [self didChangeValueForKey:@"isExecuting"];
}

-(void)cancelled {
	// Code for cancelled
  self.error = [[NSError alloc] initWithDomain:@"DownloadUrlToDiskOperation" code:123 userInfo:nil];
	
  [self done];	
}


#pragma mark Delegate Methods for NSURLConnection

// Initial response
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  if([self isCancelled]) {
    [self cancelled];
		return;
  }
	
  NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
  NSInteger statusCode = [httpResponse statusCode];
  if( statusCode == 200 ) {
    [self.stream open];
    self.expectedContentValue = [httpResponse expectedContentLength];
  } else {
    NSString* statusError  = [NSString stringWithFormat:NSLocalizedString(@"HTTP Error: %ld", nil), statusCode];
    NSDictionary* userInfo = [NSDictionary dictionaryWithObject:statusError forKey:NSLocalizedDescriptionKey];
    self.error = [[NSError alloc] initWithDomain:@"DownloadUrlToDiskOperationDomain"
                                            code:statusCode
                                        userInfo:userInfo];
    [self done];
  }
}

// The connection failed
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
	if([self isCancelled]) {
    [self cancelled];
		return;
  }	else {
		self.error = error;
		[self done];
	}
}

// The connection received more data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  if([self isCancelled]) {
    [self cancelled];
		return;
  }
  // dump the data
  // Write to disk.
	int success = [self.stream write:[data bytes] maxLength:[data length]];
  
  NSLog(@"Data length: %i", [data length]);
  NSLog(@"Success: %i", success);
  
	if (success < 0) {
		self.error = [[NSError alloc] initWithDomain:@"DownloadUrlToDiskOperation"
                                        code:1
                                    userInfo:[NSDictionary dictionaryWithObject:@"Error writing to disk" forKey:NSLocalizedDescriptionKey]];	
    [self done];
	} else {
    self.downloadedContentLength += data.length;
    [self willChangeValueForKey:@"progressValue"];
    self.progressValue = (float) self.downloadedContentLength/self.expectedContentValue;
    [self didChangeValueForKey:@"progressValue"];
  }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	if([self isCancelled]) {
    [self cancelled];
		return;
  }
	else {
		[self done];
	}
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
  return nil;
}

@end
