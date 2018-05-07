//
//  SYJSizeselect.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/10.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJSizeselect : UIView
-(void)sizeanimate;
-(void)sizeanimatetwo;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property int i;
@property (weak, nonatomic) IBOutlet UIButton *sure;


@end
