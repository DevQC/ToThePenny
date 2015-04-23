//
//  EditExpenseTableViewController.h
//  Depoza
//
//  Created by Ivan Magda on 16.02.15.
//  Copyright (c) 2015 Ivan Magda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseCategoryTableViewControllerDelegate.h"
#import "DetailExpenseTableViewControllerDelegate.h"

@class ExpenseData;

@interface DetailExpenseTableViewController : UITableViewController <ChooseCategoryTableViewControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) ExpenseData *expenseToShow;

@property (nonatomic, strong) id<DetailExpenseTableViewControllerDelegate> delegate;

@end