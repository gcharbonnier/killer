import QtQuick 2.4
import QtQuick.Controls 1.2

Item {


    property var stack:stack
    StackView{
        id:stack
        //initialItem:targetSelect
        anchors.fill: parent
        delegate: StackViewDelegate{
            function transitionFinished(properties)
            {
                properties.exitItem.x = 0
                properties.exitItem.rotation = 0
            }

            pushTransition: StackViewTransition {
                SequentialAnimation {
                    ScriptAction {
                        script: enterItem.rotation = 90
                    }
                    PropertyAnimation {
                        target: enterItem
                        property: "x"
                        from: enterItem.width
                        to: 0
                    }
                    PropertyAnimation {
                        target: enterItem
                        property: "rotation"
                        from: 90
                        to: 0
                    }
                }
                PropertyAnimation {
                    target: exitItem
                    property: "x"
                    from: 0
                    to: -exitItem.width
                }
            }
        }
    }


}

