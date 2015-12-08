//
//  sidebar.h
//  sidebartool
//
//  Created by Zirkel, Andrew D. on 11/30/15.
//  Copyright © 2015 Zirkel, Andrew D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SharedFileList/LSSharedFileList.h>


@interface sidebar : NSObject

- (id)init;
- (void)dealloc;
- (NSMutableDictionary *)getSidebarItems;
- (BOOL)addSidebarItem:(NSString *) item
							Position:(float) position;
- (BOOL)removeSidebarItem:(NSString *) itemToDelete;

@end
