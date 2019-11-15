import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.0
import "components"

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 800
    height: 480

    property int failCount: 0
    property int totalCount: 0

    H2oButton {
        x: 190
        y: 199
        width: 420
        height: 83

        Text {
            text: "Start Test"
            font.pointSize: 20
            anchors.centerIn: parent
        }
        onClicked: {
            console.debug("QML::Test Start");
            pageList[0].setObjs(itemsList[0], valuesList[0]);
            failCount = 0;
            totalCount = 0;
        }
    }

    function checkResult(pageObj, name, value)
    {
        var result = true;
        for(var i = 0; i < name.length; i++)
        {
            var result = pageObj.getObjString(name[i]);
            if(result != value[i]) {
                console.debug("QML::Test Error: "+pageObj.name()+"."+name[i]+" Set:"+value[i]+" Get:"+result);
                result = false;
                failCount++;
            }

            totalCount++;
        }

        return result;
    }

    property var pageList: [
        measure_range,
        measure_schedule,
        measure_mode,
        measure_bias,

        calibration_schedule,
        calibration_mode,

        cleaning_schedule,
        cleaning_mode,

        status_page1,
        status_page2,
        status_page3,
        //status_page4
    ]

    property var itemsList: [
        measure_range_items,
        measure_schedule_items,
        measure_mode_items,
        measure_bias_items,

        calibration_schedule_items,
        calibration_mode_items,

        cleaning_schedule_items,
        cleaning_mode_items,

        status_page1_items,
        status_page2_items,
        status_page3_items,
        //status_page4_items
    ]

    property var valuesList: [
        measure_range_values,
        measure_schedule_values,
        measure_mode_values,
        measure_bias_values,

        calibration_schedule_values,
        calibration_mode_values,

        cleaning_schedule_values,
        cleaning_mode_values,

        status_page1_values,
        status_page2_values,
        status_page3_values,
        //status_page4_values
    ]

    property var measure_range_items: ["index"]
    property var measure_range_values: ["3"]
    property var measure_schedule_items: ["index", "customize", "year", "month", "day", "hour", "minute"]
    property var measure_schedule_values: ["1", "120", "2017", "4", "10", "4", "5"]
    property var measure_mode_items: ["index", "average", "retest", "low", "high"]
    property var measure_mode_values: ["1", "2", "1", "1200.000000", "1400.000000"]
    property var measure_bias_items: ["ulr_factor", "ulr_offset", "lr_factor", "lr_offset", "mr_factor", "mr_offset", "hr_factor", "hr_offset"]
    property var measure_bias_values: ["1.000000", "0.500000", "1.000000", "0.500000", "1.000000", "0.500000", "1.000000", "0.500000"]

    property var calibration_schedule_items: ["index", "customize", "year", "month", "day", "hour", "minute"]
    property var calibration_schedule_values: ["3", "100", "2017", "5", "8", "12", "50"]
    property var calibration_mode_items: ["index", "post"]
    property var calibration_mode_values: ["1", "0"]

    property var cleaning_schedule_items: ["index", "customize", "year", "month", "day", "hour", "minute"]
    property var cleaning_schedule_values: ["3", "100", "2017", "5", "8", "12", "50"]
    property var cleaning_mode_items: ["post"]
    property var cleaning_mode_values: ["1"]

    property var status_page1_items: ["l660", "l880", "s660", "s880", "al_temp", "peek_temp", "pcb_temp", "range", "l660_mea", "l660_ref", "l880_mea", "l880_ref", "s660_mea", "s660_ref", "s880_mea", "s880_ref"]
    property var status_page1_values: ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]

    property var status_page2_items: ["pump1", "pump2", "pump3", "mixer", "valve"]
    property var status_page2_values: ["", "", "", "", ""]

    property var status_page3_items: ["leakage", "power"]
    property var status_page3_values: ["", ""]

    property var status_page4_items: ["a_vol", "b_vol", "c_vol", "std0_vol", "std1_vol_left", "std2_vol", "cleaning_vol"]
    property var status_page4_values: ["", "", "", "", "", "", ""]

    //property var io_ao_items: ["enabled", "ch1range", "ch1mapup", "ch1mapdown", "ch1mode", "ch2range", "ch2mapup", "ch2mapdown", "ch2mode", "transfer"]
    //property var io_ao_values: ["1", "1", ]

    Repeater {
        model: pageList.length

        Item {
            Connections {
                target: pageList[index]
                ignoreUnknownSignals: true
                onProbeSetObjDone: {
                    page_manager.startUpdate(target.orgName());
                }
            }

            Connections {
                target: pageList[index]
                ignoreUnknownSignals: true
                onProbeUpdateDone: {
                    checkResult(pageList[index], itemsList[index], valuesList[index]);
                    if(index < (pageList.length-1)) {
                        pageList[index+1].setObjs(itemsList[index+1], valuesList[index+1]);
                    } else {
                        console.debug("QML::Test Done. Test "+totalCount+" items, "+failCount+" failed");
                    }
                }
            }

            function setObjs() {
                pageList[index].setObjs(itemsList[index], valuesList[index]);
            }
        }
    }
}
