//
//  AudioManager.swift
//  PlayerPoll
//
//  Created by mac on 15/12/21.
//

import Foundation
import AVFoundation
import MediaPlayer

protocol MediaPlayerManagerDelegate {
    func mediaPlayer(manager: MediaPlayerManager, didFailed error: ErrorModall)
    func mediaPlayer(manager: MediaPlayerManager, currentPlayingAt second: TimeInterval)
    func mediaPlayer(manager: MediaPlayerManager, didFinishPlayingSuccessfully flag: Bool)
    func completedPlaying(manager: MediaPlayerManager)
    func loadedAndReadyToPlay(manager: MediaPlayerManager)
}

class MediaPlayerManager: NSObject, AVAudioPlayerDelegate {
    var delegate: MediaPlayerManagerDelegate?
    public let audioPlayer: AVPlayer = {
           let avPlayer = AVPlayer()
           avPlayer.automaticallyWaitsToMinimizeStalling = false
           return avPlayer
       }()
    
    public private(set) var episodeFile: URL? = nil
    public var isDraging: Bool = false

    
    private var stopPlayBackTimer: Timer?
    
    //------------------------------------------------------
    
    //MARK: Shared
    
    static let shared = MediaPlayerManager()
    
    //------------------------------------------------------
    
    //MARK: Customs
   
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        audioPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            if self != nil {
                if self?.audioPlayer.status == .readyToPlay{
                    self?.delegate?.loadedAndReadyToPlay(manager: self!)
                }
                if self?.isDraging == false && self?.isPlaying() == true {
                    if CMTimeGetSeconds(time).isNaN {
                        self?.delegate?.mediaPlayer(manager: self!, currentPlayingAt: TimeInterval(0))
                    }
                    let totalSeconds = Int(CMTimeGetSeconds(time))
                    self?.delegate?.mediaPlayer(manager: self!, currentPlayingAt: TimeInterval(totalSeconds))
                }
            }
        }
    }
        
    //------------------------------------------------------
    
    //MARK: Public
    
    public func play(withURL stringURL: String) {
        
        do {
            audioPlayer.pause()
            
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            guard let fileURL = URL(string: stringURL) else {
                let errorModal = ErrorModall(message: "Invalid Url")
                delegate?.mediaPlayer(manager: self, didFailed: errorModal)
                return
            }
                        
            let playerItem = AVPlayerItem(url: fileURL)
            episodeFile = fileURL
            audioPlayer.replaceCurrentItem(with: playerItem)
            NotificationCenter.default.addObserver(self, selector: #selector(playingEnd), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            audioPlayer.play()
            audioPlayer.volume = 1.0
            observePlayerCurrentTime()
            
        } catch(let error) {
            debugPrint(error.localizedDescription)
            let errorModal = ErrorModall(error: error, message: error.localizedDescription)
            delegate?.mediaPlayer(manager: self, didFailed: errorModal)
            return
        }
    }
    
    @objc func playingEnd(){
        delegate?.completedPlaying(manager: self)
    }
    
    public func isPlaying(on stringURL: String) -> Bool {
        
        guard let fileURL = URL(string: stringURL) else {
            return false
        }
        
        if fileURL == episodeFile {
            return true
        }
        return false
    }
    
    public func isPlaying() -> Bool {
        return audioPlayer.timeControlStatus == .playing || audioPlayer.timeControlStatus == .waitingToPlayAtSpecifiedRate
    }
    
    public func isPause() -> Bool {
        return audioPlayer.timeControlStatus == .paused
    }
    
    public func puase() {
        audioPlayer.pause()
    }
    
    public func resume() {
        audioPlayer.play()
    }
    
    public func stop() {
        audioPlayer.pause()
        let seekTime = CMTimeMakeWithSeconds(0, preferredTimescale: 1)
        audioPlayer.seek(to: seekTime)
    }
    
    public func player(playAt time: TimeInterval) {
        
        isDraging = true
        let percentage = time
        guard let duration = audioPlayer.currentItem?.duration else { return }
                 
        debugPrint("duration:\(duration)")
        let durationInSeconds = CMTimeGetSeconds(duration)
        debugPrint("time:\(time)")
        debugPrint("durationInSeconds:\(durationInSeconds)")
        
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)

        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
        audioPlayer.seek(to: seekTime)
        
        if isPause() == false {
            audioPlayer.play()
        } else {
            let totalSeconds = Int(CMTimeGetSeconds(seekTime))
            delegate?.mediaPlayer(manager: self, currentPlayingAt: TimeInterval(totalSeconds))
//            MiniPlayerManager.shared.updatePlayer(currentTime: TimeInterval(totalSeconds))
        }
    }
    
    //------------------------------------------------------
    
    //MARK: AVAudioPlayerDelegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finished playing")
        delegate?.mediaPlayer(manager: self, didFinishPlayingSuccessfully: flag)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
        if let error = error {
            debugPrint(error.localizedDescription)
            let errorModal = ErrorModall(error: error, message: error.localizedDescription)
            delegate?.mediaPlayer(manager: self, didFailed: errorModal)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Notification
    
    @objc func fireSleepTime(_ sender: Any) {
        
        stopPlayBackTimer?.invalidate()
        stop()
        NotificationCenter.default.post(name: NSNotification.Name(PMNotificationName.playerPlayModeChange.rawValue), object: nil)
    }
    
    @objc func startSleepTimer(_ notification: Notification) {
        stopPlayBackTimer?.invalidate()
    }
    
    //------------------------------------------------------
    
    //MARK: Init
    override init() {
        super.init()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: PMNotificationName.startSleepTimer.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startSleepTimer), name: NSNotification.Name(rawValue: PMNotificationName.startSleepTimer.rawValue), object: nil)
    }
    //------------------------------------------------------
}

struct ErrorModall{
    var error: Error?
    var message: String
}

enum PMNotificationName: String {
    case playerPlayModeChange = "playerPlayModeChange"
    case startSleepTimer = "startSleepTimer"
}

