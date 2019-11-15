import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
//import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../content"
import "setup"
import "../components"

Rectangle {
    id: setupPage
    width: 800
    height: 400
    objectName: "setup page"
    property alias setupStackView: list.listView
    property list<Item> setupPageList : [
        MeasureRange {},
        MeasureSchedule {},
        MeasureMode {},
        CalibSchedule {},
        CalibMode {},
        CalibFactor {},
        CleanSchedule {},
        CleanMode {},
        IOMainPage {},
        Communication {},
        SysDateTime {},
        DisplayBrightness {},
        Language {}
    ]

    Connections {
        target: mainMessage
        ignoreUnknownSignals: true
        onBackWindow: {
            setupStackView.pop({immediate: true})
        }
    }

    /*H2oNavigationView {
        id: list
        width: parent.width / 3
        height: parent.height

        pageList: setupPageList

        pageModel: ListModel {
            id: pageModel
            ListElement { name: "measure.range"; title: qsTr("Measure - Range"); page: 0 }
            ListElement { name: "measure.schedule"; title: qsTr("Measure - Schedule"); page: 1 }
            ListElement { name: "measure.mode"; title: qsTr("Measure - Mode"); page: 2 }
            ListElement { name: "measure.bias"; title: qsTr("Measure - Factor & OFF"); page: 3 }
            ListElement { name: "calibration.schedule"; title: qsTr("Calib - Schedule"); page: 4 }
            ListElement { name: "calibration.mode"; title: qsTr("Calib - Mode"); page: 5 }
            ListElement { name: "cleaning.schedule"; title: qsTr("Clean - Schedule"); page: 6 }
            ListElement { name: "cleaning.mode"; title: qsTr("Clean - Mode"); page: 7 }
            ListElement { name: "io.main"; title: qsTr("IO - Setup"); page: 8 }
            ListElement { name: "io.modbus"; title: qsTr("IO - ModBus"); page: 9 }
            ListElement { name: "sys.datetime"; title: qsTr("Sys - Date & Time"); page: 10 }
            ListElement { name: "sys.backlight"; title: qsTr("Sys - Backlight"); page: 11 }
            ListElement { name: "sys.language"; title: qsTr("Sys - Language");  page: 12 }
        }

        onListClick: {
            page_manager.startUpdate(name)
        }

        Component.onCompleted: {
            page_manager.startUpdate("measure.range")
        }
    }*/

    H2oNavigationMenu {
        id: list
        width: 240
        height: parent.height

        pageList: setupPageList

        appTypemodel: ListModel{
            ListElement{
                appType: qsTr("Measure")
                shown:false
            }
            ListElement{
                appType: qsTr("Calibration")
                shown:false
            }
            ListElement{
                appType: qsTr("Cleaning")
                shown:false
            }
            ListElement{
                appType: qsTr("IO/Com")
                shown:false
            }
            ListElement{
                appType: qsTr("System")
                shown:false
            }
        }

        appsmodel: ListModel{
            ListElement{
                appName:qsTr("Range")
                appType: qsTr("Measure")
                name: "measure.range"; title: qsTr("Measure - Range"); page: 0
            }
            ListElement{
                appName:qsTr("Schedule")
                appType: qsTr("Measure")
                name: "measure.schedule"; title: qsTr("Measure - Schedule"); page: 1
            }
            ListElement{
                appName:qsTr("Mode")
                appType: qsTr("Measure")
                name: "measure.mode"; title: qsTr("Measure - Mode"); page: 2
            }
            ListElement{
                appName:qsTr("Schedule")
                appType: qsTr("Calibration")
                name: "calibration.schedule"; title: qsTr("Calib - Schedule"); page: 3
            }
            ListElement{
                appName:qsTr("Mode")
                appType: qsTr("Calibration")
                name: "calibration.mode"; title: qsTr("Calib - Mode"); page: 4
            }
            ListElement{
                appName:qsTr("Factor&Offset")
                appType: qsTr("Calibration")
                name: "measure.bias"; title: qsTr("Measure - Factor & OFF"); page: 5
            }
            ListElement{
                appName:qsTr("Schedule")
                appType: qsTr("Cleaning")
                name: "cleaning.schedule"; title: qsTr("Clean - Schedule"); page: 6
            }
            ListElement{
                appName:qsTr("Mode")
                appType: qsTr("Cleaning")
                name: "cleaning.mode"; title: qsTr("Clean - Mode"); page: 7
            }
            ListElement{
                appName:qsTr("IO List")
                appType: qsTr("IO/Com")
                name: "io.main"; title: qsTr("IO - Setup"); page: 8
            }

            ListElement{
                appName:qsTr("Modbus")
                appType: qsTr("IO/Com")
                name: "io.modbus"; title: qsTr("IO - ModBus"); page: 9
            }
            ListElement{
                appName:qsTr("Date&Time")
                appType: qsTr("System")
                name: " "; title: qsTr("Sys - Date & Time"); page: 10 //time not update
            }
            ListElement{
                appName:qsTr("Backlight")
                appType: qsTr("System")
                name: "sys.backlight"; title: qsTr("Sys - Backlight"); page: 11
            }
            ListElement{
                appName:qsTr("Language")
                appType: qsTr("System")
                name: "sys.language"; title: qsTr("Sys - Language");  page: 12
            }
        }

        onItemClicked: {
            page_manager.startUpdate(name)
            console.debug("QML::Setup name:" + name)
        }
    }
}

