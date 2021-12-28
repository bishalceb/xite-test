sub init()
  setScreenResolution()
  m.menuList = m.top.findNode("menuList")
  m.menuList.translation = [0,350]
  m.menuList.drawFocusFeedback = true
  m.menuList.drawFocusFeedbackOnTop = false
  m.menuList.focusBitmapUri = baseImageUrl()+"menuSelector_1.png"
  m.menuList.focusFootprintBitmapUri = baseImageUrl()+"menuSelector_1.png"
  m.menuList.focusBitmapBlendColor = "#ffffff"
  m.menuList.focusFootprintBlendColor = "#ffffff"

  m.menuList.observeField("itemFocused","handleItemFocusedOnEvent")
  m.menuList.observeField("itemSelected","handleItemSelectedEvent")
  m.menuListRectBase = m.top.findNode("menuListRectBase")
  m.top.observeField("visible","handleVisibleEvent")

  m.top.observeField("hasFocus","handleMenuSlider")

  m.itemFocused = 1
  m.itemSelected = 1
end sub

function handleVisibleEvent(isVisibleEvent as object)
isVisible = isVisibleEvent.getData()
if isVisible = true then
    handleMenuListRectBaseWidth()
    createMainMenuUI()
    setFocusOnVisibleScreenOption()

end if
end function

function createMainMenuUI()
  data = CreateObject("roSGNode","ContentNode")
  baseUrl = baseImageUrl()
  contentItem = data.CreateChild("MenuListData")
  contentItem.posterUrl = baseUrl+"icon_0.png"
  contentItem.title = "Home"
  contentItem.showTitle = false
  m.menuList.content = data

end function


function handleMenuListRectBaseWidth()
m.menuListRectBase.width =  m.screenWidth*0.065
m.menuListRectBase.height =  m.screenHeight
m.menuList.itemSize = [m.screenWidth*0.065,m.screenHeight*0.065]
end function

function handleMenuSlider(hasFocusEvent as object)
  hasFocus = hasFocusEvent.getData()
  if hasFocus = true then
      fnExpandMenu()
  else
      fnWrapMenu()
  end if

end function

function fnWrapMenu()
m.menuList.setFocus(false)
m.menuListRectBase.width =  m.screenWidth*0.065
m.menuList.itemSize = [m.screenWidth*0.065,m.screenHeight*0.065]
handleMenuTitleVisibility(false)
end function

function fnExpandMenu()
m.menuListRectBase.width =  m.screenWidth*0.23
m.menuList.itemSize = [m.screenWidth*0.23,m.screenHeight*0.065]
setFocusOnVisibleScreenOption()
handleMenuTitleVisibility(true)
end function

function handleMenuTitleVisibility(showTitle)
  for i = 0 to m.menuList.content.getChildCount()-1
      m.menuList.content.getchild(i).showTitle = showTitle
  end for
end function


function onKeyEvent(key as String, press as Boolean) as Boolean
  handled = false
  if press = true
      if key = "right" then
          m.top.wrapMenu = true
          handled = true
      else if key = "down" then
          handled = true
      else if key = "up"  then
          end if
      end if
  return handled
end function

function setFocusOnVisibleScreenOption()
      m.menuList.setfocus(true)
end function
