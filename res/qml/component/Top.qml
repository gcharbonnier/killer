import QtQuick 2.0

Item {

    Row{
        spacing: 5
        anchors.fill: parent
        anchors.margins: 5

        property int colWidth : (width - height) / 4

        Column{
            height : parent.height
            width : parent.colWidth
            spacing: 10
            SPSButtonText{
                text : accountModel.accountName
                //text: "Charby"
                color:"transparent"
                width: parent.width
                height: parent.height * 0.45

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        content.stack.push({item:Qt.resolvedUrl("qrc:/res/qml/component/Player.qml"), replace:true});
                    }
                }
            }
            SPSButtonText{
                text: gameManager.campaignName
                color:"transparent"
                width: parent.width
                height: parent.height * 0.45

                MouseArea{
                    anchors.fill: parent          
                    onClicked: {
                        content.stack.push({item:Qt.resolvedUrl("qrc:/res/qml/component/Campaign.qml"), replace:true});
                    }
                }
            }
        }

        Column{
            height : parent.height
            width : parent.colWidth * 3
            spacing: 10

            SPSProgressBar{
                width: parent.width
                height: parent.height * 0.45
                sourceSymbol: "qrc:/res/appbar.cards.heart.png"
                value:75
            }

            SPSButtonText{
                text: "$ : 1234"
                width: Math.min( 200 ,parent.width)
                color: globals.ui.buttonBkColor
                height: parent.height * 0.45

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        notificationBox.color="blue";
                        notificationBox.text="This is the notification test";
                    }
                }
            }
        }

        //Santé
        //Point
        //Argent
        //Reseau
        //Connexion bdd
        //Nom équipe
        //
    }

    ListModel{
        id:menuContent
        ListElement {
            imageSource: "qrc:/res/crosshairs-146113_640.png"
            componentUrl: "qrc:/res/qml/component/Map.qml"
            text: "Map"
        }
        ListElement {
            imageSource: "qrc:/res/fingerprint48.png"
            componentUrl: "qrc:/res/qml/component/Character.qml"
            text: "Actions"
        }
        ListElement {
            imageSource: "qrc:/res/reading-310397_640.png"
            componentUrl: "/res/qml/component/Help.qml"
            text: "Actions"
        }
        ListElement {
            imageSource: "qrc:/res/star139.png"
            componentUrl: "/res/qml/component/Rewards.qml"
            text: "Actions"
        }

        ListElement {
            imageSource: "qrc:/res/walkie5.png"
            componentUrl: "/res/qml/component/Intercom.qml"
            text: "Actions"
        }

        ListElement {
            imageSource: "qrc:/res/man374.png"
            componentUrl: "/res/qml/component/Skills.qml"
        }

        ListElement {
            imageSource: "qrc:/res/shield77.png"
            componentUrl: "/res/qml/component/Equipment.qml"
        }
    }

    MenuSelector{
        model: menuContent
        stack: content.stack

    }




}

