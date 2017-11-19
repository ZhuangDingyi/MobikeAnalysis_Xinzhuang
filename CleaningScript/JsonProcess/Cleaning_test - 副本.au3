

   #cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
#include <myReplaceStringInFile.au3>
; Strip leading and trailing whitespace as well as the double spaces (or more) in between the words.

myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"HTTP.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"Connection:.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"Date:.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"Content-Type:.*",",",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"Content-Length:.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"Connection:.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"Server:.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"X-Application-Context:.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"POST.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"Host:.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"Accept-Encoding:.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"platform:.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"mobileNo:.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"eption:.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"time:.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"lang:.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"uuid:.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"version:.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"citycode:.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"accesstoken:.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"os:.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"version=.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,".*userid.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,".*:200.*"," ",0)
myReplaceStringInFile(@WorkingDir,"2017.*?\.json",0,"Transfer-Encoding:.*"," ",0)
MsgBox($MB_OK,"Mobike_Cleaning","Finished")

