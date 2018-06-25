//
//  PhotoGallaryModel.m
//  Paint
//
//  Created by Admin on 6/24/18.
//  Copyright © 2018 Tirdwayv.Co. All rights reserved.
//

#import "PhotoGallaryModel.h"


@implementation PhotoGallaryModel


+ (instancetype)sharedInstance
{
    static PhotoGallaryModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PhotoGallaryModel alloc] init];
    });
    return sharedInstance;
}

// Save Photo to galary
- (void) savePhoto:(UIImage*)image onComplete: ( void ( ^ )( NSURL* url) )completeBlock  {
    __block NSString* localId;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status)
        {
            case PHAuthorizationStatusAuthorized :
            {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    PHFetchResult *photosAsset;
                    PHAssetCollection *collection = [self findOrCreateAlbumAssetCollection:@"PaintApp"];
                    PHObjectPlaceholder *placeholder;
                    placeholder = [[PHAssetChangeRequest creationRequestForAssetFromImage:image] placeholderForCreatedAsset];
                    photosAsset = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                    PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection assets:photosAsset];
                    [albumChangeRequest addAssets:@[placeholder]];
                    localId = [placeholder localIdentifier];
                } completionHandler:^(BOOL success, NSError *error) {
                    if (success){
                        PHFetchResult* assetResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[localId] options:nil];
                        PHAsset *asset = [assetResult firstObject];
                        [asset requestContentEditingInputWithOptions:[PHContentEditingInputRequestOptions new] completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
                            NSURL *imageURL = contentEditingInput.fullSizeImageURL;
                            completeBlock(imageURL);
                        }];
                        
                    }}];
            }
                break;
            case PHAuthorizationStatusDenied :
                [self savePhoto:image onComplete:completeBlock];
            default:
                NSLog(@"Restricted");
                break;
        }
    }];
}

// Delete photo
- (void) deletePhotoWithUrl:(NSString*)url{
    NSError* error=nil;
    [[NSFileManager defaultManager] removeItemAtPath:url error:&error];
}

// Get album in galary or Create if not exist

- (PHAssetCollection*)findOrCreateAlbumAssetCollection:(NSString*)albumName{
    __block PHAssetCollection *collection;
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"title = %@", albumName];
    collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                          subtype:PHAssetCollectionSubtypeAny
                                                          options:fetchOptions].firstObject;
    if(!collection){
        __block PHObjectPlaceholder *albumPlaceholder;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCollectionChangeRequest *changeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
            albumPlaceholder = changeRequest.placeholderForCreatedAssetCollection;
            
        } completionHandler:^(BOOL success, NSError *error) {
            if (success) {
                collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                      subtype:PHAssetCollectionSubtypeAny
                                                                      options:fetchOptions].firstObject;
            } else {
                NSLog(@"Error creating album: %@", error);
            }
        }];
    }
    return collection;
}

@end
