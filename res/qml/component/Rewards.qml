import QtQuick 2.3

Item{
    height: parent.height
    width: parent.width*0.5

    Grid{
        columns: 10
        rows: 5
        anchors.fill : parent
        anchors.margins: 30
        spacing: 10
        property int rowHeight : ( height - (spacing * rows - 1) - 2 * anchors.margins ) / rows
        Repeater{
            model : 50

            Rectangle{
                width: parent.rowHeight
                height: parent.rowHeight
                radius: 5
                border.color:globals.ui.borderColor
                border.width: 2
                color : "transparent"

            }

        }
    }
}

