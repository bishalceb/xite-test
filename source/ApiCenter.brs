function videosApi()
    url="videos/get?app=2&device="+m.global.channelUniqueId
    requestHandlerObject = getServerObject()
    objectParam  = {
    "uri"           : url,
    "requestType"   : "GET",
    "authKey":"756280add7308032d4c7f6313fb3482a",
    "token":m.global.token
    }
    startTaskNode(requestHandlerObject,objectParam)
    requestHandlerObject.observeField("content","getVideoAPiCallBack")

end function

function getVideoAPiCallBack(event as object)
  response = ParseJson(event.getData())
  m.top.videoJson=response
end function


function categoryApi()
  url="categories/get?app=2&device="+m.global.channelUniqueId
  requestHandlerObject = getServerObject()
  objectParam  = {
  "uri"           : url,
  "requestType"   : "GET",
  "authKey":"756280add7308032d4c7f6313fb3482a"
  "token":m.global.token
  }
  startTaskNode(requestHandlerObject,objectParam)
  requestHandlerObject.observeField("content","getCategoryApiCallBack")

end function

function getCategoryApiCallBack(event as object)
  response = ParseJson(event.getData())
  m.top.categoryJson=response
end function

function genrateCode()
  url="device/code?app=2&device="+m.global.channelUniqueId
  requestHandlerObject = getServerObject()
  objectParam  = {
  "uri"           : url,
  "requestType"   : "POST",
  "authKey":"756280add7308032d4c7f6313fb3482a"
  }
  startTaskNode(requestHandlerObject,objectParam)
  requestHandlerObject.observeField("content","getgenrateCodeApiCallBack")

end function

function getgenrateCodeApiCallBack(event as object)
  response = ParseJson(event.getData())
  if response <> invalid and response.status="success"
    m.top.code=response.code 
  else
    m.top.unlink=response 
  end if
end function

function checkLoginStatus()
  url="device/accept?app=2&device="+m.global.channelUniqueId
  requestHandlerObject = getServerObject()
  objectParam  = {
  "uri"           : url,
  "requestType"   : "POST",
  "authKey":"756280add7308032d4c7f6313fb3482a"
  }
  startTaskNode(requestHandlerObject,objectParam)
  requestHandlerObject.observeField("content","getcheckLoginStatusCallBack")

end function

function getcheckLoginStatusCallBack(event as object)
  response = ParseJson(event.getData())
  m.top.chekLoginStatus=response
end function

function calluserApi()
  ?"m.global.token"m.global.token
  url="user/info?app=2&device="+m.global.channelUniqueId
    requestHandlerObject = getServerObject()
    objectParam  = {
    "uri"           : url,
    "requestType"   : "POST",
    "authKey":"756280add7308032d4c7f6313fb3482a",
    "token":m.global.token
    }
  startTaskNode(requestHandlerObject,objectParam)
  requestHandlerObject.observeField("content","getuserApiCallBack")

end function

function getuserApiCallBack(event as object)
  response = ParseJson(event.getData())
  ?"response"response
  m.top.userApi=response
end function


function unLinkDevice()
  ?"m.global.token"m.global.token
  url="unlink?app=2&device="+m.global.channelUniqueId
    requestHandlerObject = getServerObject()
    objectParam  = {
    "uri"           : url,
    "requestType"   : "POST",
    "authKey":"756280add7308032d4c7f6313fb3482a",
    "token":m.global.token
    }
  startTaskNode(requestHandlerObject,objectParam)
  requestHandlerObject.observeField("content","unLinkDeviceCallBack")
end function

function unLinkDeviceCallBack(event as object)
  response = ParseJson(event.getData())
  ?"unlink device"response
    m.top.unlinkResponse=response
end function

