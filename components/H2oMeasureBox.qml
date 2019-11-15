/****************************************************************************
** H2oMeasureBox.qml
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

Item {
    width: 400
    height: 50

    Timer {
        id: measDataFlashTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var loc = Qt.locale("en-US");
            //var val = ifprobe.getRealTimeMeasure();
            //var valStr = val.toLocaleString(loc, 'f', 3);
            //values.text = valStr;
            //console.debug("Real Time Measure:"+valStr)
        }
    }

    Connections {
        target: mainStackView
        onCurrentItemChanged: {
            if(mainStackView.currentItem) {
                var objName = mainStackView.currentItem.objectName
                if(objName.length > 0) {
                    if(mainStackView.currentItem.objectName == "main page") {
                        measDataFlashTimer.start()
                    } else {
                        measDataFlashTimer.stop()
                    }
                } else {
                    measDataFlashTimer.stop()
                }
            }
        }
    }

    Text {
        id: values
        width: parent.width * 3/4
        height: parent.height
        text: "----"
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        font: theme.hugeFont
    }

    Text {
        id: unit
        width: parent.width / 4
        height: parent.height
        anchors.left: values.right
        anchors.verticalCenter: values.verticalCenter
        text: "mg/L"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font: theme.mediumFont
    }
}

