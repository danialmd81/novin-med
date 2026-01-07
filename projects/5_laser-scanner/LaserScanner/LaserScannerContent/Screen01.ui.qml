/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard

import LaserScanner

Rectangle {
    id: rectangle
    width: Constants.width
    height: Constants.height

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 0
        spacing: 12

        // TextField {
        //     Layout.fillWidth: true
        //     inputMethodHints: Qt.ImhFormattedNumbersOnly // Shows numeric keyboard
        //     placeholderText: "Type here..."
        //     focus: true
        //     font.pixelSize: 20
        // }

        TextField {
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhDigitsOnly
            // TODO NOTE : This is how to set enter key icon
            EnterKeyAction.actionId: EnterKeyAction.Search
            placeholderText: "Type here..."
            focus: true
            font.pixelSize: 20
        }

        TextField {
            Layout.fillWidth: true
            placeholderText: "Type here..."
            focus: true
            font.pixelSize: 20
        }
        TextField {
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhDialableCharactersOnly
            placeholderText: "Type here..."
            focus: true
            font.pixelSize: 20
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#202020"
            radius: 8
        }
    }
}
