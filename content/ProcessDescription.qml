/****************************************************************************
** ProcessDescription.qml - Process description
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
    property int length: descriptionList.length
    property int subDescLength: descriptionList.length
    property int mainDescLength: mainDescriptionList.length
    property int rangeLength: rangeList.length

    function description(index)
    {
        return descriptionList[index];
    }

    function mainDescription(index)
    {
        return mainDescriptionList[index];
    }

    function range(index)
    {
        return rangeList[index];
    }

    function mainProcessDesc(mainIndex, rangeIndex, subIndex)
    {
        var desc = mainDescriptionList[mainIndex]+" "+rangeList[rangeIndex]+" "+descriptionList[subIndex];
        //var ret = desc.substring(0, 15);
        return desc;
    }

    function subProcessDesc(index)
    {
        return descriptionList[index];
    }

    property var rangeList: [
        "ULR",
        "LR",
        "MR",
        "HR",
        ""
    ]

    property var mainDescriptionList: [
        qsTr("MAINACT_NONE")+translator.tr,
        qsTr("MAINACT_CLEAN")+translator.tr,
        qsTr("MAINACT_CALIB")+translator.tr,
        qsTr("MAINACT_MEAS")+translator.tr,
        qsTr("MAINACT_PRIME")+translator.tr,
        qsTr("MAINACT_FLUSH")+translator.tr,
        qsTr("MAINACT_DRAIN")+translator.tr,
        qsTr("MAINACT_ONLINE")+translator.tr,
        qsTr("MAINACT_OFFLINE")+translator.tr,
        qsTr("MAINACT_SUBSTEP")+translator.tr,
        qsTr("MAINACT_STD0_V")+translator.tr,
        qsTr("MAINACT_STD1_V")+translator.tr,
        qsTr("MAINACT_PRE_TREATMENT")+translator.tr,
        qsTr("MAINACT_INITIALIZATION")+translator.tr,
        qsTr("MAINACT_PWR_DRAIN")+translator.tr,
        ""
    ]

    property var descriptionList: [
        "",
        qsTr("ProcessDescription_1")+translator.tr,
        qsTr("ProcessDescription_2")+translator.tr,
        qsTr("ProcessDescription_3")+translator.tr,
        qsTr("ProcessDescription_4")+translator.tr,
        qsTr("ProcessDescription_5")+translator.tr,
        qsTr("ProcessDescription_6")+translator.tr,
        qsTr("ProcessDescription_7")+translator.tr,
        qsTr("ProcessDescription_8")+translator.tr,
        qsTr("ProcessDescription_9")+translator.tr,
        qsTr("ProcessDescription_10")+translator.tr,
        qsTr("ProcessDescription_11")+translator.tr,
        qsTr("ProcessDescription_12")+translator.tr,
        qsTr("ProcessDescription_13")+translator.tr,
        qsTr("ProcessDescription_14")+translator.tr,
        qsTr("ProcessDescription_15")+translator.tr,
        qsTr("ProcessDescription_16")+translator.tr,
        qsTr("ProcessDescription_17")+translator.tr,
        qsTr("ProcessDescription_18")+translator.tr,
        qsTr("ProcessDescription_19")+translator.tr,
        qsTr("ProcessDescription_20")+translator.tr,
        qsTr("ProcessDescription_21")+translator.tr,
        qsTr("ProcessDescription_22")+translator.tr,
        qsTr("ProcessDescription_23")+translator.tr,
        qsTr("ProcessDescription_24")+translator.tr,
        qsTr("ProcessDescription_25")+translator.tr,
        qsTr("ProcessDescription_26")+translator.tr,
        qsTr("ProcessDescription_27")+translator.tr,
        qsTr("ProcessDescription_28")+translator.tr,
        qsTr("ProcessDescription_29")+translator.tr,
        qsTr("ProcessDescription_30")+translator.tr,
        qsTr("ProcessDescription_31")+translator.tr,
        qsTr("ProcessDescription_32")+translator.tr,
        qsTr("ProcessDescription_33")+translator.tr,
        qsTr("ProcessDescription_34")+translator.tr,
        qsTr("ProcessDescription_35")+translator.tr,
        qsTr("ProcessDescription_36")+translator.tr,
        qsTr("ProcessDescription_37")+translator.tr,
        qsTr("ProcessDescription_38")+translator.tr,
        qsTr("ProcessDescription_39")+translator.tr,
        qsTr("ProcessDescription_40")+translator.tr,
        qsTr("ProcessDescription_41")+translator.tr,
        qsTr("ProcessDescription_42")+translator.tr,
        qsTr("ProcessDescription_43")+translator.tr,
        qsTr("ProcessDescription_44")+translator.tr,
        qsTr("ProcessDescription_45")+translator.tr,
        qsTr("ProcessDescription_46")+translator.tr,
        qsTr("ProcessDescription_47")+translator.tr,
        qsTr("ProcessDescription_48")+translator.tr,
        qsTr("ProcessDescription_49")+translator.tr,
        qsTr("ProcessDescription_50")+translator.tr,
        qsTr("ProcessDescription_51")+translator.tr,
        qsTr("ProcessDescription_52")+translator.tr,
        qsTr("ProcessDescription_53")+translator.tr,
        qsTr("ProcessDescription_54")+translator.tr,
        qsTr("ProcessDescription_55")+translator.tr,
        qsTr("ProcessDescription_56")+translator.tr,
        qsTr("ProcessDescription_57")+translator.tr,
        qsTr("ProcessDescription_58")+translator.tr,
        qsTr("ProcessDescription_59")+translator.tr,
        qsTr("ProcessDescription_60")+translator.tr,
        qsTr("ProcessDescription_61")+translator.tr,
        qsTr("ProcessDescription_62")+translator.tr,
        qsTr("ProcessDescription_63")+translator.tr,
        qsTr("ProcessDescription_64")+translator.tr,
        qsTr("ProcessDescription_65")+translator.tr,
        qsTr("ProcessDescription_66")+translator.tr,
        qsTr("ProcessDescription_67")+translator.tr,
        qsTr("ProcessDescription_68")+translator.tr,
        qsTr("ProcessDescription_69")+translator.tr,
        qsTr("ProcessDescription_70")+translator.tr,
        qsTr("ProcessDescription_71")+translator.tr,
        qsTr("ProcessDescription_72")+translator.tr,
        qsTr("ProcessDescription_73")+translator.tr,
        qsTr("ProcessDescription_74")+translator.tr,
        qsTr("ProcessDescription_75")+translator.tr,
        qsTr("ProcessDescription_76")+translator.tr,
        qsTr("ProcessDescription_77")+translator.tr,
        qsTr("ProcessDescription_78")+translator.tr,
        qsTr("ProcessDescription_79")+translator.tr,
        qsTr("ProcessDescription_80")+translator.tr,
        qsTr("ProcessDescription_81")+translator.tr,
        qsTr("ProcessDescription_82")+translator.tr,
        qsTr("ProcessDescription_83")+translator.tr,
        qsTr("ProcessDescription_84")+translator.tr,
        qsTr("ProcessDescription_85")+translator.tr,
        qsTr("ProcessDescription_86")+translator.tr,
        qsTr("ProcessDescription_87")+translator.tr,
        qsTr("ProcessDescription_88")+translator.tr,
        qsTr("ProcessDescription_89")+translator.tr,
        qsTr("ProcessDescription_90")+translator.tr,
        qsTr("ProcessDescription_91")+translator.tr,
        qsTr("ProcessDescription_92")+translator.tr,
        qsTr("ProcessDescription_93")+translator.tr,
        qsTr("ProcessDescription_94")+translator.tr,
        qsTr("ProcessDescription_95")+translator.tr,
        qsTr("ProcessDescription_96")+translator.tr,
        qsTr("ProcessDescription_97")+translator.tr,
        qsTr("ProcessDescription_98")+translator.tr,
        qsTr("ProcessDescription_99")+translator.tr,
        qsTr("ProcessDescription_100")+translator.tr,
        qsTr("ProcessDescription_101")+translator.tr,
        qsTr("ProcessDescription_102")+translator.tr,
        qsTr("ProcessDescription_103")+translator.tr,
        qsTr("ProcessDescription_104")+translator.tr,
        qsTr("ProcessDescription_105")+translator.tr,
        qsTr("ProcessDescription_106")+translator.tr,
        qsTr("ProcessDescription_107")+translator.tr,
        qsTr("ProcessDescription_108")+translator.tr,
        qsTr("ProcessDescription_109")+translator.tr,
        qsTr("ProcessDescription_110")+translator.tr,
        qsTr("ProcessDescription_111")+translator.tr,
        qsTr("ProcessDescription_112")+translator.tr,
        qsTr("ProcessDescription_113")+translator.tr,
        qsTr("ProcessDescription_114")+translator.tr,
        qsTr("ProcessDescription_115")+translator.tr,
        qsTr("ProcessDescription_116")+translator.tr,
        qsTr("ProcessDescription_117")+translator.tr,
        qsTr("ProcessDescription_118")+translator.tr,
        qsTr("ProcessDescription_119")+translator.tr,
        qsTr("ProcessDescription_120")+translator.tr,
        qsTr("ProcessDescription_121")+translator.tr,
        qsTr("ProcessDescription_122")+translator.tr,
        qsTr("ProcessDescription_123")+translator.tr,
        qsTr("ProcessDescription_124")+translator.tr,
        qsTr("ProcessDescription_125")+translator.tr,
        qsTr("ProcessDescription_126")+translator.tr,
        qsTr("ProcessDescription_127")+translator.tr,
        qsTr("ProcessDescription_128")+translator.tr,
        qsTr("ProcessDescription_129")+translator.tr,
        qsTr("ProcessDescription_130")+translator.tr,
        qsTr("ProcessDescription_131")+translator.tr,
        qsTr("ProcessDescription_132")+translator.tr,
        qsTr("ProcessDescription_133")+translator.tr,
        qsTr("ProcessDescription_134")+translator.tr,
        qsTr("ProcessDescription_135")+translator.tr,
        qsTr("ProcessDescription_136")+translator.tr,
        qsTr("ProcessDescription_137")+translator.tr,
        qsTr("ProcessDescription_138")+translator.tr,
        qsTr("ProcessDescription_139")+translator.tr,
        qsTr("ProcessDescription_140")+translator.tr,
        qsTr("ProcessDescription_141")+translator.tr,
        qsTr("ProcessDescription_142")+translator.tr,
        qsTr("ProcessDescription_143")+translator.tr,
        qsTr("ProcessDescription_144")+translator.tr,
        qsTr("ProcessDescription_145")+translator.tr,
        qsTr("ProcessDescription_146")+translator.tr,
        qsTr("ProcessDescription_147")+translator.tr,
        qsTr("ProcessDescription_148")+translator.tr,
        qsTr("ProcessDescription_149")+translator.tr,
        qsTr("ProcessDescription_150")+translator.tr,
        qsTr("ProcessDescription_151")+translator.tr,
        qsTr("ProcessDescription_152")+translator.tr,
        qsTr("ProcessDescription_153")+translator.tr,
        qsTr("ProcessDescription_154")+translator.tr,
        qsTr("ProcessDescription_155")+translator.tr,
        qsTr("ProcessDescription_156")+translator.tr,
        qsTr("ProcessDescription_157")+translator.tr,
        qsTr("ProcessDescription_158")+translator.tr,
        qsTr("ProcessDescription_159")+translator.tr,
        qsTr("ProcessDescription_160")+translator.tr,
        qsTr("ProcessDescription_161")+translator.tr,
        qsTr("ProcessDescription_162")+translator.tr,
        qsTr("ProcessDescription_163")+translator.tr,
        qsTr("ProcessDescription_164")+translator.tr,
        qsTr("ProcessDescription_165")+translator.tr,
        qsTr("ProcessDescription_166")+translator.tr,
        qsTr("ProcessDescription_167")+translator.tr,
        qsTr("ProcessDescription_168")+translator.tr,
        qsTr("ProcessDescription_169")+translator.tr,
        qsTr("ProcessDescription_170")+translator.tr,
        qsTr("ProcessDescription_171")+translator.tr,
        qsTr("ProcessDescription_172")+translator.tr,
        qsTr("ProcessDescription_173")+translator.tr,
        qsTr("ProcessDescription_174")+translator.tr,
        qsTr("ProcessDescription_175")+translator.tr,
        qsTr("ProcessDescription_176")+translator.tr,
        qsTr("ProcessDescription_177")+translator.tr,
        qsTr("ProcessDescription_178")+translator.tr,
        qsTr("ProcessDescription_179")+translator.tr,
        qsTr("ProcessDescription_180")+translator.tr,
        qsTr("ProcessDescription_181")+translator.tr,
        qsTr("ProcessDescription_182")+translator.tr,
        qsTr("ProcessDescription_183")+translator.tr,
        qsTr("ProcessDescription_184")+translator.tr,
        qsTr("ProcessDescription_185")+translator.tr,
        qsTr("ProcessDescription_186")+translator.tr,
        qsTr("ProcessDescription_187")+translator.tr,
        qsTr("ProcessDescription_188")+translator.tr,
        qsTr("ProcessDescription_189")+translator.tr,
        qsTr("ProcessDescription_190")+translator.tr,
        ""
    ]

    property var systemStatus: [
        qsTr("RUNNING")+translator.tr,
        qsTr("STOPPED")+translator.tr,
        qsTr("SCHEDULE OFF")+translator.tr,
        qsTr("LOCKED")+translator.tr,
        qsTr("WAITING")+translator.tr
    ]
}
