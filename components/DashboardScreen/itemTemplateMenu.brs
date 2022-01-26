function init()
    m.menuTitle = m.top.findNode("Title")
    
    m.top.observeField("itemContent", "handleItemContentEvent")
    m.top.observeField("itemHasFocus", "handleItemHasFocusEvent")
end function

sub handleItemContentEvent( message as object)
    contentData = message.GetData()
    m.menuTitle.text = contentData.title
    m.menuTitle.font = Hind_regular(34)
    m.menuTitle.height =  42
    m.menuTitle.width = m.menuTitle.boundingRect().width
    m.menuTitle.translation = [0, 21]
end sub


sub handleItemHasFocusEvent(message as object)
    hasFocus = message.GetData()
    if hasFocus = true
        m.menuTitle.color ="#3699FF"
    else 
        m.menuTitle.color = "#92929F"
    end if
end sub

function handleTitleVisibilityEvent(isVisible)
    if isVisible = true
        m.menuTitle.visible = true
    else
        m.menuTitle.visible = false
    end if
end function
