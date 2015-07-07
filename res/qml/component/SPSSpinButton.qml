import QtQuick 2.4

Item {
    id:root
    property alias model:lstView.model
    property alias currentSelection:lstView.currentSelection

    property variant currentItem: null
    signal optionChanged()

    property string labelPrefix : ""
    property string roleToDisplayName : "label"
    property bool useImage : true

    Component.onCompleted: {
        currentItem = lstView.itemAt(currentSelection).currentData;
    }

    // - bail congés pour vente

    ListModel{
        id:dummyModel
        //A dummy model to test the component
        ListElement{
            label:"Option 1"
        }
        ListElement{
            label:"Option 2"
        }
        ListElement{
            label:"Option 3"
        }
    }

    Row{
        id:content
        anchors.fill : parent
        property int widthArrow: Math.floor(( width - 2 * (spacing + anchors.margins) ) / 5)
        //property int spacing: 5
        spacing: 5

        Rectangle{
            id:leftArrow
            radius : height * globals.ui.buttonRadiusPercHeight
            opacity: globals.ui.buttonBkOpacity
            height:content.height
            width: content.widthArrow
            //x:parent.x

            enabled: lstView.currentSelection > 0
            color:root.useImage ? "transparent" : enabled ? globals.ui.textInputBackground : globals.ui.buttonBkColorDisabled

            Text{
                text:"<<"
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment : Text.AlignVCenter
                font.pixelSize: globals.ui.textXL
                color: globals.ui.textEditColor
                minimumPixelSize: globals.ui.minimumPixelSize
                fontSizeMode : Text.Fit
                visible: !root.useImage

            }
            Image{
                anchors.fill: parent
                source:"qrc:/res/previous.png"
                visible: root.useImage && leftArrow.enabled
            }
            MouseArea{
                anchors.fill: parent
                onClicked: { lstView.previous();}
            }
        }

        Repeater{
            id:lstView
            model:dummyModel
            property int currentSelection: 0

            function next(){

                if (currentSelection < count)
                {
                    currentSelection++;
                    root.currentItem = itemAt(currentSelection).currentData;
                    root.optionChanged();
                }
            }
            function previous(){
                if (currentSelection > 0)
                {
                    currentSelection--;
                    root.currentItem = itemAt(currentSelection).currentData;
                    root.optionChanged();
                }

            }
            delegate:
                Rectangle{
                    property variant currentData: model
                    height:content.height
                    width: content.widthArrow * 3
                    radius:10
                    color: "transparent"//globals.ui.textInputBackground
                    opacity: globals.ui.buttonBkOpacity
                    visible:index === lstView.currentSelection;
                    Text{
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment : Text.AlignVCenter
                        text: labelPrefix + currentData[root.roleToDisplayName]
                        font.pixelSize: globals.ui.textXL
                        color: globals.ui.textEditColor
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                    }
                }
        }



        Rectangle{
            id:rightArrow
            radius : height * globals.ui.buttonRadiusPercHeight
            opacity: globals.ui.buttonBkOpacity
            height:content.height
            width: content.widthArrow
            //x:lstView.x + lstView.width + parent.spacing
            enabled: lstView.currentSelection < (lstView.count -1)
            color:root.useImage ? "transparent" : enabled ? globals.ui.textInputBackground : globals.ui.buttonBkColorDisabled
            Text{
                text:">>"
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment : Text.AlignVCenter
                font.pixelSize: globals.ui.textXL
                color: globals.ui.textEditColor
                minimumPixelSize: globals.ui.minimumPixelSize
                fontSizeMode : Text.Fit
                visible: !root.useImage
            }
            Image{
                anchors.fill: parent
                source:"qrc:/res/next.png"
                visible: root.useImage && rightArrow.enabled

            }

            MouseArea{
                anchors.fill: parent
                onClicked: { lstView.next();}
            }
        }


    }
}







