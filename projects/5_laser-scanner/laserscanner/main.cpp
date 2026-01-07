#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char* argv[])
{
	qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

	QGuiApplication app(argc, argv);

	qputenv("QT_VIRTUALKEYBOARD_LAYOUT_PATH", ":/QtQuick/VirtualKeyboard/Layouts");

	QQmlApplicationEngine engine;
	engine.addImportPath(":/");

	QObject::connect(
		&engine, &QQmlApplicationEngine::objectCreationFailed, &app, []() { QCoreApplication::exit(-1); },
		Qt::QueuedConnection);
	engine.load(":/qml/Main.qml");

	return app.exec();
}
