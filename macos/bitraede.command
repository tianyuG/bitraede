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

# Clean up folder by removing files like .DS_Store
cd $(dirname "$0")
dot_clean .

# Attempt to copy VST2 plugins
# Check if source folder exists
if [ -d "./vst2" ] ; then
	# Check if source folder is empty
	if [ "$(ls ./vst2)" ] ; then
		# Check is destination folder exists
		if [ -d "/Library/Audio/Plug-Ins/VST" ] ; then
			sudo cp -a ./vst2/ /Library/Audio/Plug-Ins/VST
			if [ $? -ne 0 ] ; then
				printf "%s: [vst2] 😰  Failed to copy VST2 plugins.\n" "$(date +%T)"
			else 
				printf "%s: [vst2] 👏  Copied VST2 plugins to Library.\n" "$(date +%T)"
			fi
		else 
			printf "%s: [vst2] 😱  Could not find the folder for VST2 plugins in Library.\n" "$(date +%T)"
		fi
	else
		printf "%s: [vst2] 🤷  \`vst2\` folder is empty. Skipping...\n" "$(date +%T)"
	fi
else
	printf "%s: [vst2] 🤷‍️  \`vst2\` folder does not exist. Skipping...\n" "$(date +%T)"
fi

# Attempt to copy VST3 plugins
# Check if source folder exists
if [ -d "./vst3" ] ; then
	# Check if source folder is empty
	if [ "$(ls ./vst3)" ] ; then
		# Check is destination folder exists
		if [ -d "/Library/Audio/Plug-Ins/VST3" ] ; then
			sudo cp -a ./vst3/ /Library/Audio/Plug-Ins/VST3
			if [ $? -ne 0 ] ; then
				printf "%s: [vst3] 😰  Failed to copy VST3 plugins.\n" "$(date +%T)"
			else 
				printf "%s: [vst3] 👏  Copied VST3 plugins to Library.\n" "$(date +%T)"
			fi
		else 
			printf "%s: [vst3] 😱  Could not find the folder for VST3 plugins in Library.\n" "$(date +%T)"
		fi
	else
		printf "%s: [vst3] 🤷  \`vst3\` folder is empty. Skipping...\n" "$(date +%T)"
	fi
else
	printf "%s: [vst3] 🤷‍  \`vst3\` folder does not exist. Skipping...\n" "$(date +%T)"
fi

# Attempt to copy Audio Units plugins
# Check if source folder exists
if [ -d "./audiounits" ] ; then
	# Check if source folder is empty
	if [ "$(ls ./audiounits)" ] ; then
		# Check is destination folder exists
		if [ -d "/Library/Audio/Plug-Ins/Components" ] ; then
			sudo cp -a ./audiounits/ /Library/Audio/Plug-Ins/Components
			if [ $? -ne 0 ] ; then
				printf "%s: [audiounits] 😰  Failed to copy Audio Units plugins.\n" "$(date +%T)"
			else 
				printf "%s: [audiounits] 👏  Copied Audio Units plugins to Library.\n" "$(date +%T)"
			fi
		else 
			printf "%s: [audiounits] 😱  Could not find folder for Audio Units plugins in Library.\n" "$(date +%T)"
		fi
	else
		printf "%s: [audiounits] 🤷  \`audiounits\` folder is empty. Skipping...\n" "$(date +%T)"
	fi
else
	printf "%s: [audiounits] 🤷  \`audiounits\` folder does not exist. Skipping...\n" "$(date +%T)"
fi

# Attempt to copy Applications
# Check if source folder exists
if [ -d "./applications" ] ; then
	# Check if source folder is empty
	if [ "$(ls -1 ./applications/*.app 2> /dev/null | wc -l)" -ne 0 ] ; then
		# Check is destination folder exists
		if [ -d "/Applications" ] ; then
			## TODO: Fileops
			echo "TODO"
		else
			printf "%s: [applications] 😱  Could not find Applications folder.\n" "$(date +%T)"
		fi
	else
		printf "%s: [applications] 🤷  \`applications\` folder is empty. Skipping...\n" "$(date +%T)"
	fi
else 
	printf "%s: [applications] 🤷  \`applications\` folder does not exist. Skipping...\n" "$(date +%T)"
fi

## TODO: `packages`

# Attempt to copy Max 7 Packages
# Check if source folder exists
if [ -d "./maxplugins" ] ; then
	# Check if source folder is empty
	if [ "$(ls ./maxplugins)" ] ; then
		# Check if destination folder exists
		if [ -d "/Users/Shared/Max 7/Packages" ] ; then 
			cp -a ./maxplugins/ /Users/Shared/Max\ 7/Packages
			# In case it failed to copy... Try with sudo
			if [ $? -ne 0 ] ; then
				sudo cp -a ./maxplugins /Users/Shared/Max\ 7/Packages
				if [ $? -ne 0 ] ; then
					printf "%s: [maxplugins] 😰  Failed to copy Max 7 plugins.\n" "$(date +%T)"
				else
					printf "%s: [maxplugins] 👏  Copied Max 7 plugins to shared Max plugins folder.\n" "$(date +%T)"
				fi
			else
				printf "%s: [maxplugins] 👏  Copied Max 7 plugins to shared Max plugins folder.\n" "$(date +%T)"
			fi
		else
			printf "%s: [maxplugins] 🤔  Could not find shared Max 7 plugins folder on this Mac. Is Max 7 installed?\n" "$(date +%T)"
		fi
	else
		printf "%s: [maxplugins] 🤷  \`maxplugins\` folder is empty. Skipping...\n" "$(date +%T)"
	fi
else 
	printf "%s: [maxplugins] 🤷  \`maxplugins\` folder does not exist. Skipping...\n" "$(date +%T)"
fi

## TODO: `scripts`, `system`

$SHELL