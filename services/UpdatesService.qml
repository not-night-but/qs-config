pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

Singleton {
    id: root

    property string availableUpdates

    Process {
        id: getUpdatesProc
        running: true
        command: ["bash", Paths.update_path, "--get-updates"]

        stdout: SplitParser {
            onRead: (data) => {
                root.availableUpdates = data
            }
        }
    }

    Timer {
        id: getUpdatesTimer
        running: true
        repeat: true
        interval: 60000
        onTriggered: getUpdatesProc.running = true
    }

    function forceUpdateInfo() {
        getUpdatesProc.running = true
    }

    function update() {
        runUpdate.running = true
    }

    Process {
        id: runUpdate
        running: false
        environment: ({
            OPEN_ZELLIJ: false
        })
        command: [
            "ghostty",
            "--class=float.term",
            "--title=System Update",
            "-e",
            Paths.update_path,
            "--update-system",
        ]
    }
}
