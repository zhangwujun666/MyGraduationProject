//
//  SYJCustomPickerView.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/15.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJCustomPickerView.h"
#define FIXED_PICKER_HEIGHT 60.0

@implementation SYJCustomPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setFrame:(CGRect)frame{
    CGFloat targetHeight=frame.size.height;
    CGFloat scalFactor=targetHeight/FIXED_PICKER_HEIGHT;
    frame.size.height=FIXED_PICKER_HEIGHT;
    self.transform=CGAffineTransformIdentity;
    [super setFrame:frame];
    frame.size.height=targetHeight;
    CGFloat dX=self.bounds.size.width/2;
    CGFloat dY=self.bounds.size.height/2;
    self.transform = CGAffineTransformTranslate(CGAffineTransformScale(CGAffineTransformMakeTranslation(-dX, -dY), 1, scalFactor), dX, dY);
}


@end
