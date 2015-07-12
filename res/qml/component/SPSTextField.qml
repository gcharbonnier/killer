import QtQuick 2.4

Item {
    property alias text : embTextInput.text
    property alias color : embTextInput.color
    property alias backgroundColor : embRect.color
    property alias echoMode : embTextInput.echoMode
    property alias validator : embTextInput.validator
    property alias horizontalAlignment : embTextInput.horizontalAlignment
    property alias verticalAlignment : embTextInput.verticalAlignment
    signal editingFinished()

    Rectangle{
        id:embRect
        radius : height * globals.ui.buttonRadiusPercHeight
        opacity: globals.ui.buttonBkOpacity
        height:parent.height
        width: parent.width
        color:globals.ui.textInputBackground

    }

    TextInput{
        id:embTextInput
        text: "default"
        anchors.fill: embRect
        //anchors.centerIn: embRect
        verticalAlignment: TextInput.AlignVCenter
        horizontalAlignment: TextInput.AlignHCenter
        //height:parent.height
        //width: parent.width
        font.pixelSize: globals.ui.textInputDynSize
        color: globals.ui.textEditColor
        onEditingFinished: parent.editingFinished();

    }
}

