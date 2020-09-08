local mp = require('mp')
local http = require("socket.http")
local math = require('math')
local io = require('io')
local os = require('os')
local table = require('table')
local string = require('string')

local json =  require('cjson')
local start_time = 0
local end_time = 0

local deck_name = "Japanese::Anime cards"
local model_name = "Japanese"
local collection = "/home/ym/.local/share/Anki2/User 1/collection.media/"
local sentence_field = "Examples"
local word_field = "Word"
local audio_field = "Audio"

function render()
	mp.osd_message("Sub start time: " .. start_time .. "\nSub end time: " .. end_time)
end

function set_start()
	start_time = mp.get_property_native('time-pos')
	render()
end

function set_end()
	end_time = mp.get_property_native('time-pos')
	render()
end

function get_source()
	local file, external, track_no, audio_track_no
	for i, k in ipairs(mp.get_property_native('track-list')) do
		if k.type == 'sub' and k.selected == true and file == nil then
			if k.external == true then
				file = k["external-filename"]
				external = true
				track_no = 0
			else
				external = false
				track_no = k["src-id"] - 1 -- TODO fix this
			end
		else
			if k.type == 'audio' and k.selected == true then
			audio_track_no = k["src-id"] - 1 -- TODO fix this
			end
		end
	end
	return mp.get_property_native('filename'), file, external, track_no, audio_track_no
end

function my_popen(arg)
	local file = io.popen(arg)
	local output = file:read('*all')
	file:close()
end

function create_card()
	local video_file, subtitle_file, external, track_no, audio_track_no = get_source()
	print(video_file, subtitle_file, external, track_no, audio_track_no)
	local f = nil
	if external then
		print('~/bin/extract-dialogue' .. ' -i ' .. ("%q"):format(video_file) .. ' -s ' .. ("%q"):format(subtitle_file) ..  '  -a ' .. audio_track_no .. ' -k ' .. math.floor(start_time * 1000) .. ' -e ' .. math.ceil(end_time  * 1000))
		f = io.popen('~/bin/extract-dialogue' .. ' -i ' .. ("%q"):format(video_file) .. ' -s ' .. ("%q"):format(subtitle_file) ..  '  -a ' .. audio_track_no .. ' -k ' .. (start_time * 1000) .. ' -e ' .. (end_time  * 1000))
	else
		-- TODO(ym): NOT TESTED
		f = io.popen('~/bin/extract-dialogue' .. ' -i \'' .. video_file .. '\' -s ' .. track_no ..  '  -a ' .. audio_track_no .. ' -k ' .. (start_time * 1000) .. ' -e ' .. (end_time  * 1000))
	end
	local subs = ""
	for line in f:lines() do
		subs = subs .. line .. "<br>"
	end
	f:close()
	print(subs)
	local new_name = "mpvcreate" .. os.time() .. ".mp3"
	io.popen('mv output.mp3 \'' .. collection .. new_name .. '\'') -- seriously?
	info = {
		action = "addNote",
		version = 6,
		params = {
			note = {
				deckName = deck_name,
				modelName = model_name,
				fields = {
					[word_field] = subs,
					[sentence_field] = subs,
					[audio_field] = "[sound:" .. new_name .. "]",
				},
				tags =  {
					"mpv-create",
					"日本語"
				},
			}
		}
	}
	b, c, h = http.request('http://127.0.0.1:8765/', json.encode(info))
	print(b)
end


-- SERIOUSLY?
function save_clip()
	local video_file, subtitle_file, _, _, _ = get_source()
	local new_name = "mpv-clip-" .. os.time() .. ".mp4"
	my_popen('ln -s ' .. ("%q"):format(subtitle_file) .. ' sub_file')
	my_popen('ffmpeg -v fatal -ss ' .. start_time  .. ' -to ' .. end_time .. " -copyts -i " .. ("%q"):format(video_file)  .. " -vf subtitles=sub_file -reset_timestamps 1 " .. new_name)
	my_popen('rm sub_file')
	mp.osd_message('Clip: ' .. new_name)
end

mp.add_forced_key_binding('ctrl+n', 'sub-start', set_start)
mp.add_forced_key_binding('ctrl+t', 'sub-end',  set_end)
mp.add_forced_key_binding('ctrl+h', 'create-card', create_card)
mp.add_forced_key_binding('ctrl+s', 'save-clip', save_clip)
