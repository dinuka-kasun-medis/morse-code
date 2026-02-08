import AVFoundation

final class TonePlayer {
    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private let format: AVAudioFormat
    private let sampleRate: Double = 44100
    private let frequency: Double = 600

    init() {
        format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: format)

        do {
            try engine.start()
        } catch {
            // Audio engine may fail in simulator if no audio device is available.
        }
    }

    func play(duration: TimeInterval) {
        let frameCount = AVAudioFrameCount(duration * sampleRate)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }
        buffer.frameLength = frameCount

        let theta = 2.0 * Double.pi * frequency / sampleRate
        if let channelData = buffer.floatChannelData?.pointee {
            for frame in 0..<Int(frameCount) {
                channelData[frame] = Float(sin(theta * Double(frame)) * 0.3)
            }
        }

        player.scheduleBuffer(buffer, at: nil, options: .interrupts, completionHandler: nil)
        if !player.isPlaying {
            player.play()
        }
    }
}
