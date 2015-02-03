//
//  QueueViewController.m
//  Consumer Of Great Success
//
//  Created by Yossi Halevi on 1/29/15.
//  Copyright (c) 2015 Yossi Halevi. All rights reserved.
//

#import "QueueViewController.h"
static NSString *MyIdentifier = @"TableCell";

@interface QueueViewController () {
    NSArray *queueArray;
}
@property (nonatomic,retain)    UITableView *tblView;

@end

@implementation QueueViewController



- (id) initWithData :(NSArray *)data
{
    self = [super init];
    if (self) {
        queueArray = [NSArray arrayWithArray:data];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    

    
    _tblView = [UITableView new];
    _tblView.frame = self.view.frame;
    _tblView.delegate = self;
    _tblView.dataSource = self;
    _tblView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tblView];

}


#pragma mark - Table view methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [queueArray count];
}

- (NSString *)reuseIdentifierForIndexPath:(NSIndexPath *)indexPath {
    return MyIdentifier;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@",[[queueArray objectAtIndex:indexPath.row] objectForKey:@"name"],[[queueArray objectAtIndex:indexPath.row] objectForKey:@"telephone"]];
    
    if ([[[queueArray objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME]]){
        cell.backgroundColor = [UIColor grayColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    
}

@end
