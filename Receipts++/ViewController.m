//
//  ViewController.m
//  Receipts++
//
//  Created by Tenzin Phagdol on 2016-03-31.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import "ViewController.h"
#import "InputViewController.h"
#import "TableViewCell.h"
#import "AppDelegate.h"
#import "Receipt.h"
#import "Tag.h"


@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Tag*>* allTags;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSDictionary *receiptsDictionary;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.managedObjectContext = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
}

-(void)viewWillAppear:(BOOL)animated {
    //display the data from InputViewController, requires a fetch request
    [self fetchData];
    [self.tableView reloadData];
}

-(void)fetchData {

    NSFetchRequest *fetchTags = [[NSFetchRequest alloc] init];
    NSEntityDescription *tagEntity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    fetchTags.entity = tagEntity;
    
    NSError *error;
    self.allTags = [self.managedObjectContext executeFetchRequest:fetchTags error:&error];
    if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            abort();
    }
    NSLog(@"self.allTags == %@", @(self.allTags.count));
    [self setupReceiptsDictionary];
}

- (void)setupReceiptsDictionary {
    NSMutableDictionary *receipts = [[NSMutableDictionary alloc] init];
    for (Tag *tag in self.allTags) {
        NSSet *r = tag.receipts;
        NSArray *rArray = [r allObjects];
        [receipts setObject:rArray forKey:tag.tagName];
    }
    self.receiptsDictionary = receipts;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //set it equal to the number of Tag entities
    return self.allTags.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allTags[section].receipts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Tag *tag = self.allTags[indexPath.section];
    Receipt *receipt = self.receiptsDictionary[tag.tagName][indexPath.row];

    cell.amountTextOuput.text = [receipt.amount stringValue];
    cell.noteTextOutput.text = receipt.note;
    cell.timeStampTextOutput.text = receipt.timeStamp;
    cell.tagsTextOutput.text = tag.tagName;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.allTags[section].tagName;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // pass the managedObjectContext over to the inputViewController
    
    InputViewController *inputVC = (InputViewController*)[segue destinationViewController];
    inputVC.managedOC = self.managedObjectContext;
}

@end
