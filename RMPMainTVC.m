//
//  RMPMainTVC.m
//  TogglingCells
//
//  Created by mdeveloper on 12/03/12.
//  Copyright (c) 2012 deceroainfinito.es . All rights reserved.
//

#import "RMPMainTVC.h"

@interface RMPMainTVC ()

@end

@implementation RMPMainTVC

@synthesize courses = _courses;
@synthesize states = _states;
@synthesize urls = _urls;

@synthesize receivedData = _receivedData;
@synthesize operationQueue = _operationQueue;
@synthesize downloadContentToDiskOperation = _downloadContentToDiskOperation;

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  self.courses = [NSArray arrayWithObjects:@"one", @"two", @"three", @"four", @"five", nil];
  self.states = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0", nil];
  self.urls = [NSArray arrayWithObject:@"http://www.soccerwallpaper.mackafe.com/var/albums/Lionel-Messi-Wallpaper-Gallery/wall_messi.jpg"];
  
  
  
  // Create operation queue
  self.operationQueue = [NSOperationQueue new];
  // set maximum operations possible
  [self.operationQueue setMaxConcurrentOperationCount:5];
  
  NSArray* toolbarItems = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize 
                                                                         target:self
                                                                         action:@selector(searchStuff:)],
                           nil];
  
  
  self.toolbarItems = toolbarItems;
  self.navigationController.toolbarHidden = NO;  
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *DefaultCellIdentifier = @"DefaultCell";
  static NSString *DownCellIdentifier = @"DownCell";
  
  if ([self.states objectAtIndex:[indexPath row]] == @"0") {
    RMPCustomCell *customCell = [tableView dequeueReusableCellWithIdentifier:DefaultCellIdentifier];
    customCell.lblTitle.text = [self.courses objectAtIndex:[indexPath row]];
    return customCell;
  } else {
    UITableViewCell *downCell = [tableView dequeueReusableCellWithIdentifier:DownCellIdentifier];
    return downCell;
  }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if ([self.states objectAtIndex:[indexPath row]] == @"0") {
    [self.states replaceObjectAtIndex:[indexPath row] withObject:@"1"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *filename = @"Storm.png";
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
    
    RMPDownloadContentOperation *op = [[RMPDownloadContentOperation alloc] initWithUrl:[self.urls objectAtIndex:0] 
                                                                        saveToFilePath: filePath
                                                                     updatingCellAtRow:indexPath];
    
    // KVO observers
    [op addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
    [op addObserver:self forKeyPath:@"progressValue" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.operationQueue addOperation:op];
      
    [tableView reloadData];
  }
}

#pragma mark - KVO Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)operation change:(NSDictionary *)change context:(void *)context {
  if ([operation isKindOfClass:[RMPDownloadContentOperation class]]) {
    RMPDownloadContentOperation *tmpOp = (RMPDownloadContentOperation *)operation;

    if ([keyPath isEqual:@"progressValue"]) {
      RMPDownCell *downCell = (RMPDownCell *)[self.tableView cellForRowAtIndexPath:tmpOp.indexPath];
      downCell.downloadProgressView.progress = tmpOp.progressValue;
    }
    
    if ([keyPath isEqual:@"isFinished"]) {
      
      NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
      if([paths count] > 0)
      {
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSError *error = nil;
        NSArray *documentArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
        if(error) {
          NSLog(@"Could not get list of documents in directory, error = %@",error);
        } else {
          for (NSString *file in documentArray) {
            NSLog(@"%@", file);
          }
        }
      }
      
      [self performSegueWithIdentifier:@"downloadImage" sender:self];            
    }
  }
}

@end
