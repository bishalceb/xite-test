function init()
    m.menuTitle = m.top.findNode("title")
    m.desc = m.top.findNode("desc")
    m.btn = m.top.findNode("btn")
    m.icon = m.top.findNode("icon")
    m.btntext = m.top.findNode("btntext")
    
    m.top.observeField("itemContent", "handleItemContentEvent")
    m.top.observeField("itemHasFocus", "handleItemHasFocusEvent")
end function

sub handleItemContentEvent( message as object)
    contentData = message.GetData()
    m.menuTitle.text = contentData.title
    m.menuTitle.font = Hind_Bold(40)
    m.menuTitle.height =  42
    m.desc.text =contentData.description
    m.desc.font = Hind_regular(28)
    m.menuTitle.width = 500
    m.desc.width = 500
    m.icon.uri=contentData.icon
    m.btntext.text=contentData.btntext
    m.btntext.font = Hind_Regular(34)
end sub


sub handleItemHasFocusEvent(message as object)
    hasFocus = message.GetData()
    '?"hasFocus in menu=="hasFocus
    if hasFocus = true
        m.btn.BlendColor ="#3699FF"
    else 
        m.btn.BlendColor = "#1b1b29"
    end if
end sub

function handleTitleVisibilityEvent(isVisible)
    if isVisible = true
        m.menuTitle.visible = true
    else
        m.menuTitle.visible = false
    end if
end function
