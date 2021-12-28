
function getBaseUrl()
		baseUrl ="https://hkd45fv9tj.execute-api.us-east-1.amazonaws.com/dev"
		return baseUrl
end function


function getSceneNode()
	nxt = m.top
	scene = nxt
	while nxt <> invalid
	  scene = nxt
	  nxt = scene.getParent()
	end while
	return scene
end function

function setScreenResolution()
		 resolutionObject =m.top.GetScene().currentDesignResolution
     m.screenWidth = resolutionObject.width
     m.screenHeight = resolutionObject.height
end function

function getServerObject()
		requestHandler = CreateObject("roSGNode","RequestHandlerr")
		return requestHandler
end function

function getServerObject1()
        requestHandler = CreateObject("roSGNode","RequestHandler")
        return requestHandler
end function

function startTaskNode(requestHandlerObject,objectParam)
		if objectParam.uri <> invalid and len(objectParam.uri) > 0 then
				requestHandlerObject.SetField("uri", objectParam.uri)
		end if
		if objectParam.requestType <> invalid then
		 	if objectParam.DoesExist("requestType")  then
				requestHandlerObject.SetField("requestType", objectParam.requestType)
			end if
		end if

		if objectParam.contentType <> invalid then
				if objectParam.DoesExist("contentType")  then
						requestHandlerObject.SetField("contentType", objectParam.contentType)
				end if
		end if

		if objectParam.Authorization <> invalid then
				if objectParam.DoesExist("Authorization")  then
						? "objectParam "objectParam.Authorization
						requestHandlerObject.SetField("Authorization", FormatJson(objectParam.Authorization))
				end if
		end if

		if objectParam.param <> invalid then
				if objectParam.DoesExist("param")  then
						requestHandlerObject.SetField("param", FormatJson(objectParam.param))
				end if
		end if

		if objectParam.param <> invalid then
				if objectParam.DoesExist("param")  then
						requestHandlerObject.SetField("param", FormatJson(objectParam.param))
				end if
		end if
	  requestHandlerObject.control="Run"
end function

sub showProgressDialog(msg=invalid)
  m.progressDialog = createObject("roSGNode", "ProgressDialog")
	m.progressDialog.backgroundUri="pkg:/locale/default/images/popup_0_bg.9.png"
	m.progressDialog.dividerUri="pkg:/locale/default/images/dailog-bo.jpg"
	w = m.screenWidth*0.33
	h = m.screenHeight*0.58 - m.screenHeight
	m.progressDialog.translation = [w,h]
  if(msg = invalid)
		m.progressDialog.busySpinner.poster.width= 75
		m.progressDialog.busySpinner.poster.height= 75
		m.progressDialog.busySpinner.poster.blendColor = "#ce2122"
  else
		m.progressDialog.busySpinner.poster.width= 75
		m.progressDialog.busySpinner.poster.height= 75
		m.progressDialog.busySpinner.poster.blendColor = "#ce2122"
    m.progressDialog.title = msg
  end if
	m.progressDialog.setFocus(true)
  parentNode = getSceneNode()
  parentNode.dialog = m.progressDialog
end sub

sub dismissProgressDialog()
  if(m.progressDialog <> invalid)
    m.progressDialog.close = true
  end if
end sub

function getDeviceUniqueId()
		di = CreateObject("roDeviceInfo")
		return di.GetChannelClientId()
end function


function getChannelVersion()
    di = CreateObject("roAppInfo")
    return di.GetVersion()
end function


'####################################################
'#######    Registry Functions     ############
'#######        ------------------     ############
'####################################################

function regRead(key,sectionName="adulttime")
  reg = CreateObject("roRegistry")
  sec = CreateObject("roRegistrySection", sectionName)
  secData = invalid
  if sec.Exists(key) then
      secData = sec.read(key)
  end if
  return secData
end function

function regWrite(key,value,sectionName="adulttime")
  sec = CreateObject("roRegistrySection", sectionName)
  key = key.toStr()
  sec.write(key,value)
  sec.flush()
  return true
end function

function regDelete(key,sectionName="adulttime")
  sec = CreateObject("roRegistrySection",sectionName)
  sec.delete(key)
  sec.flush()
  return true
end function

function writeIntoRegistry(key,value)
	 m.taskNodeRegistry["key"]=key
   m.taskNodeRegistry["value"]=value
	 m.taskNodeRegistry["oprations"]="write"
end function

'####################################################
'#######    End Registry Functions   ############
'#######        ------------------     ############
'####################################################

function convertArrayToString(categoryArray)
		categoryString = ""
		for each item in categoryArray
				if item <> invalid then
						if len(categoryString) > 0 then
								categoryString = categoryString +", "+ item
						else
								categoryString = item
						end if
				end if
		end for
		return categoryString
end function


function convertSecToMinute(secs)
		duration = ""
		mins= convertSecToMins(secs)
		if mins > 0 then
				duration = duration+mins.tostr()+ "m"
		end if

		secs= findSecondsLeft(secs)
		if secs > 0 then
				duration = duration+secs.tostr()+ "s"
		end if
		return duration
end function

function convertSecToMins(secs)
	  mins = 0
    mins = Fix(secs/ 60)
    return mins
end function

function findSecondsLeft(secs)
    secs = Fix(secs MOD 60)
    return secs
end function


function baseImageUrl()
  return "pkg:/locale/default/images/"
end function


function convertStarCastintoString(actors)
		starCast = ""
		for each item in actors
			if item <> invalid then
					if len(starCast) > 0 then
							starCast = starCast + ", "+item
					else
							starCast = item
					end if
			end if
		end for
		return starCast
end function


function showExitConfirmationPopup(title,msg)
    m.exitDialog = createObject("roSGNode", "Dialog")
    m.exitDialog.title = title
		m.exitDialog.message = msg

    m.exitDialog.optionsDialog = false
    m.exitDialog.iconUri="pkg:/locale/default/images/popup_000.png"
    m.exitDialog.dividerUri="pkg:/locale/default/images/popup_000.png"
		m.exitDialog.backgroundUri="pkg:/locale/default/images/dialogBorder.9.png"
    m.exitDialog.buttons = ["Yes", "No"]
    m.exitDialog.observeField("buttonSelected", "onExitDialogbuttonSelected")
    m.sceneNode = getSceneNode()
    m.sceneNode.dialog = m.exitDialog
end function

function onExitDialogbuttonSelected()
    selectedIndex = m.exitDialog.buttonSelected
    m.exitDialog.close = true
    if(selectedIndex = 0)
        m.top.isExitApp = true
    end if
end function


function showLoginConfirmationPopup(title,msg)
    m.exitDialog = createObject("roSGNode", "Dialog")
    m.exitDialog.title = title
        m.exitDialog.message = msg

    m.exitDialog.optionsDialog = false
    m.exitDialog.iconUri="pkg:/locale/default/images/popup_000.png"
    m.exitDialog.dividerUri="pkg:/locale/default/images/popup_000.png"
        m.exitDialog.backgroundUri="pkg:/locale/default/images/dialogBorder.9.png"
    m.exitDialog.buttons = ["Ok"]
    m.exitDialog.observeField("buttonSelected", "onLoginDialogbuttonSelected")
    m.sceneNode = getSceneNode()
    m.sceneNode.dialog = m.exitDialog
end function

function onLoginDialogbuttonSelected()
    selectedIndex = m.exitDialog.buttonSelected
    m.exitDialog.close = true
end function


function showParentalControlSuccessPopup(title,msg)
    m.ParentalControlSuccessPopup = createObject("roSGNode", "Dialog")
    m.ParentalControlSuccessPopup.title = title
		m.ParentalControlSuccessPopup.message = msg
    m.ParentalControlSuccessPopup.optionsDialog = false
    m.ParentalControlSuccessPopup.iconUri="pkg:/locale/default/images/popup_000.png"
    m.ParentalControlSuccessPopup.dividerUri="pkg:/locale/default/images/popup_000.png"
		m.ParentalControlSuccessPopup.backgroundUri="pkg:/locale/default/images/dialogBorder.9.png"
    m.ParentalControlSuccessPopup.buttons = ["OK"]
    m.ParentalControlSuccessPopup.observeField("buttonSelected", "onParentalControlSuccessButtonSelected")
    m.sceneNode = getSceneNode()
    m.sceneNode.dialog = m.ParentalControlSuccessPopup
end function

function onParentalControlSuccessButtonSelected()
    selectedIndex = m.ParentalControlSuccessPopup.buttonSelected
    m.ParentalControlSuccessPopup.close = true
end function


sub showErrorDialog(title="Network Error",msg=invalid)
  	m.errorDialog = createObject("roSGNode", "Dialog")
		m.errorDialog.title = title
		m.errorDialog.message = msg
		m.errorDialog.optionsDialog = false
		m.errorDialog.iconUri="pkg:/locale/default/images/popup_000.png"
    m.errorDialog.dividerUri="pkg:/locale/default/images/popup_000.png"
		m.errorDialog.backgroundUri="pkg:/locale/default/images/dialogBorder.9.png"
		m.errorDialog.buttons = ["OK"]
		m.errorDialog.setFocus(true)
		m.errorDialog.observeField("buttonSelected", "onErrorDialogbuttonSelected")
	  parentNode = getSceneNode()
	  parentNode.dialog = m.errorDialog

end sub

sub onErrorDialogbuttonSelected()
  if(m.errorDialog <> invalid)
    m.errorDialog.close = true
		if m.videoPlayer <> invalid then
				m.top.videoPlayerBackPressed = true
		else
				m.top.backPressed = true
		end if
  end if
end sub

sub showWarningDialog(title="Warning",msg=invalid,buttons=["OK"])
  	m.warningDialog = createObject("roSGNode", "Dialog")
		m.warningDialog.title = title
		m.warningDialog.message = msg
		m.warningDialog.optionsDialog = false
		m.warningDialog.iconUri="pkg:/locale/default/images/popup_000.png"
    m.warningDialog.dividerUri="pkg:/locale/default/images/popup_000.png"
		m.warningDialog.backgroundUri="pkg:/locale/default/images/dialogBorder.9.png"
		m.warningDialog.buttons = buttons
		m.warningDialog.buttonGroup.focusBitmapUri = "pkg:/locale/default/images/buttonFocus.png"
		m.warningDialog.setFocus(true)
		m.warningDialog.observeField("buttonSelected", "onWarningDialogbuttonSelected")
	  parentNode = getSceneNode()
	  parentNode.dialog = m.warningDialog

end sub

sub onWarningDialogbuttonSelected()
selectedIndex = m.warningDialog.buttonSelected
    m.warningDialog.close = true
    if(selectedIndex = 0)
		loginstatus = CreateObject("roRegistrySection", "Adulttime")
        loginstatus.Delete("loginstatus")                  
        loginstatus.Write("deviceToken","")
        m.global.removefield("deviceToken")
        m.global.addfields({"deviceToken": ""})
        loginstatus.Flush()
        m.top.showHome = true
    end if
end sub

sub showVersionDialog(status,title="Version",msg=invalid,buttons=["Continue"])
    m.versionDialog = createObject("roSGNode", "Dialog")
        m.versionstatus=status
        m.versionDialog.title = title
        m.versionDialog.message = msg
        m.versionDialog.optionsDialog = false
        m.versionDialog.iconUri="pkg:/locale/default/images/popup_000.png"
    m.versionDialog.dividerUri="pkg:/locale/default/images/popup_000.png"
        m.versionDialog.backgroundUri="pkg:/locale/default/images/dialogBorder.9.png"
        if m.versionstatus="new" OR m.versionstatus="latest"
        		m.versionDialog.buttons = ["Continue"]
        else if m.versionstatus="update"
        		m.versionDialog.buttons = ["Exit"]
        end if
        m.versionDialog.buttonGroup.focusBitmapUri = "pkg:/locale/default/images/buttonFocus.png"
        m.versionDialog.setFocus(true)
        m.versionDialog.observeField("buttonSelected", "onVersionDialogbuttonSelected")
      parentNode = getSceneNode()
      parentNode.dialog = m.versionDialog

end sub

sub onVersionDialogbuttonSelected()
selectedIndex = m.versionDialog.buttonSelected
    m.versionDialog.close = true
    if(selectedIndex = 0)
		    if m.versionstatus="new" OR m.versionstatus="latest"

		    		loginstatusreg = CreateObject("roRegistrySection", "Adulttime")
		        ' loginstatusreg.Delete("loginstatus")
		        flag = loginstatusreg.Exists("loginstatus")
		        if flag then
		            loginstatus = loginstatusreg.Read("loginstatus")
		            if loginstatus <> invalid and loginstatus="linked" then
		                 m.top.showHome = true
		                 m.global.removefield("loginstatus")
		                 m.global.addfields({"loginstatus": loginstatus})
		            else
		                m.top.showLogin = true
		            end if
		        else
		            m.top.showLogin = true
		        end if

		    else if m.versionstatus="update"
		        m.top.isExitFromApp = true
		    end if

    end if
end sub





function getDiffentRandomNum(oldNum)
	rndNum = rnd(4)
	while oldNum = rndNum
			rndNum = rnd(4)
	end while
	return rndNum
end function


function detailsButtonOption()
		buttonArray = []
		buttonArray=[
			{"title":"Play","icon":"icon_play_small.png","icon_hover":"icon_play_small_hover.png"},
			{"title":"Trailer","icon":"icon_trailer_small.png","icon_hover":"icon_trailer_small_hover.png"}
		]
		return buttonArray
end function

function detailsButtonForComingSoon()
		buttonArray = []
		buttonArray=[
			{"title":"Coming Soon","icon":"icon_play_small.png","icon_hover":"icon_play_small_hover.png"},
			{"title":"Trailer","icon":"icon_trailer_small.png","icon_hover":"icon_trailer_small_hover.png"}
		]
		return buttonArray
end function

    function detailsButtonForComingSoonIfNotLogin()
        buttonArray = []
        buttonArray=[
            {"title":"Link Account To Play","icon":"icon_play_small.png","icon_hover":"icon_play_small_hover.png"},
            {"title":"Trailer","icon":"icon_trailer_small.png","icon_hover":"icon_trailer_small_hover.png"}
        ]
        return buttonArray
end function


function manageLeftNavigationInfo(screen = invalid)
	m.navigationInfoLayout = m.top.findNode("navigationInfoLayout")
	m.navigationInfoLayout.itemSpacings= [5]
	if screen = "prefrence" OR screen = "setting" then
			m.navigationInfoLayout.translation = [m.screenWidth*0.06,m.screenHeight*0.03]
	else
			m.navigationInfoLayout.translation = [m.screenWidth*0.112,m.screenHeight*0.05]
	end if

	m.navigationInfo = m.top.findNode("navigationInfo")
	m.navigationInfo.text = "PRESS"
	m.navigationInfo.font = Hind_Bold(20)

	m.imgLeftArrowIcon = m.top.findNode("imgLeftArrowIcon")
	m.imgLeftArrowIcon.uri = baseImageUrl()+"leftArrowIcon.png"


	m.navigationInfo1 = m.top.findNode("navigationInfo1")
	m.navigationInfo1.text = "FOR MENU"
	m.navigationInfo1.font = Hind_Bold(20)
end function


function manageLeftNavigationInfoSetting(screen = invalid)
    m.navigationInfoLayout = m.top.findNode("navigationInfoLayout")
    m.navigationInfoLayout.itemSpacings= [5]

    m.navigationInfoLayout.translation = [m.screenWidth*0.05,m.screenHeight*0.05]

    m.navigationInfo = m.top.findNode("navigationInfo")
    m.navigationInfo.text = "PRESS"
    m.navigationInfo.font = Hind_Bold(20)

    m.imgLeftArrowIcon = m.top.findNode("imgLeftArrowIcon")
    m.imgLeftArrowIcon.uri = baseImageUrl()+"leftArrowIcon.png"


    m.navigationInfo1 = m.top.findNode("navigationInfo1")
    m.navigationInfo1.text = "TO GO BACK TO CONTENT"
    m.navigationInfo1.font = Hind_Bold(20)
end function


function handleBackGroundImageLoading(event as object)
    loadingStatus = event.getData()
'    if loadingStatus = "ready" then
'        m.imgLogo.uri = baseImageUrl()+"applogo.png"
'				m.imgLogo.width = 198
'				m.imgLogo.height = 25
'				m.imgLogo.loadWidth = 198
'				m.imgLogo.loadHeight = 25
'				m.imgLogo.blendColor = "#808080"
'				m.imgLogo.translation = [m.screenWidth*0.857,m.screenHeight*0.055]
'				m.imgLogo.visible = true
'		else
'				m.imgLogo.visible = false
'    end if
end function

function getEpoch()
	date = CreateObject("roDateTime")
	date.mark()
	date.ToLocalTime()
	currentEpoch = date.AsSeconds()
	dateString=m.dataObject.releaseDate+"T00:00:00Z"
	date.FromISO8601String(dateString)
	return date.AsSeconds()
end function

function getCurrentEpoch()
	date = CreateObject("roDateTime")
	date.mark()
	date.ToLocalTime()
	return date.AsSeconds()
end function
