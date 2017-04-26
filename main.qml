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

    function jump_to_next_page()
    {
        if(flickable.contentY + flickable.height < flickable.contentHeight)
        {
            flickable.contentY = flickable.contentY + flickable.height
        }
    }

    function jump_to_previous_page()
    {
        if(flickable.contentY - flickable.height > 0)
        {
            flickable.contentY = flickable.contentY - flickable.height
        }
        else
        {
            flickable.contentY = 0
        }
    }


    readonly property real lineHeight: (myText.implicitHeight - 2 * myText.textMargin) / myText.lineCount

    function jump_to_next_column()
    {
        if(flickable.contentY +  lineHeight < flickable.contentHeight - flickable.height)
        {
            flickable.contentY = flickable.contentY +  lineHeight
        }
    }

    function jump_to_previous_column()
    {
        if(flickable.contentY - lineHeight > 0)
        {
            flickable.contentY = flickable.contentY -  lineHeight
        }
        else
        {
            flickable.contentY = 0
        }
    }




    function load_setting()
    {
        if(g_cls_thread_serial_port.get_setting_value("FILE_PATH") != "")
        {
            myFile.source = g_cls_thread_serial_port.get_setting_value("FILE_PATH")
            myText.text =  myFile.read();
        }

        if(g_cls_thread_serial_port.get_setting_value("FONT_SIZE") != "")
            myText.font.pointSize = g_cls_thread_serial_port.get_setting_value("FONT_SIZE")


        if(g_cls_thread_serial_port.get_setting_value("CONTENT_Y") != "")
            btn_load.content_y = g_cls_thread_serial_port.get_setting_value("CONTENT_Y")

        if(g_cls_thread_serial_port.get_setting_value("FONT_COLOR") != "")
            myText.color = g_cls_thread_serial_port.get_setting_value("FONT_COLOR")

        if(g_cls_thread_serial_port.get_setting_value("BACKGROUND_COLOR") != "")
            rect_textarea.color = g_cls_thread_serial_port.get_setting_value("BACKGROUND_COLOR")



        if(g_cls_thread_serial_port.get_setting_value("WINDOW_WIDTH") != "")
            root_app.width = g_cls_thread_serial_port.get_setting_value("WINDOW_WIDTH")

        if(g_cls_thread_serial_port.get_setting_value("WINDOW_HEIGHT") != "")
            root_app.height = g_cls_thread_serial_port.get_setting_value("WINDOW_HEIGHT")


        if(g_cls_thread_serial_port.get_setting_value("POS_X") != "")
            root_app.x =  g_cls_thread_serial_port.get_setting_value("POS_X")

        if(g_cls_thread_serial_port.get_setting_value("POS_Y") != "")
            root_app.y =  g_cls_thread_serial_port.get_setting_value("POS_Y")

        if(g_cls_thread_serial_port.get_setting_value("FOLDER_PATH") != "")
            fileDialog.folder =  g_cls_thread_serial_port.get_setting_value("FOLDER_PATH")


        if(g_cls_thread_serial_port.get_setting_value("CONTENT_Y") != "")
            flickable.contentY = btn_load.content_y

    }

    function save_setting()
    {
        g_cls_thread_serial_port.set_setting_value("WINDOW_WIDTH" ,root_app.width)
        g_cls_thread_serial_port.set_setting_value("WINDOW_HEIGHT" ,root_app.height)
        g_cls_thread_serial_port.set_setting_value("CONTENT_Y" ,Math.round(flickable.contentY))
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
                                folder = fileDialog.folder
                                g_cls_thread_serial_port.set_setting_value("FOLDER_PATH" ,folder)

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




                    Button {
                        text: "font -"
                        height: rect_menu.height

                        onClicked: {
                            if(myText.font.pointSize > 2)
                            {
                                myText.font.pointSize -= 1
                                g_cls_thread_serial_port.set_setting_value("FONT_SIZE" ,myText.font.pointSize)
                            }
                        }
                    }

                    Button {
                        text: "font +"
                        height: rect_menu.height

                        onClicked: {
                            myText.font.pointSize += 1
                            g_cls_thread_serial_port.set_setting_value("FONT_SIZE" ,myText.font.pointSize)

                        }
                    }

                    Button {
                        id: btn_test
                        text: "btn_test"
                        height: rect_menu.height

                        onClicked: {
                            //                            root_app.jump_to_previous_page()
                            //                            jump_to_next_column()
                            //                            jump_to_previous_column()
                            //                            jump_to_next_page()
                            jump_to_previous_page()
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
                    property bool _b_update_default_content_y: false

                    Component.onCompleted: {
                        console.log("+++++>" + btn_load.content_y + ", " + contentY)
                        _b_update_default_content_y = true

                    }
                    anchors.fill: parent
                    onContentYChanged: {
                        console.log("----->" + btn_load.content_y + ", " + contentY)


                        if( btn_load.content_y != 0
                                && contentY >= 0
                                && btn_load.content_y != contentY
                                && btn_load.content_y - 0 != btn_load.content_y - contentY
                                )
                        {
                            _b_update_default_content_y = false
                        }

                        if(_b_update_default_content_y && contentY == 0 )
                        {
                            contentY = btn_load.content_y
                        }






                    }

                    TextArea.flickable: TextArea {


                        id: myText
                        anchors.fill: parent
                        wrapMode:TextEdit.WrapAnywhere
                        text: ""
                    }

                    ScrollBar.vertical: ScrollBar { id: scrollBar }
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
