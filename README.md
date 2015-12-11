# Sidebartool
A command line tool to manage the Finder Sidebar

This is quick and dirty and a work in progress.

Requires OSX 10.11

#Build
Clone the repository.<br />
Use `xcodebuild install` on command line in Project directory to build.

#Usage
Usage: sidebartool list<br />
Usage: sidebartool remove "item"&nbsp;&nbsp;&nbsp;&nbsp;Sidebar Item Title, ie. "domain-AirDrop", "All My Files", etc<br />
Usage: sidebartool add "item"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;User homedir for Users Home Directory or Folder Name, ie. Music

#Usage as a login item
This is how I use this tool with a Launch Agent that kicks off a script at first login:<br/>
Here is the Launch Agent:<br/>
Replace MYORG and PATHTO with your info.
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>org.MYORG.sidebarFavorites</string>
  	<key>LimitLoadToSessionType</key>
  	<array>
    		<string>Aqua</string>
  	</array>
	<key>ProgramArguments</key>
	<array>
		<string>/PATHTO/sidebarFavorites.sh</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
	<key>KeepAlive</key>
	<true/>
	<key>LaunchOnlyOnce</key>
	<true/>
</dict>
</plist>
```
<br/>
Here is the script:<br/>
```
#!/bin/bash

flagfile="$HOME/.sidebarFavoritesDone"

if [ ! -e $flagfile ]; then
/usr/local/bin/sidebartool remove domain-airdrop
/usr/local/bin/sidebartool remove "All My Files"
/usr/local/bin/sidebartool remove "Documents"
/usr/local/bin/sidebartool add homedir

touch $flagfile
fi

exit 0
```

