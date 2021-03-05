﻿#include %A_ScriptDir%\src\BaseballAutoConfig.ahk
#include %A_ScriptDir%\src\BaseballAuto.ahk
#include %A_ScriptDir%\src\BaseballAutoGui.ahk

DEFAULT_APP_ID:="(Hard)"

BooleanDebugMode:=true

baseballAutoConfig :=new BaseballAutoConfig( A_ScriptDir "/Config/main.ini" )
baseballAutoGui := new BaseballAutoGui("baseball")
baseballAuto := new BaseballAuto()


baseballAutoConfig.getLastGuiPosition( positionX, positionY )
baseballAutoGui.show( positionX , positionY )

^F9::
    baseballAuto.start()
return 

^F10::
    baseballAutoConfig.saveConfig()
    baseballAuto.stop()
return 

^F12:: 
    WinActivate BaseAuto.ahk
    Send, ^s

    global baseballAuto
    baseballAuto.reload()
    Reload
return 

baseballGuiClose:
    {
        global baseballAutoGui, baseballAutoConfig
        title := baseballAutoGui.getTitle() 
        WinGetPos, posx, posy, width, height, %title% 
        baseballAutoConfig.setLastGuiPosition(posx, posy)
        
        ExitApp
    }

    #include %A_ScriptDir%\src\mode\TestFunction.ahk