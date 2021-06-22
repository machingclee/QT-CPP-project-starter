import QtQuick 2.0
import QtQuick.Controls 2.5
import com.company.backend 1.0
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
        width: 400
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            width: 200
            height: globalStates.topPadding
            color: "#ffffff"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row {
            id: grid
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            TextField {
                id: projectNameTextField
                placeholderText: qsTr("Project Name")
                selectByMouse: true
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
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
        }


        GroupBox{
            title: qsTr("Projects")
            width: parent.width + 20
            height: parent.height - 100
            anchors.horizontalCenter: parent.horizontalCenter
            Item {
                id: projectListViewColumn
                width: parent.width
                height: parent.height - projectListViewColumn.y
                anchors.horizontalCenter: parent.horizontalCenter
                Component{
                    id: projectNameDelegate

                    Item{
                        id: container
                        width: parent.width

                        height:50

                        RowLayout{
                            width: 280


                            Rectangle{
                                height: 40
                                width: parent.width - selectButton.width

                                Label{
                                    id: projectNameLabels
                                    text: projectName
                                    anchors.verticalCenter:  parent.verticalCenter
                                }
                            }

                            Rectangle{
                                height: 40

                                width: selectButton.width
                                RowLayout{
                                    spacing: 8
                                    Button{
                                        id: selectButton
                                        height:30
                                        text: "Select"

                                        anchors.verticalCenter:  parent.verticalCenter
                                        onClicked: {
                                            actions.selectProject(uuid, projectName)
                                        }
                                    }


                                    Button{
                                        id: deleteButton
                                        height:30

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
                }

                ListView{
                    id: projectListView
                    visible: true
                    anchors.fill: parent
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    model: states.projectListModel
                    delegate: projectNameDelegate
                }


            }
        }


    }

}
