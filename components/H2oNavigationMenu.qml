/****************************************************************************
** H2oNavigationMenu.qml
**
** Created on: 2017-10-31
**
** Author: BW
**
** Copyright (C) 2016 Hach DDC
**              All Rights Reserved
**
**
** Notes:
**
****************************************************************************/

import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Item {
    id:root
    width: 240
    height: parent.height
    property int pItemHeight: 50
    property int cItemHeight: 48
    property alias listView: listStackView

    //number of current children
    property int currentChildrenCount:0
    //mumber of current parent
    property int currentparentcount:appTypemodel.count

    //space of parents
    property int parentItemSpacing:2

    //message to return the index of sub-controller after clicked for selection
    signal itemClicked(var name)

    property ListModel appsmodel
    property ListModel appTypemodel

    property list<Item> pageList

    ExclusiveGroup {
        id: parentExclusiveGroup
    }

    ExclusiveGroup {
        id: childExclusiveGroup
    }

    //parent list view insert children list
    Column{
        id:parentcol
        spacing: parentItemSpacing
        Repeater{
            model:appTypemodel
            delegate:Component{
                id:content

                Item{
                    id:parentcontent
                    property int cindex:index

                    property bool checked: false
                    property ExclusiveGroup exclusiveGroup: parentExclusiveGroup

                    onExclusiveGroupChanged: {
                        if(exclusiveGroup)
                            exclusiveGroup.bindCheckable(parentcontent)
                    }

                    onCheckedChanged: {
                        //console.debug("onCheckedChanged checked:"+checked)
                    }

                    width: root.width
                    height: appTypemodel.get(parentcontent.cindex).shown?root.pItemHeight+root.cItemHeight*appcol.childrenCount:root.pItemHeight
                    Behavior on height{
                        PropertyAnimation{
                            properties: "height"
                            duration: 350
                            easing.type:Easing.OutQuart
                        }
                    }
                    Rectangle{
                        id:typebnt
                        //width: pma.containsMouse?root.width:root.width-20
                        width: pma.containsMouse?root.width:root.width
                        height: root.pItemHeight
                        //radius: pma.containsMouse?0:height/2
                        color: parentcontent.checked ? "#3ebdf2":"#3ebdf2"

                        /*Behavior on radius{
                            PropertyAnimation{
                                properties: "radius"
                                duration: 250
                            }
                        }*/
                        /*Behavior on width{
                            PropertyAnimation{
                                properties: "width"
                                duration: 250
                            }
                        }*/
                        Text {
                            id: typetext
                            text: qsTr(appType)+translator.tr
                            anchors.centerIn: parent
                            color: "white"//"#12ccaa"
                            font: mainTheme.smallFont
                        }
                        MouseArea{
                            id:pma
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {

                                parentcontent.checked = true;

                                //the parent show children
                                if(appTypemodel.get(index).shown==false){
                                    for(var a=0;a<appTypemodel.count;a++){
                                        appTypemodel.setProperty(a,"shown",false)
                                    }
                                    //show children
                                    appTypemodel.setProperty(index,"shown",true)
                                    //tell root the number of child to update the root length
                                    var childrencount=0;
                                    for(var c=0;c<appsmodel.count;c++){
                                        if(appTypemodel.get(parentcontent.cindex).appType==appsmodel.get(c).appType){
                                            childrencount++;
                                        }
                                    }
                                    currentChildrenCount=childrencount
                                    if(currentChildrenCount==0) {
                                        itemClicked(name);
                                    }
                                }
                                else{
                                    appTypemodel.setProperty(index,"shown",false)
                                }
                            }
                        }
                    }


                    //children
                    Column{
                        id:appcol
                        width: root.width
                        clip: true
                        anchors.top:typebnt.bottom
                        property int childrenCount:0
                        height: appTypemodel.get(parentcontent.cindex).shown?root.cItemHeight*childrenCount:0
                        Behavior on height{
                            PropertyAnimation{
                                properties: "height"
                                duration: 350
                                easing.type: Easing.OutQuart
                            }
                        }

                        Repeater{
                            id:apprep
                            model: ListModel{
                                id:subModel
                                Component.onCompleted: {
                                    for(var c=0;c<appsmodel.count;c++){
                                        if(appTypemodel.get(parentcontent.cindex).appType==appsmodel.get(c).appType){
                                            append({"appName":appsmodel.get(c).appName,
                                                       "appType":appsmodel.get(c).appType,
                                                       "name": appsmodel.get(c).name,
                                                       "title": appsmodel.get(c).title,
                                                       "page": appsmodel.get(c).page,
                                                       "originIndex":c})
                                                        //originIndex restore the origin position of Component, it return the oppsite postion of children
                                        }
                                    }
                                    appcol.childrenCount=subModel.count
                                }
                            }

                            delegate: Rectangle{
                                id:itemconent
                                width: root.width
                                height: root.cItemHeight
                                color: "#0098db"

                                property bool checked: false
                                property ExclusiveGroup exclusiveGroup: childExclusiveGroup

                                onExclusiveGroupChanged: {
                                    if(exclusiveGroup)
                                        exclusiveGroup.bindCheckable(itemconent)
                                }

                                onCheckedChanged: {
                                    //console.debug("onCheckedChanged child checked:"+checked)
                                }

                                Rectangle{
                                    width: parent.width-20
                                    height: parent.height-10
                                    color: "#313131"//"#331233df"
                                    radius: 5
                                    anchors.centerIn: parent
                                    //scale: childrenma.containsMouse?1:0
                                    scale: itemconent.checked ? "1":"0"
                                    /*Behavior on scale {
                                        PropertyAnimation {
                                            properties: "scale"
                                            duration: 350
                                            easing.type: Easing.OutBack
                                        }
                                    }*/
                                }

                                MouseArea{
                                    id:childrenma
                                    hoverEnabled: true
                                    anchors.fill: parent
                                    onClicked: {
                                        listStackView.push({item: pageList[page], immediate: true, replace: true})
                                        //root send the signal and return the index
                                        itemClicked(name)
                                        itemconent.checked = true
                                    }
                                }
                                Text{
                                    text: qsTr(appName)+translator.tr
                                    anchors.centerIn: parent
                                    color: "white"//"#444444"
                                    font: mainTheme.smallFont
                                    style: Text.Outline
                                    styleColor: "#000000"
                                }
                                Rectangle{
                                    width: parent.width-10
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    height: 2
                                    color: "#000000"
                                    visible: index!=0
                                    Rectangle{
                                        width: parent.width
                                        height: 1
                                        y:1
                                        color: "#222222"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }


    }

    Rectangle {
        x: 240
        y: 0
        width: parent.height
        height: 8 //* Flat.FlatStyle.scaleFactor
        rotation: 90
        //anchors.left: parent.right
        transformOrigin: Item.TopLeft

        gradient: Gradient {
            GradientStop {
                color: Qt.rgba(0, 0, 0, 0.15)
                position: 0
            }
            GradientStop {
                color: Qt.rgba(0, 0, 0, 0.05)
                position: 0.5
            }
            GradientStop {
                color: Qt.rgba(0, 0, 0, 0)
                position: 1
            }
        }
    }

    StackView {
        id: listStackView
        x: root.width
        y: 0
        width: parent.width - root.width
        height: parent.height
        //initialItem: pageList[0]
        //onCurrentItemChanged: message.subTitleMessage = pageModel.get(0).title
    }
}

