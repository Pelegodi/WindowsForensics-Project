#!/bin/bash
#Welcome to my Project
#student's name: Peleg odi
#student code:S24 
#Class code:7736
#lecturer's name:Natali erez

clear
figlet -t -c "Welcome to my script" |lolcat -a -d 3
sleep 1
 function start () #This function is implemented to commence and ascertain the identity of the script user
{
	
	sleep 1
	echo "What should I call you?"
	read name
	sleep 1
	echo "Hello $name,I hope everything is going fine for you "
	sleep 2
	echo "Lets get to work"
	sleep 1
}
start

#sudo apt update  > /dev/null 2>&1
function chck () #This function checks for app installations and takes care of installing them if they are missing.
{
	echo "[#]Verifying the presence of all required tools"
	sleep 2
	echo "[#]It shouldn't take too long"
	sleep 3
	apps="foremost binwalk strings bulk_extractor "
	for app in $apps
	do
		if command -v $app &> /dev/null
		then
			echo "$app is already installed."
			sleep 2
		else
			# Install the program
			echo "$app is not installed. Installing..."
			sleep 2
			sudo apt-get install $app &> /dev/null
		fi
	done
	
}
chck
	sleep 3

function imf () #This function is created to seek user input on the scanning parameters they wish to define
{
	read -p "Please enter a memory file or an image file:" File  #Double-check your location to be within the file's directory .
	location=$(pwd)
	rm -rf info-* > /dev/null 2>&1
    mkdir info-$File
    cd "info-$File"
    names="BinwalkAnalysis StringsAnalsis ForemostAnalysis BulkAnalysis Volatility "
    mkdir $names
    cd $location
}
imf

function str() #this function Utilize strings for extracting human-readable text from the specified file.
{ 
	echo "[+] Extracting Strings from the file ...."
	strings $File > $location/info-$File/StringsAnalsis/stringsfile
}
function bwalk() # this function Utilize binwalk for extracting hidden content within the placed file.
{   
	echo "[+] Extracting Binwalk data ...."
	binwalk  $File > $location/info-$File/BinwalkAnalysis/binwalkfile
} 


function form() # this function Utilize foremost for parsing and extracting data from the file.
{ 
	echo "[+] Extracting Foremost data ...."
	rm -rf foremost
	foremost -i $File -t all -o $location/info-$File/ForemostAnalysis/foremost > /dev/null 2>&1

}



function vot() #Using volatility to extract data from the file we placed. make sure that you have the volatility tool in the directory before execute. 
{
	function VOLDOWN ()
	{
		rm -rf volatility_2.6_lin64_standalone*  > /dev/null 2>&1 
		rm vol.py  > /dev/null 2>&1   
		wget http://downloads.volatilityfoundation.org/releases/2.6/volatility_2.6_lin64_standalone.zip > /dev/null 2>&1
		unzip volatility_2.6_lin64_standalone.zip > /dev/null 2>&1 && cd volatility_2.6_lin64_standalone  # 
		mv volatility_2.6_lin64_standalone vol.py   
		cp vol.py $location
		cd $location   
		rm -rf volatility_2.6_lin64_standalone*   
	}	
	VOLDOWN
	echo "[+] Extracting volatility data ...."
	cd 	$location
	echo "$(./vol.py -f $File imageinfo 2>&1)"   > $location/info-$File/Volatility/profile-volsss
	OS=$(./vol.py -f $File imageinfo 2>&1 |grep -i "Suggested Profile"|awk -F: '{print $2}'|awk '{print $1}'|sed 's/,//g') #Reveals the OS associated with the file.
	
	VOLDATA="pslist pstree userassist sockets" #Exhibits the Volatility commands to be utilized.
	for i in $VOLDATA
	do
		cd  $location
		echo "[+] Extracting $i data ...."
		echo $(./vol.py -f $File --profile=$OS $i 2>&1) > $location/info-$File/Volatility/vol-$i  
	done
}
	sleep 2
function bulk() #Employ bulk_extractor to analyze and extract information from the file.
{
    echo "[+] Extracting Bulk extractor data ...."
	bulk_extractor $File -o $location/info-$File/BulkAnalysis/bulk > /dev/null 2>&1
}


	sleep 4
function result()#This function is designed to display the script's outcomes and save them in a file.
{   
    cd info-$File
    echo
    echo "Prosesing"
    sleep 2
    echo
	echo "[*] All the information extrcted to a new directory called: info-$File"
	sleep 2
	echo "[*] The total count of text files is $(find . -type f -name '*.txt'|wc -l)"
	sleep 2
	echo "[*] The total count of executable files is $(find . -type f -name '*.exe'|wc -l)"
	sleep 2
	echo "[*] The total count of PNG files is $(find . -type f -name '*.png'|wc -l)"
	sleep 2
	echo "[*] The total count of PCAP files is $(find . -type f -name '*.pcap'|wc -l)"
	sleep 2 
	echo "[*] The total count of DOC files is $(find . -type f -name '*.doc'|wc -l)"
	sleep 2
	echo "[*] The total count of ZIP files is $(find . -type f -name '*.zip'|wc -l)"
	sleep 2
	echo "[*] The total count of jpeg files is $(find . -type f -name '*.jpeg'|wc -l)"
	sleep 3
	echo "Uncover it by yourself"
	sleep 2
}


	sleep 2
function get_user_choice() #The script user has the option to select in lowercase, thanks to this function
{
    echo "Select M(memory file) I(image file):"
    read -r choice

    # Convert the input to lowercase for case-insensitive comparison M-m I-i
    choice_lower=$(echo "$choice" | tr '[:upper:]' '[:lower:]')

    if [[ "$choice_lower" == "i" ]]; 
    then
        echo "$File is a image file"
		echo "Extracting data Launches..... "
		echo "Its may take a few minuts...."
		sleep 3
    elif [[ "$choice_lower" == "m" ]]; 
    then
        
		echo "$File is a memory file"
		echo "Launching data extraction.... "
		echo
		echo "........................................."
    else
        echo "Invalid choice. Please enter 'I' for image file or 'M' for memory file."
    fi
}
function End() #This function marks the endpoint of the script's execution

{
	figlet -t -c "Thank you for using my script" |lolcat -a -d 3
}




get_user_choice 
bulk
bwalk
form
str
vot
result
End

#The titles listed above depict the sequential flow for the script to function flawlessly


