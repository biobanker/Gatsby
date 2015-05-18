#cs ----------------------------------------------------------------------------

 AutoIt Version: 1.0
 Author:         Annie �sberg, Jesper Lind

 Script Function:Select

	Run LIMS as a robot
	  N.B. Require Full windoW,

#ce ----------------------------------------------------------------------------

#include <Functions.au3>
#include <Configuration.au3>
#include <TestSchemes.au3>

; =================================================
; Main
; =================================================


; Start LIMS
; Dev
;mouseClickFcn("Citrix XenApp", 1075, 375, 1)

; Test
mouseClickFcn("Citrix XenApp", 1400, 375, 1)


For $curUserIndex = 0 to $nrOfGroups
   ConsoleWrite("---------------" & @CRLF & $curUserIndex & @CRLF)
   ConsoleWrite("---------------" & @CRLF & $userConfigArray[$curUserIndex][0] & @CRLF)

   logEvent("*****************************************", @ScriptDir & "\Example.log")
   logEvent("Current user: " & "---------------" & $userConfigArray[$curUserIndex][0] & @CRLF, @ScriptDir & "\Example.log")
   logEvent("*****************************************", @ScriptDir & "\Example.log")


; Log in
   loginLIMS($userConfigArray, $curUserIndex)
   Sleep(10000)  	;TODO: Fix thism


   ; Open Function
   ConsoleWrite("---------------" & @CRLF & "Opening function" & @CRLF)



   For $curFunction = 0 To $nrOfFunctions

	  ; =================================================
	  ;To be fetched from database
	  $curUserFunctionID = "Log sample" ;
	  $nrOfFields = $userConfigArray[$curUserIndex][2]
	  ; =================================================
	  $curTestIndex = 0
	  ;$curLabelID = "VAL_" & _Now()
	  ConsoleWrite("---------------" & @CRLF & "Number of fields: " & $nrOfFields & @CRLF)

	  ConsoleWrite("---------------" & @CRLF & "Item: " & $curFunction & "|" & $workFlowPositions[$curFunction][0] & "|" &  $workFlowPositions[$curFunction][1] & @CRLF)
	  mouseClickFcn($curEnvironment, $workFlowPositions[$curFunction][0], $workFlowPositions[$curFunction][1], 1)

	  WinWaitActive($curUserFunctionID)
	  For $curFieldIndex = 0 To $nrOfFields - 1

		 ; Get current configuration values
		 local	$curfieldType = $groupConfigArray[$curUserIndex][$curFieldIndex][0]
		 local	$curProposedInit  = $groupConfigArray[$curUserIndex][$curFieldIndex][1]
		 local	$curProposedValue  = $groupConfigArray[$curUserIndex][$curFieldIndex][2]
		 local	$curTestValue  = $groupConfigArray[$curUserIndex][$curFieldIndex][3]
		 local	$curExpectedOutcome  = $groupConfigArray[$curUserIndex][$curFieldIndex][4]
		 local	$curFieldText  = $groupConfigArray[$curUserIndex][$curFieldIndex][5]
		 local	$curSleepValue = $groupConfigArray[$curUserIndex][$curFieldIndex][6]
		 local	$curTestType = $groupConfigArray[$curUserIndex][$curFieldIndex][7]


		 ;ConsoleWrite("++++++++++++++++++++++++++++++ Working with field: " & $curFieldText )
		 ; Perform action on current field

		 IF $curTestType == 'Standard' Then
			checkSingleField($curfieldType, $curProposedInit, $curProposedValue, $curTestValue, $curExpectedOutcome, $curFieldText, $curSleepValue, $curTestType)
		 ELSE
			testField($curfieldType, $curProposedInit, $curProposedValue, $curTestValue, $curExpectedOutcome, $curFieldText, $curSleepValue, $curTestType)
		 ENDIF
	  Next

	  ; Close user dialog
	  closeUserDialog()
	  ;Send("!o")

	  ; Handle exception for log sample dialog, end sample log and handle sample grid window
	  ;If $curUserFunctionID == "Log sample" Then
	  ;  handleSampleGridWindow()
	  ;EndIf


   Next
   logEvent("Test finished", @ScriptDir & "\Example.log")
   logEvent("*****************************************", @ScriptDir & "\Example.log")

   logoutLIMS()

Next




