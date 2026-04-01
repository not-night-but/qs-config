pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs.services

Singleton {
    id: root
    property string cavaOut

    Process {
        id: cavaProc
        command: ["bash", Paths.cava_path]
        running: true

        stdout: SplitParser {
            onRead: data => {
                root.cavaOut = data
            }
        }
    }
}
