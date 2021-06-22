import QtQuick 2.0
import QtQuick.Controls 2.5
import com.company.backend 1.0


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
        width: 252
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

                    Row{
                        width: 280
                        anchors.horizontalCenter: parent.horizontalCenter

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
                                text:"Del"
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
