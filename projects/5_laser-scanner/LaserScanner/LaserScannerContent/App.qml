import QtQuick
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Settings

import LaserScanner

Window {
    // flags: Qt.FramelessWindowHint

    width: mainScreen.width
    height: mainScreen.height

    visible: true
    title: "LaserScanner"

    Screen01 {
        id: mainScreen
        anchors.centerIn: parent
    }

    Component.onCompleted: {
        VirtualKeyboardSettings.styleName = "laser-scanner";
    }

    InputPanel {
        id: inputPanel
        property bool showKeyboard: active
        y: showKeyboard ? parent.height - height : parent.height
        Behavior on y {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }

        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
