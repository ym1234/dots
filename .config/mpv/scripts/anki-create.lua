local mp = require('mp')
local http = require("socket.http")
local io = require('io')
local os = require('os')
local table = require('table')
local string = require('string')

local json =  require('cjson')
local start_time = 0
local end_time = 0

local deck_name = "Japanese::Sentences"
local model_name = "MIA Japanese"
local collection = "/home/ym/.local/share/Anki2/User 1/collection.media/"
local sentence_field = "Expression"
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
				track_no = k["src-id"] - 1
			end
		else
			if k.type == 'audio' and k.selected == true then
			audio_track_no = k["src-id"] - 1
			end
		end
	end
	return mp.get_property_native('filename'), file, external, track_no, audio_track_no
end

function create_card()
	local video_file, subtitle_file, external, track_no, audio_track_no = get_source()
	local f = nil
	if external then
		print('extract-dialouge' .. ' -i \'' .. video_file .. '\' -s \'' .. subtitle_file ..  '\'  -a ' .. audio_track_no .. ' -k ' .. (start_time * 1000) .. ' -e ' .. (end_time  * 1000))
		f = io.popen('~/bin/extract-dialogue' .. ' -i \'' .. video_file .. '\' -s \'' .. subtitle_file ..  '\'  -a ' .. audio_track_no .. ' -k ' .. (start_time * 1000) .. ' -e ' .. (end_time  * 1000))
	else
		-- TODO(ym): NOT TESTED
		f = io.popen('~/bin/extract-dialogue' .. ' -i \'' .. video_file .. '\' -s ' .. track_no ..  '  -a ' .. audio_track_no .. ' -k ' .. (start_time * 1000) .. ' -e ' .. (end_time  * 1000))
	end
	local subs = ""
	for line in f:lines() do
		subs = subs .. line .. "<br>"
	end
	print(subs)
	local new_name = "mpvcreate" .. os.time() .. ".mp3"
	io.popen('mv output.mp3 \'' .. collection .. new_name .. '\'')
	info = {
		action = "addNote",
		version = 6,
		params = {
			note = {
				deckName = deck_name,
				modelName = model_name,
				fields = {
					[sentence_field] = subs,
					[audio_field] = "[sound:" .. new_name .. "]",
				},
				tags =  {
					"mpv-create",
					"japanese"
				},
			}
		}
	}
	b, c, h = http.request('http://127.0.0.1:8765/', json.encode(info))
	print(b)
end

mp.add_forced_key_binding('ctrl+n', 'sub-start', set_start)
mp.add_forced_key_binding('ctrl+t', 'sub-end',  set_end)
mp.add_forced_key_binding('ctrl+h', 'create-card', create_card)
