import QtQuick 2.3

Item{
    height: parent.height
    width: parent.width*0.5

    Column{
        opacity: 1
        anchors.fill:parent
        anchors.margins: 20
        spacing:20
        property int rowHeight: (height - 7* spacing - 2* anchors.margins) / 7

        Row{
            width: parent.width
            height : parent.rowHeight

            Text{
                width: parent.width * 0.6
                height: parent.height
                text:"Communication channel :"
                color: globals.ui.textcolor
                font.pixelSize: globals.ui.textGodzilla
                minimumPixelSize: globals.ui.minimumPixelSize
                fontSizeMode : Text.Fit
                font.family: "Syncopate"
                horizontalAlignment: Text.AlignRight
                verticalAlignment : Text.AlignVCenter
            }


            SPSSpinButton{
                model:ListModel{
                    //A dummy model to test the component
                    ListElement{
                        label:"All"
                    }
                    ListElement{
                        label:"Your team only"
                    }
                    ListElement{
                        label:"Friends"
                    }
                    ListElement{
                        label:"Foes"
                    }
                }
                width: parent.width * 0.4
                height:parent.height
            }
        }

        Rectangle{
            width: parent.width
            height : 5 * parent.rowHeight
            color : globals.ui.background
            opacity : globals.ui.buttonBkOpacity

        }

        Row{
            width: parent.width
            height : parent.rowHeight

            Text{
                width: parent.width * 0.2
                height: parent.height
                text:"You :"
                color: globals.ui.textcolor
                font.pixelSize: globals.ui.textGodzilla
                minimumPixelSize: globals.ui.minimumPixelSize
                fontSizeMode : Text.Fit
                font.family: "Syncopate"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment : Text.AlignVCenter
            }
            SPSTextField{
                width: parent.width * 0.6
                height: parent.height
                backgroundColor:globals.ui.background
            }
            SPSButtonText{
                width: parent.width * 0.2
                height: parent.height
                text:"Send"
                //onClicked:""
            }
        }

    }
}

