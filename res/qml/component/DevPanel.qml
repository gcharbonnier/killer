import QtQuick 2.4

Item{
    anchors.fill: parent

    Item{
        id:container            //This item is used to center the content of the page and is scale animated

        anchors.centerIn: parent
        width: parent.width * 0.7
        height: parent.height * 0.9
        scale : 0
        Component.onCompleted: state = "Ready";
        states: State {
            name: "Ready"
            PropertyChanges { target:container; scale : 1}
        }
        transitions: Transition {
            PropertyAnimation { properties: "scale"; duration:1000;easing.type: Easing.InOutQuad }
        }

        ListModel{
            id:resolutionModel

            ListElement{
                label:"1920x1080"
                width : 1920
                height : 1080
            }
            ListElement{
                label:"1024x768"
                height : 768
                width : 1024
            }
            ListElement{
                label:"480x800 (Galaxy S, Ace4)"
                height : 480
                width : 800
            }
            ListElement{
                label:"360x640 (Nokia, Sony Ericson)"
                height : 360
                width : 640
            }
            ListElement{
                label:"320x480 (Galaxy Ace, IPhone 3GS)"
                height : 320
                width : 480
            }
            ListElement{
                label:"240x320 (Galaxy mini)"
                height : 240
                width : 320
            }



        }


        Rectangle {
            id:mainPage
            width: parent.width
            height: parent.height - 110

            visible: true
            opacity:0.8
            radius: height * globals.ui.backgroundRadiusPercHeight
            color: globals.ui.background

            Column{
                id:content
                anchors.fill : parent
                anchors.margins: 0
                property int rowHeight : Math.floor( Math.min(100, (height - 6 * spacing) /7))
                spacing: 5

                Row{
                    spacing:5
                    width: parent.width
                    height: parent.rowHeight


                    Text{
                        text:"Resolution :"
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: globals.ui.textXL
                        color: globals.ui.textcolor
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                        width: parent.width * 0.5
                        height:parent.height
                    }

                    SPSSpinButton{
                        id:spinResolution

                        model:resolutionModel
                        width: parent.width * 0.4
                        height:content.rowHeight
                        onOptionChanged: {
                            mainWnd.visibility = 2
                            mainWnd.width = currentItem.width
                            mainWnd.height = currentItem.height
                        }
                    }
                }
            }

        }
        SPSButtonText{
            width: parent.width * 0.4
            height: Math.min(100,parent.height *0.1)
            anchors.left: parent.left
            anchors.bottom : parent.bottom
            text:"Return"
            onClicked:{

                //mainWnd.mainPanel.state=""
                loader.source = "MainMenu.qml"
            }
        }


    }
}



