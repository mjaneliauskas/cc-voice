Config = {
	debug = false,
	voiceModes = {
		{1.5, "Whisper"},
		{4.5, "Normal"},
		{10.0, "Shouting"},
	},				
	controls = { 
		proximity = {
			key = 246, -- Y
		}, 
		radio = {
			pressed = false,
			key = 137,
		},
		speaker = {
			key = 246, -- Y
			secondary = 21,
		}
	},
	radioChannelNames = { 
		[1] = "Police",
		[2] = "EMS",
		[3] = "PD/EMS",	
		[4] = "PDM",		
	},
	callChannelNames = {

	},
	use3dAudio = false, 
	useSendingRangeOnly = true,
	useNativeAudio = false, 
	useExternalServer = false, 
	externalAddress = "127.0.0.1",
	externalPort = 30120,
	use2dAudioInVehicles = true, 
	showRadioList = false, 
}
