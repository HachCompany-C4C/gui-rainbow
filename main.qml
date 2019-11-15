import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2

import QtQuick.Window 2.2
import "content"
import "pages"
import "components"
import "pages/test"

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 800
    height: 480
    title: qsTr("Hello Rainbow")
    color: "#f2f2f2"

    Image {
        id: image
        source: "qrc:///resources/images/Hach_login_image.png"
    }

    BusyIndicator {
        id: busyIndicator
        z: 3
        width: 35
        height: 35
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20


    }

    function closeWindow()
    {
        // console.debug("QML::main close");
        busyIndicator.running = false;
        busyIndicator.visible = false;
        image.visible = false;
        mouseArea.visible = false;
    }

    Component.onCompleted: {
        var compon = Qt.createComponent("ContentWindow.qml")
        //Incubators allow new component instances to be instantiated asynchronously and do not cause freezes in the UI.
        var obj = compon.createObject(mainWindow, {"mainWnd": mainWindow} );
        //var obj = compon.incubateObject(mainWindow);
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
    }

    /*
    property alias mainMessage: message
    property alias mainStackView: stackView
    property alias mainNumKeyBoard: numKeyBoard
    property alias mainVKeyBoard: vKeyBoard
    property alias mainCircleProgressDialog: circleProgressDialog
    property alias mainMessageDialog: messageDialog
    property alias mainMessageDialogNoButton: messageDialogNoButton
    property alias mainMessageDialogOneButton: messageDialogOneButton
    property alias mainNavigation: naviPage
    property alias mainBusyDialog: busyDialog
    property alias mainRefreshTimer: refreshTimer
    property alias mainScreenCali: scrCali
    property alias mainNotifyDialog: notifyDialog
    property alias mainEventDesc: eventDesc
    property alias mainEventModel: eventModel
    property alias mainTheme: theme

    property Item mainNaviPage: NaviPage { id: naviPage }
    property Item mainHomePage: HomePage { id: homePage }

    Item {
        id: theme
        FontLoader {
            id: noto
            //source: "file:/usr/lib/fonts/NotoSansCJKsc-Regular.otf"
            source: "qrc:///resources/fonts/NotoSans/NotoSans-Regular.ttf"
        }
        property font veryhugeFont: Qt.font({family: noto.name, pixelSize: 144})
        property font hugeFont: Qt.font({family: noto.name, pixelSize: 72})
        property font bigFont: Qt.font({family: noto.name, pixelSize: 36})
        property font mediumFont: Qt.font({family: noto.name, pixelSize: 24})
        property font smallFont: Qt.font({family: noto.name, pixelSize: 18})
        property font tinyFont: Qt.font({family: noto.name, pixelSize: 14})

        property font veryhugeboldFont: Qt.font({family: noto.name, pixelSize: 144, bold: true})
        property font hugeboldFont: Qt.font({family: noto.name, pixelSize: 72, bold: true})
        property font bigboldFont: Qt.font({family: noto.name, pixelSize: 36, bold: true})
        property font mediumboldFont: Qt.font({family: noto.name, pixelSize: 24, bold: true})
        property font smallboldFont: Qt.font({family: noto.name, pixelSize: 18, bold: true})
        property font tinyboldFont: Qt.font({family: noto.name, pixelSize: 14, bold: true})

        property int veryhugeFontSize: 144
        property int hugeFontSize: 72
        property int bigFontSize: 36
        property int mediumFontSize: 24
        property int smallFontSize: 18
        property int tinyFontSize: 14

        FontLoader {
            id: icomoon
            source: "qrc:///resources/images/hach-font-icons.ttf"
        }
        property font veryhugeIcon: Qt.font({family: icomoon.name, pixelSize: 144})
        property font hugeIcon: Qt.font({family: icomoon.name, pixelSize: 72})
        property font bigIcon: Qt.font({family: icomoon.name, pixelSize: 36})
        property font mediumIcon: Qt.font({family: icomoon.name, pixelSize: 24})
        property font smallIcon: Qt.font({family: icomoon.name, pixelSize: 18})
        property font miniIcon: Qt.font({family: icomoon.name, pixelSize: 14})
        property font tinyIcon: Qt.font({family: icomoon.name, pixelSize: 12})

        property color mainTextColor: "#313131"
        property color secondaryTextColor: "#9e9e9e"
        property color mediumBackgroundColor: "#e4e4e4"
        property color lightBackgroundColor: "#f2f2f2"
        property color hachBlueColor: "#0098db"
        property color lightBlueColor: "#3ebdf2"
        property color darkGrayColor: "#313131"
        property color mediumGrayColor: "#9e9e9e"
    }

    RefreshTimer {
        id: refreshTimer
    }

    MessageDelegate {
        id: message
        x: 0
        y: 0
        width: parent.width
        height: 60
        z: 1
        titleMessage: qsTr("Home") + translator.tr
    }

    StackView {
        id: stackView
        rotation: 0
        width: message.width
        height: parent.height - message.height
        anchors.top: message.bottom
        anchors.left: parent.left

        initialItem: homePage
    }

    //Test {
    //    z: 2
    //}

    H2oNumKeyBoard {
        id: numKeyBoard
    }

    H2oVKeyBoard {
        id: vKeyBoard
        Component.onCompleted: {
            //vKeyBoard.open();
        }
    }

    DataInit {
        onDataInitDone: {
            busyDialog.close();
            mainRefreshTimer.running = true
            screenSaver.init();
        }
        Component.onCompleted: {
            busyDialog.visible = true;
            initTimer.start();
        }
    }

    EventModel {
        id: eventModel
    }

    NotifyDialog {
        id: notifyDialog
    }

    H2oBusyDialog {
        id: busyDialog
        x: 0
        y: 0
        width: 800
        height: 480
        visible: false
    }
    H2oCircleProgressDialog {
        id: circleProgressDialog
    }

    H2oMessageDialog {
        id: messageDialog
    }
    H2oMessageDialogNoButton {
        id: messageDialogNoButton
    }
    H2oMessageDialogOneButton {
        id: messageDialogOneButton
    }

    ScreenCalibrate {
        id: scrCali
        x: 0
        y: 0
        z: 2
        width: 800
        height: 480
        visible: false
    }
    EventDescription {
        id: eventDesc
    }

    ScreenSaver {
        id: screenSaver
    }*/
}

