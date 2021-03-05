﻿#include %A_ScriptDir%\src\util\AutoLogger.ahk
#include %A_ScriptDir%\src\util\ActiveImageSearcher.ahk
#include %A_ScriptDir%\src\util\InActiveInputController.ahk

class MC_GameController{
    logger:= new AutoLogger( "Controll" ) 
    extensions:="png,bmp"

    __NEW(){
        global DEFAULT_APP_ID
        this.imageSearcher := new ActiveImageSearcher( this.logger )
        this.controller := new InActiveInputController( this.logger )        
        this.currentTargetTitle:=DEFAULT_APP_ID
    }
    setActiveId(title){
        this.currentTargetTitle:=title
        this.imageSearcher.setActiveId(title)
        this.controller.setActiveId(title)
    }
    checkAppPlayer(){
        return this.imageSearcher.possible()
    }
    searchImageFolder( targetFolder, needLog=true) {

        if( this.internalSearchImageFolder( targetFolder, fileName, posX, posY ) ){
            this.logger.debug( fileName "가 존재합니다." )
            return true
        }else{
            if( needLog ){
                this.logger.debug( "폴더 [ " targetFolder " ]에 존재하는 이미지가 없습니다." )
            }
            return false
        } 
    }

    internalSearchImageFolder( targetFolder, ByRef fileName, ByRef posX, ByRef posY ) {

        Loop, %A_ScriptDir%\Resource\Image\%targetFolder%\*
        {
            if A_LoopFileExt in % this.extensions
            {
                fileName=%targetFolder%\%A_LoopFileName%
                If( this.imageSearcher.funcSearchImage( posX, posY, fileName) = true ) { 
                    return true
                } 
            }
        } 
        return false
    }

    searchAndClickFolder( targetFolder, relateX=0, relateY=0 , boolDelay=true ) {
        if( this.internalSearchImageFolder( targetFolder, fileName, imgX, imgY ) ){ 

            imgX:=imgX+relateX
            imgY:=imgY+relateY

            this.randomClick(imgX, imgY, 0, 15, boolDelay)
            Return true

        }else{
            this.logger.debug( "No " targetFolder " 을 찾지 못했습니다. " )
            return false
        } 
    }

    click( positionX, positionY, needDelay ){
        this.controller.click(positionX, positionY)
        if( needDelay ){
            this.sleep(2)
        }
    }

    randomClick( positionX, positionY , randomStart:=0, randomEnd:=15 , needDelay:=true ){
        Random, randFirst, randomStart, randomEnd
        Random, randSecond, randomStart, randomEnd

        positionX+=randFirst
        positionY+=randSecond
        ; ToolTip, % "TargetX = " positionX ", targetY= "positionY
        ; MouseMove %positionX%, %positionY%
        this.click( positionX,positionY, needDelay )		
    }

    sleep( secSleep ){
        msec:=secSleep*1000
        Sleep, %msec%
    }

    ;이미지 찾을때까지 대기후 클릭
    ; delay & 횟수가 필요
    waitingImageAndClickFolder( targetFolder , checkLimitCount:= 60, sleepDelay:= 2) {
        Loop %checkLimitCount%
        {
            If ( this.searchAndClickFolder( targetFolder ) = true ) {
                return true
            }
            this.sleep( sleepDelay )

            ; if( A_Index > checkLimitCount ){
            ; return false
            ; }
        }
        return false
    }
    clickUntilImageFound( targetFolder, posX,posY, limitCount:=5, sleepDelay:= 3) {

        Loop %limitCount%
        {
            if( this.searchImageFolder( targetFolder ) ){
                return true
            }else{
                this.randomClick( posX, posY )			
            }
            this.sleep( sleepDelay ) 
        }
        return false
    }
    clickRatioPos( ratioX, ratioY, maxSize:=40 ) {
        WinGetPos, , , winW, winH, % this.currentTargetTitle	

        targetX:= winW * ratioX
        targetY:= winH * ratioY
        ; ToolTip, % "WinW = " winW ", WinH = " winH ", TargetX = " targetX ", targetY= "targetY
        this.randomClick(targetX, targetY, 0, maxSize, true)
    }
}