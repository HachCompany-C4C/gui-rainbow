/****************************************************************************
** H2oProgressBar.qml
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

ProgressBar {

    style: ProgressBarStyle {
        background: Rectangle {
            implicitHeight: 12
            //border.width: 1
            //border.color: "gray"
            color: "#f2f2f2"
        }

        progress: Rectangle {
            id: progress
            implicitHeight: 12
            color: "#0098db"
            /*gradient: Gradient {
                GradientStop { position: 0 ; color: progress.color }
                GradientStop { position: 0.5 ; color: "white" }
                GradientStop { position: 1 ; color: progress.color }
            }*/
        }
    }

}
