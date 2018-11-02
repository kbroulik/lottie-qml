/*
 * Copyright 2018 Kai Uwe Broulik <kde@broulik.de>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) version 3, or any
 * later version accepted by the membership of KDE e.V. (or its
 * successor approved by the membership of KDE e.V.), which shall
 * act as a proxy defined in Section 6 of version 3 of the license.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.10
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0
import org.kde.lottie 1.0 as Lottie

Window {
    id: root

    width: 800
    height: 600
    title: "Lottie Tester"
    visible: true

    Shortcut {
        sequence: StandardKey.Quit
        onActivated: Qt.quit()
    }

    Shortcut {
        sequence: "Ctrl+Tab" // FIXME StandardKey.NextChild
        onActivated: sourceCombo.incrementCurrentIndex()
    }
    Shortcut {
        sequence: "Ctrl+Shift+Tab" // FIXME StandardKey.PreviousChild
        onActivated: sourceCombo.decrementCurrentIndex()
    }
    Shortcut {
        sequence: StandardKey.FullScreen
        onActivated: fullCheck.checked = !fullCheck.checked
    }

    Settings {
        id: settings
        property alias windowWidth: root.width
        property alias windowHeight: root.height
        property alias loop: loopCheck.checked
        property alias clearBeforeRendering: clearCheck.checked
        property alias reverse: reverseCheck.checked
        property alias fullScreen: fullCheck.checked
        property alias fillMode: fillModeCombo.currentIndex
        //property real speed: speedSlider.value
        property alias debug: debugCheck.checked
        property string color
        onColorChanged: colorCombo.currentIndex = colorCombo.model.indexOf(color)

        property alias lastFile: lottieAnim.source
        // TODO remember all open files
        property var files
    }

    ToolBar {
        id: toolBar
        width: parent.width
        height: toolFlow.height
        z: 2

        Flow {
            id: toolFlow
            width: parent.width
            spacing: 5

            ComboBox {
                id: sourceCombo
                textRole: "text"
                model: []

                function itemFromUrl(url) {
                    var filename = /[^/]*$/.exec(url)[0]; // extract file name from URL

                    return {
                        text: filename,
                        value: url
                    }
                }

                Component.onCompleted: {
                    if (settings.lastFile) {
                        model = [itemFromUrl(settings.lastFile)];
                    }
                }
            }

            Button {
                id: playCheck
                text: lottieAnim.running ? "Pause" : "Play"
                onClicked: lottieAnim.running = !lottieAnim.running
            }

            Button {
                text: "Stop"
                onClicked: lottieAnim.stop()
            }

            CheckBox {
                id: loopCheck
                text: "Loop"
                checked: true
            }

            CheckBox {
                id: clearCheck
                text: "Clear before rendering"
                checked: true
            }

            CheckBox {
                id: reverseCheck
                text: "Reverse"
            }

            CheckBox {
                id: fullCheck
                text: "Full size"
            }

            ComboBox {
                id: fillModeCombo
                model: [
                    {text: "Stretch", value: Image.Stretch},
                    {text: "Fit", value: Image.PreserveAspectFit},
                    {text: "Crop", value: Image.PreserveAspectCrop},
                    {text: "Pad", value: Image.Pad}
                ]
                textRole: "text"
            }

            Slider {
                id: speedSlider
                from: 0
                to: 5
                value: 1
                stepSize: 0.1
            }

            Label {
                text: speedSlider.value.toFixed(1) + "x"
            }

            ComboBox {
                id: colorCombo
                model: ["white", "black", "red", "green", "blue", "magenta", "cyan",
                    "springgreen", "steelblue", "tan", "teal", "thistle", "salmon", "sandybrown"]
                contentItem: Rectangle {
                    border {
                        width: 1
                    }

                    color: colorCombo.currentText
                }

                delegate: ItemDelegate {
                    width: colorCombo.width

                    Rectangle {
                        anchors.fill: parent
                        color: modelData
                    }
                }

                onCurrentTextChanged: settings.color = currentText
            }

            CheckBox {
                id: debugCheck
                text: "Debug"
            }
        }

    }

    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            top: toolBar.bottom
            bottom: parent.bottom
        }
        color: colorCombo.currentText

        Label {
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
            text: {
                if (lottieAnim.status === Image.Error) {
                    return (lottieAnim.errorString || "Error");
                } else if (sourceCombo.count === 0) {
                    return "Drop a Lottie JSON animation file here to preview it."
                } else {
                    return ""
                }
            }
            visible: text !== ""
        }

        Lottie.LottieAnimation {
            id: lottieAnim
            anchors.centerIn: parent
            width: fullCheck.checked ? parent.width : implicitWidth
            height: fullCheck.checked ? parent.height : implicitHeight
            source: (sourceCombo.model[sourceCombo.currentIndex] || {}).value || ""
            running: true
            clearBeforeRendering: clearCheck.checked
            speed: speedSlider.value
            loops: loopCheck.checked ? Animation.Infinite : 0
            fillMode: fillModeCombo.model[fillModeCombo.currentIndex].value
            reverse: reverseCheck.checked
        }

        Rectangle {
            anchors.fill: lottieAnim
            border {
                width: 1
                color: "#000"
            }
            color: "#33ff00ff"
            visible: debugCheck.checked
        }

        DropArea {
            anchors.fill: parent
            onEntered: {
                if (!drag.hasUrls) {
                    drag.accepted = false;
                }
            }

            onDropped: {
                if (!drop.hasUrls) {
                    return;
                }

                var newModel = sourceCombo.model;

                drop.urls.forEach(function (url) {
                    newModel.push(sourceCombo.itemFromUrl(url));
                });

                sourceCombo.model = newModel;
                sourceCombo.currentIndex = sourceCombo.count - 1;
            }
        }
    }
}
