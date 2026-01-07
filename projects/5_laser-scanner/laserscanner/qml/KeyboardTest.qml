import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Settings

Rectangle {
    id: window
    width: 640
    height: 480
    visible: true
    color: "#121212"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

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

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#202020"
            radius: 8
        }
    }
}
