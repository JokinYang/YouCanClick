import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("You Can Click")

    function setTimeout(callback, timeout) {
        let timer = Qt.createQmlObject("import QtQuick 2.12; Timer {}", window)
        timer.interval = timeout
        timer.repeat = false
        timer.triggered.connect(callback)
        timer.start()
    }

    function is_point_in_rect(px, py, rx1, ry1, rx2, ry2) {
        return px >= rx1 && px <= rx2 && py >= ry1 && py <= ry2
    }

    function gen_next_pos(mx, my, x, y, w, h) {
        // mx means mouseX
        // x,y means the weight's top-left position
        // w,h means the weight's w and h
        let delta = 100

        const W = window.width - w
        const H = window.height - h

        const px = x + mx
        const py = y + my

        const i_x1 = Math.max(px - w - delta, 0)
        const i_y1 = Math.max(py - h - delta, 0)
        const i_x2 = Math.min(px + w + delta, W)
        const i_y2 = Math.min(py + h + delta, H)

        let target_x = 0
        let target_y = 0

        do {
            target_x = Math.random() * W
            target_y = Math.random() * H
        } while (!is_point_in_rect(target_x, target_y, i_x1, i_y1, i_x2, i_y2))

        return [target_x, target_y]
    }

    Rectangle {

        id: mouse_area_rect
        //anchors.centerIn: parent
        width: label.width + 20
        height: label.height + 20
        x: (window.width - width) / 2
        y: (window.height - height) / 2
        color: "#12456789"
        radius: 15

        Behavior on x {
            NumberAnimation {
                id: x_animation
                easing.type: Easing.OutBack
                duration: 200
            }
        }

        Behavior on y {
            NumberAnimation {
                id: y_animation
                easing.type: Easing.OutBack
                duration: 200
            }
        }

        Text {
            id: label
            anchors.centerIn: parent
            font.pointSize: 20

            //color: "#f5e902"
            text: qsTr("Click Me!")
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
            hoverEnabled: true
            property bool moving: false

            function update_pos() {
                if (x_animation.running || y_animation.running)
                    return
                let x, y

                       [x, y] = gen_next_pos(mouseX, mouseY, parent.x,
                                             parent.y, parent.width,
                                             parent.height)
                parent.x = x
                parent.y = y
            }

            onPositionChanged: {
                update_pos()
            }

            onClicked: {
                update_pos()
            }
        }
    }
}
