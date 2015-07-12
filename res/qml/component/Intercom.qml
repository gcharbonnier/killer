import QtQuick 2.3

Item{
    height: parent.height
    width: parent.width*0.5

    Column{
        opacity: 1
        anchors.fill:parent
        anchors.margins: 5
        spacing:5
        property int rowHeight: (height - 2 * spacing ) / 7

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
            color : "white"
            opacity : 0.3

            Connections{
                target:messageModel
                onRowsInserted: lstview.positionViewAtEnd()
            }

            ListView{
                id: lstview
                clip:lstview
                anchors.fill: parent
                anchors.margins: 2
                model:messageModel

                //onCountChanged:positionViewAtEnd()
                Component.onCompleted: positionViewAtEnd()


                delegate:Row{
                    width: parent.width
                    height : 50
                    spacing: 5

                    //Component.onCompleted: lstview.positionViewAtEnd()
                    Text{
                        //date time
                        text: model.DateTime
                        color:"white"
                        width: parent.width * 0.15
                        height: parent.height
                        font.pixelSize: globals.ui.textXXL
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment : Text.AlignVCenter
                    }
                    Text{
                        text: model.Type === 0 ? model.MessageContent : model.NameEmitter +" : " + "@" + model.NameRecipient +" "+model.MessageContent
                        color : model.Type === 0 ? "white" : "blue"
                        width: parent.width * 0.8
                        height: parent.height
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment : Text.AlignVCenter

                        font.pixelSize: globals.ui.textM
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                    }



                }

            }

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
                id:msgToSend
                text:""
                width: parent.width * 0.6
                height: parent.height
                backgroundColor:globals.ui.background
                horizontalAlignment: Text.AlignLeft
            }
            SPSButtonText{
                width: parent.width * 0.2
                height: parent.height
                text:"Send"
                onClicked: messageModel.sendMessage( msgToSend.text, globals.currentTarget.name);

            }
        }

    }
}

