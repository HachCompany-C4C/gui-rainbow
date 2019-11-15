/****************************************************************************
** LogoutDialog.qml - Logout dialog
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
import QtQuick.Layouts 1.0
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import "../components"

Dialog
{
    id: root

    //width: content.implicitWidth+20
    //height: content.implicitHeight

    function openDialog()
    {
        open();
    }

    contentItem: Rectangle {
        id: content

        implicitWidth: 256+5
        implicitHeight: userText.height + loginButton.height + 50

        Text {
            id: userText
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 20
            property var userList: [
                qsTr("None")+translator.tr,
                qsTr("Operator")+translator.tr,
                qsTr("Administer")+translator.tr,
                qsTr("None")+translator.tr]
            text: qsTr("User")+translator.tr + ": " + userText.userList[mainPermisMgr.permission]
            font: mainTheme.titleFont
        }

        H2oButton {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: parent.width/2
            buttonRadius: 0
            text: qsTr("CANCEL")+translator.tr
            buttonTextColor: theme.mainTextColor
            buttonColor: theme.mediumBackgroundColor
            buttonBorderColor: theme.mediumBackgroundColor
            onClicked: {
                reject();
            }
        }

        H2oButton {
            id: loginButton
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: parent.width/2
            buttonRadius: 0
            text: qsTr("SIGN OUT")+translator.tr
            onClicked: {
                mainPermisMgr.logout();
                accept();
            }
        }
    }
    //Component.onCompleted: root.open()
}
