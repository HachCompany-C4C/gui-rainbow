import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
//import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../content"
import "service"
import "../components"

Rectangle {
    id: servicePage
    width: 800
    height: 400
    objectName: "service page"
    property alias serviceStackView: list.listView
    property list<Item> servicePageList : [
        MeasureSample {},
        MechanicalComponent {},
        LeakagePower {},
        SystemInfo {},
        FirmwareUpdate {},
        Reagent {},
        ManualSchedule {},
        //IO {},
        FactoryReset {},
        ScreenCalibration {},
        Permission {},
        Test {}
        /*TestIO {},
        TestPV {},
        TestMH {},
        TestAD {},
        TestSubstep {}*/
    ]

    Connections {
        target: mainMessage
        ignoreUnknownSignals: true
        onBackWindow: {
            serviceStackView.pop({immediate: true})
            console.debug("QML::serviceStackView pop")
        }
    }

    /*H2oNavigationView {
        id: list
        width: parent.width / 3
        height: parent.height

        pageList: servicePageList

        pageModel: ListModel {
            id: pageModel
            ListElement { name: "status.signal"; title: qsTr("Signals"); page: 0 }
            ListElement { name: "service.sysinfo"; title: qsTr("System Info"); page: 1 }
            ListElement { name: "service.maintance.resetreagent"; title: qsTr("Maint - Reset Reagent Level"); page: 2 }
            ListElement { name: "service.maintance.measure"; title: qsTr("Maint - Manual Operation"); page: 3 }
            ListElement { name: "service.maintance.primeflush"; title: qsTr("Maint - Prime&Flush"); page: 6 }
            ListElement { name: "service.advanced.factoryreset"; title: qsTr("Advd - Factory Reset"); page: 7 }
            ListElement { name: "service.advanced.firmwareupdate"; title: qsTr("Advd - Firmware Update"); page: 8 }
            ListElement { name: "service.advanced.test"; title: qsTr("Advanced - Test"); page: 9 }
            ListElement { name: "service.advanced.flushfluid"; title: qsTr("Advd - Flush Fluid System"); page: 10 }
            ListElement { name: "service.advanced.deepflushsettings"; title: qsTr("Advd - Deep Flush Setting"); page: 11 }
            ListElement { name: "service.advanced.screencalibration"; title: qsTr("Advd - Screen Calibration"); page: 12 }
            ListElement { name: "service.advanced.permission"; title: qsTr("Advd - Permission"); page: 13 }
        }
    }*/

    H2oNavigationMenu {
        id: list
        width: 240
        height: parent.height

        pageList: servicePageList

        appTypemodel: ListModel{
            ListElement{
                appType: "Signal"
                shown:false
            }
            ListElement{
                appType: "System"
                shown:false
            }
            ListElement{
                appType: "Maintenance"
                shown:false
            }
            ListElement{
                appType: "Advanced"
                shown:false
            }
            /*ListElement{
                appType: "Test"
                shown:false
            }*/
        }

        appsmodel: ListModel{
            ListElement{
                appName:"Measure sample"
                appType: "Signal"
                name: "status.page1"; title: qsTr("Signal - Measure sample"); page: 0
            }
            ListElement{
                appName:"Mechanical Component"
                appType: "Signal"
                name: "status.page2"; title: qsTr("Signal - Mechanical Component"); page: 1
            }
            ListElement{
                appName:"Leakage & Power"
                appType: "Signal"
                name: "status.page3"; title: qsTr("Signal - Leakage & Power"); page: 2
            }
            ListElement{
                appName:"System Information"
                appType: "System"
                name: "system.info"; title: qsTr("System - Information"); page: 3
            }
            ListElement{
                appName:"Software Upgrade"
                appType: "System"
                name: "system.upgrade"; title: qsTr("System - Firmware"); page: 4
            }
            ListElement{
                appName:"Reagents"
                appType: "Maintenance"
                name: "maintenance.reset"; title: qsTr("Maintenance - Reset Reagent"); page: 5
            }
            ListElement{
                appName:"Manual Operation"
                appType: "Maintenance"
                name: "maintenance.manual"; title: qsTr("Maintenance - Manual"); page: 6
            }
            /*ListElement{
                appName:"I/O"
                appType: "Maintenance"
                name: "maintencance.io"; title: qsTr("Maintenance - I/O"); page: 7
            }*/
            ListElement{
                appName:"Factory Reset"
                appType: "Advanced"
                name: "advanced.freset"; title: qsTr("Advanced - Factory Reset"); page: 7
            }

            ListElement{
                appName:"Screen Calibration"
                appType: "Advanced"
                name: "advaned.calibration"; title: qsTr("Advanced - Screen Calibration"); page: 8
            }
            ListElement{
                appName:"Permission"
                appType: "Advanced"
                name: "advanced.permission"; title: qsTr("Advanced - Permission"); page: 9
            }
            ListElement{
                appName:"Test"
                appType: "Advanced"
                name: "advanced.test"; title: qsTr("Advanced - Test"); page: 10
            }
            /*ListElement{
                appName:"IO"
                appType: "Test"
                name: "test.io"; title: qsTr("Test - IO"); page: 10
            }
            ListElement{
                appName:"Pump&Valve"
                appType: "Test"
                name: "test.pv"; title: qsTr("Test - Pump&Valve"); page: 11
            }
            ListElement{
                appName:"Mixer&Heating"
                appType: "Test"
                name: "test.mh"; title: qsTr("Test - Mixer&Heating"); page: 12
            }
            ListElement{
                appName:"AD Adjust"
                appType: "Test"
                name: "test.ad"; title: qsTr("Test - AD"); page: 13
            }
            ListElement{
                appName:"Substep"
                appType: "Test"
                name: "test.substep"; title: qsTr("Test - Substep"); page: 14
            }*/

        }

        onItemClicked: {
            if(name === "status.page1"
                || name === "status.page2"
                || name === "status.page3"
                || name === "system.info"
                || name === "test.pv/status.page1"
                || name === "test.mh/status.page1"
                || name === "test.ad/status.page1"
                || name === "test.substep/status.page1")
            {
                page_manager.startUpdate(name)
            }
        }

        //Component.onCompleted: {
        //    page_manager.startUpdate("status.page1")
        //}
    }
}

