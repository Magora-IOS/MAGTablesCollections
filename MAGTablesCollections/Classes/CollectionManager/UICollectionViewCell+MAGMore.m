
#import "UICollectionViewCell+MAGMore.h"
#import "NSObject+MAGMore.h"

@implementation UICollectionViewCell (MAGMore)

+ (void)mag_registerInCollectionView:(UICollectionView *)collectionView {
    UINib *nib = [UINib nibWithNibName:[self mag_className] bundle:[NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:[self mag_className]];
}

+ (id)mag_createForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *result = [UICollectionViewCell mag_createForCollectionView:collectionView cellIdentifier:[self mag_className] indexPath:indexPath];
    return result;
}

+ (id)mag_createForCollectionView:(UICollectionView *)collectionView cellIdentifier:(NSString *)cellIdentifier indexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *result = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!result) {
        result = [self mag_createCollectionView];
    }
    return result;
}

+ (id)mag_createCollectionView {
    NSString *nibName = [self mag_className];
    return [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] objectAtIndex:0];
}

@end
