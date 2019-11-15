/****************************************************************************
** PrognosysManager.qml - Prognosys manager
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
    property bool prognosysEnabled: true

    onPrognosysEnabledChanged: {
        local_settings.setValue("prognosys", "enabled", prognosysEnabled);
    }

    Component.onCompleted: {
        var enable = local_settings.getValueBool("prognosys", "enabled", true);
        mainPrognosysMgr.prognosysEnabled = enable;
    }
}
