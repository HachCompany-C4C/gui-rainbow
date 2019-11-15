/****************************************************************************
** SignalService.qml - Content window
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

import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2

import QtQuick.Window 2.2
import "content"
import "pages"
import "components"
import "pages/test"

Rectangle {
    id: contentWindow
    width: 800
    height: 480
    color: "#f2f2f2"
    visible: false

    property var mainWnd

    property alias mainMessage: message
    property alias mainStackView: stackView
    property alias mainNumKeyBoard: numKeyBoard
    property alias mainVKeyBoard: vKeyBoard
    property alias mainCircleProgressDialog: circleProgressDialog
    property alias mainMessageDialog: messageDialog
    property alias mainMessageDialogNoButton: messageDialogNoButton
    property alias mainMessageDialogOneButton: messageDialogOneButton
    property alias mainMessageDialogTwoButton: messageDialogTwoButton
    property alias mainBusyDialog: busyDialog
    property alias mainRefreshTimer: refreshTimer
    property alias mainScreenCali: scrCali
    property alias mainScreenTest: scrTest
    property alias mainNotifyDialog: notifyDialog
    property alias mainEventDesc: eventDesc
    property alias mainEventModel: eventModel
    property alias mainTheme: theme
    property alias mainNaviPage: naviPage
    property alias mainHomePage: homePage
    property alias mainPermisMgr: permissionManager
    property alias mainPrognosysMgr: prognosysManager
    property alias mainLoginDialog: loginDialog
    property alias mainLogoutDialog: logoutDialog
    property alias mainPasswdKeyBoard: passwdKeyBoard
    property alias mainTerminal: terminal
    property alias mainHelpPage: helpPage
    property alias mainWelcomePage: welcomePage
    property alias mainFactoryResetData: factoryResetData
    property alias mainDataInit: dataInit

    property Item naviPageItem: NaviPage { id: naviPage }
    property Item homePageItem: HomePage { id: homePage }
    property Item helpPageItem: HelpPage { id: helpPage }
    property Item factoryResetDate: FactoryResetData { id: factoryResetData }

    property alias mainPowerDrain: powerDrain

    signal initialDone()

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

        property font titleFont: Qt.font({family: noto.name, pixelSize: 20})
        property font textFont: Qt.font({family: noto.name, pixelSize: 16})
        property font font30: Qt.font({family: noto.name, pixelSize: 30})
        property font font22: Qt.font({family: noto.name, pixelSize: 22})

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

        FontLoader {
            id: icomoon2
            source: "qrc:///resources/images/icomoon.ttf"
        }

        property font veryhugeIcon2: Qt.font({family: icomoon2.name, pixelSize: 144})
        property font hugeIcon2: Qt.font({family: icomoon2.name, pixelSize: 72})
        property font bigIcon2: Qt.font({family: icomoon2.name, pixelSize: 36})
        property font mediumIcon2: Qt.font({family: icomoon2.name, pixelSize: 24})
        property font smallIcon2: Qt.font({family: icomoon2.name, pixelSize: 18})
        property font miniIcon2: Qt.font({family: icomoon2.name, pixelSize: 14})
        property font tinyIcon2: Qt.font({family: icomoon2.name, pixelSize: 12})

        property color mainTextColor: "#313131"
        property color secondaryTextColor: "#9e9e9e"
        property color mediumBackgroundColor: "#e4e4e4"
        property color lightBackgroundColor: "#f2f2f2"
        property color hachBlueColor: "#0098db"
        property color lightBlueColor: "#3ebdf2"
        property color darkGrayColor: "#313131"
        property color mediumGrayColor: "#9e9e9e"
    }

    Terminal {
        id: terminal
    }

    RefreshTimer {
        id: refreshTimer
    }

    PermissionManager {
        id: permissionManager
    }

    PrognosysManager {
        id: prognosysManager
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

    H2oNumKeyBoard {
        id: numKeyBoard
    }

    H2oVKeyBoard {
        id: vKeyBoard
        Component.onCompleted: {
            // vKeyBoard.open();
        }
    }

    H2oPasswdKeyBoard {
        id: passwdKeyBoard
        Component.onCompleted: {
             //passwdKeyBoard.openDialog(qsTr("Please enter password of administer"));
        }
    }

    LoginDialog {
        id: loginDialog
        Component.onCompleted: {
           // open();
        }
    }

    LogoutDialog {
        id: logoutDialog
        Component.onCompleted: {
           // open();
        }
    }

    DataInit {
        id: dataInit
        onDataInitDone: {
            welcomePage.init();
            initDone();
        }

        onDataInitFailed: {
            initDone();
            welcomePage.visible = false;
            probeDataInitFailed = true;
        }

        function initDone()
        {
            //busyDialog.close();
            mainRefreshTimer.running = true
            screenSaver.init();
            //comm_terminal.createConnection();
            mainWnd.closeWindow();
            contentWindow.visible = true;
            contentWindow.initialDone(); //signal for service tool
        }

        Component.onCompleted: {
            //busyDialog.visible = true;
            initTimer.start();
            watchdog.sdNotifyPidNotifyReady();
            watchdog.sdNotifyPidNotifyWatchdog();
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
    H2oMessageDialogTwoButton {
        id: messageDialogTwoButton
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
    ScreenTest {
        id: scrTest
        z: 2
        width: 800
        height: 480
        visible: false
    }

    EventDescription {
        id: eventDesc
    }

    /*Component.onCompleted: {
        var compon = Qt.createComponent("WelcomePage.qml")
        //Incubators allow new component instances to be instantiated asynchronously and do not cause freezes in the UI.
        var keyBoard = compon.incubateObject(contentWindow);
        keyBoard.z = 1
        keyBoard.visible = true;
    }*/
    WelcomePage {
        id: welcomePage
        z: 1
    }

    ScreenSaver {
        id: screenSaver
        z: 2
    }

    PowerDrain {
        id: powerDrain
    }
}
