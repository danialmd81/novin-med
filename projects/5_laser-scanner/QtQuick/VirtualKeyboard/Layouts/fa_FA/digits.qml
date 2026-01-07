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
                text: "\u06F1"
                alternativeKeys: "\u06F11"
            }
            Key {
                text: "\u06F2"
                alternativeKeys: "\u06F22"
            }
            Key {
                text: "\u06F3"
                alternativeKeys: "\u06F33"
            }
        }
        KeyboardRow {
            Key {
                text: "\u06F4"
                alternativeKeys: "\u06F44"
            }
            Key {
                text: "\u06F5"
                alternativeKeys: "\u06F55"
            }
            Key {
                text: "\u06F6"
                alternativeKeys: "\u06F66"
            }
        }
        KeyboardRow {
            Key {
                text: "\u06F7"
                alternativeKeys: "\u06F77"
            }
            Key {
                text: "\u06F8"
                alternativeKeys: "\u06F88"
            }
            Key {
                text: "\u06F9"
                alternativeKeys: "\u06F99"
            }
        }

        KeyboardRow {
            BackspaceKey {}
            ChangeLanguageKey {
                customLayoutsOnly: true
            }
            Key {
                text: "\u06F0"
                alternativeKeys: "\u06F00"
            }
            EnterKey {}
        }
    }
}
