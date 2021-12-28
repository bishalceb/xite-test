sub Init()
    setScreenResolution()
    m.contentLayout = m.top.findNode("contentLayout")

    m.menuPanel = m.top.findNode("menuPanel")
    m.menuPanel.observeField("wrapMenu","handleWrapMenuEvent")
    m.menuList = m.menuPanel.findNode("menuList")
    m.menuList.observeField("itemSelected","handleItemSelectedEvent")
    m.bgImageMasking = m.top.findNode("bgImageMasking")
    m.bgImageMasking.width = m.screenWidth
    m.bgImageMasking.height = m.screenHeight
    m.bgImageMasking.loadWidth = m.screenWidth
    m.bgImageMasking.loadHeight = m.screenHeight
    m.bgImageMasking.uri = baseImageUrl()+"app_bg.png"
    
    m.imgLogo = m.top.findNode("imgLogo")
    m.imgLogo.translation = [m.screenWidth*0.68,m.screenHeight*0.01]

    m.backGroundImage = m.top.findNode("backGroundImage")
    m.backGroundImage.observeField("loadStatus","handleBackGroundImageLoading")


    m.containerLayout = m.top.findNode("containerLayout")

    m.title = m.top.findNode("Title")

    m.infoLineLayout = m.top.findNode("infoLineLayout")

    m.lblReleaseDate = m.top.findNode("lblReleaseDate")

    m.lblDuration = m.top.findNode("lblDuration")

    m.lblDescription = m.top.findNode("lblDescription")
    m.lblDescription.width=m.screenWidth*0.55
    m.lblDescription.height=m.screenHeight*0.30
    m.lblDescription.maxLines = 4
    m.lblDescription.wrap = true


    m.rowList = m.top.findNode("rowList")
    m.rowList.translation = [m.screenWidth*0.10,m.screenWidth*0.60]
    ' m.rowList.focusBitmapBlendColor = "#cd1024"
    ' m.rowList.focusFootprintBlendColor = "#cd1024"

    m.rowList.ObserveField("rowItemFocused","handleFocusedContentNode")
    m.rowList.ObserveField("rowItemSelected","handleSelectedContentNode")

    m.top.ObserveField("contentNode","handleContentNode")

    m.top.ObserveField("menuData","handleMenuesponse")

    m.top.ObserveField("focusedNode","handleFocusedNode")

    m.top.ObserveField("visible","onVisibleChange")

    setUpFontSize()
    setUpFontColor()
    initRowListProperties()
    m.dataArray = []
end sub

function onVisibleChange()
  if m.top.visible then
      'm.menuPanel.visible = false
      manageLeftNavigationInfo()
      'm.rowList.content = invalid   
          if m.rowList.content = invalid then
            showProgressDialog()
            HomeApi("https://raw.githubusercontent.com/XiteTV/frontend-coding-exercise/main/data/dataset.json")
            m.menuPanel.visible = true
            m.menuPanel.hasFocus = false
          end if
          m.rowList.setfocus(true)        
  end if
end function

function setUpFontSize()
    m.title.font          = Hind_Bold(60)
    m.lblReleaseDate.font = Hind_Regular(30)
    m.lblDuration.font    = Hind_Regular(30)
    ' m.lblGenre.font       = Hind_Regular(30)
    m.lblDescription.font = Hind_Regular(30)
    ' m.lblThumbsDown.font = Hind_Regular(18)
    ' m.lblThumbsUp.font = Hind_Regular(18)
end function

function setUpFontColor()

  m.title.color          = "#FFFFFFFF"
  m.lblReleaseDate.color = "#737374"
  m.lblDuration.color    = "#737374"
  ' m.lblGenre.color       = "#737374"
  m.lblDescription.color = "#FFFFFFFF"
  ' m.lblThumbsDown.color = "#737374"
  ' m.lblThumbsUp.color = "#737374"
  ' m.icon_thumbsDown.blendColor = "#737374"
  ' m.icon_thumbsUp.blendColor = "#737374"

end function

function handleContentNode(response as object)
    response = response.getData()
    if response <> invalid then
        m.dataArray = response
        createRowList(m.dataArray)
    end if
end function

function initRowListProperties()
  rowHeight = m.screenHeight*0.213
  itemSpacing = m.screenWidth*0.01
  offsetX = m.screenWidth*0.0
  offsetY = m.screenHeight*0.005
  m.rowList.itemComponentName="ItemTemplateRowList"
  m.rowList.itemSize = [m.screenWidth*0.95,m.screenHeight*0.30]
  m.rowList.rowItemSize = [m.screenWidth*0.21,rowHeight]
  m.rowList.rowHeights = [rowHeight+50,rowHeight+50,rowHeight+50]
  m.rowList.itemSpacing = [itemSpacing,itemSpacing]
  m.rowList.rowItemSpacing = [itemSpacing,itemSpacing]
  m.rowList.rowFocusAnimationStyle = "floatingFocus"
  m.rowList.rowLabelFont = Hind_Bold(30)
  m.rowList.rowLabelOffset = [offsetX,offsetY]
  m.rowList.focusBitmapBlendColor = "#ffffff"
  m.rowList.rowCounterRightOffset=[m.screenWidth*0.10,m.screenWidth*0.10,m.screenWidth*0.10]
  m.contentLayout.translation = [m.screenWidth*0.11,m.screenHeight*0.12]
  m.rowList.translation = [m.screenWidth*0.10,m.screenHeight*0.60]

  ' m.rowList.focusBitmapBlendColor ="#6845DD"
end function

function createRowList(dataArray)
    if dataArray <> invalid then
        rowSpacing = []
        rowLabelOffset = []
        itemSpacing = m.screenWidth*0.018
        dataContent  = CreateObject("roSGNode","ContentNode")
        for each genres in dataArray.genres
            isgenrematch=false
            for each item in dataArray.videos
                if genres.id=item.genre_id
                    if isgenrematch=false
                        rowContent = dataContent.createChild("ContentNode")
                        rowContent.title = genres.name
                    end if 
                    isgenrematch=true   
                    itemContent = rowContent.createChild("RowListContentData")
                    if item <> invalid then
                        if item.image_url <> invalid then
                        itemContent.posterUrl = item.image_url
                        end if
                        if item.title <> invalid then
                        itemContent.title = item.title
                        end if
                        if item.artist <> invalid then
                        itemContent.artist = item.artist
                        end if
                        if item.release_year <> invalid then
                            itemContent.releaseyear = item.release_year
                        end if
                    end if
                end if    
            end for    
            rowSpacing.push([itemSpacing*2.5])
            rowLabelOffset.push([offsetX,offsetY])
        end for    
        m.rowList.rowSpacings =rowSpacing
        m.rowList.content = dataContent
        'm.rowList.rowLabelOffset = rowLabelOffset
        m.contentLayout.translation = [m.screenWidth*0.11,m.screenHeight*0.12]
        m.rowList.translation = [m.screenWidth*0.10,m.screenHeight*0.60]

        m.rowList.setFocus(true)
        dismissProgressDialog()
    else
        m.rowList.content = invalid
    end if

end function

function handleFocusedContentNode(focusEvent as object)
    focusRow = focusEvent.getData()
    row = focusRow[0]
    column = focusRow[1]
    ?"dd"m.rowList.content.getChild(row).getChild(column)
    focusedItem = m.rowList.content.getChild(row).getChild(column)
    m.top.focusedNode = focusedItem

end function

function handleSelectedContentNode(selectedEvent as object)
    selectedRow = selectedEvent.getData()
    row = selectedRow[0]
    column = selectedRow[1]
    'm.top.selectedEvent =m.homeResponse[row].data[column]
    '?"seletce event="m.homeResponse[row].data[column].content.videos[0].url
    m.global.removefield("url")
    m.global.addfields({"url": "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_5mb.mp4"})
    m.global.removefield("streamFormat")
    m.global.addfields({"streamFormat": "mp4"})
    if m.itemSelected = 1
        m.top.showPlayer=true
    else
        m.top.showPlayer=true
        ' if m.global.deviceToken <> invalid AND NOT m.global.deviceToken=""
        '     m.top.showPlayer=true
        ' else
        '     showLoginConfirmationPopup("Please Login","Please goto Setting and Login to view this content")     
        ' end if
    end if
end function



function handleFocusedNode(event as Object)
    dataObject = event.getData()
    if dataObject <> invalid then
        if dataObject.title <> invalid then
            m.title.text = dataObject.title
        end if

        if dataObject.releaseyear <> invalid then
            m.lblReleaseDate.text = dataObject.releaseyear
        end if

        ' if dataObject.content.duration <> invalid then
        '     m.lblDuration.text = convertSecToMinute(dataObject.content.duration)
        ' end if

'        if dataObject.categories <> invalid then
'            m.lblGenre.text = convertArrayToString(dataObject.categories)
'        end if

        ' if dataObject.shortDescription <> invalid and len(dataObject.shortDescription) > 0 then
        '     if len(dataObject.shortDescription) > 290
        '         m.lblDescription.text = dataObject.shortDescription
        '         m.lblDescription.width=m.screenWidth*0.50
        '         m.lblDescription.height=m.screenHeight*0.20
        '         m.lblDescription.maxLines = 4
        '         m.lblDescription.wrap = true
        '     else if len(dataObject.shortDescription) < 290 and len(dataObject.shortDescription) > 200
        '         m.lblDescription.text = dataObject.shortDescription
        '         m.lblDescription.width=m.screenWidth*0.50
        '         m.lblDescription.height=m.screenHeight*0.15
        '         m.lblDescription.maxLines = 3
        '         m.lblDescription.wrap = true
        '     else
        '         m.lblDescription.text = dataObject.shortDescription
        '         m.lblDescription.width=m.screenWidth*0.50
        '         m.lblDescription.height=m.screenHeight*0.10
        '         m.lblDescription.maxLines = 2
        '         m.lblDescription.wrap = true
        '     end if
        ' else
        '     m.lblDescription.text  =""
        '     m.lblDescription.height=m.screenHeight*0.02
        '     m.lblDescription.maxLines = 1
        '     m.lblDescription.wrap = false
        ' end if

        if dataObject.posterUrl <> invalid then
            m.backGroundImage.loadWidth = m.screenWidth
            m.backGroundImage.loadHeight = m.screenHeight
            m.backGroundImage.uri = dataObject.posterUrl
        end if
        m.lblDescription.text = "Artist: "+dataObject.artist
'        if dataObject.ratingsUp <> invalid then
'            m.lblThumbsUp.text = (dataObject.ratingsUp).toStr()
'            m.icon_thumbsUp.visible = true
'        end if
'
'        if dataObject.ratingsDown <> invalid then
'            m.lblThumbsDown.text = (dataObject.ratingsDown).toStr()
'            m.icon_thumbsDown.visible = true
'        end if

    end if
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    ? "HomeScreen press : "press;" key : "key
    if press = true
        if key = "back" AND m.menuPanel.hasFocus = true then
            showExitConfirmationPopup("Exit Confirmation","Do you really want to exit?")
            handled = true
        else if key = "left" or key = "back"
          if m.rowList.hasFocus() then
              m.rowList.setFocus(false)
              m.menuPanel.hasFocus = true
              m.contentLayout.translation = [m.screenWidth*0.25,m.screenHeight*0.12]
              m.rowList.translation = [m.screenWidth*0.25,m.screenHeight*0.60]
          end if
          handled = true
        else if key = "right"
            handled = true
        else if key = "down" OR key = "up"
            handled = true
        end if
    end if
    return handled
end function

function handleWrapMenuEvent(wrapMenuEvent as object)
    isWrapMenu = wrapMenuEvent.getData()
    if isWrapMenu = true then
        m.menuPanel.hasFocus = false
        m.rowList.setFocus(true)
        m.contentLayout.translation = [m.screenWidth*0.11,m.screenHeight*0.12]
        m.rowList.translation = [m.screenWidth*0.10,m.screenHeight*0.60]
    end if
end function

function handleItemSelectedEvent(message as object)
    m.itemSelected = message.GetData()
    m.menuPanel.wrapMenu = true
    ' if m.itemSelected = 0 then
    '     ? "show SearchScreen"
    '     m.global.removefield("optionSelected")
    '     m.global.removefield("list")
    '     m.global.addfields({"list" : "menu","optionSelected" : 0})
    '     m.top.showSearchScreen=true
    '    ' m.top.contentNode=m.dataArray
    '  else if m.itemSelected=4
    '     m.top.showSetting=true
    '  else
    '   showProgressDialog()
    '  HomeApi(m.menuResponse.menuData[m.itemSelected-1].path)
    '  end if
end function
