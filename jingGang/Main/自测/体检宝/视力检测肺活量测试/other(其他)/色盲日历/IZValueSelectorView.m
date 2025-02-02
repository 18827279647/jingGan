//
//  IZValueSelectorView.m
//  IZValueSelector
//
//  Created by Iman Zarrabian on 02/11/12.
//  Copyright (c) 2012 Iman Zarrabian. All rights reserved.
//

#import "IZValueSelectorView.h"
#import <QuartzCore/QuartzCore.h>


@implementation IZValueSelectorView {
    UITableView *_contentTableView;
    CGRect _selectionRect;
    NSMutableArray *dataarray ;
    
    UILabel *_cache;
}

@synthesize shouldBeTransparent = _shouldBeTransparent;
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.horizontalScrolling = NO;
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.horizontalScrolling = NO;
    }
    return self;
}

- (void)layoutSubviews {
    if (_contentTableView == nil) {
        [self createContentTableView];
        dataarray = [NSMutableArray array];
    }
    [super layoutSubviews];
}



- (void)createContentTableView {

    UIImageView *selectionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectorRect"]];
    _selectionRect = [self.dataSource rectForSelectionInSelector:self];
    selectionImageView.frame = _selectionRect;
    if (self.shouldBeTransparent) {
        selectionImageView.alpha = 0.7;
    }
    
    if (self.horizontalScrolling) {
        
        //In this case user might have created a view larger than taller
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.height, self.bounds.size.width)];        
    }
    else {
        _contentTableView = [[UITableView alloc] initWithFrame:self.bounds];
    }
    
    if (self.debugEnabled) {
        _contentTableView.layer.borderColor = [UIColor blackColor].CGColor;
        _contentTableView.layer.borderWidth = 1.0;
        _contentTableView.layer.cornerRadius = 10.0;
        
        _contentTableView.tableHeaderView.layer.borderColor = [UIColor blackColor].CGColor;
        _contentTableView.tableFooterView.layer.borderColor = [UIColor blackColor].CGColor;
    }


    // Initialization code
    CGFloat OffsetCreated;
    
    //If this is an horizontal scrolling we have to rotate the table view
    if (self.horizontalScrolling) {
        CGAffineTransform rotateTable = CGAffineTransformMakeRotation(-M_PI_2);
        _contentTableView.transform = rotateTable;
        
        OffsetCreated = _contentTableView.frame.origin.x;
        _contentTableView.frame = self.bounds;
    }

    _contentTableView.backgroundColor = [UIColor clearColor];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (self.horizontalScrolling) {
        _contentTableView.rowHeight = [self.dataSource rowWidthInSelector:self];
    }
    else {
        _contentTableView.rowHeight = [self.dataSource rowHeightInSelector:self];
    }
    
    if (self.horizontalScrolling) {
        _contentTableView.contentInset = UIEdgeInsetsMake( _selectionRect.origin.x ,  0,_contentTableView.frame.size.height - _selectionRect.origin.x - _selectionRect.size.width - 2*OffsetCreated, 0);
    }
    else {
        _contentTableView.contentInset = UIEdgeInsetsMake( _selectionRect.origin.y, 0, _contentTableView.frame.size.height - _selectionRect.origin.y - _selectionRect.size.height  , 0);
    }
    _contentTableView.showsVerticalScrollIndicator = NO;
    _contentTableView.showsHorizontalScrollIndicator = NO;

    [self addSubview:_contentTableView];
//    [self addSubview:selectionImageView];    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = [self.dataSource numberOfRowsInSelector:self];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *contentSubviews = [cell.contentView subviews];
    //We the content view already has a subview we just replace it, no need to add it again
    //hopefully ARC will do the rest and release the old retained view
    if ([contentSubviews count] > 0 ) {
        UIView *contentSubV = [contentSubviews objectAtIndex:0];
        //This will release the previous contentSubV
        [contentSubV removeFromSuperview];
        
        UIView *viewToAdd = [self.dataSource selector:self viewForRowAtIndex:indexPath.row];
        contentSubV = viewToAdd;
        if (self.debugEnabled) {
            viewToAdd.layer.borderWidth = 1.0;
            viewToAdd.layer.borderColor = [UIColor redColor].CGColor;
        }
        [cell.contentView addSubview:contentSubV];
    }
    else {
        
        UILabel *viewToAdd = (UILabel *)[self.dataSource selector:self viewForRowAtIndex:indexPath.row];
        //This is a new cell so we just have to add the view
        if (self.debugEnabled) {
            viewToAdd.layer.borderWidth = 1.0;
            viewToAdd.layer.borderColor = [UIColor redColor].CGColor;
        }
        [dataarray addObject:viewToAdd];
        [cell.contentView addSubview:viewToAdd];

    }
    
    if (self.debugEnabled) {
        cell.layer.borderColor = [UIColor greenColor].CGColor;
        cell.layer.borderWidth = 1.0;
    }
    
    if (self.horizontalScrolling) {
        CGAffineTransform rotateTable = CGAffineTransformMakeRotation(M_PI_2);
        cell.transform = rotateTable;
    }
    if (indexPath.row == 0)
    {
        UILabel *l = (UILabel *)[cell.contentView subviews][0];
        l.textColor = [UIColor blackColor];
        _cache = l;
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView == _contentTableView) {
//        [_contentTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        [self.delegate selector:self didSelectRowAtIndex:indexPath.row];
//    }
//}

#pragma mark Scroll view methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollToTheSelectedCell];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollToTheSelectedCell];
    }
}

- (void)scrollToTheSelectedCell {
    
    CGRect selectionRectConverted = [self convertRect:_selectionRect toView:_contentTableView];        
    NSArray *indexPathArray = [_contentTableView indexPathsForRowsInRect:selectionRectConverted];
    
    CGFloat intersectionHeight = 0.0;
    NSIndexPath *selectedIndexPath = nil;
    
    UILabel *l;
    for (NSIndexPath *index in indexPathArray) {
        //looping through the closest cells to get the closest one
        UITableViewCell *cell = [_contentTableView cellForRowAtIndexPath:index];
        CGRect intersectedRect = CGRectIntersection(cell.frame, selectionRectConverted);
       
        if (intersectedRect.size.height>=intersectionHeight) {
            selectedIndexPath = index;
            intersectionHeight = intersectedRect.size.height;
            l = (UILabel *) [cell.contentView subviews][0];
//            NSLog(@"cheshi ---text- %@",l.text);
        }
    }
    _cache.textColor = [UIColor blackColor];
    l.textColor = [UIColor blackColor];
    _cache = l;
    if (selectedIndexPath!=nil) {
        //As soon as we elected an indexpath we just have to scroll to it
        [_contentTableView scrollToRowAtIndexPath:selectedIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        UILabel *label = dataarray[selectedIndexPath.row % dataarray.count];
//        NSLog(@"cheshi --+++-- %@",label.text);
        [self.delegate selector:self didSelectRowAtIndex:selectedIndexPath.row];
    }
}

- (void)reloadData {
    [_contentTableView reloadData];
}

@end
