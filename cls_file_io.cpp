#include "cls_file_io.h"
#include <QFile>
#include <QTextStream>

clsFileIO::clsFileIO()
{

}

//clsFileIO::FileIO(QObject *parent) :
//    QObject(parent)
//{

//}

QString clsFileIO::read()
{
    if (mSource.isEmpty()){
        emit error("source is empty");
        return QString();
    }
#if __APPLE__
    mSource = mSource.replace("file://","");
#else
    mSource = mSource.replace("file:///","");
#endif

    QFile file(mSource);
    QString fileContent;
    if ( file.open(QIODevice::ReadOnly) ) {
        QString line;
        QTextStream t( &file );
        do {
            line = t.readLine();
            fileContent += line + "\r\n";
        } while (!line.isNull());

        file.close();
    } else {
        emit error("Unable to open the file");
        return QString();
    }

    return fileContent;
}
/*
bool clsFileIO::write(const QString& data)
{
    if (mSource.isEmpty())
        return false;

    QFile file(mSource);
    if (!file.open(QFile::WriteOnly | QFile::Truncate))
        return false;

    QTextStream out(&file);
    out << data;

    file.close();

    return true;
}
*/
