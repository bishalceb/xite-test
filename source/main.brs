sub main(args as dynamic)
  screen = createObject("roSGScreen")
  port = createObject("roMessagePort")
  screen.setMessagePort(port)

  m.global = screen.getGlobalNode()
  fnSetDeeplinking(args)
  scene = screen.createScene("HomeScene")
  scene.signalBeacon("AppLaunchComplete")
  screen.show()
  scene.observeField("isExitFromApp", port)
  while true
      msg = wait(0, port)
      if type(msg) = "roSGScreenEvent" and msg.isScreenClosed()
          return
      else if type(msg) = "roSGNodeEvent"
          if msg.getField() = "isExitFromApp" then
            return
          end if
      end if
  end while
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

