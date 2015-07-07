import QtQuick 2.0

Rectangle{
    id:menuSelector
    property int maximizedWidth: mainWnd.width / 2
    property int maximizedheight: mainWnd.height
    property var model: null
    property var stack: null

    layer.enabled: false
    width: height
    height: parent.height - 2 * anchors.margins
    radius:20
    opacity:0.8
    border.width: 0
    color: globals.ui.buttonMenuBkColor

    anchors{
        right: parent.right
        top: parent.top
        //bottom: parent.bottom
        margins: 20
    }

    Component.onCompleted: {
        content.stack.push({item:Qt.resolvedUrl(model.get(0).componentUrl), replace:true});
    }


    Image{
        id:menuimg
        anchors.fill: parent
        anchors.margins: 15
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
            anchors.margins: 20
            rows:3
            columns:3
            spacing: 20
            property int ceilWidth: (width - 2*anchors.margins- (columns-1)*spacing)/columns
            property int ceilHeight: (height - 2*anchors.margins- (rows-1)*spacing)/rows

            Repeater{
                id:repeaterMenu
                model:menuSelector.model
                property variant currentData: model
                Rectangle{
                    width: parent.ceilWidth
                    height:parent.ceilHeight
                    color:globals.ui.buttonMenuBkColor
                    radius:20
                    Image{
                        source: imageSource
                        anchors.fill: parent
                        anchors.margins: 20
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
                radius:20
                Image{
                    source:"qrc:/res/close.png"
                    anchors.fill: parent
                    anchors.margins: 20
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


