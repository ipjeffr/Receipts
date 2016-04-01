//
//  InputViewController.m
//  Receipts++
//
//  Created by Tenzin Phagdol on 2016-03-31.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import "InputViewController.h"
#import "AppDelegate.h"
#import "Receipt.h"
#import "Tag.h"

@interface InputViewController ()
@property (weak, nonatomic) IBOutlet UITextField *amountInputField;
@property (weak, nonatomic) IBOutlet UITextView *noteInputField;
@property (weak, nonatomic) IBOutlet UITextField *timeStampInputField;
@property (strong, nonatomic) IBOutletCollection(UISwitch) NSArray *switches;

@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSSet<Tag *>*)makeTagSet {
    NSMutableSet *tagSet = [[NSMutableSet alloc] init];
    for (UISwitch *s in self.switches) {
        switch (s.tag) {
            case 1:
                if (s.on) {
                    [tagSet addObject:[self createTagWithString:@"Personal"]];
                    break;
                }
            case 2:
                if (s.on) {
                    [tagSet addObject:[self createTagWithString:@"Family"]];
                    break;
                }
            case 3:
                if (s.on) {
                    [tagSet addObject:[self createTagWithString:@"Business"]];
                    break;
                }
            default:
                break;
        }
    }
    return tagSet;
}

-(Tag*)createTagWithString:(NSString*)tagName {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"tagName == %@", tagName]];
    
    NSError *error;
    NSArray *results = [self.managedOC executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"error == %@", error.localizedDescription);
    }
    
    if (results.count == 0){
        Tag *tag = [NSEntityDescription
                    insertNewObjectForEntityForName:@"Tag"
                    inManagedObjectContext:self.managedOC];
        tag.tagName = tagName;
        return tag;
    } else {
        Tag *tag = results[0];
        return tag;
    }
}

- (IBAction)pressedSaveReceipt:(id)sender {
    
    Receipt *newReceipt = [NSEntityDescription
                           insertNewObjectForEntityForName:@"Receipt"
                           inManagedObjectContext:self.managedOC];
    newReceipt.tags = [self makeTagSet];
    newReceipt.amount = @([self.amountInputField.text intValue]);
    newReceipt.note = self.noteInputField.text;
    newReceipt.timeStamp = self.timeStampInputField.text;
    
    NSError *error;
    if (![self.managedOC save:&error]) {
        NSLog(@"Unresolved error %@", error.localizedDescription);
        abort();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
