# biträde for macOS

Please read through this file carefully before using biträde ('this script', 'the script'), as elevated permission can cause harm if not used properly. This script was a _bona fide_ attempt to streamline maintaining DISIS computers.

## Format of this document
This document mostly follows the Python Markdown format [^1]. Two important syntaxes are inline code and code blocks. 

* Inline code is fenced by one backtick, like `this`.
* Code block is fenced by three backticks, for example:

    ```shell
echo hello world!
```

    (`shell` being an optional language tag. It tells Markdown how to do syntax highlighting, however it won't be shown if the document is rendered.)
    
If you are looking at the html file, you won't see the backticks and `shell` mentioned above.

## Usage
In order to run this script, it must be marked as executable. By default, double clicking on `bitraede.command` should be enough. 

However, if you double click it and only see a terminal window flashing by or a text editor simply opens, you will need to mark the script to be executable [^2]. To do so, open Terminal by [^3]:

* Clicking on the magnifying glass icon (the default keyboard shortcut is ⌘Space) on top-right side of the screen, start typing 'terminal' and press return when Terminal is selected, or,
* Open Finder and click on Application > Utilities > Terminal.app.

Once Terminal is open, type in 

```shell
chmod +x␣
```

Note that the character after `+x` is a single whitespace.

Then, drag the script file, `bitraede.command`, into the Terminal window. The Terminal should look similar to this:

```shell
chmod +x /Volume/flashdrive/macos/bitraede.command
```

Press return to flip the execution triads. If this script is saved on a removable device and this removable device is used amongst different Macs, you should only need to do it once.

Once proper execution permission is set, double click `bitrade.command` to execute this script.

**`bitraede.command` shall not be executed with elevated permission. That is to say, do not `sudo`-open this script. When elevated permission is required, you will be asked to authenticate once during the lifetime of this script.**

## File structure for macOS biträde
```
bitraede
|---macos
    |   bitraede.command
    |   CHECK_UPDATE
    |   README.html
    |   README.md
    |   REBOOT_REQUIRED
    |---applications
        |   (.app files OR empty)
        |   ...
    |---audiounits
        |   (AU plugins OR empty)
        |   ...
    |---maxplugins
        |   (Max 7 plugins OR empty)
        |   ...
    |---pacakges
        |   (.pkg files OR empty)
        |   ...
    |---scripts
        |   (custom script files OR empty)
        |   (optionally, REBOOT_REQUIRED)
        |   ...
    |---system
        |   (macOS installer: an .app file)
        |   (OR CHECK_UPDATE)
        |   (OR empty)
    |---vst2
        |   (VST2 plugins OR empty)
        |   ...
    |---vst3
        |   (VST3 plugins OR empty)
        |   ...
```

Please leave files/folders in respective folders.

For files/folders in `vst2`, `vst3` and `audiounits` folders, they will be copied to respective folders in `/Library`. As such, elevated permission is required.

For files/folders in `maxplugins`, they will be copied to Max's plugin folder in `/Users/Shared/Max 7/`. No special permission is required.

For `.pkg` files [^4] in `packages`, they will be executed sequencially. Elevated permission is required.

For `.app` files [^5] in `applications`, they will be copied to `/Applications`. Elevated permission is required. If the `.app` file happens to be custom installers (usually the installers have the `.pkg` extension), do not leave them in this folder. Instead, please write a shell script for them.

A special case for the `.app` installers is macOS installation file. For macOS installer, please leave it in the `system` folder. If a macOS installer file is found, this script will attempt to upgrade OS X/macOS currently installed on the target computer to the version contained in the installer. By utilising this option, you agree to Apple Inc.'s Software License Agreements [^6] for that specific version of OS X/macOS. Elevated permission is required.

If the file named `CHECK_UPDATE` is copied from the root folder to `system` folder, this script will attempt to update the current system. The major system version will remain the same (for example, if the target Mac has OS X 10.11.1, it will update to 10.11.6 instead of the latest stable version of macOS). It will also attempt to update certain included Apple software (for example, Digital Camera RAW Compatibility Update). This option will be ignored if a macOS installer file is found in `system`; otherwise, if `CHECK_UPDATE` is present, elevated permission is required.

You can also leave shell scripts in the `scripts` folder. As mentioned before, `bitraede.command` shall not be executed with elevated permission; you should elevate permission only for commands that really need it in the shell script (by using `sudo`, for example). Shell scripts should use `.sh` or `.command` file extension and they should be executable.

**Please exercise extreme caution with the elevated permission; it is imperative that you test the custom scripts before deploying them to production. With great power comes great responsibility.**

If elevated permission is required, you will be asked to authenticate with an account that has `sudo` access. You will only be asked to authenticate once during the entire lifetime of this script.

## FAQ
### Q1: Application 'can't be opened because it is from an unidentified developer'?
A1: This is because the application is not signed with a valid developer ID and Gatekeeper prevented it from running [^7]. If you indeed trust the app, you can exempt it from Gatekeeper. To do so, right click (or left click whilst holding option key) on the app icon in 'Applications' folder and choose 'Open'. When asked 'Are you sure you want to open it', click 'Open'. Optionaly you can disable Gatekeeper, however this is not recommened for security reasons. See [^8] if you really want to do that.

### Q2: Application 'is damaged and can't be opened. You should move it to the Trash'?
A2: In most cases it means the application itself is damaged and Gatekeeper prevented it from running [^9]. Most of the time is it best to follow the suggestion and move the application to Trash. Occasionally it is caused by execution triad for the application not set correctly. If you trust the publisher and the application, you can try to open Terminal, type `chmod +x␣` (`␣` being a whitespace), open Finder, go to 'Applications' folder and locate the application, right click (or left click whilst holding option key) on the app, click 'Show Package Contents', navigate to Contents > MacOS, drag the binary file (usually nemed the same as the application and has an icon resembles Terminal) to the Terminal window and press return. Then, close the Finder window and try open the application.

### Q3: How is the codesigning policy enforced?
A3: In short, only the signature for macOS upgrade (`.app`) is verified. Signautures for `.pkg` files and other `.app` files are not checked. It is, therefore, up to the sysadmin to make sure the applications/packages are legit. 

### Q4: macOS cannot be upgraded?
A4: Many possible reasons, not limited to the following:

* The macOS version in the installer is older than the one already installed.
* The code signature of the installer is not valid.
	* This usually indicates the installer is corrupt.
	* This only apply to OS X installers downloaded before 2016-02-14: Apple's updated certificate rendered them invalid [^10]. It is possible to circumvent the check by modifying system time [^11], however it is recommended to download a new one from Mac App Store.

### Q5: What is the opearating sequence?
A5: `vst2` -> `vst3` -> `audiounits` -> `applications` -> `packages` -> `maxpackages` -> `scripts` -> `system` (upgrade or update).

All operations are optional. If packages are installed or system update is performed, after the script is complete, you will be prompted to reboot with a 10-second timeout. If the package does not require rebooting or if you simply want to postpone reboot, cancel it during the timeout. System upgrade will always result in a reboot.

### Q6: Why biträde cannot be run with `sudo`?
A6: For security concerns. If `sudo ./bitraede.command` is allowed, everything in this script will be executed with elevated permissions, which is not only not necessary but also can be potentially dangerous, especially with custom scripts [^12]. 

### Q7: What version of OS X/macOS can I upgrade to with biträde?
A7: All iMacs in DISIS have OS X 10.11 installed, so it can be upgraded to macOS 10.12 or higher. biträde also utilises a tool called `startosinstall`, which are not available in OS X 10.10 installer or earlier versions.

### Q8: What is the differences between 'update' and 'upgrade'?
A8: In the scope of this README, 'update' is defined to be 'updating system software to the _current_ major version', whilst 'upgrade' is defined to be 'upgrading system software to the _lastest available_ major version'. For example, if you update an iMac with OS X 10.11.1 (El Capitan) installed, it will be updated to OS X 10.11.6, the most recent OS X 10.11 available at the time of writing; however if you choose to upgrade, it will be upgraded to macOS 10.12.2, the most recent macOS available at the time of writing. 

In addition, if you choose to update the system, the software updater will also check for updates of certain system features (Digital Camera RAW Compatibility Update, for example).

If you have both the OS X/macOS installer and `CHECK_UPDATE` file in `system` folder, `CHECK_UPDATE` will be ignored. 

### Q9: Where can I obtain OS X/macOS installer?
A9: The only official way is through Mac App Store. **Do not download it from internet** as it can be manipulated (even though biträde will probably reject it as it won't pass codesigning verification). **Do not share the installer with others** as it contains an Mac App Store receipt (which can be traced back to who released the installer). 

### Q10: Why not use flags (`--reboot-required`, for example) instead of special files?
A10: This is intentional. biträde is designed with the assumption that the maintainer may not have too much experience with UNIX, and double clicking on the script would be easier for the maintainer (rather than figuring out how to run the script with flags). It is also not practical to wait for user input as it is designed to reduce user input. That said, this script is not designed to be invoked in Terminal directly. 

## Notes on scripting
* Do not use scripting unless you fully understand what you are doing [^13].
* If an command requires elevated permission, use `sudo` in front of the line that really needs it. Avoid using `su`. 
* Test the script before deploying to production.
* Scripts must use `.sh` or `.command` file extensions. UTI is not checked.
* In addition, scripts must be executable. biträde will not try to change file mode bits.
* If your script requires reboot: Copy the file named `REBOOT_REQUIRED` from the root folder to `scripts` folder. Bear in mind that if `.pkg` files are installed, biträde will attempt to reboot at the end anyways. The reboot will not occur immediately if system update/upgrade is requested; otherwise the script will attempt to reboot after all scripts were executed regardless of the outcome of the scripts.

## Notes on upgrading
There is no guarantee that the method I use here will be the same for future macOS versions. `startosinstall` was first spotted in OS X 10.10 installer and was since included in all OS X/macOS installers. There is an undocumented flag, `--nointeraction`, which I decided not to use as, well, it's not documented. 

It is always possible to use the `createinstallmedia` tool, which is also included in recent OS X installers (10.9 and newer). This is a well-documented tool for creating OS X/macOS installing media (flash drive, for example) [^14]. 

## Legal
```
bitraede - DISIS Maintenance Script Set

Copyright (C) 2017 Tianyu Ge

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
```
* A copy of the GNU General Public License v3.0 can be found at the root folder (named `LICENSE`), and you can also find it [online](https://www.gnu.org/licenses/gpl-3.0.en.html). 
* All product names and trademarks are property of their respective owners. 
* This script set is provided on a _pro bono publico_ basis. See `LICENSE` file in root folder regarding warranty (§15) and liability (§16).

## Tested configuration
* macOS Sierra Version 10.12.2 (16C67), Terminal Version 2.7.1 (388)
* macOS Sierra Version 10.12.2 (16C67), iTerm2 Build 3.0.13

[^1]: [https://pythonhosted.org/Markdown/index.html](https://pythonhosted.org/Markdown/index.html)

[^2]: Other options are currently being explored, which would make things easier. If they work.

[^3]: Terminal.app is located in `/Applications/Utilities/Terminal.app`.

[^4]: They are actually folders.

[^5]: Also actually folders. Technically 'directories', to be pedantic.

[^6]: [http://www.apple.com/legal/sla/](http://www.apple.com/legal/sla/)

[^7]: [https://support.apple.com/en-us/HT202491](https://support.apple.com/en-us/HT202491)

[^8]: _Loc. cit._

[^9]: _Loc. cit._

[^10]: [http://arstechnica.com/apple/2016/03/psa-updated-apple-certificate-means-old-os-x-installers-dont-work-anymore/](http://arstechnica.com/apple/2016/03/psa-updated-apple-certificate-means-old-os-x-installers-dont-work-anymore/)

[^11]: [http://osxdaily.com/2015/01/19/fix-os-x-install-errors-cant-be-verified-error-occurred-preparing-mac/](http://osxdaily.com/2015/01/19/fix-os-x-install-errors-cant-be-verified-error-occurred-preparing-mac/)

[^12]: The other reason that you should not invoke this script with `./bitraede.command` is currently part of the script cannot expand `./` to an absolute path.

[^13]: My dad got me a computer tutoring software soon after I first used a laptop. The software featured a section, paraphrased 'DO NOT DO THIS IF YOU ARE A NEWBIE', prominently. I immediately disregarded the advise and used `FORMAT C:\` in `COMMAND.COM`. Hilarity ensues. Thanks for showing me what I shan't do, people who made that software. /s

[^14]: For more information on `createinstallmedia`, please refer to Apple's Help Topic #201372: [https://support.apple.com/en-us/HT201372](https://support.apple.com/en-us/HT201372)