
#import <UIKit/UIKit.h>

@interface UICollectionViewCell (MAGMore)

+ (void)mag_registerInCollectionView:(UICollectionView *)collectionView;

+ (id)mag_createForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
+ (id)mag_createForCollectionView:(UICollectionView *)collectionView cellIdentifier:(NSString *)cellIdentifier indexPath:(NSIndexPath *)indexPath;//        please use this method rarely
@end
