#include "cls_input_keyboard.h"

clsInputKeyboard::clsInputKeyboard()
{
    // Create a generic keyboard event structure
    ip.type = INPUT_KEYBOARD;
    ip.ki.wScan = 0;
    ip.ki.time = 0;
    ip.ki.dwExtraInfo = 0;
}

void clsInputKeyboard::input_single_command(QString str_key)
{
    if(str_key == "Up")
    {
        // Press the "Ctrl" key
        ip.ki.wVk = VK_UP;
        ip.ki.dwFlags = 0; // 0 for key press
        SendInput(1, &ip, sizeof(INPUT));


        // Release the "Ctrl" key
        ip.ki.wVk = VK_UP;
        ip.ki.dwFlags = KEYEVENTF_KEYUP;
        SendInput(1, &ip, sizeof(INPUT));
    }
    else if(str_key == "Down")
    {

    }
    else if(str_key == "Left")
    {

    }
    else if(str_key == "Right")
    {

    }
    else if(str_key == "Enter")
    {

    }

}

//void clsInputKeyboard::test()
//{
//    while(1)
//    {
//        // Press the "Ctrl" key
//        ip.ki.wVk = VK_CONTROL;
//        ip.ki.dwFlags = 0; // 0 for key press
//        SendInput(1, &ip, sizeof(INPUT));

//        // Press the "V" key
//        ip.ki.wVk = 'V';
//        ip.ki.dwFlags = 0; // 0 for key press
//        SendInput(1, &ip, sizeof(INPUT));

//        // Release the "V" key
//        ip.ki.wVk = 'V';
//        ip.ki.dwFlags = KEYEVENTF_KEYUP;
//        SendInput(1, &ip, sizeof(INPUT));

//        // Release the "Ctrl" key
//        ip.ki.wVk = VK_CONTROL;
//        ip.ki.dwFlags = KEYEVENTF_KEYUP;
//        SendInput(1, &ip, sizeof(INPUT));

//        Sleep(1000); // pause for 1 second
//    }
//}
