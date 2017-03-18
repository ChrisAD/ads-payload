# ads-payload
Powershell script which will take any payload and put it in the a bat script which delivers the payload. The payload is delivered using environment variables, alternating-data-streams and wmic. This was specifically made to evade Palo Alto Traps endpoint protection, which has now been patched through responsible disclosure. 

To run it, simply ./create-payload.ps1 <input file.exe> 

When the BAT file gets executed it will do the following: 
- Populate environment variables with the base64 encoded executable 
- Reads the environment into an a text file on the system
- Uses Windows built-in tool certutil to decode the file into executable
- Forwards the file into an ADS of desktop.ini
- Executes the file using wmic

The executable will be chopped into smaller parts and then put into environment variables. This was a workaround to make it store arbitrary sizes of executables. 


#TODOS
* Add a small Test-Path to make sure the desktop.ini file exists. 
* Make it not touch the filesystem any more than necessary. Certutil directly into ADS? 
