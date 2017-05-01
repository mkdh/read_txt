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
    title: qsTr("Hello World")
    
    onWidthChanged: {
        //        g_cls_thread_serial_port.set_setting_value("WINDOW_WIDTH" ,root_app.width)
    }
    
    onHeightChanged: {
        //        g_cls_thread_serial_port.set_setting_value("WINDOW_HEIGHT" ,root_app.height)
        
    }
    Component.onCompleted: {
        root_app.load_setting()
        root_app.open_serial_port()
    }
    
    onClosing: {
        root_app.save_setting()
    }
    readonly property real lineHeight: (myText.implicitHeight - 2 * myText.textMargin) / myText.lineCount
    property bool b_show_footer: false
    function jump_to_next_page()
    {
        flickable._b_update_default_content_y = false
        var count_page_column = Math.round(flickable.height / lineHeight) - 1
        
        //        if(flickable.contentY + flickable.height - lineHeight - 2 * myText.textMargin < flickable.contentHeight)
        //        {
        //            flickable.contentY = flickable.contentY + flickable.height - lineHeight - 2 * myText.textMargin
        //        }
        var move_height = count_page_column * lineHeight
        if(flickable.contentY + move_height < flickable.contentHeight)
        {
            flickable.contentY = flickable.contentY + move_height
        }
    }
    
    function jump_to_previous_page()
    {
        flickable._b_update_default_content_y = false
        
        var count_page_column = Math.round(flickable.height / lineHeight) - 1
        var move_height = count_page_column * lineHeight
        
        if(flickable.contentY - move_height > 0)
        {
            flickable.contentY = flickable.contentY - move_height
        }
        else
        {
            flickable.contentY = 0
        }
    }
    
    function jump_to_next_column()
    {
        flickable._b_update_default_content_y = false
        
        if(flickable.contentY +  lineHeight < flickable.contentHeight - flickable.height)
        {
            flickable.contentY = flickable.contentY +  lineHeight
        }
    }
    
    function jump_to_previous_column()
    {
        flickable._b_update_default_content_y = false
        
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
        
        if(g_cls_thread_serial_port.get_setting_value("Font_Point_Size") != "")
            myText.font.pointSize = g_cls_thread_serial_port.get_setting_value("Font_Point_Size")
        
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
    
    function open_serial_port()
    {
        var b_open_serial_port =  g_cls_thread_serial_port.open_serial_port()
        if(b_open_serial_port)
        {
            root_app.title = "serial_port open success"
        }
        else
        {
            root_app.title = "serial_port open fail"
        }
    }

    Connections{
        target: g_cls_thread_serial_port
        onSignal_send_to_qml: {
            //txt_debug_message.text += msg + "\r\n"
            txt_debug_message.text = msg + "\r\n------------" +  txt_debug_message.text + "\r\n"
            txt_debug_message.text = get_short_text(txt_debug_message.text , 1000)
        }
        property string old_command: old_command
        
        onSignal_send_command: {
            console.log(msg)
            root_app.title = msg
            if(msg == " FORWARD" || msg == " -OK-")
            {
                
                old_command = msg
                root_app.jump_to_previous_page()
            }
            else if(msg == " REVERSE")
            {
                old_command = msg
                root_app.jump_to_next_page()
            }
            else if(msg == " RIGHT")
            {
                old_command = msg
                root_app.jump_to_next_column()
            }
            else if(msg == " LEFT")
            {
                old_command = msg
                root_app.jump_to_previous_column()
            }
            else if(msg == " REPEAT")
            {
                root_app.title = msg + " " + old_command
                
                if(old_command == " FORWARD")
                {
                    root_app.jump_to_previous_page()
                }
                else if(old_command == " REVERSE" || old_command == " -OK-")
                {
                    root_app.jump_to_next_page()
                }
                else if(old_command == " RIGHT")
                {
                    root_app.jump_to_next_column()
                }
                else if(old_command == " LEFT")
                {
                    root_app.jump_to_previous_column()
                }
            }
            if(msg == " 0")
            {
                b_show_footer = !b_show_footer
            }
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
                                g_cls_thread_serial_port.set_setting_value("Font_Point_Size" , myText.font.pointSize)
                            }
                        }
                    }
                    
                    Button {
                        text: "font +"
                        height: rect_menu.height
                        
                        onClicked: {
                            myText.font.pointSize += 1
                            g_cls_thread_serial_port.set_setting_value("Font_Point_Size" , myText.font.pointSize)
                        }
                    }
                    
                    Button {
                        id: btn_test
                        text: "btn_test"
                        height: rect_menu.height
                        
                        onClicked: {
                            //                            b_show_footer = ! b_show_footer
root_app.open_serial_port()
                        }
                    }
                }
            }
            
            Rectangle {
                id: rect_current_contex_y
                z: 2
                color: "red"
                width: 15
                height: 30
                anchors.right: rect_textarea.right
                opacity: 0.5
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
                    anchors.fill: rect_textarea
                    
                    Component.onCompleted: {
                        console.log("+++++>" + btn_load.content_y + ", " + contentY)
                        _b_update_default_content_y = true
                        
                    }
                    onContentYChanged: {
                        
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
                        rect_current_contex_y.y = -rect_current_contex_y.height * 0.5 + rect_textarea.y + flickable.height * contentY / (flickable.contentHeight - flickable.height )
                        console.log(rect_current_contex_y.y)
                    }
                    
                    TextArea.flickable: TextArea {
                        id: myText
                        wrapMode:TextEdit.WrapAnywhere
                        text: ""
                        font.pointSize: 19
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
        height: {
            if(b_show_footer)
            {
                return 30
            }
            else
            {
                return 0
            }
        }
        
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("First")
        }
        TabButton {
            text: qsTr("Second")
        }
    }
}
