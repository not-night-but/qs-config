pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
    id: root
    
    readonly property PwNode sink: Pipewire.ready ? Pipewire.defaultAudioSink : null

    property bool wpctlAvailable: false
    property bool wpctlStateValid: false
    property real wpctlOutputVolume: 0
    property bool wpctlOutputMuted: true

    property real maxVolume: 1.5
    readonly property real stepVolume: 5.0 / 100.0
    readonly property real epsioln: 0.005

    property bool isSettingOutputVolume: false

    signal volumeAtMaximum()
    signal volumeAtMinimum()

    function clampOutputVolume(vol: real): real {
        if (vol === undefined || isNaN(vol)) {
            return 0;
        }
        return Math.max(0, Math.min(root.maxVolume, vol))
    }

    function refreshWpctlOutputState(): void {
        if (wpctlStateProcess.running) {
            return;
        }
        wpctlStateProcess.command = ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"];
        wpctlStateProcess.running = true;
    }

    readonly property real volume: {
        if (wpctlStateValid) {
            return clampOutputVolume(wpctlOutputVolume)
        }

        if (!sink?.audio) {
            return 0;
        }
        return clampOutputVolume(sink.audio.volume);
    }

    readonly property bool muted: {
        if (wpctlStateValid) {
            return wpctlOutputMuted;
        }
        return sink?.audio?.muted ?? true;
    }

    function applyWpctlOutputState(raw: string): bool {
        const text = String(raw || "").trim();
        const match = text.match(/Volume:\s*([0-9]*\.?[0-9]+)/i);
        if (!match || match.length < 2) {
            return false;
        }

        const parsedVolume = Number(match[1]);
        if (isNaN(parsedVolume)) {
            return false;
        }

        wpctlOutputVolume = clampOutputVolume(parsedVolume);
        wpctlOutputMuted = /\[MUTED\]/i.test(text);
        wpctlStateValid = true;
        return true;
    }

    Connections {
        target: root
        function onSinkChanged() {
            root.refreshWpctlOutputState();
        }
    }

    Timer {
        id: wpctlPollTimer
        interval: 20000
        running: true
        repeat: true
        onTriggered: root.refreshWpctlOutputState()
    }

    Process {
        id: wpctlStateProcess
        running: false

        onExited: function (code) {
            if (code !== 0 || !root.applyWpctlOutputState(stdout.text)) {
                root.wpctlStateValid = false;
            }
        }

        stdout: StdioCollector {}
    }

    Process {
        id: wpctlSetVolumeProcess
        running: false

        onExited: function (code) {
            root.isSettingOutputVolume = false;
            if (code !== 0) {
                if (root.sink?.audio) {
                    root.sink.audio.muted = false;
                    root.sink.audio.volume = root.clampOutputVolume(root.wpctlOutputVolume);
                }
            }
            root.refreshWpctlOutputState();
        }
    }

    Process {
        id: wpctlSetMuteProcess
        running: false

        onExited: function() {
            root.refreshWpctlOutputState()
        }
    }

    Connections {
        target: sink?.audio ?? null

        function onVolumeChanged() {
            root.refreshWpctlOutputState();

            if (root.isSettingOutputVolume) {
                return;
            }

            if (!root.sink?.audio) {
                return;
            }

            const vol = root.sink.audio.volume;
            if (vol === undefined || isNaN(vol)) {
                return;
            }

            if (vol > root.maxVolume) {
                root.isSettingOutputVolume = true;
                Qt.callLater(() => {
                    if (root.sink?.audio && root.sink.audio.volume > root.maxVolume) {
                        root.sink.audio.volume = root.maxVolume;
                    }
                    root.isSettingOutputVolume = false;
                });
            }
        }

        function onMutedChanged() {
            root.refreshWpctlOutputState();
        }
    }

    function increaseVolume() {
        if (!Pipewire.ready) {
            return;
        }
        if (volume >= root.maxVolume) {
            volumeAtMaximum();
            return;
        }
        setVolume(Math.min(root.maxVolume, volume + stepVolume));
    }

    function decreaseVolume() {
        if (!Pipewire.ready) {
            return;
        }

        if (volume <= 0) {
            volumeAtMinumum();
            return;
        }
        setVolume(Math.max(0, volume - stepVolume))
    }

    function setVolume(newVolume: real) {
        if (!Pipewire.ready) {
            return;
        }

        const clampedVolume = clampOutputVolume(newVolume);
        const delta = Math.abs(clampedVolume - volume)
        if (delta < root.epsilon) {
            return;
        }

        if (wpctlSetVolumeProcess.running) {
            return;
        }

        root.isSettingOutputVolume = true;
        root.wpctlOutputMuted = false;
        root.wpctlOutputVolume = clampedVolume;
        wpctlStateValid = true;

        const volumePct = Math.round(clampedVolume * 10000) / 100;
        wpctlSetVolumeProcess.command = ["sh", "-c", "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume @DEFAULT_AUDIO_SINK@ " + volumePct + "%"];
        wpctlSetVolumeProcess.running = true;

        return;
    }

    function toggleOutputMuted() {
        setOutputMuted(!sink.audio.muted)
    }

    function setOutputMuted(muted: bool) {
        if (!Pipewire.ready || (!sink?.audio && !wpctlAvailable)) {
            Logger.w("AudioService", "No sink available or Pipewire not ready");
            return;
        }

        if (wpctlSetMuteProcess.running) {
            return;
        }

        wpctlOutputMuted = muted;
        wpctlStateValid = true;
        wpctlSetMuteProcess.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", muted ? "1" : "0"];
        wpctlSetMuteProcess.running = true;
        return;
    }


    function getOutputIcon() {
        if (muted) {
            return "";
        } else {
            return ""
        }
    }

    PwObjectTracker {
        id: sinkTracker
        objects: root.sink ? [root.sink] : []
    }
}
