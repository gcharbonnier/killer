import QtQuick 2.3


Item{

    height: parent.height
    width: parent.width
    visible:true
    z:1000

    Grid{
        columns: 10
        rows: 5
        height: parent.height
        width: parent.width
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

