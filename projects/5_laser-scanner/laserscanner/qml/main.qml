import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Settings

Window {
    id: window
    width: 640
    height: 480
    visible: true
    // title: qsTr("Hello World")

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

    Component.onCompleted: {
        VirtualKeyboardSettings.styleName = "laser-scanner";
    }
    InputPanel {
        id: inputPanel
        z: 99
        y: window.height
        width: window.width

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                inputPanel.y: window.height - inputPanel.height
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            NumberAnimation {
                properties: "y"
                easing.type: Easing.InOutQuad
            }
        }
    }
}
