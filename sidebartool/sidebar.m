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
	NSArray *specialItems;
	LSSharedFileListRef *sidebarItems;
}

- (id)init{
	self = [super init];
	if (self) {
		specialItems=@[@"domain-AirDrop", @"All My Files", @"iCloud"];
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
		if ([specialItems containsObject:itemName]){
			itemList[itemName]=@"";
		} else {
			LSSharedFileListItemResolve((__bridge LSSharedFileListItemRef)(item),0,(CFURLRef*) &itemPath,Nil);
			itemList[itemName]=[(__bridge NSURL *)itemPath path];
		}
	}
	return itemList;
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
