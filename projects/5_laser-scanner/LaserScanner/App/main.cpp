// Copyright (C) 2024 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

#include <QApplication>
#include <QQmlApplicationEngine>

#include "autogen/environment.h"

int main(int argc, char* argv[])
{
	set_qt_environment();
	QApplication app(argc, argv);

	// for deploy
	// QString layoutPath = QGuiApplication::applicationDirPath() + "/qml/QtQuick/VirtualKeyboard/Layouts";
	// qputenv("QT_VIRTUALKEYBOARD_LAYOUT_PATH", layoutPath.toUtf8());

	// for test
	qputenv("QT_VIRTUALKEYBOARD_LAYOUT_PATH",
		"/mnt/E/Code/novin-med/projects/5_laser-scanner/LaserScanner/QtQuick/VirtualKeyboard/Layouts");

	qputenv("QT_VIRTUALKEYBOARD_LANGUAGES", "en,fa");

	QQmlApplicationEngine engine;
	const QUrl url(mainQmlFile);
	QObject::connect(
		&engine, &QQmlApplicationEngine::objectCreated, &app,
		[url](QObject* obj, const QUrl& objUrl)
		{
			if (!obj && url == objUrl)
				QCoreApplication::exit(-1);
		},
		Qt::QueuedConnection);

	// for test
	engine.addImportPath("/mnt/E/Code/novin-med/projects/5_laser-scanner/LaserScanner/");

	engine.addImportPath(QCoreApplication::applicationDirPath() + "/qml");
	engine.addImportPath(":/");
	engine.load(url);

	if (engine.rootObjects().isEmpty())
		return -1;

	return app.exec();
}
