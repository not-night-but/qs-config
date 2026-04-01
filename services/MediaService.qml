pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property list<MprisPlayer> availablePlayers: Mpris.players.values
    property MprisPlayer activePlayer: availablePlayers.find(p => p.isPlaying) ?? availablePlayers.find(p => p.canControl && p.canPlay) ?? null

    property bool isShuffled: activePlayer.shuffle
    property bool canShuffle: activePlayer.shuffleSupported && activePlayer.canControl

    property bool isLooping: activePlayer.loopState !== MprisLoopState.None

    FrameAnimation {
        running: root.activePlayer.playbackState == MprisPlaybackState.Playing && root.activePlayer.positionSupported
        onTriggered: root.activePlayer.positionChanged()
    }

    function toggleShuffle() {
        if (!root.canShuffle) {
            return
        }
        activePlayer.shuffle = !activePlayer.shuffle
    }

    function getLoopIcon(): string {
        if (activePlayer.loopState === MprisLoopState.Track) {
            return "󰑘"
        } else if (activePlayer.loopState === MprisLoopState.Playlist) {
            return "󰑖"
        } else {
            return "󰑗"
        }
    }

    function cycleLoopState() {
        if (!activePlayer || !activePlayer.loopSupported || !activePlayer.canControl) return
        if (activePlayer.loopState === MprisLoopState.None) {
            activePlayer.loopState = MprisLoopState.Playlist
        } else if (activePlayer.loopState === MprisLoopState.Playlist) {
            activePlayer.loopState = MprisLoopState.Track
        } else if (activePlayer.loopState === MprisLoopState.Track) {
            activePlayer.loopState = MprisLoopState.None
        }
    }

    function seek(pos: real) {
        if (!activePlayer.canSeek || !activePlayer.positionSupported) return
        activePlayer.position = pos
    }
}
