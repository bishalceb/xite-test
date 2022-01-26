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
    m.channellist =m.top.findNode("channellist")    
    m.channellist.observeField("itemSelected","handleChannelItemSelectedEvent") 
    initChannelListProperties()

    m.Dasboardtext =m.top.findNode("Dasboardtext")   
    m.Dasboardtext.font = Hind_Bold(36)
    m.hometext =m.top.findNode("hometext") 
    m.hometext.font = Hind_Regular(28)  
    m.dashsmall =m.top.findNode("dashsmall")   
    m.dashsmall.font = Hind_Bold(30)
    m.linkdeviceRect =m.top.findNode("linkdeviceRect")  
    m.linktext =m.top.findNode("linktext")  
    m.linktext.font = Hind_Bold(30)
    m.linkbtntext =m.top.findNode("linkbtntext") 
    m.linkbtntext.font = Hind_Regular(28)    
    m.linkbtn =m.top.findNode("linkbtn") 
  

    m.top.ObserveField("visible","onVisibleChange")
    m.top.ObserveField("userApi","userApiResponse")
    m.top.ObserveField("unlinkResponse","Logout")
end sub    

function onVisibleChange()
    if m.top.visible then
        if m.global.token <> "" and m.global.token<> invalid
          calluserApi()
          m.linkdeviceRect.visible=false
        else  
          m.linkdeviceRect.visible=true
        end if   
        createMenuUI()
        createChannelListUI()
    end if
end function

sub Logout(unlinkres)
  dismissProgressDialog()
  unlinkres=unlinkres.getData()
  if unlinkres.status="success"
    m.linkdeviceRect.visible=true
    createMenuUI()
    createChannelListUI()
  end if  
end sub  

function userApiResponse(res)
  res=res.getData()
  ?"res"res.user_info
  if res <> invalid and res.status ="refresh"
    m.global.loginData={
      "token":res.message.token,
      "email":res.message.email,
      "username":res.message.username,
      "level":res.message.level
  }
    calluserApi()
  else if res <> invalid and res.status ="success"
    m.global.loginData={
      "token":res.user_info.token,
      "email":res.user_info.email,
      "username":res.user_info.username,
      "level":res.user_info.level
  }
  else if m.categoryJson<> invalid and m.categoryJson.status ="error"   
    loginstatus = CreateObject("roRegistrySection", "Americonic")
    loginstatus.Write("isLogin","0")
    loginstatus.Write("token","")
    loginstatus.Flush()
    m.global.token=""
    m.linkdeviceRect.visible=true
    createMenuUI()
    createChannelListUI()
  end if  
end function  

function initMenuListProperties()
  m.menulist.itemComponentName="ItemTemplateMenu"
  m.menulist.drawFocusFeedback = false
  m.menulist.itemSize = [130,100]
  m.menulist.numColumns = 10
  m.menulist.translation = [400,34]
end function

function initChannelListProperties()
  m.channellist.itemComponentName="ItemTemplateChannelList"
  m.channellist.itemSize = [600,700]
  m.channellist.numColumns = 2
  m.channellist.translation = [100,340]
end function

  function createMenuUI()
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
    'm.menulist.jumpToItem=
 end function

 function createChannelListUI()
  dataContent  = CreateObject("roSGNode","ContentNode")
  channelJsonTitle=["AmerIconic Tv","Americonic Tube"]
  channelJsonDesc=["At AMERiconic TV we simply want to make entertainment entertaining again","Our AMERiconic TUBE platform is under development! Check back soon."]
  icon=["pkg:/locale/default/images/americonic_logo.png","pkg:/locale/default/images/americonictube_logo.png"]
  if m.global.token <>"" and m.global.token <>invalid
    btntext=["Launch AmericonicTv","Launch AmericonicTube"]
  else
    btntext=["Account not linked","Account not linked"]
  end if  
  columnSpacings=[]
  for i=0 to channelJsonTitle.Count()-1
     rowContent = dataContent.createChild("CustomContentNode")
     rowContent.title = channelJsonTitle[i] 
     rowContent.description = channelJsonDesc[i] 
     rowContent.icon = icon[i]
     rowContent.btntext=btntext[i]
    columnSpacings.push(40) 
  end for
  m.channellist.columnSpacings=columnSpacings
  m.channellist.content = dataContent
  'm.menulist.jumpToItem=
end function

function handleMenuItemSelectedEvent(message as object)
  itemSelected = message.GetData()
  if itemSelected=0
  else if itemSelected=1  
    m.top.channelClick="tv"
    m.top.showtvchannel=true
  else if itemSelected=2
    m.top.channelClick="tube"
    m.top.showtvchannel=true
  else if itemSelected=3 
    if m.global.token <> "" and m.global.token<> invalid
    m.top.showAcc=true
    else
      m.top.showLinkDevice=true
    end if  
  else if itemSelected=4  
    showProgressDialog()
    unLinkDevice()
  end if     
end function

function handleChannelItemSelectedEvent(message as object)
  itemSelected = message.GetData()
  if m.global.token <> "" and m.global.token<> invalid
    if itemSelected=0
      m.top.channelClick="tv"
      m.top.showtvchannel=true
    else if itemSelected=1
      m.top.channelClick="tube"
      m.top.showtvchannel=true
    end if    
  else
    m.top.showLinkDevice=true
  end if  
end function


Function OnkeyEvent(key, press) as Boolean
    result = false
    if press
        if key = "back"
            showExitConfirmationPopup("Exit Confirmation","Do you really want to exit'?")
            return true
       else if key="OK"
          if m.linkbtn.hasFocus()
            m.top.showLinkDevice=true
          end if  
           return true
       else if key="up"
          if m.linkdeviceRect.visible and m.channellist.hasFocus()
          m.linkbtn.setFocus(true)
          m.linkbtn.blendColor="#3699FF"
          else if m.linkbtn.hasFocus() or m.channellist.hasFocus()
            m.linkbtn.blendColor="#1b1b29"
            m.menulist.setFocus(true)
          end if
          return true
       else if key="down"
          if m.linkdeviceRect.visible and m.menulist.hasFocus()
              m.linkbtn.setFocus(true)
              m.linkbtn.blendColor="#3699FF"
          else if m.linkbtn.hasFocus() or m.menulist.hasFocus()
            m.linkbtn.blendColor="#1b1b29"
            m.channellist.setFocus(true)
          end if
          return true
        else if key="left"
          return true
        else if key="right"
          return true
    end if
    end if

End Function