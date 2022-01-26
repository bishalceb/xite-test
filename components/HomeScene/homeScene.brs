sub init()
    setScreenResolution()
    m.dashboardScreen = m.top.findNode("dashboardScreen")
    m.dashboardScreen.ObserveField("isExitApp","handleExitFromApp")
    m.tvChannel = m.top.findNode("tvChannel")
    
    m.playerPage=m.top.findNode("playerPage")
    m.myAccount=m.top.findNode("myAccount")
    m.linkDevice=m.top.findNode("linkDevice")
    m.top.observeField("inputRequest", "roInputData")
    onVisibleChange()
end sub

function onVisibleChange()  
    if m.global.deeplinking =invalid
        showDashoBoard()
    else
        m.global.removefield("url")
        m.global.addfields({"url": "https://stream.mux.com/"+m.global.deeplinking.id+".m3u8"})
        showPlayerScreenComponent()
    end if    
end function

function roInputData()
    m.global.removefield("url")
    m.global.addfields({"url": "https://stream.mux.com/"+m.global.deeplinking.id+".m3u8"})
    'm.global.token="eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImEyZDUxNzRjMjFiNTVhYzM4NThjNDQ5MTQyMzhjZWNlYjhlM2FkY2Q4MWZlMzM3NzZiYWI3NjM2ZTI1OTZjZGUzYzA0NjA4YWZhNmI1MWI5In0.eyJhdWQiOiIxIiwianRpIjoiYTJkNTE3NGMyMWI1NWFjMzg1OGM0NDkxNDIzOGNlY2ViOGUzYWRjZDgxZmUzMzc3NmJhYjc2MzZlMjU5NmNkZTNjMDQ2MDhhZmE2YjUxYjkiLCJpYXQiOjE2NDE5MzM3NTcsIm5iZiI6MTY0MTkzMzc1NywiZXhwIjoxNjczNDY5NzU3LCJzdWIiOiIzOSIsInNjb3BlcyI6W119.JjULQjNqH_D-K4SwdIqZZHygotnoFqfiCEBvYbmHesUV2jl8UQW-Lwo-lUEsYNvAk5snG1WjFgLNlgV1dzps8R7BU4jNuQDBxWC2r5ED53CaBKvGyrdrGVKu7TQkIdnsJedQbovpRNngnrY8xbi0rFPSe1qX7NrCvlmIMlSUMqPy9JPZfthtSE3dSjIjO61SqjNwW1GXHvHBtvu2MWVvyPz_m9d_6VCe-MeeD1bTdovmczks8i3BccoavgwEnLWv9Z3EprzLy6LTU9N71M89bossAO0WxcAcQJuObFaW9F5EhBTqSJoW5iTCMPz5by6n0GWR4rSe8W408ihiQYuFMc3QLDxhbBn8lxz1g4UIPLz9XAXwvmMzV8hb67D71bV_53LneZVTyXcgOqsIRX95wYWVtFNyA9gnAcJ6v942C8LBnpmnJheVu-tHz66d1NucK6SvFV0_OThQCweDema7Z70c6IOAkR5y2GUGvol3sIS1l3L-Mb6BxVqvvdMJZUwgCoITChAiC8VoQdOU_GaeOWogQNFGbcn9DgvylriCsNrNJNLI5ND-SJprcuU6NEmHDPy5T7ZC4Wjzwqz91DHB2ODFTQ_31FQqEcsNOF2N8_Mvw2zf-lmSfmpGizBpo6e_D2zp7kOGDJHL4KeAFDhWi0-n2FgcGeXCLbSro5EW6Ss"
    showPlayerScreenComponent()
end function

function showLinkDevice()
    m.linkDevice.visible = true
    m.dashboardScreen.visible = false
    m.playerPage.visible =false
    m.tvChannel.visible = false
    m.myAccount.visible = false
end function    

function showAccountPage()
    m.dashboardScreen.visible = false
    m.playerPage.visible=false
    m.tvChannel.visible = false
    m.myAccount.visible = true
    m.linkDevice.visible = false
end function

function showTvChannel()
    m.tvChannel.channelClick=m.dashboardScreen.channelClick
    m.tvChannel.visible = true
    m.dashboardScreen.visible = false
    m.playerPage.visible=false
    m.myAccount.visible = false
    m.linkDevice.visible = false
end function

function showDashoBoard()
    m.dashboardScreen.visible = true
    m.playerPage.visible=false
    m.tvChannel.visible = false
    m.myAccount.visible = false
    m.linkDevice.visible = false
end function


function showPlayerScreenComponent()
    m.playerPage.visible=true
    m.dashboardScreen.visible = false
    m.tvChannel.visible = false
    m.myAccount.visible = false
    m.linkDevice.visible = false
end function


function handleExitFromApp(isExitAppEvent as object)
    isExitApp = isExitAppEvent.getData()
    ?"exit"
    m.top.isExitFromApp = isExitApp
end function


