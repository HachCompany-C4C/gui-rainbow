import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2

import QtQuick.Window 2.2
import "content"
import "pages/setup"
import "components"

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 800
    height: 480
    title: qsTr("Test Rainbow")

    objectName: "main view"
    property string uiMessage

    Connections {
        target: ifprobe
        ignoreUnknownSignals: true
        onDebugMessage: {
            var result = "[Testcase]"+message+" "+operate;
            if(ifprobe.testResult())
            {
                result += " done";
            } else {
                result += " fail";
            }
            console.debug(result);
        }
    }

    MeasureRange {
        id: mesaurePage

        Component.onCompleted: {
            ifprobe.setExpert("measure.range.index");
            page_manager.startUpdate("measure.range");
        }
    }

}

