extends AudioStreamPlayer

func play_sound(sound: AudioStream):
	if !playing:
		play()
	
	var playback : AudioStreamPlaybackPolyphonic = get_stream_playback()
	playback.play_stream(sound)
	pass
