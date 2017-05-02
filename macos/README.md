# biträde for macOS

Please read through this file carefully before using biträde ('this script', 'the script'), as elevated permission can cause harm if not used properly. This script was a _bona fide_ attempt to streamline maintaining DISIS computers.

## Format of this document
This document mostly follows the Python Markdown format [^1]. Two important syntaxes are inline code and code blocks:

* Inline code is fenced by one backtick, like `this`.
* Code block is fenced by three backticks, for example:

    ```shell
echo hello world!
```

    (`shell` being an optional language tag. It tells Markdown how to do syntax highlighting, however it won't be shown if the document is rendered.)
    
If you are looking at the html file or have the Markdown file rendered, you won't see the backticks and `shell` mentioned above.

## Usage
Double click on the ``runme.app`` to run. You will be prompted to put in admin credentials and ``Console.app`` will show up. Click on ``~/Library/Logs/`` on sidebar and locate the log that starts with ``bitraede-``.

## File structure for macOS biträde
```
bitraede	<-- Referred to as 'root folder' in this README
└---macos
    |   bitraede.command
    |   README.html
    |   README.md
    └---applications
        |   (.app files OR empty)
        |   ...
    └---audiounits
        |   (AU plugins OR empty)
        |   ...
    └---maxpackages
        |   (Max 7 packages OR empty)
        |   ...
    └---OPTIONS
        |   ALLOW_UNTRUSTED
        |   CHECK_UPDATE
        |   NO_REBOOT
        |   REBOOT_REQUIRED
    └---pacakges
        |   (.pkg files OR empty)
        |   ...
    └---scripts
        |   (custom script files OR empty)
        |   (optionally, REBOOT_REQUIRED)
        |   ...
    └---system
        |   (macOS installer: an .app file)
        |   (OR CHECK_UPDATE)
        |   (OR empty)
    └---vst2
        |   (VST2 plugins OR empty)
        |   ...
    └---vst3
        |   (VST3 plugins OR empty)
        |   ...
```

Please leave files/folders in respective folders.

For files/folders in `vst2`, `vst3` and `audiounits` folders, they will be copied to respective folders in `/Library/Audio/Plug-Ins`. This will ensure all users will have access to these plugins. As such, elevated permission is required.

For files/folders in `maxpackages`, they will be copied to Max's packages folder in `/Users/Shared/Max 7/Packages`. No special permission should be required.

For `.pkg` files [^4] in `packages`, they will be executed sequencially. Elevated permission is required. Reboot will be performed at the end of the script, with a 10-second grace period. By default, biträde will refuse to install untrust packages (packages that do not carry a valid certificate, which includes packages that carry an expired certificate). In order to install untrusted packages, copy `ALLOW_UNTRUSTED` from the `OPTIONS` folder to `packages` folder. To prevent biträde from rebooting after packages are installed, copy `NO_REBOOT` from the `OPTIONS` folder to `packages` folder. If you have both `NO_REBOOT` in `packages` and `REBOOT_REQUIRED` in `scripts`, `NO_REBOOT` will be ignored.

For `.app` files [^5] in `applications`, they will be copied to `/Applications`. Elevated permission should not be required. If the `.app` file happens to be custom installers (usually the installers have the `.pkg` extension), do not leave them in this folder. Instead, please write a shell script for them.

A special case for the `.app` installers is macOS installation file. For macOS installer, please leave it in the `system` folder. If a macOS installer file is found, this script will attempt to upgrade OS X/macOS currently installed on the target computer to the version contained in the installer. By utilising this option, you agree to Apple Inc.'s Software License Agreements [^6] for that specific version of OS X/macOS. Elevated permission is required.

If the file named `CHECK_UPDATE` is copied from the `OPTIONS` folder to `system` folder, this script will attempt to update the current system. The major system version will remain the same (for example, if the target Mac has OS X 10.11.1, it will update to 10.11.6 instead of the latest stable version of macOS). It will also attempt to update certain included Apple software (for example, Digital Camera RAW Compatibility Update). This option will be ignored if a macOS installer file is found in `system`; otherwise, if `CHECK_UPDATE` is present, elevated permission is required.

You can also leave shell scripts in the `scripts` folder. As mentioned before, `bitraede.command` shall not be executed with elevated permission; you should elevate permission only for commands that really need it in the shell script (by using `sudo`, for example). Shell scripts should use `.sh` or `.command` file extension and they should be executable.

**Please exercise extreme caution with the elevated permission; it is imperative that you test the custom scripts before deploying them to production. With great power comes great responsibility.**

If elevated permission is required, you will be asked to authenticate with an account that has `sudo` access. You will only be asked to authenticate once during the entire lifetime of this script.

## Logs
biträde will create a log file named `bitraede-#DATE.log` at `~/Library/Logs`, where `#DATE` will be replaced by current date and time similar to this: `bitraede-2017-01-01-01-01.log`. 

If `ALLOW_UNTRUSTED` is present in `packages` folder, installing an untrusted package, successful or not, will cause biträde to create a log file named `bitraede-#DATE-#PKG.log` in `~/Library/Logs`, like `bitraede-2017-01-01-01-01-example.pkg.log`.

If an executable script is present in `scripts` folder, running it will cause biträde to create a log named `bitraede-#DATE-#SH.log` in `~/Library/Logs`, like `bitraede-2017-01-01-01-01-exempel.sh.log`.

Log files can be viewed using `Console.app`.

## FAQ
### Q1: Application 'can't be opened because it is from an unidentified developer'?
A1: This is because the application is not signed with a valid developer ID and Gatekeeper prevented it from running [^7]. If you indeed trust the publisher and the application, you can exempt it from Gatekeeper. To do so, right click (or left click whilst holding option key) on the app icon in 'Applications' folder and choose 'Open'. When asked 'Are you sure you want to open it', click 'Open'. You will only need to do it once. Optionaly you can disable Gatekeeper altogether; however this is strongly not recommened for security reasons. See [^8] if you really want to do that.

### Q2: Application 'is damaged and can't be opened. You should move it to the Trash'?
A2: In most cases it means the application itself is damaged and Gatekeeper prevented it from running [^9]. Most of the time is it best to follow the suggestion and move the application to Trash. Occasionally it is caused by execution triad for the application not set correctly. If you trust the publisher and the application, you can try to open Terminal, type `chmod +x␣` (`␣` being a whitespace), open Finder, go to 'Applications' folder and locate the application, right click (or left click whilst holding option key) on the app, click 'Show Package Contents', navigate to Contents > MacOS, drag the binary file (usually nemed the same as the application and has an icon resembles Terminal) to the Terminal window and press return. Then, close the Finder window and try open the application.

### Q3: How is the codesigning policy enforced?
A3: In short, only the signatures for macOS upgrade (`.app`) and `.pkg` files are verified. Signautures for other `.app` files are not checked. It is, therefore, up to the sysadmin to make sure the applications are legit. 

### Q4: macOS cannot be upgraded?
A4: Many possible reasons, not limited to the following:

* The macOS version in the installer is older than the one already installed.
* The code signature of the installer is not valid.
	* This usually indicates the installer is corrupt.
	* This only apply to OS X installers downloaded before 2016-02-14: Apple's updated certificate rendered them invalid [^10]. It is possible to circumvent the check by modifying system time [^11], however it is recommended to download a new one from Mac App Store.

### Q5: What is the opearating sequence?
A5: `vst2` -> `vst3` -> `audiounits` -> `applications` -> `packages` -> `maxpackages` -> `scripts` -> `system` (upgrade or update).

All operations are optional. If packages are installed or system update is performed, after the script is complete, you will be prompted to reboot with a 10-second timeout. If the packages do not require rebooting or if you simply want to postpone reboot, cancel it during the timeout. System upgrade will always result in a reboot.

### Q6: What version of OS X/macOS can I upgrade to with biträde?
A7: All iMacs in DISIS have OS X 10.11 installed, so it can be upgraded to macOS 10.12 or higher. biträde also utilises a tool called `startosinstall`, which was not available in OS X 10.10 installer or earlier versions.

### Q7: What is the differences between 'update' and 'upgrade'?
A8: In the scope of this README, 'update' is defined to be 'updating system software to the _current_ major version', whilst 'upgrade' is defined to be 'upgrading system software to the _lastest available_ major version'. For example, if you update an iMac with OS X 10.11.1 (El Capitan) installed, it will be updated to OS X 10.11.6, the most recent OS X 10.11 available at the time of writing; however if you choose to upgrade, it will be upgraded to macOS 10.12.2, the most recent macOS available at the time of writing. 

In addition, if you choose to update the system, the software updater will also check for updates of certain system features (Digital Camera RAW Compatibility Update, for example).

If you have both the OS X/macOS installer and `CHECK_UPDATE` file in `system` folder, `CHECK_UPDATE` will be ignored. 

### Q8: Where can I obtain OS X/macOS installer?
A9: The only official way is through Mac App Store. **Do not download it from internet** as it can be manipulated (even though biträde will probably reject it as it won't pass codesigning verification). **Do not share the installer with others** as it contains an Mac App Store receipt (which can be traced back to who released the installer). 

### Q09: Why not use flags (`--reboot-required`, for example) instead of special files?
A10: This is intentional. biträde is designed with the assumption that the maintainer may not have too much experience with UNIX, and double clicking on the script would be easier for the maintainer (rather than figuring out how to run the script with flags). It is also not practical to wait for user input as it is designed to reduce user input. 

## Notes on scripting
* Do not use scripting unless you fully understand what you are doing [^12].
* If an command requires elevated permission, use `sudo` in front of the line that really needs it. Avoid using `su`. 
* Test the script before deploying to production.
* Scripts must use `.sh` file extensions. UTI is not checked.
* In addition, scripts must be executable. biträde will not try to change file mode bits.
* If your script requires reboot: Copy the file named `REBOOT_REQUIRED` from the `OPTIONS` folder to `scripts` folder. Bear in mind that if `.pkg` files are installed, biträde will attempt to reboot at the end anyways. The reboot will not occur immediately if system update/upgrade is requested; otherwise the script will attempt to reboot after all scripts were executed regardless of the outcome of the scripts.

## Notes on upgrading
There is no guarantee that the method I use here will be the same for future macOS versions. `startosinstall` was first spotted in OS X 10.10 installer and was since included in all OS X/macOS installers. There is an undocumented flag, `--nointeraction`, which I decided not to use, as it's not documented and there is no guarantee it won't be removed in future releases. 

It is always possible to use the `createinstallmedia` tool, which is also included in recent OS X installers (10.9 and newer). This is a well-documented tool for creating OS X/macOS installing media (flash drive, for example) [^15]. 

## Notes on System Integrity Protection (SIP)
Simply put, all applications currently installed on DISIS iMacs do not require disabling (or even temporarily disabling) SIP. Older applications, like Rogue Aomeba-maintained Soundflower, will fail to install because the installer would attempt to install an unsigned kernel extension (kext), which is explicitly forbidden under SIP [^15]. Other applications, like earlier versions of Homebrew, will fail to install becuase the installer would try to write to directories that were protected under SIP. The current versions of both applications are modified so they can be installed without disabling SIP.

It is not possible to write a script to disable SIP; instead, you will need to boot to Recovery Mode to do so [^15]. 

## Legal
```
MIT License

Copyright (c) 2017 Tianyu Ge

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
* A copy of the MIT License can be found at the root folder (named `LICENSE`), and you can also find it [online](https://opensource.org/licenses/MIT). 
* All product names and trademarks are property of their respective owners. 

## Tested configuration
* macOS Sierra Version 10.12.2 (16C67), Terminal Version 2.7.1 (388)
* macOS Sierra Version 10.12.2 (16C67), iTerm2 Build 3.0.13

[^1]: [https://pythonhosted.org/Markdown/index.html](https://pythonhosted.org/Markdown/index.html)

[^2]: Other options are currently being explored, which would make things easier. If they work.

[^3]: Terminal.app is located in `/Applications/Utilities/Terminal.app`.

[^4]: They are actually folders.

[^5]: Also actually folders. Technically 'directories', to be pedantic.

[^6]: [http://www.apple.com/legal/sla/](http://www.apple.com/legal/sla/)

[^7]: For more information regarding Gatekeeper, refer to Apple's [Help Topic #202491](https://support.apple.com/en-us/HT202491).

[^8]: _Loc. cit._

[^9]: _Loc. cit._

[^10]: [http://arstechnica.com/apple/2016/03/psa-updated-apple-certificate-means-old-os-x-installers-dont-work-anymore/](http://arstechnica.com/apple/2016/03/psa-updated-apple-certificate-means-old-os-x-installers-dont-work-anymore/)

[^11]: [http://osxdaily.com/2015/01/19/fix-os-x-install-errors-cant-be-verified-error-occurred-preparing-mac/](http://osxdaily.com/2015/01/19/fix-os-x-install-errors-cant-be-verified-error-occurred-preparing-mac/)

[^12]: My dad got me a computer tutoring software soon after I first used a laptop. The software featured a section, paraphrased 'DO NOT DO THIS IF YOU ARE A NEWBIE', prominently. I immediately disregarded the advise and used `FORMAT C:\` in `COMMAND.COM`. Hilarity ensues. Thanks for showing me what I shan't do, people who made that software. /s

[^13]: For more information on `createinstallmedia`, please refer to Apple's [Help Topic #201372](https://support.apple.com/en-us/HT201372).

[^14]: It appears that Rogue Amoeba is not actively maintaining Soundflower; it offers a commercial application called Loopback which has similar functionalities. For a version of Soundflower that can be used in OS X 10.11 and above, refer to this page: [https://www.fluxforge.com/blog/soundflower-os-x-10.11-10.12-macOS-sierra/](https://www.fluxforge.com/blog/soundflower-os-x-10.11-10.12-macOS-sierra/)

[^15]: For technical details of SIP, refer to Apple's [Help Topic #204899](https://support.apple.com/en-us/HT204899); to learn how to enable and disable SIP, refer to [this developer document](https://developer.apple.com/library/content/documentation/Security/Conceptual/System_Integrity_Protection_Guide/ConfiguringSystemIntegrityProtection/ConfiguringSystemIntegrityProtection.html).