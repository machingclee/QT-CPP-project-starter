import QtQuick 2.2
import QtQuick.Controls 2.2

Page {
    id: page
    width: 600
    height: 400
    title: qsTr("Project List")
    anchors.fill: parent

    ProjectHomeMainComponent{
        anchors.fill: parent
    }
}




/*##^##
Designer {
    D{i:0;formeditorZoom:1.1}
}
##^##*/
