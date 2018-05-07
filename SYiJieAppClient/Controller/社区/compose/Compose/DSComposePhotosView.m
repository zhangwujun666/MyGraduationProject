//
//  DSComposePhotosView.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/28.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSComposePhotosView.h"
#import "DSComposePhotoViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JKImagePickerController.h"
#import "DSComposePhotoViewCell.h"
#define kCellNum 3//每行显示的单元格数目

@interface DSComposePhotosView()<JKImagePickerControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation DSComposePhotosView



- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
//    if (self){
//        UIImage  *img = [UIImage imageNamed:@"compose_pic_add"];
//        UIButton   *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        //CGFloat collectionY = CGRectGetMaxY(self.collectionView.frame);
//        button.frame = CGRectMake(15, 140, img.size.width, img.size.height);
//        [button setBackgroundImage:img forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"compose_pic_add_highlighted"] forState:UIControlStateHighlighted];
//        button.hidden = YES;
//        self.addButton = button;
//        [self addSubview:button];
//    }
    
    return self;
}

-(void)runInMainQueue:(void (^)())queue{
    dispatch_async(dispatch_get_main_queue(), queue);
}

-(void)runInGlobalQueue:(void (^)())queue{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), queue);
}

-(void)setAssetsArray:(NSMutableArray *)assetsArray {
    
    _assetsArray = assetsArray;
    
    NSMutableArray *tempbox = [NSMutableArray array];
    for(JKAssets *asset in assetsArray){
        
        [tempbox addObject:asset.photo];
    }
    
    self.selectedPhotos = [NSArray arrayWithArray:tempbox];
}

static NSString *kPhotoCellIdentifier = @"kPhotoCellIdentifier";

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assetsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DSComposePhotoViewCell *cell = (DSComposePhotoViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    
        cell.asset = [self.assetsArray objectAtIndex:[indexPath row]];
        cell.deletePhotoButton.tag = indexPath.row;
        cell.indexpath = indexPath;
        [cell.deletePhotoButton addTarget:self action:@selector(deleteView:) forControlEvents:UIControlEventTouchUpInside];
//    }else{
//        JKAssets *asset = [[JKAssets alloc] init];
//        asset.photo = [UIImage imageNamed:@"compose_pic_add_highlighted"];
//        
//        cell.asset = asset;
//        cell.deletePhotoButton.tag = indexPath.row;
//        cell.indexpath = indexPath;
//        //[cell.deletePhotoButton removeFromSuperview];
//        
//        //[cell.deletePhotoButton addTarget:self action:@selector(deleteView:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
    return cell;
}

- (void)deleteView:(id)sender{
    NSInteger deletedPhoto = ((UIButton *)sender).tag;
    for (DSComposePhotoViewCell *currentCell in [self.collectionView subviews]){
        
        if (deletedPhoto == currentCell.indexpath.row){
            
            if (self.assetsArray.count > 0){
                [self.assetsArray removeObjectAtIndex:deletedPhoto];
                [UIView animateWithDuration:1 animations:^{
                    currentCell.frame = CGRectMake(currentCell.frame.origin.x, currentCell.frame.origin.y + 100, 0, 0);
                     [currentCell removeFromSuperview];
                }completion:^(BOOL finished) {
                   
                }];
            }
        }
        
        if (deletedPhoto < currentCell.indexpath.row){
            currentCell.deletePhotoButton.tag -= 1;
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float imgW = (collectionView.frame.size.width - 2*5)/3.0;
    return CGSizeMake(imgW, imgW);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)[indexPath row]);
    NSArray *cellArray = [collectionView visibleCells];
    if (indexPath.row == ([cellArray count] - 1)) {
        if ([self.delegate respondsToSelector:@selector(presentToImageViewCotroller)]) {
            [self.delegate presentToImageViewCotroller];
        }
    }
}

//代理执行
//- (void)addButtonClicked {
  //  if ([self.delegate respondsToSelector:@selector(presentToImageViewCotroller)]) {
    //    [self.delegate presentToImageViewCotroller];
    //}
//    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
//    imagePickerController.delegate = self;
//    imagePickerController.showsCancelButton = YES;
//    imagePickerController.allowsMultipleSelection = YES;
//    imagePickerController.minimumNumberOfSelection = 1;
//    imagePickerController.maximumNumberOfSelection = 9;
//    imagePickerController.selectedAssetArray = self.assetsArray;
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
//    [self presentViewController:navigationController animated:YES completion:NULL];
//    NSLog(@"button clicked");
//}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //layout.minimumLineSpacing = 5.0;
        layout.minimumInteritemSpacing = 5.0;
        //layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 50, kAllWidth - 10, 200) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[DSComposePhotoViewCell class] forCellWithReuseIdentifier:kPhotoCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:_collectionView];
    }
    return _collectionView;
}
@end
