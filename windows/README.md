# biträde for Windows

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

In order to execute the script, double-click on `bitraede.bat`. User Access Control (UAC) will then show up and ask you for the admin user name and password. Once the correct credential is confirmed, another command line window will show up and the script will then start [^2].

## File structure for Windows biträde
```
bitraede	<-- Referred to as 'root folder' in this README
|---windows
    |   bitraede.bat
    |   ps.ps1
    |   README.html
    |   README.md
    |---exe
        |   (exe installers OR empty)
        |   ...
    |---maxpackages
        |   (Max 7 packages OR empty)
        |   ...
    |---msi
        |   (msi installers OR empty)
        |   ...
    |---OPTIONS
        |   CHECK_UPDATE
    |---scripts
        |   (PowerShell scripts OR empty)
        |   ...
    |---system
        |   (CHECK_UPDATE OR empty)
        |   .
    |---vst
        |   (VST files for Max 7 OR empty)
        |	 ...
```

## Logs
Logs can be viewed using Event Viewer.

To review biträde Event Logs, press the Windows key on keyboard and start typing 'Event Viewer', or press [Win]+R, type in `eventvwr.msc` and press Enter.

You can locate biträde Event Logs from 'Event Viewer (Local) - Applications and Services Logs - bitraede Events'.

## FAQ
### Q1: 

## Notes on scripting
* Do not use scripting unless you fully understand what you are doing [^13].
* If an command requires elevated permission, use `sudo` in front of the line that really needs it. Avoid using `su`. 
* Test the script before deploying to production.
* Scripts must use `.sh` or `.command` file extensions. UTI is not checked.
* In addition, scripts must be executable. biträde will not try to change file mode bits.
* If your script requires reboot: Copy the file named `REBOOT_REQUIRED` from the `OPTIONS` folder to `scripts` folder. Bear in mind that if `.pkg` files are installed, biträde will attempt to reboot at the end anyways. The reboot will not occur immediately if system update/upgrade is requested; otherwise the script will attempt to reboot after all scripts were executed regardless of the outcome of the scripts.

## Notes on upgrading
There is no guarantee that the method I use here will be the same for future macOS versions. `startosinstall` was first spotted in OS X 10.10 installer and was since included in all OS X/macOS installers. There is an undocumented flag, `--nointeraction`, which I decided not to use, as it's not documented and there is no guarantee it won't be removed in future releases. 

It is always possible to use the `createinstallmedia` tool, which is also included in recent OS X installers (10.9 and newer). This is a well-documented tool for creating OS X/macOS installing media (flash drive, for example) [^14]. 

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

[^2]: The fact is, `bitraede.bat` is merely a batch script to kickstart the actual PowerShell script. Due to the default Local Security policies, PowerShell scripts cannot be executed without being signed. This introduced two problems: first, a trusted certificate must be obtained, and second, after the PowerShell script is signed with a certificate, it will not be easily editable. 