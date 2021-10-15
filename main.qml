import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Qt.labs.calendar 1.0
import QtQml 2.12

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Calendar")




    GridLayout {
        id: gridLayout
        anchors.fill: parent
        columns: 1

        RowLayout{
            Layout.fillWidth: true
            Layout.row: 0
            Layout.preferredHeight: 40

            Button{
                id: back
                Layout.fillWidth: true
                text: "<"
                onClicked: gridLayout.decDate()
                Layout.fillHeight: true
            }


            ComboBox{
                id: monthcb
                Layout.fillWidth: true
                onCurrentIndexChanged: grid.month = currentIndex
                model: gridLayout.fillMonth()
                currentIndex: grid.month
                padding: 5
                hoverEnabled: true
                popup.onOpened: {  }
            }

            Button{
                id: today
                Layout.fillWidth: true
                text: "today"
                Layout.fillHeight: true
                onClicked:{
                    var d = new Date()
                    grid.year=d.getFullYear()
                    grid.month=d.getMonth()
                }
            }

            ComboBox{
                id: yearcb
                Layout.fillWidth: true
                onCurrentTextChanged: grid.year = currentText
                model: gridLayout.fillYear()
                currentIndex: gridLayout.findYear()
                popup.onOpened: {  }
            }

            Button{
                id: forward
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: ">"
                onClicked: gridLayout.incDate()
            }

        }


        DayOfWeekRow {
            locale: grid.locale
            Layout.row: 1
            Layout.fillWidth: true

            delegate: Text {
                text: model.shortName
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                width: contentWidth+2
            }
        }

        MonthGrid {
            id: grid
            Layout.row: 2
            locale: Qt.locale()
            Layout.fillWidth: true
            Layout.fillHeight: true
            month: monthcb.currentIndex

            delegate: Rectangle{
                id: rect
                color: marea.containsMouse ? "cornflowerblue" : model.today ? "green" : date.getDay()%6<=0 ? "lightgrey" : "white"
                width: grid.width/7
                height: grid.height/5
                radius: 8
                opacity: model.month === grid.month ? 1 : 0.25

                MouseArea{
                    id: marea
                    anchors.fill: parent
                    hoverEnabled: true
                    onPressed: rect.scale=0.98
                    onReleased: rect.scale=1
                    onClicked: console.log(txt.date.toLocaleDateString(grid.locale))

                    Text {
                        id: txt
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        //opacity: model.month === grid.month ? 1 : 0.2
                        text: model.day
                        color: marea.containsMouse ? "white" : model.today ? "white" : "grey"
                        property var date: model.date
                        font.bold: true
                    }

                }
            }
        }
        function incDate(){
            if (grid.month === Calendar.November) {
                grid.year++
                grid.month=0
            }
            else{
                grid.month++
            }
        }

        function decDate(){
            if (grid.month === Calendar.January) {
                grid.year--
                grid.month=11
            }
            else{
                grid.month--
            }
        }

        function fillMonth(){
            var monthArr=[]
            for(var i=0; i<12; i++){
                var date = new Date(2222, i, 1)
                var month=date.toLocaleDateString(grid.locale).split(' ')[1]
                monthArr.push(month)
            }
            return monthArr
        }

        function fillYear(){
            var yearArr=[]
            var year=new Date().getFullYear()
            for(var i=year-100; i<year+100; i++){
                yearArr.push(i)
            }
            return yearArr
        }

        function findYear(){
            return fillYear().indexOf(grid.year)
        }

        function findMonth(){
            return grid.month
        }
    }

}
