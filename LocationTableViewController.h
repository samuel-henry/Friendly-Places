//
//  LocationTableViewController.h
//  Friendly Places
//
//  Created by Sam on 3/15/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationTableViewController : UITableViewController <NSFetchedResultsControllerDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (assign) BOOL isSearchType;
@property (strong, nonatomic) NSString *currentPredicate;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString*)scope;

@end
