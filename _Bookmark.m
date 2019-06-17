// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Bookmark.m instead.

#import "_Bookmark.h"

@implementation BookmarkID
@end

@implementation _Bookmark

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Bookmark" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Bookmark";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Bookmark" inManagedObjectContext:moc_];
}

- (BookmarkID*)objectID {
	return (BookmarkID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic id;

- (int32_t)idValue {
	NSNumber *result = [self id];
	return [result intValue];
}

- (void)setIdValue:(int32_t)value_ {
	[self setId:@(value_)];
}

- (int32_t)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result intValue];
}

- (void)setPrimitiveIdValue:(int32_t)value_ {
	[self setPrimitiveId:@(value_)];
}

@dynamic title;

@dynamic url;

@end

@implementation BookmarkAttributes 
+ (NSString *)id {
	return @"id";
}
+ (NSString *)title {
	return @"title";
}
+ (NSString *)url {
	return @"url";
}
@end

