//
//  RXFreeCollectionView.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/21.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RXFreeCollectionView : UIView

-(void)showView:(NSString*)string with:(id)obj with:(SEL)sel;
-(void)p_dismissView;

@end

NS_ASSUME_NONNULL_END
