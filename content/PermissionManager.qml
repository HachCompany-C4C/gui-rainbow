/****************************************************************************
** PermissionManager.qml - Permission manager
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
    property int permission: 0 //0-no login 1-operator 2-admin 3-close perms
    property int permslevel: permission > 2 ? 2 : permission
    property bool editabled: permission >= 1 ? true : false
    property bool admineditabled: permission >= 2 ? true : false
    property bool permsenabled : permission >= 3 ? false : true
    property bool superperms: false //use password 12342234
    property var usernames: ["guest", "operator", "admin", "anonymous"]
    property string user: usernames[permission]

    Connections {
        target: mouse_event
        ignoreUnknownSignals: true
        onPressed: {
            //console.debug("QML::Perms Mgr restart timer")
            if(exhTimer.running) {
                if(permission == 1 || permission == 2) {
                    exhTimer.restart();
                } else {
                    exhTimer.stop();
                }
            }
        }
    }

    Timer {
        id: exhTimer
        interval: 60000*60 // 1 hour
        running: false
        repeat: false
        triggeredOnStart: false
        onTriggered: {
            logout();
        }
    }

    function checkPermission()
    {
        if(permission > 0) {
            return true;
        } else {
            mainMessageDialogOneButton.openDialog("reminder",
                                                  qsTr("Please login first")+translator.tr)
            return false;
        }
    }

    function getPermsEnabled()
    {
        var b = true;
        var res = local_settings.getValueBool("permission", "enabled", false);
        //console.debug("QML::Permission enabled: "+res);
        if(res === true) {
            b = true;
        } else if(res === false) {
            permission = 3;
            b = false;
        }

        return b;
    }

    function enablePermission(b, user_set)
    {
        if(b) {
            // goto administer permission
            permission = 2;
            exhTimer.restart();
        } else { // disable permission

            // reset password
            password_mgr.resetPassword("operator");
            password_mgr.resetPassword("administer");
            permission = 3;
            exhTimer.stop();
            superperms = false;
        }

        local_settings.setValue("permission", "enabled", b);

        // a user index cache for settings log
        if(user_set)
        {
            console.debug("QML::PermissionMgr set user");
            login_perms.setObj("user", permission);
        }
    }

    function checkPassword(user, password)
    {
        var ret = false;
        var pw = password_mgr.getPasswordEncrypted(user);
        if(pw === password_mgr.encrypt(password)) {
            ret = true;
        }

        // super password for administer
        if (password_mgr.encrypt(password) === password_mgr.superPasswordEncrypted() && user === "administer") {
            superperms = true;
            ret = true;
        }

        return ret;
    }

    function setPassword(user, password)
    {
        password_mgr.savePassword(user, password);
    }

    // user: "Operator", "Administer"
    function login(user, password)
    {
        if(checkPassword(user, password)) {
            if(user === "operator") {
                permission = 1;
            } else if(user === "administer") {
                permission = 2;
            }

            if(permission > 0) {
                exhTimer.restart()
                //console.debug("QML::Permission: "+permission)
            }

            login_perms.setObj("user", permission);
            return true;
        }

        return false;
    }

    // user: "Operator", "Administer"
    function logout()
    {
        permission = 0;
        mainNaviPage.navigateHome();
        superperms = false;
        exhTimer.stop();
        login_perms.setObj("user", permission);
        console.debug("Permission logout")
    }
}
