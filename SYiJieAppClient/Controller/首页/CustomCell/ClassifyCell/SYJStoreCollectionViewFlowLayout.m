//
//  SYJStoreCollectionViewFlowLayout.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/5.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJStoreCollectionViewFlowLayout.h"

@implementation SYJStoreCollectionViewFlowLayout
    -(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
        
        NSArray *answer=[[super layoutAttributesForElementsInRect:rect] mutableCopy];
        
        for (int i=1; i<[answer count]; i++) {
            UICollectionViewLayoutAttributes *currentLayoutAttributes=answer[i];
            UICollectionViewLayoutAttributes *prevLayoutAttributesans=answer[i-1];
            NSInteger maximumSpacing=0.001;
//            if (prevLayoutAttributesans.frame.size.width==0.001&&prevLayoutAttributesans.size.height==0.001) {
//                maximumSpacing=0;
//            }
//            if (currentLayoutAttributes.frame.size.width!=prevLayoutAttributesans.frame.size.width) {
//                maximumSpacing=0;
//            }
            NSInteger origin=CGRectGetMaxX(prevLayoutAttributesans.frame);
            if (origin+maximumSpacing+currentLayoutAttributes.frame.size.width<self.collectionViewContentSize.width) {
                CGRect frame=currentLayoutAttributes.frame;
//                if (maximumSpacing!=0) {
//                  frame.origin.x=origin+maximumSpacing;
//                }else{
//                  frame.origin.x=5;
//                }
                currentLayoutAttributes.frame=frame;
            }
        }
        //NSLog(@"%@",answer);
        return answer;
    }

//-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewLayoutAttributes *attributes=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    CGRect originFram=self.collectionView.frame;
//    int currentSection=(int)indexPath.section;
//    if (currentSection==0) {
//        attributes.frame=CGRectMake(<#CGFloat x#>, <#CGFloat y#>, 52, 25)
//    }else{
//        attributes.frame=CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//    }
//    return attributes;
//}
@end
