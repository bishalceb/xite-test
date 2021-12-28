sub init()

    m.homeScreenComponent = m.top.findNode("homeScreenComponent")
    m.homeScreenComponent.ObserveField("selectedEvent","navigateToDetailsScreen")
    m.homeScreenComponent.ObserveField("isExitApp","handleExitFromApp")
    
    m.playerPage=m.top.findNode("playerPage")

    m.bgImage = m.top.findNode("bgImage")
    m.bgImage.width = m.screenWidth
    m.bgImage.height = m.screenHeight
    m.bgImage.uri = baseImageUrl()+"background_screen.png"

    m.top.ObserveField("showHome","showHomeScreenComponent")
    onVisibleChange()
end sub

function onVisibleChange()   
    showHomeScreenComponent()
end function



function showHomeScreenComponent()
    m.global.removefield("optionSelected")
    m.global.removefield("list")
    m.global.addfields({"list" : "menu","optionSelected" : 1})
    m.homeScreenComponent.visible = true
    m.playerPage.visible=false
end function


function showPlayerScreenComponent()
    ?"come in Player"
    m.homeScreenComponent.visible = false
    m.playerPage.visible=true
end function




function handleExitFromApp(isExitAppEvent as object)
    isExitApp = isExitAppEvent.getData()
    m.top.isExitFromApp = isExitApp
end function

function handleExitFromAppViaSkip(isExitAppEvent as object)
    isExitApp = isExitAppEvent.getData()
    m.top.isExitFromApp = isExitApp
end function

function navigateToDetailsScreen(selectedEvent as object)
    selectedContent = selectedEvent.getData()
    node = selectedEvent.getRoSGNode()
    m.homeScreenComponent.visible = false

    if node.id ="homeScreenComponent" then
        lastScreen = "HomeScreen"
    else if node.id ="searchScreen" then
        lastScreen = "SearchScreen"
    else
        lastScreen = "HomeScreen"
    end if
    m.detailsScreen.lastScreen = lastScreen
    m.detailsScreen.visible = true
end function
