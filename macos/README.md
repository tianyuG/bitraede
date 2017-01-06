# biträde for macOS

Please read through this file carefully before using biträde ('this script', 'the script'), as elevated permission can cause harm if not used properly. This script was a _bona fide_ attempt to streamline maintaining DISIS computers.

## Convention of this document
This document mostly follows the Python Flavoured Markdown convention [^1]. Two important syntaxes are inline code and code blocks. 

* Inline code is fenced by one backtick, like `this`.
* Code block is fenced by three backticks, for example:

    ```shell
echo hello world!
```

    (`shell` being an optional language tag. It tells Markdown how to do syntax highlighting, however it won't be shown if the document is rendered.)
    
If you are looking at the html file, you won't see the backticks mentioned above.

## Usage
This script does not come with the execution permission enabled by default. Therefore, if you double click it, you should only see a terminal window flashing and nothing would be done to the system [^2]. To flip the execution triads, open Terminal by [^3]:

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

Press return to flip the execution triads. If this script is saved on a removable device and this removable device is used amongst different Macs, you will only need to do it once.

Once proper execution permission is set, double click `bitrade.command` to execute this script.

**`bitraede.command` shall not be executed with elevated permission. That is to say, do not `sudo`-open this script. When elevated permission is required, you will be asked to authenticate once during the lifetime of this script.**

## File structure for macOS biträde
```
bitraede
|---macos
    |   bitraede.command
    |   README.html
    |   README.md
    |---pacakges
        |   (.pkg files OR empty)
        |   ...
    |---vst2
        |   (VST2 plugins OR empty)
        |   ...
    |---vst3
        |   (VST3 plugins OR empty)
        |   ...
    |---audiounit
        |   (AU plugins OR empty)
        |   ...
    |---maxplugins
        |   (Max 7 plugins OR empty)
        |   ...
    |---applications
        |   (.app files OR empty)
        |   ...
    |---system
        |   (macOS installer, an .app file)
        |   (OR a file named CHECK_UPDATE)
        |   (OR empty)
    |---scripts
        |   (custom script files OR empty)
        |   ...
```

Please leave files/folders in respective folders.

For files/folders in `vst2`, `vst3` and `audiounit` folders, they will be copied to respective folders in `/Library`. As such, elevated permission is required.

For files/folders in `maxplugins`, they will be copied to Max's plugin folder in `/Users/Shared/Max 7/`. No special permission is required.

For `.pkg` files [^4] in `packages`, they will be executed sequencially. Elevated permission is required.

For `.app` files [^4] in `applications`, they will be copied to `/Applications`. Elevated permission is required. If the `.app` file happens to be custom installers (usually the installers have the `.pkg` extension), do not leave them in this folder. Instead, please write a shell script for them.

A special case for the `.app` installers is macOS installation file. For macOS installer, please leave it in the `system` folder. If a macOS installer file is found, this script will attempt to upgrade OS X/macOS currently installed on the target computer to the version contained in the installer. Elevated permission is required.

If there is a file named `CHECK_UPDATE` in `system`, this script will attempt to update the current system. The major system version will remain the same (for example, if the target Mac has OS X 10.11.1, it will update to 10.11.6 instead of the latest stable version of macOS). It will also attempt to update certain included Apple software (for example, Digital Camera RAW Compatibility Update). This option will be ignored if a macOS installer file is found in `system`; otherwise, if `CHECK_UPDATE` is present, elevated permission is required.

You can also leave shell scripts in the `scripts` folder. As mentioned before, `bitraede.command` shall not be executed with elevated permission; you should elevate permission only for commands that really need it in the shell script (by using `sudo`, for example). Shell scripts should use `.sh` or `.command` file extension and they should be executable.

**Please exercise extreme caution with the elevated permission; it is imperative that you test the custom scripts before deploying them to production. With great power comes great responsibility.**

If elevated permission is required, you will be asked to authenticate with an account that has `sudo` access. You will only be asked to authenticate once during the entire lifetime of this script.

## FAQ
### Q1: Application 'can't be opened because it is from an unidentified developer'?
A1: This is because the application is not signed with a valid developer ID and Gatekeeper prevented it from running [^5]. If you indeed trust the app, you can exempt it from Gatekeeper. To do so, right click (or left click whilst holding option key) on the app icon in 'Applications' folder and choose 'Open'. When asked 'Are you sure you want to open it', click 'Open'. Optionaly you can disable Gatekeeper, however this is not recommened for security reasons. See [^5] if you really want to do that.

### Q2: Application 'is damaged and can't be opened. You should move it to the Trash'?
A2: In most cases it means the application itself is damaged and Gatekeeper prevented it from running [^5]. Most of the time is it best to follow the suggestion and move the application to Trash. Occasionally it is caused by execution triad for the application not set correctly. If you trust the publisher and the application, you can try to open Terminal, type `chmod +x␣` (`␣` being a whitespace), open Finder, go to 'Applications' folder and locate the application, right click (or left click whilst holding option key) on the app, click 'Show Package Contents', navigate to Contents > MacOS, drag the binary file (usually nemed the same as the application and has an icon resembles Terminal) to the Terminal window and press return. Then, close the Finder window and try open the application.

### Q3: How is the codesigning policy enforced?
A3: In short, only the signature for macOS upgrade (`.app`) is verified. Signautures for `.pkg` files and other `.app` files are not checked. It is, therefore, up to the sysadmin to make sure the applications/packages are legit. 

### Q4: macOS cannot be upgraded?
A4: Many possible reasons, not limited to the following:

* The macOS version in the installer is older than the one already installed.
* The code signature of the installer is not valid.
	* This usually indicates the installer is corrupt.
	* This only apply to OS X installers downloaded before 2016-02-14: Apple's updated certificate rendered them invalid [^6]. It is possible to circumvent the check by modifying system time [^7], however it is recommended to download a new one from Mac App Store.

### Q5: What is the opearating sequence?
`maxpackages` 

-> `vst2` 

-> `vst3` 

-> `audiounit` 

-> `applications` 

-> `packages` 

-> `scripts` 

-> `system` (upgrade or update).

All operations are optional.

[^1]: [https://pythonhosted.org/Markdown/index.html](https://pythonhosted.org/Markdown/index.html)
[^2]: Other options are currently being explored, which would make things easier. If they work.
[^3]: Terminal.app is located in `/Applications/Utilities/Terminal.app`.
[^4]: They are actually folders... Technically 'directories', to be pedantic.
[^5]: [https://support.apple.com/en-us/HT202491](https://support.apple.com/en-us/HT202491)
[^6]: [http://arstechnica.com/apple/2016/03/psa-updated-apple-certificate-means-old-os-x-installers-dont-work-anymore/](http://arstechnica.com/apple/2016/03/psa-updated-apple-certificate-means-old-os-x-installers-dont-work-anymore/)
[^7]: [http://osxdaily.com/2015/01/19/fix-os-x-install-errors-cant-be-verified-error-occurred-preparing-mac/](http://osxdaily.com/2015/01/19/fix-os-x-install-errors-cant-be-verified-error-occurred-preparing-mac/)
