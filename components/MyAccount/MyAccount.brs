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
    
    m.Dasboardtext =m.top.findNode("Dasboardtext")   
    m.Dasboardtext.font = Hind_Bold(36)
    m.hometext =m.top.findNode("hometext") 
    m.hometext.font = Hind_Regular(28)  
    m.dashsmall =m.top.findNode("dashsmall")   
    m.dashsmall.font = Hind_Bold(30)  

    m.membershiptext =m.top.findNode("membershiptext")   
    m.membershiptext.font = Hind_Bold(36)
    m.statusText =m.top.findNode("statusText") 
    m.statusText.font = Hind_Regular(30)  
    m.statusValue =m.top.findNode("statusValue")   
    m.statusValue.font = Hind_Regular(30)
    m.memberstarttext =m.top.findNode("memberstarttext")   
    m.memberstarttext.font = Hind_Regular(30)
    ' m.userNameText =m.top.findNode("userNameText")   
    ' m.userNameText.font = Hind_Regular(30)
    ' m.userValue =m.top.findNode("userValue")   
    ' m.userValue.font = Hind_Regular(30)
  

    m.top.ObserveField("visible","onVisibleChange")
    m.top.ObserveField("unlinkResponse","Logout")
end sub    

function onVisibleChange()
    if m.top.visible then
      ?" m.global.loginData" m.global.loginData
        if  m.global.loginData <> invalid and m.global.loginData.DoesExist("level") and m.global.loginData.level=0
          m.statusValue.text="Unsubscribe"
          'm.userValue.text=m.global.loginData.username
        else if m.global.loginData <> invalid
          ?"m.global.loginData.username"m.global.loginData.username
          'm.userValue.text=m.global.loginData.username
          m.statusValue.text="Your Purchase AmericonicTv:Lifetime"  
        end if  
        createMenuUI()
    end if
end function


sub Logout(unlinkres)
  dismissProgressDialog()
  unlinkres=unlinkres.getData()
  if unlinkres.status="success"
    m.top.showdashboard=true
  end if  
end sub  

function initMenuListProperties()
  m.menulist.itemComponentName="ItemTemplateMenu"
  m.menulist.drawFocusFeedback = false
  m.menulist.itemSize = [130,100]
  m.menulist.numColumns = 10
  m.menulist.translation = [400,34]
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
    m.menulist.jumpToItem=3
 end function



function handleMenuItemSelectedEvent(message as object)
  itemSelected = message.GetData()
  if itemSelected=0
    m.top.showdashboard=true
  else if itemSelected=1  
    m.top.channelClick="tv"
    m.top.showtvchannel=true
  else if itemSelected=2
    m.top.channelClick="tube"
    m.top.showtvchannel=true
  else if itemSelected=3 
    m.top.showAcc=true
  else if itemSelected=4  
    showProgressDialog()
    unLinkDevice()  
  end if     
end function


Function OnkeyEvent(key, press) as Boolean
    result = false
    if press
        if key = "back"
            m.top.showdashboard=true
            return true
       else if key="OK"
           return true
       else if key="up"
          m.menulist.setFocus(true)
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