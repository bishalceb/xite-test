sub main(args as dynamic)
  screen = createObject("roSGScreen")
  port = createObject("roMessagePort")
  input = CreateObject("roInput")
  input.SetMessagePort(port)
  input.enableTransportEvents()
  screen.setMessagePort(port)

  m.global = screen.getGlobalNode()
  m.global.addFields( {loginData:{},token:"",lastscreen:"",channelUniqueId:"",devicename:""})
  getRegistryData()
  fnSetDeeplinking(args)
  scene = screen.createScene("HomeScene")
  scene.signalBeacon("AppLaunchComplete")
  screen.show()
  scene.observeField("isExitFromApp", port)
  
  while true
      msg = wait(0, port)
      if type(msg) = "roSGScreenEvent" and msg.isScreenClosed()
          return
      else if type(msg) = "roInputEvent"
          if msg.IsInput()
            inputData = msg.GetInfo()
            deeplink = {
              id: inputData.contentID
              type: inputData.mediaType
            }
            m.global.addField("deeplinking", "assocarray", false)
            m.global.deeplinking = deeplink
            scene.inputRequest = deeplink
          end if     
      else if type(msg) = "roSGNodeEvent"
          if msg.getField() = "isExitFromApp" then
            return
          end if
      end if
  end while
end sub

sub getRegistryData()
  di=getDeviceUniqueId()
  'di.GetModel();di.GetModelDisplayName();di.GetModelType();di.GetModelDetails();di.
  ?"GetDeviceUniqueId"di.GetChannelClientId();di.GetFriendlyName()
  m.global.channelUniqueId=di.GetChannelClientId()
  m.global.devicename=di.GetFriendlyName()
  registry = CreateObject("roRegistrySection", "Americonic")
   flag = registry.Exists("isLogin")
   tokenflag = registry.Exists("token")
   if flag then
      isLogin = registry.Read("isLogin")
      if isLogin <> invalid AND isLogin="1"
         m.global.isLogin="1"
      else
         m.global.isLogin="0"
      end if
   else
      m.global.isLogin="0"
   end if
   if tokenflag then
      token = registry.Read("token")
      m.global.token=token
  else    
   end if   
end sub 

Function getDeepLinks(args) as Object
    deeplink = Invalid
    if args.contentid <> Invalid and args.mediaType <> Invalid
        deeplink = {
            id: args.contentId
            type: args.mediaType
        }
    end if
    return deeplink
end Function

function fnSetDeeplinking(args)
  deeplink = getDeepLinks(args)
  m.global.addField("deeplinking", "assocarray", false)
  m.global.deeplinking = deeplink
end function

