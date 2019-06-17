// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Bookmark.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface BookmarkID : NSManagedObjectID {}
@end

@interface _Bookmark : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BookmarkID *objectID;

@property (nonatomic, strong, nullable) NSNumber* id;

@property (atomic) int32_t idValue;
- (int32_t)idValue;
- (void)setIdValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSString* title;

@property (nonatomic, strong, nullable) NSString* url;

@end

@interface _Bookmark (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSNumber*)primitiveId;
- (void)setPrimitiveId:(nullable NSNumber*)value;

- (int32_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int32_t)value_;

- (nullable NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(nullable NSString*)value;

- (nullable NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(nullable NSString*)value;

@end

@interface BookmarkAttributes: NSObject 
+ (NSString *)id;
+ (NSString *)title;
+ (NSString *)url;
@end

NS_ASSUME_NONNULL_END
