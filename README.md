# biträde - DISIS Maintenance Script Set
biträde is a set of scripts designed to help maintaining the computers at Digital Interactive Sound & Intermedia Studio (DISIS) at Virginia Tech.

## Supported platforms
* OS X 10.10 or higher - shell script
	* Although not currently implemented, OS version requirement reserved for JXA support introduced with OS X 10.10.
	* All iMacs at DISIS currently have OS X 10.11 deployed.
	* Script tested on OS X 10.11 and macOS 10.12.
* Windows 8.1 (build 9200) or higher - batch script and PowerShell Script
	* Included PowerShell Script requires PowerShell 4.0 features, which comes with Windows 8.1.
	* All PCs at DISIS currently have Windows 8.1 (build 9600) deployed.
	* Script tested on Windows 8.1 (build 9600) and Windows 10 (version 1607).
	
## Usage
See individual README files for each platform.

## FAQs

### Why is Linux not currently supported?
biträde was designed to streamline software deployment for DISIS computers. At DISIS, we have around 10 Macs, 10 PCs and one computer running Ubuntu. It simply isn’t practival to create a separate script for Linux at this stage. 

### Why is biträde needed in the first place?
Several considerations. Here’s three to start with:
* To ensure safety, end-users were given accounts with relatively low privileges. When it’s necessary to deploy multiple packages, it quickly becomes a hassle to type in the admin password every time a privileged action is required. biträde can ensure for each computer only one password input is needed.
* Installing packages by hand with GUI is [slower than](http://www.commitstrip.com/en/2016/12/22/terminal-forever/) installing with scripts.
* Unlike macOS, there isn’t a mutually-agreed folder for VST plugins on Windows. biträde will help setting up a folder for VST on Windows.

### Why not use Swift on Mac?
_i.e._, Why use scripting languages?
No need to compile. Just run the script _et voila_.

### What do I need to know to use biträde?
Not much. You’ll need to copy the files to designated folders and tell biträde what it need to do with them. This involves editing a simple text file. See README files for each platform for documentation. 
You will also need to know the admin password for the computers at DISIS for biträde to actually do something.