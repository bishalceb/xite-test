sub init()
    setScreenResolution()
    m.loginStatusTimer = m.top.findNode("loginStatusTimer")
    m.loginStatusTimer.ObserveField("fire","checkLoginDoneInWebisite")
    m.topImage = m.top.findNode("topImage")
    m.topImage.uri=baseImageUrl()+"logo.png"
    m.sign_in_title = m.top.findNode("sign_in_title")
    m.link_signin_title = m.top.findNode("link_signin_title")
    m.visitlink_signin_title = m.top.findNode("visitlink_signin_title")
    m.enter_code_title = m.top.findNode("enter_code_title")
    m.code_text1 = m.top.findNode("code_text1")
    m.code_text2 = m.top.findNode("code_text2")
    m.code_text3 = m.top.findNode("code_text3")
    m.code_text4 = m.top.findNode("code_text4")
    m.code_text5 = m.top.findNode("code_text5")
    m.code_text6 = m.top.findNode("code_text6")
    'To show message we use below component
    m.toastDisplay = m.top.findNode("toastComponent")
    m.toastDisplay.observeField("dismissed", "handleToastDismissedEvent")

    setUpFontSize() 
    m.top.ObserveField("chekLoginStatus","getLoginResponse")
    m.top.ObserveField("code","getSignInCode")
    m.top.ObserveField("unlink","unlinkmessage")
    m.top.ObserveField("visible","onVisibleChange")
end sub    

sub onVisibleChange()
    if m.top.visible then
        m.sign_in_title.setFocus(true)
        showProgressDialog()
        genrateCode()
    end if
end sub

sub unlinkmessage(re)
    dismissProgressDialog()
    re=re.getData()
end sub    

sub getSignInCode(code)
    dismissProgressDialog()
    signInCode=code.getData()
    if signInCode <> invalid
        signInCodeInArray = signInCode.tostr().Split("")
        if signInCodeInArray <> invalid and signInCodeInArray.Count()=6
            m.code_text1.text=signInCodeInArray[0]
            m.code_text2.text=signInCodeInArray[1]
            m.code_text3.text=signInCodeInArray[2]
            m.code_text4.text=signInCodeInArray[3]  
            m.code_text5.text=signInCodeInArray[4]  
            m.code_text6.text=signInCodeInArray[5]  
        end if    
        m.loginStatusTimer.control="start"
        checkLoginDoneInWebisite()
    end if
end sub    

sub checkLoginDoneInWebisite()
    checkLoginStatus()
end sub    

sub getLoginResponse(loginresponse)
    loginresponse=loginresponse.getData()
    if loginresponse <> invalid and loginresponse.status="success"
        loginstatus = CreateObject("roRegistrySection", "Americonic")
        loginstatus.Write("isLogin","1")
        loginstatus.Write("token",loginresponse.userInfo.token)
        loginstatus.Flush()
        m.global.loginData={
            "token":loginresponse.userInfo.token,
            "email":loginresponse.userInfo.email,
            "username":loginresponse.userInfo.username,
            "level":loginresponse.userInfo.level
        }
        m.global.token=loginresponse.userInfo.token
        m.loginStatusTimer.control="stop"
        ?"m.global.loginData"m.global.loginData
        m.top.showdashboard=true
    end if        
end sub     


sub setUpFontSize()
    m.sign_in_title.font = Hind_Regular(75)
    m.link_signin_title.font = Hind_Regular(30)
    m.visitlink_signin_title.font = Hind_Bold(30)
    m.enter_code_title.font = Hind_Regular(30)
    m.code_text1.font = Hind_Regular(60.5)
    m.code_text2.font = Hind_Regular(60.5)
    m.code_text3.font = Hind_Regular(60.5)
    m.code_text4.font = Hind_Regular(60.5)
    m.code_text5.font = Hind_Regular(60.5)
    m.code_text6.font = Hind_Regular(60.5)
end sub

Function OnkeyEvent(key, press) as Boolean
    result = false
    if press
        if key = "back"
            m.loginStatusTimer.control="stop"
            m.top.showdashboard=true
            return true
        end if
    end if

End Function