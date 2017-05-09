#ifndef CLSINPUTKEYBOARD_H
#define CLSINPUTKEYBOARD_H

#define WINVER 0x0500
#include "windows.h"
#include <QString>
//https://batchloaf.wordpress.com/2012/10/18/simulating-a-ctrl-v-keystroke-in-win32-c-or-c-using-sendinput/

class clsInputKeyboard
{
public:
    clsInputKeyboard();
    //    void test();
    void input_single_command(QString str_key);
private:
    INPUT ip;

};

#endif // CLSINPUTKEYBOARD_H
