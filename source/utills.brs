
function getBaseUrl()
		'baseUrl ="https://api.biblio-dev.easybroadcast.fr"		
        baseUrl ="https://api.americonic.com/"	
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
                requestHandlerObject.SetField("Authorization", FormatJson(objectParam.Authorization))
        end if
    end if

    if objectParam.authKey <> invalid then
      if objectParam.DoesExist("authKey")  then
              requestHandlerObject.SetField("authKey", FormatJson(objectParam.authKey))
      end if
    end if
  if objectParam.token <> invalid then
    if objectParam.DoesExist("token")  then
            requestHandlerObject.SetField("token", FormatJson(objectParam.token))
    end if
  end if

    if objectParam.param <> invalid then
            if objectParam.DoesExist("param")  then
                    requestHandlerObject.SetField("param", FormatJson(objectParam.param))
            end if
    end if
  requestHandlerObject.control="Run"
end function

Function gmdate(seconds as Dynamic) as Dynamic
  a   = seconds
  b   = 60
  c   = Fix(a / b)
  sec = int(a - b * c)

  a   = Fix(a/60)
  b   = 60
  c   = Fix(a / b)
  min = a - b * c

  a   = Fix(a/60)
  b   = 60
  c   = Fix(a / b)
  hour = a - b * c

  if hour <> 0 AND min <> 0
    tmes_string =  hour.toStr()+" h"+" "+min.toStr()+" min"
  else if hour <> 0
    tmes_string = hour.toStr()+" h"
  else if min <> 0
    tmes_string = min.toStr() + " min"
  else
    tmes_string = sec.toStr() + " sec"
  end if
  return tmes_string
End FUnction

sub showProgressDialog(msg=invalid)
  m.progressDialog = createObject("roSGNode", "ProgressDialog")
    m.progressDialog.backgroundUri="pkg:/locale/default/images/popup_0_bg.9.png"
    m.progressDialog.dividerUri="pkg:/locale/default/images/dailog-bo.jpg"
    w = m.screenWidth*0.01
    h = m.screenHeight*0.05
    m.progressDialog.translation = [w,h]
  if(msg = invalid)
        m.progressDialog.busySpinner.poster.width= 120
        m.progressDialog.busySpinner.poster.height= 120
        m.progressDialog.busySpinner.poster.blendColor = "#ffffff"
  else
        m.progressDialog.busySpinner.poster.width= 120
        m.progressDialog.busySpinner.poster.height= 120
        m.progressDialog.busySpinner.poster.blendColor = "#ffffff"
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
        return di
end function


' function getChannelVersion()
'     di = CreateObject("roAppInfo")
'     return di.GetVersion()
' end function

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

function IsValidEmail(email as String) as Boolean
    return CreateObject("roRegex", "^[A-Za-z0-9_%+-]+(\.[A-Za-z0-9_%+-]+)*@([A-Za-z0-9-]+\.)+[A-Za-z]{2,6}$", "i").IsMatch(email)
end function



function convertSecToMinute(secs)
        duration = ""
        mins= convertSecToMins(secs)
        if mins > 0 then
                duration = duration+mins.tostr()+ " : "
        end if

        secs= findSecondsLeft(secs)
        if secs > 0 then
                duration = duration+secs.tostr()
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

function showExitConfirmationPopup(title,msg)
  m.exitDialog = createObject("roSGNode", "Dialog")
  m.exitDialog.title = title
  m.exitDialog.message = msg

  m.exitDialog.optionsDialog = false
  m.exitDialog.iconUri="pkg:/locale/default/images/popup_000.png"
  m.exitDialog.dividerUri="pkg:/locale/default/images/popup_000.png"
  m.exitDialog.backgroundUri="pkg:/locale/default/images/selected.9.png"
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


function showDialog(title,msg)
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


