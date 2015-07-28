import QtQuick 2.0

Rectangle{
    id:menuSelector
    property int maximizedWidth: 300
    property int maximizedheight: 300
    property var model: null
    property var stack: null

    layer.enabled: false

    radius:Math.min(20, height * globals.ui.buttonRadiusPercHeight)
    opacity:0.8
    border.width: 0
    color: globals.ui.buttonMenuBkColor


    Component.onCompleted: {
        content.stack.push({item:Qt.resolvedUrl(model.get(0).componentUrl), replace:true});
    }


    Image{
        id:menuimg
        anchors.fill: parent
        anchors.margins: Math.min(15, menuSelector.height * 0.05)
        //anchors.margins: 20
        source: repeaterMenu.currentData.imageSource ? repeaterMenu.currentData.imageSource : "qrc:/res/menu.png"
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if (state == "")
                menuSelector.state = "opened";
            else menuSelector.state ="";
        }
        onExited: menuSelector.state ="";
    }

    Rectangle{
        id:lstChoice
        width: parent.width
        height: parent.height
        opacity:0
        color:"#00000000"
        enabled:false


        Grid{
            anchors.fill: parent
            anchors.margins:Math.min(20, menuSelector.height*0.05)
            rows:3
            columns:3
            spacing: Math.min(20, height*0.05)
            property int ceilWidth: (width - (columns-1)*spacing)/columns
            property int ceilHeight: (height - (rows-1)*spacing)/rows

            Repeater{
                id:repeaterMenu
                model:menuSelector.model
                property variant currentData: model
                Rectangle{
                    width: parent.ceilWidth
                    height:parent.ceilHeight
                    color:globals.ui.buttonMenuBkColor
                    radius: Math.min(20, height * globals.ui.buttonRadiusPercHeight)
                    Image{
                        source: imageSource
                        anchors.fill: parent
                        anchors.margins: Math.min(20, menuSelector.height*0.05)
                    }
                    Text
                    {
                        id: embText
                        text: label
                        enabled: parent.enabled
                        anchors.fill: parent
                        anchors.margins: globals.ui.buttonMargin
                        color: "black"//globals.ui.textcolor
                        font.pixelSize: globals.ui.textM
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                        font.family: "Syncopate"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment : Text.AlignVCenter
                    }

                    MouseArea{
                        anchors.fill: parent
                        propagateComposedEvents: true
                        onClicked: {
                            menuSelector.stack.push({item:Qt.resolvedUrl(componentUrl), replace:true});
                            menuSelector.state = "";
                            menuimg.source = imageSource

                        }
                    }

                }

            }

            Rectangle{
                width: parent.ceilWidth
                height:parent.ceilHeight
                color: globals.ui.buttonMenuBkColor
                radius: Math.min(20, height * globals.ui.buttonRadiusPercHeight)
                Image{
                    source:"qrc:/res/close.png"
                    anchors.fill: parent
                    anchors.margins: Math.min(20, menuSelector.height*0.05)
                }
                Text
                {
                    text: qsTr("Quit campaign")
                    enabled: parent.enabled
                    anchors.fill: parent
                    anchors.margins: globals.ui.buttonMargin
                    color: "black"//globals.ui.textcolor
                    font.pixelSize: globals.ui.textM
                    minimumPixelSize: globals.ui.minimumPixelSize
                    fontSizeMode : Text.Fit
                    font.family: "Syncopate"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment : Text.AlignVCenter
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        mainPanel.state="";
                        gameManager.stopGame( );
                        menuSelector.state = "";
                    }
                }
            }
        }
    }


    states: [
            State {
                name: "opened"
                PropertyChanges { target: menuSelector; width: maximizedWidth }
                PropertyChanges { target: menuSelector; height: maximizedheight }
                PropertyChanges { target: menuSelector; border.width: 0 }
                PropertyChanges { target: menuSelector; color: globals.ui.menuBackground }
                PropertyChanges { target: lstChoice; opacity: 0.8 }
                PropertyChanges { target: lstChoice; enabled: true }
                PropertyChanges { target: menuimg; visible: false }
            }
        ]
    transitions: Transition {
                PropertyAnimation { properties: "width,height, opacity"; duration:1000;easing.type: Easing.InOutQuad }
                ColorAnimation { target: menuSelector; duration:1000}
        }

}


