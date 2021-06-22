import QtQuick 2.0
import QtQuick.Controls 2.5
import com.company.backend 1.0
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
Item {
    Item {
        id: states
        property variant projectListModel: ListModel {}
    }

    Backend{
        id: backend
    }

    ProjectsHomeDAO{
        id: projectsHomeDao
    }

    Item{
        id: actions

        signal addProject(string projectName)
        signal saveAllProjects(bool showAlert)
        signal getAllProjects()
        signal selectProject(string uuid, string projectName)
        signal removeAtIndex(string index)

        onAddProject: {
            const uuid = backend.generateUUId().replace(/\{|\}/g,"")
            states.projectListModel.append({ projectName, uuid })
        }
        onSaveAllProjects: {
            projectsHomeDao.clearAll()

            const {err} = projectsHomeDao.saveAll(states.projectListModel)
            if(err){
                globalActions.showAlert(err)
            } else {
                if(!showAlert){
                    return
                }
                globalActions.showAlert("Project is saved successfully.")
            }
        }
        onGetAllProjects:{
            states.projectListModel.clear()
            const { success, result: projects, err } = projectsHomeDao.getAll()
            if(err){
                globalActions.showAlert(err)
            }else{
                for(var i=0; i < projects.length; i++){
                    const { uuid, projectName } = projects[i]
                    console.log(" projects[i]",  uuid, projectName)
                    states.projectListModel.append({ uuid, projectName })
                }
            }
        }
        onSelectProject:{
            globalActions.setSelectedProjectUuid(uuid)
            globalActions.setSelectedProjectName(projectName)
            actions.saveAllProjects(false)
            globalActions.navToProjectDetail()
        }
        onRemoveAtIndex: {
            states.projectListModel.remove(index, 1)
        }
    }

    Component.onCompleted: {
        console.log("get all projects")
        actions.getAllProjects()
    }

    Column {
        id: column
        y: 0
        width: 600
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            width: 200
            height: globalStates.topPadding
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        RowLayout {
            id: grid
            Layout.fillWidth: true
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12

            TextField {
                id: projectNameTextField
                placeholderText: qsTr("Project Name")
                selectByMouse: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                Layout.rightMargin: 20
            }

            Button {
                text: "Add"
                onClicked: {
                    const name = projectNameTextField.text
                    if(name.replace(/\s+/g,"")!== ""){
                        actions.addProject(name.trim())
                    }
                }

            }

            Button {
                text: "Save"
                onClicked: {
                    actions.saveAllProjects(true)
                }
            }
        }

        Rectangle {
            width: 200
            height: globalStates.topPadding
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
        }


        Column {
            id: projectListViewColumn
            width: 200
            height: parent.height - projectListViewColumn.y
            anchors.horizontalCenter: parent.horizontalCenter

            Component{
                id: projectNameDelegate


                Item{
                    id: container
                    anchors.horizontalCenter: parent.horizontalCenter
                    height:54

                    RowLayout{
                        width: 280
                        anchors.horizontalCenter: parent.horizontalCenter

                        Rectangle{
                            height: 40
                            color:"transparent"
                            width: parent.width - selectButton.width
                            Layout.rightMargin: 20
                            border.width: 1
                            border.color: "#c2c2c2"
                            radius: 5
                            Layout.topMargin: 2


                            Label{
                                id: projectNameLabels
                                text: projectName
                                anchors.verticalCenter:  parent.verticalCenter
                                padding: 10

                            }
                        }


                        RowLayout{
                            spacing: 12
                            Layout.alignment: Qt.AlignVCenter
                            Button{
                                id: selectButton
                                text: "Select"
                                anchors.verticalCenter:  parent.verticalCenter
                                onClicked: {
                                    actions.selectProject(uuid, projectName)
                                }
                            }


                            Button{
                                id: deleteButton
                                text:"Delete"
                                anchors.verticalCenter: parent.verticalCenter
                                onClicked: {
                                    actions.removeAtIndex(index)
                                }
                            }

                        }
                    }
                }
            }

            ListView{
                id: projectListView
                visible: true
                anchors.fill: parent
                model: states.projectListModel
                delegate: projectNameDelegate
            }


        }

    }

}
