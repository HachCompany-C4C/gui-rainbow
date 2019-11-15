/****************************************************************************
** H2oProgressCircle.qml
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

import QtQuick 2.0
import QtQml 2.2

Item {
    id: root

    width: size
    height: size
    opacity: enabled ? 1.0 : 0.4

    property real value: 0.0

    property int size: 200               // The size of the circle in pixel
    property real arcBegin: 0            // start arc angle in degree
    property real arcEnd: 360*value      // end arc angle in degree
    property real arcOffset: 0           // rotation
    property bool isPie: false           // paint a pie instead of an arc
    property bool showBackground: true  // a full circle as a background of the arc
    property real lineWidth: 8          // width of the line
    property string colorCircle: "#0098db"
    property string colorBackground: "#f2f2f2"

    property alias beginAnimation: animationArcBegin.enabled
    property alias endAnimation: animationArcEnd.enabled

    property int animationDuration: 200

    onArcBeginChanged: canvas.requestPaint()
    onArcEndChanged: canvas.requestPaint()

    Text {
        anchors.fill: parent

        text: {
            var rval = value*100;
            var ival = rval.toFixed(0);
            return ""+ival+"%";
        }
        font.pointSize: 24
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Behavior on arcBegin {
       id: animationArcBegin
       enabled: true
       NumberAnimation {
           duration: root.animationDuration
           easing.type: Easing.InOutCubic
       }
    }

    Behavior on arcEnd {
       id: animationArcEnd
       enabled: true
       NumberAnimation {
           duration: root.animationDuration
           easing.type: Easing.InOutCubic
       }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        rotation: -90 + parent.arcOffset

        onPaint: {
            var ctx = getContext("2d")
            var x = width / 2
            var y = height / 2
            var start = Math.PI * (parent.arcBegin / 180)
            var end = Math.PI * (parent.arcEnd / 180)
            ctx.reset()

            if (root.isPie) {
                if (root.showBackground) {
                    ctx.beginPath()
                    ctx.fillStyle = root.colorBackground
                    ctx.moveTo(x, y)
                    ctx.arc(x, y, width / 2, 0, Math.PI * 2, false)
                    ctx.lineTo(x, y)
                    ctx.fill()
                }
                ctx.beginPath()
                ctx.fillStyle = root.colorCircle
                ctx.lineCap = 'round'
                ctx.moveTo(x, y)
                ctx.arc(x, y, width / 2, start, end, false)
                ctx.lineTo(x, y)
                ctx.fill()
            } else {
                if (root.showBackground) {
                    ctx.beginPath();
                    ctx.arc(x, y, (width / 2) - parent.lineWidth / 2, 0, Math.PI * 2, false)
                    ctx.lineWidth = root.lineWidth
                    ctx.strokeStyle = root.colorBackground
                    ctx.stroke()
                }
                ctx.beginPath();
                ctx.arc(x, y, (width / 2) - parent.lineWidth / 2, start, end, false)
                ctx.lineWidth = root.lineWidth
                ctx.strokeStyle = root.colorCircle
                ctx.lineCap = 'round'
                ctx.stroke()
            }
        }
    }
}
