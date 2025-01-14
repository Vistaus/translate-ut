/*
 * Copyright (C) 2022  walking-octopus
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * translate is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import Ubuntu.Components 1.3
//import QtQuick.Controls 2.2
//import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
//import "./Components"

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'translate.walking-octopus'
    automaticOrientation: true

    width: units.gu(65)
    height: units.gu(70)
    anchorToKeyboard: true

    Settings {
        id: preferences

        property int last_source_lang: 0
        property int last_target_lang: 26

        property string baseURL: "https://lingva.ml/api/v1"

        property int commonMargin: 2
    }

    PageStack {
        id: pStack

        Component.onCompleted: pStack.push(Qt.resolvedUrl("./Pages/MainPage.qml"))
    }

    function showSettings() {
        var prop = {
            commonMargin: preferences.commonMargin,
            baseURL: preferences.baseURL,
        }

        var slot_applyChanges = function(msettings) {
            console.log("Save changes...")
            preferences.commonMargin = msettings.commonMargin;
            preferences.baseURL = msettings.baseURL;
        }

        var settingPage = pStack.push(Qt.resolvedUrl("./Pages/Settings.qml"), prop);

        settingPage.applyChanges.connect(function() { slot_applyChanges(settingPage) });
    }

    function request(url) {
        return new Promise((resolve, reject) => {
            const xhr = new XMLHttpRequest();
            xhr.open("GET", url, true);
            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    resolve(xhr.response);
                } else {
                    reject(xhr.statusText);
                }
            };
            xhr.onerror = () => reject(xhr.statusText);
            xhr.send();
        });
    }

}
