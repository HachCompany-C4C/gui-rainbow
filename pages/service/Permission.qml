/****************************************************************************
** Permission.qml - UI for setting permission
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
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../../components"

Rectangle {
    id: rectangle
    objectName: "Permisson"
    property string title: qsTr("Permisson")+translator.tr
    width: 800
    height: 370

    enabled: mainPermisMgr.admineditabled

    Text {
        id: loginUserText
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 10
        property var userList: [
            qsTr("None")+translator.tr,
            qsTr("Operator")+translator.tr,
            qsTr("Administer")+translator.tr,
            qsTr("None")+translator.tr]
        text: qsTr("Login user")+translator.tr + ": " + loginUserText.userList[mainPermisMgr.permission]
        font: mainTheme.titleFont
    }

    Text {
        id: enableText
        anchors.right: enableSw.left
        anchors.rightMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        text: qsTr("Enable permission")+translator.tr
        font: mainTheme.titleFont
    }

    function updatePermsPage() {
        enableSw.checked = mainPermisMgr.getPermsEnabled();
        //console.debug("QML::Permission "+enableSw.checked)
        oldPassword.valid = true;
        newPassword.valid = true;
        confirmPassword.valid = true;
    }

    H2oSwitch {
        id: enableSw
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: enableText.verticalCenter
        enabled: mainPermisMgr.permission == 2 ? true : false
        signal editDone(var inputStr);

        onValueChanged: {
            // disable permission
            if(!enableSw.checked) {
                enableSw.checked = true;
                mainPasswdKeyBoard.textField = enableSw;
                mainPasswdKeyBoard.openDialog(qsTr("Please enter password of administer"));
            }
        }

        onEditDone: {
            if(mainPermisMgr.checkPassword("administer", inputStr)) {
                enableSw.checked = false;
                mainPermisMgr.enablePermission(false, true);
            } else {
                mainMessageDialogOneButton.openDialog("warning",
                                                      qsTr("Invalid password, please try again."));
                enableSw.checked = true;
            }
        }

        Component.onCompleted: {
            updatePermsPage();
        }
    }

    Rectangle {
        id: sp
        width: 800-20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 50
        height: Flat.FlatStyle.onePixel
        color: Flat.FlatStyle.lightFrameColor
    }

    Text {
        id: changePwText
        anchors.top: sp.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        font: mainTheme.titleFont
        text: mainPermisMgr.permission != 3 ? qsTr("Change password") + translator.tr :
                                              qsTr("Please entry password for administer to enable permission.") + translator.tr
    }

    Rectangle {
        id: group
        width: 500
        height: 250
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: changePwText.top
        anchors.topMargin: 40
        // enabled: enableSw.checked

        Text {
            id: userText
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10
            font: mainTheme.smallFont
            text: qsTr("User") + translator.tr
        }

        H2oDropBoxEx {
            id: userList
            anchors.verticalCenter: userText.verticalCenter
            anchors.left: userText.left
            anchors.leftMargin: 160
            width: 250
            height: 40
            model: userList.modelList[mainPermisMgr.permission]

            property var modelList: [
                userModel1, userModel1, userModel2, userModel3
            ]

            ListModel {
                id: userModel1
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Operator"); user: "operator"; index: 0 }
            }

            ListModel {
                id: userModel2
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Administer"); user: "administer"; index: 0 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Operator"); user: "operator"; index: 1 }
            }

            ListModel {
                id: userModel3
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Administer"); user: "administer"; index: 0 }
            }

            onCurrentIndexChanged: {
                oldPassword.text = "";
            }

            /*Connections {
                target: mainPermisMgr
                ignoreUnknownSignals: true
                onPermissionChanged: {
                    //console.debug("QML::Permission permission = "+mainPermisMgr.permission);
                    //userList.currentIndex = 0;
                    //userList.model = userList.modelList[mainPermisMgr.permission];
                }
            }*/
        }

        Text {
            id: oldpwText
            anchors.left: userText.left
            anchors.leftMargin: 0
            anchors.top: userText.bottom
            anchors.topMargin: 20
            font: mainTheme.smallFont
            text: qsTr("old password") + translator.tr
        }

        function checkOldPassword()
        {
            var user = userList.model.get(userList.currentIndex).user
            if(mainPermisMgr.checkPassword(user, oldPassword.text)) {
                oldPassword.valid = true;
                return true;
            } else {
                oldPassword.valid = false;
                mainMessageDialogOneButton.openDialog("warning",
                                                      qsTr("Invalid password, please try again."));
                return false;
            }
        }

        H2oTextField {
            id: oldPassword
            anchors.left: oldpwText.left
            anchors.leftMargin: 160
            anchors.verticalCenter: oldpwText.verticalCenter
            width: 250
            height: 40
            plaintext: "******"
            keyBoard: mainPasswdKeyBoard
            echoMode: TextInput.Password

            enabled: mainPermisMgr.permission == 1  // if operator
                     || (mainPermisMgr.permission == 2 && userList.currentIndex == 0) //if administer but select administer
                     ? true : false

            onEditDone: {
                text = inputStr;
                group.checkOldPassword();
            }
        }

        Text {
            id: newpwText
            anchors.left: oldpwText.left
            anchors.leftMargin: 0
            anchors.top: oldpwText.bottom
            anchors.topMargin: 20
            font: mainTheme.smallFont
            text: qsTr("New password") + translator.tr
        }

        H2oTextField {
            id: newPassword
            anchors.left: newpwText.left
            anchors.leftMargin: 160
            anchors.verticalCenter: newpwText.verticalCenter
            width: 250
            height: 40
            plaintext: "******"
            keyBoard: mainPasswdKeyBoard
            echoMode: TextInput.Password

            onEditDone: {
                text = inputStr;
                if(text == "") {
                    mainMessageDialogOneButton.openDialog("warning",
                                                          qsTr("Please enter password."));
                }
            }
        }

        Text {
            id: confirmpwText
            anchors.left: newpwText.left
            anchors.leftMargin: 0
            anchors.top: newpwText.bottom
            anchors.topMargin: 20
            font: mainTheme.smallFont
            text: qsTr("Confirm password") + translator.tr
        }

        H2oTextField {
            id: confirmPassword
            anchors.left: confirmpwText.left
            anchors.leftMargin: 160
            anchors.verticalCenter: confirmpwText.verticalCenter
            width: 250
            height: 40
            plaintext: "******"
            keyBoard: mainPasswdKeyBoard
            echoMode: TextInput.Password

            onEditDone: {
                text = inputStr;

                if(text != "") {
                    if(newPassword.text == confirmPassword.text) {
                        confirmPassword.valid = true;
                    } else {
                        confirmPassword.valid = false;
                        mainMessageDialogOneButton.openDialog("warning",
                                                              qsTr("The two passwords you entered didn't match."));
                    }
                } else {
                    mainMessageDialogOneButton.openDialog("warning",
                                                          qsTr("Please enter password."));
                }
            }
        }

        H2oButton {
            anchors.left: confirmPassword.left
            anchors.leftMargin: 0
            anchors.top: confirmpwText.bottom
            anchors.topMargin: 20
            width: 250
            text: mainPermisMgr.permission != 3 ? qsTr("CHANGE") + translator.tr
                                                : qsTr("ENABLE PERMISSION") + translator.tr

            onClicked: {
                // if old password enabled, need to check old password valid
                if((!oldPassword.enabled) || group.checkOldPassword())
                {
                    if(newPassword.text != "") {
                        if(newPassword.text == confirmPassword.text) {
                            var user = userList.model.get(userList.currentIndex).user
                            mainPermisMgr.setPassword(user, newPassword.text);
                            if(mainPermisMgr.permission == 3) {
                                mainPermisMgr.enablePermission(true, true);
                                enableSw.checked = true;
                                mainMessageDialogOneButton.openDialog("warning",
                                                                      qsTr("Enable permission successfully."));
                            } else {
                                mainMessageDialogOneButton.openDialog("warning",
                                                                      qsTr("Password has been changed successfully."));
                            }
                        } else {
                            mainMessageDialogOneButton.openDialog("warning",
                                                                  qsTr("The two passwords you entered didn't match."));
                        }

                    } else {
                        mainMessageDialogOneButton.openDialog("warning",
                                                              qsTr("Please enter password."));
                    }
                } else {
                    mainMessageDialogOneButton.openDialog("warning",
                                                          qsTr("Old password invalid."));
                }

                oldPassword.text = "";
                newPassword.text = "";
                confirmPassword.text = "";
            }
        }
    }

    /*
    Rectangle {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        height: 420
        width: Flat.FlatStyle.onePixel
        color: Flat.FlatStyle.lightFrameColor
    }

    Text {
        id: adminText
        anchors.horizontalCenter: adminBtn.horizontalCenter
        anchors.verticalCenter: adminBtn.verticalCenter
        anchors.verticalCenterOffset: -150
        font: mainTheme.mediumFont
        text: qsTr("Reset Administrator password") + translator.tr
    }
    H2oButton {
        id: adminBtn
        x: 150
        y: 200
        height: 60
        width: 100
        buttonRadius: 5
        text: qsTr("RESET") + translator.tr

        onClicked: {
            rpw = "admin"
            //resetpw.visible = true;
        }
    }
    Text {
        id: operator
        anchors.horizontalCenter: opBtn.horizontalCenter
        anchors.verticalCenter: opBtn.verticalCenter
        anchors.verticalCenterOffset: -150
        font: mainTheme.mediumFont
        text: qsTr("Reset Operator password") + translator.tr
    }
    H2oButton {
        id: opBtn
        x: 552
        y: 200
        height: 60
        width: 100
        buttonRadius: 5
        text: qsTr("RESET") + translator.tr

        onClicked: {
            rpw = "opertaor"
            //resetpw.visible = true;
        }
    }

    Rectangle {
        id: resetpw

        height: 250
        width: 500
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        visible: false
        border.width: 2
        border.color: "black"

        Text {
            id: oldPwText
            x: 35
            y: 20
            font: mainTheme.smallFont
            text: qsTr("Old password:") + translator.tr
        }
        H2oTextField {
            id: oldPw
            x: 300
            anchors.verticalCenter: oldPwText.verticalCenter
            height: 40
            width: 150

            onEditDone: {

            }
        }

        Text {
            id: newPwText
            x: oldPwText.x
            y: 80
            font: mainTheme.smallFont
            text: qsTr("New password:") + translator.tr
        }
        H2oTextField {
            id: newPw
            x: oldPw.x
            anchors.verticalCenter: newPwText.verticalCenter
            height: oldPw.height
            width: oldPw.width

            onEditDone: {

            }
        }
        Text {
            id: rewritePwText
            x: oldPwText.x
            y: 140
            font: mainTheme.smallFont
            text: qsTr("rewirte password:") + translator.tr
        }
        H2oTextField {
            id: rewirtePw
            x: oldPw.x
            anchors.verticalCenter: rewritePwText.verticalCenter
            height: oldPw.height
            width: oldPw.width

            onEditDone: {

            }
        }
        H2oButton {
            id: changePw
            x: 100
            y: 200
            height: 45
            width: 100
            text: qsTr("Confirm") + translator.tr
            onClicked: {
                //TODO
                resetpw.visible = false
            }
        }

        H2oButton {
            id: cancelPw
            x: 300
            y: 200
            height: 45
            width: 100
            text: qsTr("Cancel") + translator.tr
            onClicked: {
                //TODO
                resetpw.visible = false
            }
        }
    }

    Connections {
        target: mainMessage

        onLoginWindowPopped: {
            mainNumKeyBoard.open();
            mainNumKeyBoard.textField = h2oTextField;
        }
    }

    TextField {
        id: h2oTextField
        visible: false
        property bool editTextHoldEnabled: false

        signal editDone(var inputStr)

        style: TextFieldStyle {
            textColor: "black"

            background: Rectangle {
                radius: 4
                border.color: "black"
                border.width: 1
                implicitHeight: 40

                Text {
                    font.pixelSize: 40
                }
            }
        }

        //echoMode: TextInput.Password

        Button {
            id: button
            anchors.right: parent.right
            anchors.rightMargin: 2
            anchors.verticalCenter: parent.verticalCenter

            Label {
                width: 40
                height: 38
                text: "\ue637"
                color: "black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: theme.mediumIcon
            }

            style: ButtonStyle {

                background: Rectangle {
                    implicitWidth: 40
                    implicitHeight: 38
                    border.width: control.activeFocus ? 1 : 0
                    //border.color: "#888"
                    radius: 4
                    gradient: Gradient {
                        GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                        GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                    }
                }
            }

            function keyboardOutput() {
                console.debug("QML::H2oTextField key board output")
            }

            onClicked: {
                //console.debug("H2o Virtual Key Board")
                mainKeyBoard.open();
                mainKeyBoard.textField = h2oTextField;
                //var compon = Qt.createComponent("H2oVKeyBoard.qml")
                //Incubators allow new component instances to be instantiated asynchronously and do not cause freezes in the UI.
                //var keyBoard = compon.incubateObject(h2oTextField, {"text": editTextHoldEnabled ? h2oTextField.text : ""});
                //keyBoard.open()
            }
        }
    }*/
}
