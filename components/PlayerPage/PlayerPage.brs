sub init()
 m.videoPlayer =   m.top.findNode("VideoPlayer")
   m.top.ObserveField("visible","onVisibleChange")
end sub

Sub onVisibleChange(event as object)
    isVisible = event.getdata()
    if m.top.visible then
      ?"m.global.url"m.global.url
      ContentNode = CreateObject("roSGNode", "ContentNode")
    ContentNode.url = m.global.url
    ContentNode.streamFormat = "hls"
     m.videoPlayer.content = ContentNode
     m.videoPlayer.visible = true
     m.videoPlayer.setFocus(true)
     m.videoPlayer.control = "play"
     m.videoPlayer.observeField("state", "OnVideoPlayerStateChange")
  end if
end Sub


Sub OnVideoPlayerStateChange()
  print "Playerpage.brs - [OnVideoPlayerStateChange]"
  if m.videoPlayer.state = "buffering"
      ? "video is Buffering please Wait"
  else if m.videoPlayer.state = "error"
    m.videoPlayer.visible = false
    m.videoPlayer.setFocus(true)
  else if m.videoPlayer.state = "playing"
    m.videoPlayer.visible = true
    m.videoPlayer.setFocus(true)
  else if m.videoPlayer.state = "finished"
      ?"Finished call automatic for post question"
      m.videoPlayer.control = "stop"
      m.videoPlayer.visible = false
      m.videoPlayer.setFocus(false)
      m.top.showtvchannel=true
  end if
End Sub

Function OnkeyEvent(key, press) as Boolean
    print ">>> Player >> OnkeyEvent"
    print "in Player.xml onKeyEvent ";key;" "; press
    result = false
    if press
        if key = "back"
          if m.global.deeplinking =invalid
            m.top.showtvchannel=true
          else
            m.top.showdashboard=true
          end if  
          m.global.addField("deeplinking", "assocarray", false)
          m.global.deeplinking = invalid
          m.videoPlayer.control = "stop"
          m.videoPlayer.visible = false
          m.videoPlayer.setFocus(false)
          return true
       else if key="OK"
          return true
       else if key="up"
         return true
       else if key="down"
          return true
       else if key="left"
          return true
        else if key="right"
          return true
        end if
    end if

End Function
