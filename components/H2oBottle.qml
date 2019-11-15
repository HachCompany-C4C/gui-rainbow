/****************************************************************************
** H2oBottle.qml - Bottle
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

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "bottle.js" as Bottle

Item {
    id: control
    //border.color: "black"
    //border.width: 1
    width: 130
    height: 135
    property string title: "text"
    property real persent: 0.1
    property real volumnDefault: 5000
    property string bottleColor: "yellow"
    property string volumn: (persent*volumnDefault).toFixed()
    property real volumnMax: 2000
    property real maxPersent: (volumnMax/volumnDefault).toFixed(2)
    //color: "transparent"
    //property bool unlinked: true

    //signal editDone(var inputStr)
    //signal linkedbottle()
    //signal dislinkedbottle()
    signal editVolDone()
    signal slidered(var persent)

    function updateStatus(psent, def)
    {
        persent = psent;
        volumnDefault = def;
        volumn = (persent*volumnDefault).toFixed();
    }

    Text {
        id: txt
        anchors.left: parent.left
        anchors.leftMargin: 30
        y: 10
        text: control.title
    }

    Rectangle {
        id: background
        //border.color: "black"
        //border.width: 1
        anchors.top: txt.bottom
        anchors.horizontalCenter: txt.horizontalCenter
        width: 62
        height: control.height
        color: "transparent"

        Canvas {
            id: canvas
            width: parent.width
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom

            antialiasing: true

            property string strokeStyle: "steelblue"
            property string fillStyle: control.bottleColor
            property bool fill: true
            property bool stroke: true
            property real alpha: 1
            property real cscale: 1
            property real rotate: 0
            property int frame: 0
            //property real persent: control.persent
            property real remHeight: control.persent > 1.0 ? 261.39288 : 261.39288*control.persent

            onFillChanged: requestPaint();
            onStrokeChanged: requestPaint();
            onAlphaChanged: requestPaint();
            onScaleChanged: requestPaint();
            onRotateChanged: requestPaint();
            onRemHeightChanged: requestPaint();

            onPaint: {
                var ctx = canvas.getContext('2d');
                var originX = 0; //canvas.width/2 + 10
                var originY = 0; //canvas.height/2 + 10

                ctx.save();
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                ctx.globalAlpha = canvas.alpha;
                ctx.globalCompositeOperation = "source-over";

                ctx.translate(originX, originY)
                ctx.scale(canvas.cscale, canvas.cscale);
                ctx.rotate(canvas.rotate);
                ctx.translate(-originX, -originY)

                ctx.strokeStyle = control.color; //Qt.rgba(.3, .3, .3,1);
                ctx.lineWidth = 1;

                for (var i = 0; i < Bottle.bottle.length; i++) {
                    if (Bottle.bottle[i].width != undefined)
                        ctx.lineWidth = Bottle.bottle[i].width;

                    if (Bottle.bottle[i].path != undefined)
                        ctx.path = Bottle.bottle[i].path;

                    if (Bottle.bottle[i].fill != undefined) {
                        ctx.fillStyle = Bottle.bottle[i].fill;
                        ctx.fill();
                    }

                    if (Bottle.bottle[i].stroke != undefined) {
                        ctx.strokeStyle = Bottle.bottle[i].stroke;
                        ctx.stroke();
                    }
                }

                //ctx.fillStyle = canvas.fillStyle;
                //ctx.fillRect(2.1971455, 196.43648, 99.999237, 130.39288); //326.82936
                //ctx.fillRect(2.1971455, 326.82936-remHeight, 99.999237, remHeight);

                ctx.save();
                //ctx.translate(0,0);
                //ctx.translate(0,0);
                //ctx.scale(0,0);
                //ctx.translate(0,0);

                //canvas.scale = 1;

                ctx.restore();
            }

            /*MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.debug("QML::H2oBottle open input pad")
                }
            }*/
        }
    }

    Rectangle {
        id: content
        //border.color: "black"
        //border.width: 1
        anchors.bottom: background.bottom
        anchors.horizontalCenter: txt.horizontalCenter
        width: 62
        height: control.persent > 1.0 ? control.height : control.height*control.persent
        clip: true
        color: "transparent"

        Canvas {
            id: canvasContent
            width: parent.width
            height: control.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            //anchors.bottomMargin: canvasContent.height - content.height

            antialiasing: true

            property string strokeStyle: "steelblue"
            property string fillStyle: control.bottleColor
            property bool fill: true
            property bool stroke: true
            property real alpha: 1
            property real cscale: 1
            property real rotate: 0
            property int frame: 0
            //property real persent: control.persent
            property real remHeight: control.persent > 1.0 ? 261.39288 : 261.39288*control.persent

            onFillChanged: requestPaint();
            onStrokeChanged: requestPaint();
            onAlphaChanged: requestPaint();
            onScaleChanged: requestPaint();
            onRotateChanged: requestPaint();
            onRemHeightChanged: requestPaint();

            onPaint: {
                var ctx = canvasContent.getContext('2d');
                var originX = 0; //canvas.width/2 + 10
                var originY = 0; //canvas.height/2 + 10

                ctx.save();
                ctx.clearRect(0, 0, canvasContent.width, canvasContent.height);
                ctx.globalAlpha = canvasContent.alpha;
                ctx.globalCompositeOperation = "source-over";

                ctx.translate(originX, originY)
                ctx.scale(canvasContent.cscale, canvasContent.cscale);
                ctx.rotate(canvasContent.rotate);
                ctx.translate(-originX, -originY)

                ctx.strokeStyle = control.color; //Qt.rgba(.3, .3, .3,1);
                ctx.lineWidth = 1;

                for (var i = 0; i < Bottle.bottle.length; i++) {
                    if (Bottle.bottle[i].width != undefined)
                        ctx.lineWidth = Bottle.bottle[i].width;

                    if (Bottle.bottle[i].path != undefined)
                        ctx.path = Bottle.bottle[i].path;

                    if (Bottle.bottle[i].fill != undefined) {
                        ctx.fillStyle = canvasContent.fillStyle; //Bottle.bottle[i].fill;
                        ctx.fill();
                    }

                    if (Bottle.bottle[i].stroke != undefined) {
                        ctx.strokeStyle = Bottle.bottle[i].stroke;
                        ctx.stroke();
                    }
                }

                //ctx.fillStyle = canvasContent.fillStyle;
                //ctx.fillRect(2.1971455, 196.43648, 99.999237, 130.39288); //326.82936
                //ctx.fillRect(2.1971455, 326.82936-remHeight, 99.999237, remHeight);

                ctx.save();
                //ctx.translate(0,0);
                //ctx.translate(0,0);
                //ctx.scale(0,0);
                //ctx.translate(0,0);

                //canvasContent.scale = 1;

                ctx.restore();
            }

            /*MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.debug("QML::H2oBottle open input pad")
                }
            }*/
        }
    }

    Text {
        anchors.horizontalCenter: txt.horizontalCenter
        anchors.top: txt.bottom
        anchors.topMargin: 50
        text: ""+(control.persent*100).toFixed(0)+"%"
    }

    Text {
        font.pixelSize: 14
        anchors.horizontalCenter: txt.horizontalCenter
        anchors.top: txt.bottom
        anchors.topMargin: 70
        text: "" + control.volumn + "mL"
    }

    Slider {
        anchors.centerIn: background
        width: background.width
        height: background.height
        orientation: Qt.Vertical
        maximumValue: maxPersent
        minimumValue: 0.00
        stepSize: 0.01
        value: control.persent
        onPressedChanged: {
            if(!pressed) {
                control.persent = value;
                console.debug("QML::H2oBottle volumn default: " + volumnDefault);
                console.debug("QML::H2oBottle volumn default: " + volumnMax);
                var temp;
                if(control.persent == maxPersent)
                {
                    temp = volumnMax;
                } else {
                    temp = control.persent * volumnDefault;
                }

                if(temp < 0) temp = 0;
                volumn = temp.toFixed()
                slidered(value);
            }
        }

        style: SliderStyle {
            groove: Rectangle {
                color: "transparent"
            }

            handle: Rectangle {
                color: "transparent"
            }
        }
    }

    /*Rectangle {
        id: linked
        x: canvas.x+42
        y: 75
        height: 50
        width: 20
        border.color: "black"
        border.width: 1
        Rectangle {
            id:leftlink
            x:3
            y:3
            height: 20
            width: 14
            radius: 10
            opacity: 0.5
            border.color: "black"
            border.width: 2
        }
        Rectangle {
            id:rightlink
            x:3 //linked.width-23
            y:linked.height-23//3
            height: 20
            width: 14
            radius: 10
            opacity: 0.5
            border.color: "black"
            border.width: 2
        }
        Rectangle {
            id: middlelink
            x:7
            y:10
            border.color: "black"
            border.width: 2
            height: 30
            width: 6
            radius: 10
            opacity: 0.5
            //color: "black"
        }

        Rectangle {
            id: breaklink
            x: 2
            y: 21
            height: 8
            width: 16
            color: "white"
            visible: control.unlinked
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(breaklink.visible === false)
                {
                    breaklink.visible = true
                    dislinkedbottle()
                }
                else
                {
                    breaklink.visible = false
                    linkedbottle()

                }
            }
        }
    }*/

    Rectangle {
        id: add
        anchors.horizontalCenter: txt.horizontalCenter
        anchors.horizontalCenterOffset: 70
        anchors.top: txt.top
        anchors.topMargin: 40
        width: 40
        height: width
        radius: 4
        border.color: "#0098db"; //Flat.FlatStyle.lightFrameColor
        border.width: Flat.FlatStyle.onePixel
        color: addMouseArea.pressed ? "#0098db" : "white"

        property real persent: control.persent
        property real volumn: control.volumn
        x: 144
        y: 220

        Text {
            font: mainTheme.mediumFont
            anchors.centerIn: parent
            text: "+"
            color: addMouseArea.pressed ? "white" : "#0098db"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            id: addMouseArea
            anchors.fill: parent
            onPressed: {
                persent += 0.01;

                if(persent < 0) persent = 0.0; //make sure persent >= 0

                if((persent*100).toFixed() - (maxPersent*100).toFixed() >= 0)
                {
                    persent = maxPersent;
                    volumn = volumnMax;
                } else {
                    volumn = (persent * volumnDefault).toFixed()
                }

                console.debug("QML2::persent = "+persent+"maxPersent = "+maxPersent + "volumn = "+volumn)

                canvas.requestPaint();
            }
            //onPressAndHold: persent>1.0? persent = 0.0 : persent += 0.05
            onPressAndHold: {
                addtimer.start();
            }
            onReleased: {
                addtimer.stop();
                editVolDone()
            }
        }
    }
    Rectangle {
        id: minus
        anchors.horizontalCenter: txt.horizontalCenter
        anchors.horizontalCenterOffset: 70
        anchors.top: txt.top
        anchors.topMargin: 100
        width: 40
        height: width
        radius: 4
        border.color: "#0098db"; //Flat.FlatStyle.lightFrameColor
        border.width: Flat.FlatStyle.onePixel
        color: minusMouseArea.pressed ? "#0098db" : "white"

        property real persent: control.persent
        property real volumn: control.volumn

        property real remHeight: canvasContent.remHeight
        x: 144
        y: 99

        Text {
            font: mainTheme.mediumFont
            anchors.centerIn: parent
            text: "-"
            color: minusMouseArea.pressed ? "white" : "#0098db"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            id: minusMouseArea
            anchors.fill: parent
            onPressed: {

                if(persent > 0.01) {
                    persent -= 0.01
                } else {
                    persent = 0.0;
                }

                var temp = control.persent * volumnDefault
                if(temp < 0) temp = 0;
                volumn = temp.toFixed()

                canvas.requestPaint();
                //editVolDone()
            }

            onPressAndHold: {
                minustimer.start();
            }
            onReleased: {

                minustimer.stop();
                editVolDone()
            }
        }
    }

    Timer {
        id: addtimer
        interval: 200
        repeat: true
        running: false
        triggeredOnStart: true
        onTriggered: {
            //console.debug("QML::H2oBottle start timer")

            control.persent += 0.05;

            if((persent*100).toFixed() - (maxPersent*100).toFixed() >= 0)
            {
                control.persent = maxPersent;
                control.volumn = volumnMax;
            } else {
                control.volumn = (control.persent * volumnDefault).toFixed()
            }

            canvas.requestPaint();
        }
    }
    Timer {
        id: minustimer
        interval: 200
        repeat: true
        running: false
        triggeredOnStart: true

        onTriggered: {
            //console.debug("QML::H2oBottle start timer")

            if((control.persent-0.05)>0.0) {
                control.persent -= 0.05;
            } else {
                control.persent = 0.0;
            }

            if(persent < 0) persent = 0.0; //make sure persent >= 0

            var temp = control.persent * volumnDefault
            if(temp < 0)
                temp = 0;
            control.volumn = temp.toFixed()
            canvas.requestPaint();
        }
    }

}
