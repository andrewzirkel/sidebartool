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

void printUsage(){
	printf("Usage: sidebartool list\n\
Usage: sidebartool remove \"item\"\tSidebar Item Title, ie. \"Air Drop\"\n\
Usage: sidebartool add \"item\"\t\tUser homedir for Users Home Directory or Folder Name, ie. Music\
\n");
	
}

void printOutput(id output) {
	NSString *formattedOutput;
	formattedOutput = [NSString stringWithFormat:@"%@\n",output];
	printf("%s",[formattedOutput cStringUsingEncoding:[NSString defaultCStringEncoding]]);
}

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		//load sidebar
		sidebar *mySidebar = [[sidebar alloc] init];
		
		//get and execute arguments
		NSArray *arguments = [[NSProcessInfo processInfo] arguments];
		if (argc > 1) {
			if ([arguments[1] caseInsensitiveCompare:@"list"]==0){
				//list
				NSDictionary *myItems=[mySidebar getSidebarItems];
				printOutput([NSString stringWithFormat:@"%@\n",myItems]);
			} else if ([arguments[1] caseInsensitiveCompare:@"remove"]==0) {
				//remove
				if (argc > 2) {
					if ([mySidebar removeSidebarItem:arguments[2]]) {
						printOutput([NSString stringWithFormat:@"%@ removed\n",arguments[2]]);
					} else {
						printOutput([NSString stringWithFormat:@"%@ not found\n",arguments[2]]);
					}
				} else printUsage();
			} else if ([arguments[1] caseInsensitiveCompare:@"add"]==0) {
				//add
				if (argc > 2) {
					BOOL result;
					if ([arguments[2] caseInsensitiveCompare:@"homedir"]==0) {
						result = [mySidebar addSidebarItem:nil Position:1];
					} else {
						result =[mySidebar addSidebarItem:arguments[2] Position:1];
					}
					if (result) {
						printOutput([NSString stringWithFormat:@"%@ added",arguments[2]]);
					} else {
						printOutput([NSString stringWithFormat:@"%@ not added",arguments[2]]);
					}
				}else printUsage();
			}else printUsage();
		}else printUsage();
	}
    return 0;
}
