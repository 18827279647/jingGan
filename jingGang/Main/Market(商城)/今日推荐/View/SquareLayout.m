//
//  SquareLayout.m
//  01-百思不得其姐
//
//  Created by 李攀祥 on 16/3/8.
//  Copyright © 2016年 李攀祥. All rights reserved.
//

#import "SquareLayout.h"

@interface SquareLayout ()
/** attrs的数组 */
@property(nonatomic,strong)NSMutableArray * attrsArr;

@property (nonatomic, strong) NSArray * StyleArray;
@end
@implementation SquareLayout

-(NSMutableArray *)attrsArr
{
    if(!_attrsArr){
        _attrsArr=[[NSMutableArray alloc] init];
    }
    return _attrsArr;
}

- (NSArray *)StyleArray{
    if (!_StyleArray) {
        _StyleArray = @[@"1-1",@"2-1",@"2-2",@"3-1",@"3-2",@"3-3",@"3-4",@"4-1",@"4-2",@"4-3",@"4-4",@"5-1",@"5-2",@"5-3",@"5-4"];
    }
    return _StyleArray;
}


-(void)prepareLayout
{
    [super prepareLayout];
    [self.attrsArr removeAllObjects];
    NSInteger count =[self.collectionView   numberOfItemsInSection:0];
    for (int i=0; i<count; i++) {
        NSIndexPath *  indexPath =[NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes * attrs=[self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArr addObject:attrs];
    }
    
    NSLog(@"1---%zd",self.attrsArr.count);
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArr;
}

#pragma mark ---- 返回CollectionView的内容大小
/*!
 * 如果不设置这个的话  CollectionView就不能滑动
 */
//-(CGSize)collectionViewContentSize
//{
//    int count =(int)[self.collectionView numberOfItemsInSection:0];
//    int rows=(count +3 -1)/3;
//    CGFloat rowH = self.collectionView.frame.size.width/2;
//    if ((count)%6==2|(count)%6==4) {
//        return CGSizeMake(0, rows * rowH-rowH/2);
//    }else{
//        return CGSizeMake(0, rows*rowH);
//    }
//}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"2----%zd",indexPath.row);
    CGFloat width =self.collectionView.frame.size.width*0.5;
    UICollectionViewLayoutAttributes * attrs=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat height = self.collectionView.height;
    NSInteger i=indexPath.item;
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.StyleArray.count; i++) {
        if ([self.style isEqualToString:self.StyleArray[i]]) {
            index = i;
            break;
        }
    }
  //@"1-1",@"2-1",@"2-2",@"3-1",@"3-2",@"3-3",@"3-4",@"4-1",@"4-2",@"4-3",@"4-4",@"5-1",@"5-2",@"5-3",@"5-4"
    
    switch (index) {
        case 0:
            attrs.frame = CGRectMake(0, 0, self.collectionView.width, self.collectionView.height);
            break;
        case 1:
            switch (i) {
                case 0:
                    attrs.frame = CGRectMake(0, 0, width, height);
                    break;
                case 1:
                    attrs.frame = CGRectMake(width, 0, width, height);
                    break;
                default:
                    break;
            }
            break;
        case 2:
            attrs.frame = CGRectMake(0, 0, self.collectionView.width, height / 2);
            break;
        case 3:
            if (i == 0) {
               attrs.frame = CGRectMake(0, 0, width, height);
            }else {
                attrs.frame = CGRectMake(width, 0, width, height);
            }
            break;
        case 4:
            if (i == 0 || i == 1) {
                attrs.frame = CGRectMake(0, 0, width, height);
            }else {
                attrs.frame = CGRectMake(width, 0, width, height);
            }
            break;
        case 5:
            attrs.frame = CGRectMake(self.collectionView.width/self.attrsArr.count * i, 0, self.collectionView.frame.size.width / self.attrsArr.count, height);
            break;
        case 6:
            switch (i) {
                case 0:
                    attrs.frame = CGRectMake(0, 0, self.collectionView.width, height /2);
                    break;
                case 1:
                    attrs.frame = CGRectMake(0,height/2, self.collectionView.width / 2, height/2 );
                    break;
                default:
                    attrs.frame = CGRectMake(self.collectionView.width/2 * i, 0, self.collectionView.width / 2, height/2);
                    break;
            }
            break;
        case 7:
            if (i < 2) {
                attrs.frame = CGRectMake(self.collectionView.width / 2 * i, 0, self.collectionView.width / 2, height /2);
            }else {
               attrs.frame = CGRectMake(self.collectionView.width / 2 * (i-2), height/2, self.collectionView.width / 2, height/2);
            }
            break;
        case 8:
            if ( i == 0) {
                attrs.frame = CGRectMake(0, 0, self.collectionView.width, height /2);
            }else {
               attrs.frame = CGRectMake(self.collectionView.width / self.attrsArr.count * i,0, self.collectionView.width / self.attrsArr.count, height/2 );
            }
            break;
        case 9:
            switch (i) {
                case 0:
                    attrs.frame = CGRectMake(0, 0, self.collectionView.width, height /2);
                    break;
                case 1:case 2:
                    attrs.frame = CGRectMake(self.collectionView.width / self.attrsArr.count * i,0, self.collectionView.width / self.attrsArr.count, height/2 );
                    break;
                case 3:
                    attrs.frame = CGRectMake(0,height/2, self.collectionView.width, height/2 );
                    break;
                default:
                    break;
            }
            break;
        case 10:
            attrs.frame = CGRectMake(self.collectionView.width / self.attrsArr.count * i,0, self.collectionView.width / self.attrsArr.count, height);
            break;
        case 11:
            switch (i) {
                case 0:case 1:
                    attrs.frame = CGRectMake(self.collectionView.width / 2 * i , 0, self.collectionView.width / 2, height/2 );
                    break;
                case 2:case 4:case 3:
                    attrs.frame = CGRectMake(self.collectionView.width / 3 * (i - 2),height / 2, self.collectionView.width / 3, height /2);
                    break;
                default:
                    break;
            }
            break;
        case 12:
            switch (i) {
                case 0:case 1:
                    attrs.frame = CGRectMake(self.collectionView.width / 2 * i , 0, self.collectionView.width / 2, height/2 );
                    break;
                case 2:
                attrs.frame = CGRectMake(0,height / 2, self.collectionView.width / 2, height /2);
                    break;
                case 3:
                attrs.frame = CGRectMake(self.collectionView.width / 2 ,height/2, self.collectionView.width / 4, height/2);
                    break;
                case 4:
                    attrs.frame = CGRectMake(self.collectionView.width / 2  +  self.collectionView.width / 4,height/2, self.collectionView.width / 4, height/2);
                    break;
                default:
                    break;
            }
            break;
        case 13:
            attrs.frame = CGRectMake(self.collectionView.width / 5 * i , 0, self.collectionView.width / 5, height );
            break;
        case 14:
            break;
        default:
            break;
    }
    

    
    return attrs;
}

@end
