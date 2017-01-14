#!/bin/sh

# bitraede for macOS
# Tianyu Ge

# BEGINS

# Display GPL disclaimer
printf "\nbitraede - DISIS Maintenance Script Set\n\nMIT License\n\nCopyright (c) 2017 Tianyu Ge\n\nPermission is hereby granted, free of charge, to any person obtaining a copy\nof this software and associated documentation files (the "Software"), to deal\nin the Software without restriction, including without limitation the rights\nto use, copy, modify, merge, publish, distribute, sublicense, and/or sell\ncopies of the Software, and to permit persons to whom the Software is\nfurnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all\ncopies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\nIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\nFITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\nAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\nLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\nOUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\nSOFTWARE.\n\n"

# Checks if the script is executed with elevated permission
# If so, refuse to continue
if [ "$EUID" -eq 0 ] ; then
	printf "\e[1mYou are either running bitraede using an account with root privilege or with utilities like \`sudo\`.\e[0m\n\nThis could be dangerous.\n\nbitraede will now quit and please run this script again with normal privilege. For more information, please refer to the README file.\n"
	exit
fi

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR=$HOME/Library/Logs
LOG_DATE=$(date +%Y-%m-%d-%H-%M)
LOG_FILE=$LOG_DIR/bitraede-$LOG_DATE.log
ALLOW_UNTRUSTED=0
CHECK_UPDATE=0
NO_REBOOT=0
PKG_INSTALLED=0
REBOOT_REQUIRED=0

cd $CURRENT_DIR

# Gain sudo access
sudo printf "%s [preprocessing] 🙌  Elevate privileges acquired.\n" "$(date +%T)" | tee -a $LOG_FILE 
if [ $? -ne 0 ] ; then
	printf "%s [preprocessing] 😰  Elevated privileges not acquired.\n\n%s [bitraede] 👋  All done!\n" "$(date +%T)" "$(date +%T)" | tee -a $LOG_FILE 
	exit
else
	printf "%s [preprocessing] 💡  Main log can be located at %s\n" "$(date +%T)" ${LOG_FILE} | tee -a $LOG_FILE 
fi

if [ -s "${CURRENT_DIR}/packages/ALLOW_UNTRUSTED" ] ; then
	ALLOW_UNTRUSTED=1
	printf "%s [preprocessing-ALLOW_UNTRUSTED] 👉  bitraede will allow installing unsigned \'.pkg\' files.\n" "$(date +%T)" | tee -a $LOG_FILE 
fi
if [ -s "${CURRENT_DIR}/system/CHECK_UPDATE" ] ; then
	if [ -s "${CURRENT_DIR}/system/*.app" ] ; then
		printf "%s [preprocessing-CHECK_UPDATE] ✋  bitraede found .app file(s) in \'system\' folder. No operating system update will be scheduled.\n" "$(date +%T)" | tee -a $LOG_FILE 
	else
		CHECK_UPDATE=1
		printf "%s [preprocessing-CHECK_UPDATE] 👉  bitraede will schedule an operating system update after its job is finished.\n" "$(date +%T)" | tee -a $LOG_FILE 
	fi
fi
if [ -s "${CURRENT_DIR}/packages/NO_REBOOT" ] ; then
	if [ -s "${CURRENT_DIR}/scripts/REBOOT_REQUIRED" ] ; then
		printf "%s [preprocessing-NO_REBOOT] ✋  bitraede found REBOOT_REQUIRED in \'scripts\' folder. Reboot will still be scheduled.\n" "$(date +%T)" | tee -a $LOG_FILE 
	else
		NO_REBOOT=1
		printf "%s [preprocessing-NO_REBOOT] 👉  bitraede will not reboot even if packages are installed.\n" "$(date +%T)" | tee -a $LOG_FILE 
	fi
fi
if [ -s "${CURRENT_DIR}/scripts/REBOOT_REQUIRED" ] ; then
	REBOOT_REQUIRED=1
	printf "%s [preprocessing-REBOOT_REQUIRED] 👉  bitraede will schedule a reboot after its job is finished.\n" "$(date +%T)" | tee -a $LOG_FILE 
fi

# Clean up folder by removing files like .DS_Store
dot_clean . 2> /dev/null

# Attempt to copy VST2 plugins
# Check if source folder exists
if [ -d "${CURRENT_DIR}/vst2" ] ; then
	# Check if source folder is empty
	if [ "$(ls ${CURRENT_DIR}/vst2)" ] ; then
		# Check is destination folder exists
		if [ -d "/Library/Audio/Plug-Ins/VST" ] ; then
			sudo cp -a ${CURRENT_DIR}/vst2/ /Library/Audio/Plug-Ins/VST
			if [ $? -ne 0 ] ; then
				printf "%s [vst2] 😰  Failed to copy VST2 plugins.\n" "$(date +%T)" | tee -a $LOG_FILE 
			else 
				printf "%s [vst2] 👏  Copied all given VST2 plugins to Library.\n" "$(date +%T)" | tee -a $LOG_FILE 
			fi
		else 
			printf "%s [vst2] 😱  Could not find the folder for VST2 plugins in Library.\n" "$(date +%T)" | tee -a $LOG_FILE 
		fi
	else
		printf "%s [vst2] 🤷  \'vst2\' folder is empty. Skipping...\n" "$(date +%T)" | tee -a $LOG_FILE 
	fi
else
	printf "%s [vst2] 🤷‍️  \'vst2\' folder does not exist. Skipping...\n" "$(date +%T)" | tee -a $LOG_FILE 
fi

# Attempt to copy VST3 plugins
# Check if source folder exists
if [ -d "${CURRENT_DIR}/vst3" ] ; then
	# Check if source folder is empty
	if [ "$(ls ${CURRENT_DIR}/vst3)" ] ; then
		# Check is destination folder exists
		if [ -d "/Library/Audio/Plug-Ins/VST3" ] ; then
			sudo cp -a ${CURRENT_DIR}/vst3/ /Library/Audio/Plug-Ins/VST3
			if [ $? -ne 0 ] ; then
				printf "%s [vst3] 😰  Failed to copy VST3 plugins.\n" "$(date +%T)" | tee -a $LOG_FILE 
			else 
				printf "%s [vst3] 👏  Copied all given VST3 plugins to Library.\n" "$(date +%T)" | tee -a $LOG_FILE 
			fi
		else 
			printf "%s [vst3] 😱  Could not find the folder for VST3 plugins in Library.\n" "$(date +%T)" | tee -a $LOG_FILE 
		fi
	else
		printf "%s [vst3] 🤷  \'vst3\' folder is empty. Skipping...\n" "$(date +%T)" | tee -a $LOG_FILE 
	fi
else
	printf "%s [vst3] 🤷‍  \'vst3\' folder does not exist. Skipping...\n" "$(date +%T)" | tee -a $LOG_FILE 
fi

# Attempt to copy Audio Units plugins
# Check if source folder exists
if [ -d "${CURRENT_DIR}/audiounits" ] ; then
	# Check if source folder is empty
	if [ "$(ls ${CURRENT_DIR}/audiounits)" ] ; then
		# Check is destination folder exists
		if [ -d "/Library/Audio/Plug-Ins/Components" ] ; then
			sudo cp -a ${CURRENT_DIR}/audiounits/ /Library/Audio/Plug-Ins/Components
			if [ $? -ne 0 ] ; then
				printf "%s [audiounits] 😰  Failed to copy Audio Units plugins.\n" "$(date +%T)" | tee -a $LOG_FILE 
			else 
				printf "%s [audiounits] 👏  Copied all given Audio Units plugins to Library.\n" "$(date +%T)" | tee -a $LOG_FILE 
			fi
		else 
			printf "%s [audiounits] 😱  Could not find folder for Audio Units plugins in Library.\n" "$(date +%T)" | tee -a $LOG_FILE 
		fi
	else
		printf "%s [audiounits] 🤷  \'audiounits\' folder is empty. Skipping...\n" "$(date +%T)" | tee -a $LOG_FILE 
	fi
else
	printf "%s [audiounits] 🤷  \'audiounits\' folder does not exist. Skipping...\n" "$(date +%T)" | tee -a $LOG_FILE 
fi

# Attempt to copy Applications
# Check if source folder exists
if [ -d "${CURRENT_DIR}/applications" ] ; then
	# Check if source folder is empty
	if [ "$(ls -d1 ${CURRENT_DIR}/applications/*.app 2> /dev/null | wc -l)" -ne 0 ] ; then
		# Check is destination folder exists
		if [ -d "/Applications" ] ; then
			SRC_APP_DIR="$CURRENT_DIR/applications/*.app"
			# Iterate through the source directory to obtain 
			for APP in $SRC_APP_DIR ; do
				# Check if file is executable
				if [ -x "${APP}" ] ; then
					cp -R "${APP}" /Applications
					# Try sudo if failed
					if [ $? -ne 0 ] ; then 
						sudo cp -R "${APP}" /Applications
						if [ $? -ne 0 ] ; then
							printf "%s [applications] 😰  Failed to copy application \'%s\'.\n" "$(date +%T)" $(basename "$APP") | tee -a $LOG_FILE 
						else
							codesign --verify "${APP}" 2> /dev/null
							if [ $? -ne 0 ] ; then
								printf "%s [applications] 👌  Copied UNTRUSTED application \'%s\'.\n" "$(date +%T)" $(basename "$APP") | tee -a $LOG_FILE 
							else
								printf "%s [applications] 👏  Copied application \'%s\'.\n" "$(date +%T)" $(basename "$APP") | tee -a $LOG_FILE 
							fi
						fi
					else
						codesign --verify "${APP}" 2> /dev/null
						if [ $? -ne 0 ] ; then
							printf "%s [applications] 👌  Copied UNTRUSTED application \'%s\'.\n" "$(date +%T)" $(basename "$APP") | tee -a $LOG_FILE 
						else
							printf "%s [applications] 👏  Copied application \'%s\'.\n" "$(date +%T)" $(basename "$APP") | tee -a $LOG_FILE 
						fi
					fi
				else
					printf "%s [applications] 🤔  Did not copy application \'%s\' because of bad file permission. Is it executable?\n" "$(date +%T)" $(basename "$APP") | tee -a $LOG_FILE 
				fi
			done
		else
			printf "%s [applications] 😱  Could not find Applications folder.\n" "$(date +%T)" | tee -a $LOG_FILE 
		fi
	else
		printf "%s [applications] 🤷  \'applications\' folder is empty. Skipping...\n" "$(date +%T)" | tee -a $LOG_FILE 
	fi
else 
	printf "%s [applications] 🤷  \'applications\' folder does not exist. Skipping...\n" "$(date +%T)" | tee -a $LOG_FILE 
fi

## TODO: `packages`
# Attempt to install .pkg packages
# Check if source folder exists
if [ -d "${CURRENT_DIR}/packages" ] ; then
	# Check if source folder is empty
	if [ "$(ls -1 ${CURRENT_DIR}/packages/*.pkg 2> /dev/null | wc -l)" ] ; then
		SRC_PKG_DIR="$CURRENT_DIR/packages/*.pkg"
		for PKG in $SRC_PKG_DIR ; do
			# Check if file is executable
			if [ -x "${PKG}" ] ; then
				PKG_INSTALLED=1
				# Attempt to install a pkg file
				# Verify certificate of the pkg file
				codesign --verify "${PKG}" 2> /dev/null
				# If pkg is not properly signed
				if [ $? -ne 0 ] ; then
					# If ALLOW_UNTRUSTED was specified
					if [ $ALLOW_UNTRUSTED -ne 0 ] ; then
						# Attempt to install untrusted pkg
						sudo installer -allowUntrusted -dumplog -pkg "${PKG}" -target / >> "${LOG_DIR}/bitraede-${LOG_DATE}-$(basename ${PKG}).log" 2>&1
						# Check if installation is successful
						if [ $? -ne 0 ] ; then
							printf "%s [packages] 😰  Failed to install UNTRUSTED package \'%s\'. Log file can be located at %s\n" "$(date +%T)" $(basename "${PKG}") "${LOG_DIR}/bitraede-${LOG_DATE}-$(basename ${PKG}).log" | tee -a $LOG_FILE 
						else
							REBOOT_REQUIRED=1
							printf "%s [packages] 👌  Installed UNTRUSTED package \'%s\'. Log file can be located at %s\n" "$(date +%T)" $(basename "${PKG}") "${PKG}.log" | tee -a $LOG_FILE 
						fi
					# pkg is untrusted and ALLOW_UNTRUSTED is not specified
					else
						printf "%s [packages] 👿  UNTRUSTED package \'%s\' was not installed due to invalid code signature.\n" "$(date +%T)" $(basename "${PKG}") | tee -a $LOG_FILE 
					fi
				# If pkg is properly signed
				else
					# Attempt to install trusted pkg
					sudo installer -pkg "${PKG}" -target / 2> "${PKG}.log"
					# Check if pkg is successfully installed
					if [ $? -ne 0 ] ; then
						printf "%s [packages] 😰  Failed to install package \'%s\'.\n" "$(date +%T)" $(basename "${PKG}") | tee -a $LOG_FILE 
					else
						REBOOT_REQUIRED=1
						printf "%s [packages] 👏  Installed package \'%s\'.\n" "$(date +%T)" $(basename "${PKG}") | tee -a $LOG_FILE 
					fi
				fi
			else
				printf "%s [packages] 🤔  Skipped package \'%s\' because of bad file permission. Is it executable?\n" "$(date +%T)" $(basename "$PKG") | tee -a $LOG_FILE 
			fi
		done
	else
		printf "%s [packages] 🤷  \'packages\' folder is empty. Skipping...\n" "$(date +%T)" | tee -a $LOG_FILE 
	fi
else
	printf "%s [packages] 🤷  \'packages\' folder does not exist. Skipping...\n" "$(date +%T)" | tee -a $LOG_FILE 
fi

# Attempt to copy Max 7 plugins
# Check if source folder exists
if [ -d "${CURRENT_DIR}/maxpackages" ] ; then
	# Check if source folder is empty
	if [ "$(ls ${CURRENT_DIR}/maxpackages)" ] ; then
		# Check if destination folder exists
		if [ -d "/Users/Shared/Max 7/Packages" ] ; then 
			cp -a ${CURRENT_DIR}/maxpackages/ /Users/Shared/Max\ 7/Packages
			# In case it failed to copy... Try with sudo
			if [ $? -ne 0 ] ; then
				sudo cp -a ${CURRENT_DIR}/maxpackages /Users/Shared/Max\ 7/Packages
				if [ $? -ne 0 ] ; then
					printf "%s [maxpackages] 😰  Failed to copy Max 7 plugins.\n" "$(date +%T)" | tee -a $LOG_FILE 
				else
					printf "%s [maxpackages] 👏  Copied Max 7 plugins to shared Max plugins folder.\n" "$(date +%T)" | tee -a $LOG_FILE 
				fi
			else
				printf "%s [maxpackages] 👏  Copied Max 7 plugins to shared Max plugins folder.\n" "$(date +%T)" | tee -a $LOG_FILE 
			fi
		else
			printf "%s [maxpackages] 🤔  Could not find shared Max 7 plugins folder on this Mac. Is Max 7 installed?\n" "$(date +%T)" | tee -a $LOG_FILE 
		fi
	else
		printf "%s [maxpackages] 🤷  \'maxpackages\' folder is empty. Skipping...\n" "$(date +%T)" | tee -a $LOG_FILE 
	fi
else 
	printf "%s [maxpackages] 🤷  \'maxpackages\' folder does not exist. Skipping...\n" "$(date +%T)" | tee -a $LOG_FILE 
fi

## TODO: `scripts`, `system`

## TODO: Check is reboot is required

$SHELL