//
//  main.m
//  sidebartool
//
//  Created by Zirkel, Andrew D. on 11/26/15.
//  Copyright © 2015 Zirkel, Andrew D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SharedFileList/LSSharedFileList.h>
#import "sidebar.h"

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		//variable init
		NSString *formattedOutput;
		//load sidebar
		sidebar *mySidebar = [[sidebar alloc] init];
		
		//get and execute arguments
		NSArray *arguments = [[NSProcessInfo processInfo] arguments];
		if (argc > 1) {
			if ([arguments[1] caseInsensitiveCompare:@"list"]==0){
				NSDictionary *myItems=[mySidebar getSidebarItems];
				formattedOutput = [NSString stringWithFormat:@"%@\n",myItems];
				printf("%s",[formattedOutput cStringUsingEncoding:[NSString defaultCStringEncoding]]);
			} else if ([arguments[1] caseInsensitiveCompare:@"remove"]==0) {
				if (argc > 2) {
					if ([mySidebar removeSidebarItem:arguments[2]]) {
						formattedOutput = [NSString stringWithFormat:@"%@ removed\n",arguments[2]];
						printf("%s",[formattedOutput cStringUsingEncoding:[NSString defaultCStringEncoding]]);
					} else {
						formattedOutput = [NSString stringWithFormat:@"%@ not found\n",arguments[2]];
						printf("%s",[formattedOutput cStringUsingEncoding:[NSString defaultCStringEncoding]]);
					};
				}
			}
		} else {
			//print help
		}
		
	}
    return 0;
}
