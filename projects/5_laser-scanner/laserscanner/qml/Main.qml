import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Settings

Window {
    id: window
    width: 540
    height: 960
    visible: true
    // title: qsTr("Hello World")

    property bool splashDone: false

    Loader {
        anchors.fill: parent
        source: splashDone ? "KeyboardTest.qml" : "splash/SplashScreen.qml"
    }

    Timer {
        id: splashTimer
        interval: 2000 // 2 seconds
        running: true
        repeat: false
        onTriggered: window.splashDone = true
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
