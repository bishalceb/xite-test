sub init()
    setScreenResolution()
    m.componentBase = m.top.findNode("ComponentBase")
    m.componentBase.width = m.screenWidth * 0.5
    m.componentBase.height = m.screenHeight * 0.1
    m.componentBase.translation = [ m.screenWidth * 0.25, m.screenHeight * 0.80]

    m.message = m.top.findNode("Message")
    m.message.width = m.componentBase.width
    m.message.height = m.componentBase.height

    m.countdownTimer = m.top.findNode("CountdownTimer")
    m.countdownTimer.observeField("fire", "handleCountdownTimerFireEvent")

    m.top.observeField("message", "handleMessageEvent")
end sub

' function setScreenResolution()
'      resolutionObject =m.top.GetScene().currentDesignResolution
'      m.screenWidth = resolutionObject.width
'      m.screenHeight = resolutionObject.height
' end function

sub handleMessageEvent(message as object)
    messageText = message.GetData()
    if messageText <> ""
        m.countdownTimer.control = "start"
        m.componentBase.visible = true
        m.message.text = messageText
        m.top.setFocus(true)
    end if
end sub

sub handleCountdownTimerFireEvent(message as object)
    m.componentBase.visible = false
    m.top.dismissed = true
end sub
