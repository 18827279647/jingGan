//
//  YSSelecteCityController.h
//  jingGang
//
//  Created by dengxf on 16/11/23.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSSelecteCityController : UIViewController
- (instancetype)initWithCities:(NSArray *)cities selected:(id_block_t)selectedCallback showHeaderView:(BOOL)show;
@end
