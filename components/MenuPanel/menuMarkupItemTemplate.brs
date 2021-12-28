function init()
    m.icon = m.top.findNode("Icon")
    m.menuTitle = m.top.findNode("Title")
    m.menuLayout = m.top.findNode("menuLayout")

    m.top.observeField("itemContent", "handleItemContentEvent")
    m.top.observeField("itemHasFocus", "handleItemHasFocusEvent")
    ' m.top.observeField("width", "updateWidth")
end function

sub handleItemContentEvent( message as object)
    contentData = message.GetData()
    ' ? "contentData "contentData
    ' ? "m.top.width: "m.top.width
    m.icon.width  = 42
    m.icon.height = 42
    m.icon.uri = contentData.posterUrl
    h = (m.top.height-35)/2
    w = (m.top.width-20)/2
    m.icon.translation = [ w , h]
    x_axis = m.icon.translation[0]
    m.menuTitle.text = contentData.title
    m.menuTitle.font = Hind_Bold(33)
    m.menuTitle.height =  m.top.height
    m.menuTitle.translation = [0, 8]
    m.menuTitle.color = "#000000"
    m.icon.blendColor = "#000000"
    'handleTitleVisibilityEvent(contentData.showTitle)
end sub

' function updateWidth(width as Object)
'     width = width.getData()
'     m.menuTitle.width = width
' end function


sub handleItemHasFocusEvent(message as object)
    hasFocus = message.GetData()
    if hasFocus = true
        m.icon.blendColor = "#000000"
        m.menuTitle.color = "#000000"
    else
        m.icon.blendColor = "#000000"
        m.menuTitle.color = "#000000"
    end if
end sub

function handleTitleVisibilityEvent(isVisible)
    if isVisible = true
        m.menuTitle.visible = true
    else
        m.menuTitle.visible = false
    end if
end function
