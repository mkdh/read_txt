import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import FileIO 1.0
import QtQuick.Controls.Styles 1.4


import QtQuick.Dialogs 1.0

ApplicationWindow {
    id: root_app
    visible: true
    width: 640
    height: 480

    onWidthChanged: {
        //        g_cls_thread_serial_port.set_setting_value("WINDOW_WIDTH" ,root_app.width)
    }

    onHeightChanged: {
        //        g_cls_thread_serial_port.set_setting_value("WINDOW_HEIGHT" ,root_app.height)

    }
    Component.onCompleted: {
        root_app.load_setting()
    }

    onClosing: {
        root_app.save_setting()
    }


    function load_setting()
    {
        btn_load.content_y= g_cls_thread_serial_port.get_setting_value("CONTENT_Y")
        myText.color = g_cls_thread_serial_port.get_setting_value("FONT_COLOR")
        rect_textarea.color = g_cls_thread_serial_port.get_setting_value("BACKGROUND_COLOR")
        myFile.source = g_cls_thread_serial_port.get_setting_value("FILE_PATH")
        myText.text =  myFile.read();
        root_app.width = g_cls_thread_serial_port.get_setting_value("WINDOW_WIDTH")
        root_app.height = g_cls_thread_serial_port.get_setting_value("WINDOW_HEIGHT")
        flickable.contentY = btn_load.content_y
        root_app.x =  g_cls_thread_serial_port.get_setting_value("POS_X")
        root_app.y =  g_cls_thread_serial_port.get_setting_value("POS_Y")


    }

    function save_setting()
    {
        g_cls_thread_serial_port.set_setting_value("WINDOW_WIDTH" ,root_app.width)
        g_cls_thread_serial_port.set_setting_value("WINDOW_HEIGHT" ,root_app.height)
        g_cls_thread_serial_port.set_setting_value("CONTENT_Y" ,flickable.contentY)
        g_cls_thread_serial_port.set_setting_value("POS_X" ,root_app.x)
        g_cls_thread_serial_port.set_setting_value("POS_Y" ,root_app.y)

    }


    title: qsTr("Hello World")

    function get_short_text(full_text, limit_number) {

        if(full_text.length > limit_number)
        {
            return full_text.substring(0, limit_number);
        }
        else
        {
            return full_text;
        }
    }






    Connections{
        target: g_cls_thread_serial_port
        onSignal_send_to_qml: {
            //txt_debug_message.text += msg + "\r\n"
            txt_debug_message.text = msg + "\r\n------------" +  txt_debug_message.text + "\r\n"


            txt_debug_message.text = get_short_text(txt_debug_message.text , 1000)
        }
    }
    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Page {

            Rectangle {
                id: rect_menu
                color: "gray"
                width: parent.width
                height: 30
                Row {
                    Button {
                        text: "open file"
                        height: rect_menu.height
                        onClicked: {
                            fileDialog.visible = true
                        }

                        FileDialog {
                            id: fileDialog
                            title: "Please choose a file"
                            folder: shortcuts.home
                            onAccepted: {
                                console.log("You chose: " + fileDialog.fileUrls)
                                myFile.source = "" + fileDialog.fileUrls
                                myText.text =  myFile.read();
                                g_cls_thread_serial_port.set_setting_value("FILE_PATH" ,myFile.source)

                            }
                            onRejected: {
                                console.log("Canceled")
                            }
                            Component.onCompleted: visible = false
                        }
                    }

                    Button {
                        text: "font color"
                        height: rect_menu.height
                        onClicked: {
                            colorDialog.visible = true
                        }
                        ColorDialog {
                            id: colorDialog
                            title: "Please choose a color"

                            onAccepted: {
                                console.log("You chose: " + colorDialog.color)
                                myText.color = colorDialog.color
                                g_cls_thread_serial_port.set_setting_value("FONT_COLOR" ,colorDialog.color)
                            }
                            Component.onCompleted: visible = false
                        }
                    }

                    Button {
                        text: "background color"
                        height: rect_menu.height
                        onClicked: {
                            colorDialog_backgroung.visible = true
                        }
                        ColorDialog {
                            id: colorDialog_backgroung
                            title: "Please choose a color"

                            onAccepted: {
                                rect_textarea.color = colorDialog_backgroung.color
                                g_cls_thread_serial_port.set_setting_value("BACKGROUND_COLOR" ,colorDialog_backgroung.color)

                            }
                            Component.onCompleted: visible = false
                        }
                    }

                    Button {
                        id: btn_load

                        text: "load setting"
                        height: rect_menu.height
                        property real content_y: 0
                        onClicked: {

                            root_app.load_setting()
                        }
                    }


                    Button {
                        text: "save setting"
                        height: rect_menu.height

                        onClicked: {
                            root_app.save_setting()
                        }
                    }
                }
            }
            Rectangle {
                id: rect_textarea
                //http://stackoverflow.com/questions/8894531/reading-a-line-from-a-txt-or-csv-file-in-qml-qt-quick
                color: "white"

                width: parent.width
                anchors.top: rect_menu.bottom
                anchors.bottom: parent.bottom
                Flickable {
                    id: flickable
                    Component.onCompleted: {

                    }

                    anchors.fill: parent
                    onContentYChanged: {
                        //                        g_cls_thread_serial_port.set_setting_value("CONTENT_Y" ,flickable.contentY)
                    }

                    TextArea.flickable: TextArea {
                        id: myText
                        anchors.fill: parent
                        wrapMode:TextEdit.WrapAnywhere
                        text: ""
                    }

                    ScrollBar.vertical: ScrollBar { }
                }



                FileIO {
                    id: myFile
                    source: "my_file.txt"
                    onError: console.log(msg)
                }

            }


        }

        Page {
            Flickable {
                id: flickableItem
                anchors.fill: parent

                TextArea.flickable: TextArea {
                    id:txt_debug_message
                    anchors.fill: parent
                    //                    mouseSelectionMode:TextEdit.SelectWords
                    wrapMode: TextEdit.WrapAnywhere
                    text:"";
                    onContentHeightChanged: {
                        if(contentHeight > height)
                        {
                            flickableItem.contentY = contentHeight - height
                        }
                    }
                }//TextArea

                ScrollBar.vertical: ScrollBar { }
            }//Flickable

        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("First")
        }
        TabButton {
            text: qsTr("Second")
        }
    }




}
