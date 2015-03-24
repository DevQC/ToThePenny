    //
    //  TodayViewController.m
    //  Depoza Extension
    //
    //  Created by Ivan Magda on 23.03.15.
    //  Copyright (c) 2015 Ivan Magda. All rights reserved.
    //

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

    //CoreData
@import CoreData;
#import "Persistence.h"
#import "ExpenseData+Fetch.h"
#import "CategoryData.h"

static NSString * const kAppGroupSharedContainer = @"group.com.vanyaland.depoza";

@interface TodayViewController () <NCWidgetProviding, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *noExpensesLabel;
@property (nonatomic, strong) Persistence *persistence;

@end

@implementation TodayViewController {
    NSArray *_expenses;
    BOOL _isFirst;
    NSUserDefaults *_userDefaults;
}

#pragma mark - ViewController life cycle -

- (void)viewDidLoad {
    [super viewDidLoad];

    _persistence = [Persistence sharedInstance];

    _expenses = [ExpenseData expensesWithEqualDayWithDate:[NSDate date] managedObjectContext:_persistence.managedObjectContext];

    [self.tableView layoutIfNeeded];

    self.noExpensesLabel.textColor = [UIColor whiteColor];

    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (_expenses.count > 0) {
                             self.preferredContentSize = self.tableView.contentSize;

                             self.noExpensesLabel.hidden = YES;
                         } else {
                             self.tableView.hidden = YES;
                         }
                     } completion:nil];

    _userDefaults = [[NSUserDefaults alloc]initWithSuiteName:kAppGroupSharedContainer];
    NSLog(@"%ld", (long)[_userDefaults integerForKey:@"numberExpenseToShow"]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _expenses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSParameterAssert(cell);

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

#pragma mark Helpers

- (NSString *)formatDate:(NSDate *)theDate {
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [NSDateFormatter new];
        formatter.timeStyle = NSDateFormatterShortStyle;
    }
    return [formatter stringFromDate:theDate];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ExpenseData *expense = _expenses[indexPath.row];

    cell.textLabel.text = expense.category.title;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f, %@", [expense.amount floatValue], [self formatDate:expense.dateOfExpense]];
}

@end