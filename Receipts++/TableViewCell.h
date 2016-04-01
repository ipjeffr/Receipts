//
//  TableViewCell.h
//  Receipts++
//
//  Created by Tenzin Phagdol on 2016-03-31.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *amountTextOuput;
@property (weak, nonatomic) IBOutlet UILabel *noteTextOutput;
@property (weak, nonatomic) IBOutlet UILabel *timeStampTextOutput;
@property (weak, nonatomic) IBOutlet UILabel *tagsTextOutput;

@end
