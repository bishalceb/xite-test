sub init()
    setScreenResolution()
    m.boundingSize =m.top.findNode("boundingSize")  
    m.bgRect =m.top.findNode("bgRect")
    m.bgRect.width="1920"
    m.bgRect.height="1080"
    m.menulist =m.top.findNode("menulist")    
    m.menuList.observeField("itemSelected","handleMenuItemSelectedEvent") 
    initMenuListProperties()
    m.menulist.itemComponentName="ItemTemplateMenu"
    m.waitingRoomPlayer = m.top.FindNode("bgvideo")
    m.waitingRoomPlayer.translation = [0,130]

    m.contenRowtlist =m.top.findNode("contenRowtlist")
    m.contenRowtlist.observeField("rowItemSelected","handleRowItemSelectedEvent")
    m.contenRowtlist.ObserveField("rowItemFocused","handleFocusedContentNode")
    initRowListProperties()

    m.toastDisplay = m.top.findNode("toastComponent")
    m.toastDisplay.observeField("dismissed", "handleToastDismissedEvent")

    m.top.ObserveField("visible","onVisibleChange")
    m.top.ObserveField("videoJson","getVideoData")
    m.top.ObserveField("categoryJson","getListOfCategory")
    m.top.ObserveField("unlinkResponse","Logout")
end sub    

sub onVisibleChange()
    if m.top.visible then
        if m.contenRowtlist.content = invalid or m.global.lastscreen="Account"
        showProgressDialog()
        createMenuUI()
        setWaitngRoomPlayer()
        categoryApi()
        else
            m.contenRowtlist.setFocus(true)
            m.waitingRoomPlayer.control = "play"
            m.waitingRoomPlayer.visible = true
        end if    
    end if
end sub

sub handleToastDismissedEvent(message as object)
    toastDismissed = message.GetData()
    if toastDismissed = true
        m.toastDisplay.message = ""
        m.toastDisplay.setfocus(false)
        m.contenRowtlist.setFocus(true)
    end if
end sub

sub Logout(unlinkres)
    dismissProgressDialog()
    unlinkres=unlinkres.getData()
    if unlinkres.status="success"
        loginstatus = CreateObject("roRegistrySection", "Americonic")
        loginstatus.Write("isLogin","0")
        loginstatus.Write("token","")
        loginstatus.Flush()
        m.global.token=""
        m.top.showdashboard=true
    end if  
  end sub  

sub loadTvRowContent()
    m.contenRowtlist.content = invalid
    rowSpacing = []
    rowLabelOffset = []
    itemSpacing = m.screenWidth*0.04 
    rowHeight = m.screenHeight*0.38     
    rowItemSize=[]
    rowHeights=[]
    if m.RowlistJson.videos <> invalid and m.RowlistJson.videos.Count()>0
        dataContent  = CreateObject("roSGNode","ContentNode")
        i=0
        for each categoryid in m.categoryJson.categories
            if categoryid.tv="1"
                ismatch=false 
                for each data in m.RowlistJson.videos
                    for each idmatch in data.categories
                        if idmatch.id=categoryid.id  
                            if ismatch=false
                                ismatch=true
                                rowContent = dataContent.createChild("ContentNode") 
                                rowContent.title =categoryid.title
                            end if
                            itemContent = rowContent.createChild("CustomContentNode")
                            if data["title"] <> invalid then
                                itemContent.title = data.title
                            end if
                            if data["playback_id"] <> invalid then
                                itemContent.url = "https://stream.mux.com/"+data.playback_id+".m3u8"
                            end if
                            if data.image_url <> invalid then
                                itemContent.posterUrl = data.image_url
                            end if 
                        end if    
                    end for   
                end for
                rowSpacing.push([40])
                rowItemSize.Push([406,227])
                rowHeights.Push(300)
                rowLabelOffset.push([0,0])
                i+=1 
            end if
        end for       
    end if  
    m.contenRowtlist.rowSpacings =rowSpacing
    m.contenRowtlist.content = dataContent
    m.contenRowtlist.rowLabelOffset = rowLabelOffset
    m.contenRowtlist.rowItemSize=rowItemSize
    m.contenRowtlist.rowHeights=rowHeights  
    m.contenRowtlist.setFocus(true)
    dismissProgressDialog()
end sub

sub loadTubeRowContent()
    ?"tube"
    m.contenRowtlist.content = invalid
    rowSpacing = []
    rowLabelOffset = []
    itemSpacing = m.screenWidth*0.04 
    rowHeight = m.screenHeight*0.38     
    rowItemSize=[]
    rowHeights=[]
    if m.RowlistJson.videos <> invalid and m.RowlistJson.videos.Count()>0
        dataContent  = CreateObject("roSGNode","ContentNode")
        i=0
        for each categoryid in m.categoryJson.categories
            if categoryid.tube="1"
                ismatch=false 
                for each data in m.RowlistJson.videos
                    for each idmatch in data.categories
                        if idmatch.id=categoryid.id  
                            if ismatch=false
                                ismatch=true
                                rowContent = dataContent.createChild("ContentNode") 
                                rowContent.title =categoryid.title
                            end if
                            itemContent = rowContent.createChild("CustomContentNode")
                            if data["title"] <> invalid then
                                itemContent.title =data.title
                            end if
                            if data["playback_id"] <> invalid then
                                itemContent.url = "https://stream.mux.com/"+data.playback_id+".m3u8"
                            end if
                            if data.image_url <> invalid then
                                itemContent.posterUrl = data.image_url
                            end if 
                        end if    
                    end for   
                end for
                rowSpacing.push([40])
                rowItemSize.Push([406,227])
                rowHeights.Push(300)
                rowLabelOffset.push([0,0])
                i+=1 
            end if
        end for       
    end if  
    m.contenRowtlist.rowSpacings =rowSpacing
    m.contenRowtlist.content = dataContent
    m.contenRowtlist.rowLabelOffset = rowLabelOffset
    m.contenRowtlist.rowItemSize=rowItemSize
    m.contenRowtlist.rowHeights=rowHeights  
    m.contenRowtlist.setFocus(true)
    dismissProgressDialog()
end sub

sub setWaitngRoomPlayer()
	ContentNode = CreateObject("roSGNode", "ContentNode")
    ContentNode.url="https://americonic.mediafire.com/file/b8qb6g7pcjif20p/flag-waving.mp4/file"
    ContentNode.streamFormat ="mp4"
    m.waitingRoomPlayer.content = ContentNode
    m.waitingRoomPlayer.visible = true
   ' m.waitingRoomPlayer.setFocus(true)
    m.waitingRoomPlayer.control = "play"
    m.waitingRoomPlayer.observeField("state", "OnVideoPlayerStateChange")
end sub	

sub OnVideoPlayerStateChange()
    if m.waitingRoomPlayer.state = "buffering"
    else if m.waitingRoomPlayer.state = "error"
          m.error=true
          m.waitingRoomPlayer.control = "stop"
          m.waitingRoomPlayer.visible = false
    else if m.waitingRoomPlayer.state = "playing"
        m.error=false
        m.waitingRoomPlayer.visible = true
    else if m.waitingRoomPlayer.state = "finished"
      m.waitingRoomPlayer.control = "play"
      m.waitingRoomPlayer.visible = true
      'm.waitingRoomPlayer.seek = 0
    end if
  end sub

sub getVideoData(json as object)
    m.RowlistJson=json.getData()
    ?"videojson"m.RowlistJson;m.top.channelClick
    if m.top.channelClick="tv"
        loadTvRowContent()
    else    
        loadTubeRowContent()
    end if
end sub  

sub getListOfCategory(json as object)
    m.categoryJson=json.getData()
    ?"categoryJson"m.categoryJson
    if m.categoryJson<> invalid and m.categoryJson.status ="refresh"
        loginstatus = CreateObject("roRegistrySection", "Americonic")
        loginstatus.Write("isLogin","1")
        loginstatus.Write("token",m.categoryJson.message.token)
        loginstatus.Flush()
        m.global.loginData={
            "token":m.categoryJson.message.token,
            "email":m.categoryJson.message.email,
            "username":m.categoryJson.message.username,
            "level":m.categoryJson.message.level
        }
        m.global.token=m.categoryJson.message.token
        categoryApi()
    else if m.categoryJson<> invalid and m.categoryJson.status ="success"  
        if m.categoryJson<> invalid and m.categoryJson.categories.Count()>0
            videosApi()
        end if
    else if m.categoryJson<> invalid and m.categoryJson.status ="error"  
        dismissProgressDialog()
        loginstatus = CreateObject("roRegistrySection", "Americonic")
        loginstatus.Write("isLogin","0")
        loginstatus.Write("token","")
        loginstatus.Flush()
        m.global.token=""
        m.top.showdashboard=true
    end if
end sub  

sub initMenuListProperties()
  m.menulist.itemComponentName="ItemTemplateMenu"
  m.menulist.drawFocusFeedback = false
  m.menulist.itemSize = [130,100]
  m.menulist.numColumns = 10
  m.menulist.translation = [400,34]
end sub

function initRowListProperties()
    rowHeight = m.screenHeight*0.38
   itemSpacing = m.screenWidth*0.01
   offsetX = m.screenWidth*0.0
   offsetY = m.screenHeight*0.007
   m.contenRowtlist.itemComponentName="ItemTemplateRowList"
   m.contenRowtlist.itemSize = [m.screenWidth,m.screenHeight*0.45]
   m.contenRowtlist.rowItemSize = [[222,124]]
   'm.railsList.rowHeights = [rowHeight+50,rowHeight+50,rowHeight+50,rowHeight+50,rowHeight+50,rowHeight+50,rowHeight+50,rowHeight+50,rowHeight+50,rowHeight+50,rowHeight+50,rowHeight+50,rowHeight+50,rowHeight+50,rowHeight+50]
   m.contenRowtlist.rowLabelFont = Hind_Bold(36)
   m.contenRowtlist.rowFocusAnimationStyle = "floatingFocus"
   m.contenRowtlist.vertFocusAnimationStyle = "fixedFocus"
   m.contenRowtlist.focusBitmapBlendColor = "#3699FF"
   m.contenRowtlist.translation = [96,600]
 end function

sub createMenuUI()
    if m.global.token <> "" and m.global.token<> invalid
        menuJson = ["Dashboard","Americonic Tv","Americonic Tube","My Account","Logout"]
       else
        menuJson = ["Dashboard","Americonic Tv","Americonic Tube","Login"]
    end if
    dataContent  = CreateObject("roSGNode","ContentNode")
    columnSpacings=[]
    for each item in menuJson
       rowContent = dataContent.createChild("CustomContentNode")
       rowContent.title = item
       m.boundingSize.text=item
       if m.boundingSize.boundingRect().width > 130
        space=m.boundingSize.boundingRect().width-90
      else
        space =40
      end if    
      columnSpacings.push(space) 
    end for
    m.menulist.columnSpacings=columnSpacings
    m.menulist.content = dataContent
    m.menulist.setFocus(true)
    m.menulist.jumpToItem=1
 end sub


 function handleMenuItemSelectedEvent(message as object)
    itemSelected = message.GetData()
    if itemSelected=0
        m.global.lastscreen="dashboard"
        m.top.showdashboard=true
    else if itemSelected=1  
        m.global.lastscreen="tvchannel"
        showProgressDialog()
        loadTvRowContent()
    else if itemSelected=2
        m.global.lastscreen="tvchannel"
        showProgressDialog()
        loadTubeRowContent()
    else if itemSelected=3 
        m.global.lastscreen="Account"
        m.top.showAcc=true
    else if itemSelected=4  
        showProgressDialog()
        unLinkDevice()
    end if     
end function

function handleRowItemSelectedEvent(message as object)
    itemSelected = message.GetData()  
    if m.global.loginData <> invalid and m.global.loginData.DoesExist("level") and m.global.loginData.level=1
        m.waitingRoomPlayer.control = "stop"
        'm.waitingRoomPlayer.visible = false
        m.global.removefield("url")
        m.global.addfields({"url": m.contenRowtlist.content.getChild(itemSelected[0]).getChild(itemSelected[1]).url})
        m.global.lastscreen="tvchannel"
        m.top.showPlayer=true  
    else
        m.toastDisplay.message = "Please visit https://www.americonic.com and subscribe to watch!"
        m.toastDisplay.visible = true    
    end if
end function


Function OnkeyEvent(key, press) as Boolean
    result = false
    if press
        if key = "back"
            m.contenRowtlist.content = invalid
            m.top.showdashboard=true
            return true
       else if key="OK"
           return true
       else if key="up"
          m.menulist.setFocus(true)
          return true
       else if key="down"
            m.contenRowtlist.setFocus(true)
          return true
        else if key="left"
          return true
        else if key="right"
          return true
    end if
    end if

End Function