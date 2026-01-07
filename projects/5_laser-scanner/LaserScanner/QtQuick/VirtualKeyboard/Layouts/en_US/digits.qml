// Copyright (C) 2016 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Components
import QtQuick.VirtualKeyboard.Plugins

KeyboardLayout {
    inputMethod: PlainInputMethod {}
    inputMode: InputEngine.InputMode.Numeric

    KeyboardColumn {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: height
        KeyboardRow {
            Key {
                key: Qt.Key_1
                text: "1"
            }
            Key {
                key: Qt.Key_2
                text: "2"
                smallText: "ABC"
                smallTextVisible: true
            }
            Key {
                key: Qt.Key_3
                text: "3"
                smallText: "DEF"
                smallTextVisible: true
            }
        }
        KeyboardRow {
            Key {
                key: Qt.Key_4
                text: "4"
                smallText: "GHI"
                smallTextVisible: true
            }
            Key {
                key: Qt.Key_5
                text: "5"
                smallText: "JKL"
                smallTextVisible: true
            }
            Key {
                key: Qt.Key_6
                text: "6"
                smallText: "MNO"
                smallTextVisible: true
            }
        }
        KeyboardRow {
            Key {
                key: Qt.Key_7
                text: "7"
                smallText: "PRQS"
                smallTextVisible: true
            }
            Key {
                key: Qt.Key_8
                text: "8"
                smallText: "TUV"
                smallTextVisible: true
            }
            Key {
                key: Qt.Key_9
                text: "9"
                smallText: "WXYZ"
                smallTextVisible: true
            }
        }
        KeyboardRow {
            BackspaceKey {}
            ChangeLanguageKey {
                customLayoutsOnly: true
                visible: true
            }
            // TODO: #2 check with mr.Karbasi if + color on figma is okay or not?
            Key {
                key: Qt.Key_0
                text: "0"
                smallText: "+"
                smallTextVisible: true
            }
            EnterKey {}
        }
    }
}
