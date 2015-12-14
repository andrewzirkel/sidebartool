//
//  sidebar.m
//  sidebartool
//
//  Created by Zirkel, Andrew D. on 11/30/15.
//  Copyright © 2015 Zirkel, Andrew D. All rights reserved.
//

#import "sidebar.h"

@implementation sidebar {
	NSArray *sidebarSnapShot;
	LSSharedFileListRef *sidebarItems;
}

- (id)init{
	self = [super init];
	if (self) {
		//get sidebar snapshot
		sidebarItems = LSSharedFileListCreate(Nil,kLSSharedFileListFavoriteItems,Nil);
		sidebarSnapShot = (__bridge NSArray *)(LSSharedFileListCopySnapshot(sidebarItems, Nil));
	}
	return self;
}

- (void)dealloc{
	CFPreferencesSynchronize(kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
	CFPreferencesAppSynchronize((__bridge CFStringRef)@"com.apple.sidebarlists");
}

- (NSDictionary *)getSidebarItems {
	NSMutableDictionary *itemList = [[NSMutableDictionary alloc] init];
	CFURLRef itemPath = Nil;
	
	for (id item in sidebarSnapShot) {
		NSString *itemName = (__bridge NSString *)(LSSharedFileListItemCopyDisplayName((__bridge LSSharedFileListItemRef)(item)));
		LSSharedFileListItemResolve((__bridge LSSharedFileListItemRef)(item),0,(CFURLRef*) &itemPath,Nil);
		itemList[itemName]= ([(__bridge NSURL *)itemPath path] != nil) ? [(__bridge NSURL *)itemPath path] : @"";
	}
	return itemList;
}

- (BOOL)addSidebarItem:(NSString *) item
							Position:(float) position{
	//check for special urls:
	/* Needs display name and correct icon
	//iCloud
	if (item && [item caseInsensitiveCompare:@"iCloud"]==0) {
		item=@"x-apple-finder:icloud";
		NSURL *itemToAdd = [NSURL URLWithString:[item stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
		LSSharedFileListInsertItemURL(sidebarItems, kLSSharedFileListItemBeforeFirst, (__bridge CFStringRef)@"iCloud Drive", nil, (__bridge CFURLRef)itemToAdd, nil, nil);
		return true;
	}
	*/
	//All My Files:
	if (item && [item caseInsensitiveCompare:@"All My Files"]==0) {
		item = @"file://localhost/System/Library/CoreServices/Finder.app/Contents/Resources/MyLibraries/myDocuments.cannedSearch";
		NSURL *itemToAdd = [NSURL URLWithString:[item stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
		LSSharedFileListInsertItemURL(sidebarItems, kLSSharedFileListItemBeforeFirst, Nil, nil, (__bridge CFURLRef)itemToAdd, nil, nil);
		return true;
	}
	//set up base url
	NSString *pathPrefix = [@"file://localhost" stringByAppendingString:NSHomeDirectory()];
	if (item!=nil) {
		item = [[pathPrefix stringByAppendingString:@"/"] stringByAppendingString:item];
	} else item = pathPrefix;
	//build url
	NSURL *itemToAdd = [NSURL URLWithString:[item stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	//check if path exists
	NSError *err;
	if ([itemToAdd checkResourceIsReachableAndReturnError:&err]) {
		LSSharedFileListInsertItemURL(sidebarItems, kLSSharedFileListItemBeforeFirst, Nil, nil, (__bridge CFURLRef)itemToAdd, nil, nil);
		return TRUE;
	}else {
		return false;
	}
}

- (BOOL)removeSidebarItem:(NSString *) itemToDelete {
	for (id item in sidebarSnapShot) {
		NSString *itemName = (__bridge NSString *)(LSSharedFileListItemCopyDisplayName((__bridge LSSharedFileListItemRef)(item)));
		if ([itemToDelete caseInsensitiveCompare:itemName]==0) {
			//NSLog(@"Removing %@",itemName);
			LSSharedFileListItemRemove(sidebarItems,(__bridge LSSharedFileListItemRef)(item));
			return true;
		}
	}
	return false;
}

@end
