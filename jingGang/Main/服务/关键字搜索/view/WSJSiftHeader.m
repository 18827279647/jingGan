//
//  WSJSiftHeader.m
//  jingGang
//
//  Created by thinker on 15/8/6.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "WSJSiftHeader.h"

@interface WSJSiftHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation WSJSiftHeader

- (void)setStatusSelect:(BOOL)b
{
    if (b)
    {
        self.imageView.image = [UIImage imageNamed:@"XIALA"];
    }
    else
    {
        self.imageView.image = [UIImage imageNamed:@"XIALA"];
    }
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor redColor];
}
- (IBAction)selectTap:(UIGestureRecognizer *)sender
{
    self.selectSection(self.section);
}

@end
