import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Settings

Window {
    width: 1200
    height: 1000
    visible: true
    title: "Virtual Keyboard Style Test"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        Label {
            text: "Tap the field to show the virtual keyboard:"
            font.pixelSize: 18
        }

        TextField {
            id: tf
            Layout.fillWidth: true
            placeholderText: "Type here..."
            focus: true
            font.pixelSize: 20
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#202020"
            radius: 8

            Text {
                anchors.centerIn: parent
                color: "white"
                text: "Content area (keyboard will overlay / push depending on your layout)."
                wrapMode: Text.WordWrap
                width: parent.width * 0.9
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    // IMPORTANT:
    // - VirtualKeyboardSettings.styleName selects a *style plugin* (e.g. "default").
    // - For a custom QML style file, the robust approach is to set the environment
    //   variable *before* QML loads (see main.cpp): QT_VIRTUALKEYBOARD_STYLE.
    Component.onCompleted: {
        VirtualKeyboardSettings.styleName = "laser-scanner";
    }

    // The actual on-screen keyboard UI
    InputPanel {
        id: inputPanel
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: Qt.inputMethod.visible
    }
}
