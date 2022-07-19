local mp = require('mp')
local msg = require('mp.msg')
local utils = require('mp.utils')

local os = require('os')
local math = require('math')
local table = require('table')
local string = require('string')

local http = require('socket.http')

local anki_address = 'http://127.0.0.1:8765/'

local deck = '07. 日本語::Anime cards'
local prefix = utils.join_path(os.getenv('HOME'), [[.local/share/Anki2/User 1/collection.media]])

local AUDIO_CLIP_FADE = 0.2
local AUDIO_CLIP_PADDING = 0.75

local IMAGE_FIELD = 'Image'
local AUDIO_FIELD = 'Audio'

if unpack ~= nil then table.unpack = unpack end

-- get_name, create_audio, create_screenshot are from animecard.lua
local function get_name(s, e)
	return mp.get_property('filename'):gsub('%W','') .. tostring(s) .. tostring(e)
end

local function create_audio(s, e)
	if s == nil or e == nil then
		return
	end

	local source = mp.get_property('path')
	local aid = mp.get_property('aid')

	local tracks_count = mp.get_property_number('track-list/count')
	for i = 1, tracks_count do
		local track_type = mp.get_property(string.format('track-list/%d/type', i))
		local track_selected = mp.get_property(string.format('track-list/%d/selected', i))
		if track_type == 'audio' and track_selected == 'yes' then
			if mp.get_property(string.format('track-list/%d/external-filename', i), o) ~= o then
				source = mp.get_property(string.format('track-list/%d/external-filename', i))
				aid = 'auto'
			end
			break
		end
	end

	local destination = utils.join_path(prefix, get_name(s, e) .. '.mp3')
	s = s - AUDIO_CLIP_PADDING
	local t = e - s + AUDIO_CLIP_PADDING

	local cmd = {
		'run',
		'mpv',
		source,
		'--loop-file=no',
		'--video=no',
		'--no-ocopy-metadata',
		'--no-sub',
		'--audio-channels=1',
		string.format('--start=%.3f', s),
		string.format('--length=%.3f', t),
		string.format('--aid=%s', aid),
		string.format('--af-append=afade=t=in:curve=ipar:st=%.3f:d=%.3f', s, AUDIO_CLIP_FADE),
		string.format('--af-append=afade=t=out:curve=ipar:st=%.3f:d=%.3f', s + t - AUDIO_CLIP_FADE, AUDIO_CLIP_FADE),
		string.format('-o=%s', destination)
	}
	mp.commandv(table.unpack(cmd))
end


local function create_screenshot(s, e)
	local source = mp.get_property('path')
	local img = utils.join_path(prefix, get_name(s,e) .. '.png')

	local cmd = {
		'run',
		'mpv',
		source,
		'--loop-file=no',
		'--audio=no',
		'--no-ocopy-metadata',
		'--no-sub',
		'--frames=1',
		'--vf-add=format=rgb24',
		'--vf-add=scale=-2:480',
		string.format('--start=%.3f', mp.get_property_number('time-pos')),
		string.format('-o=%s', img)
	}
	mp.commandv(table.unpack(cmd))
end

local function anki_connect(action, params)
	local req = utils.format_json({action=action, params=params, version=6})
	local r, err = http.request(anki_address, req)
	if not r then
		msg.info(err)
		error(string.format('\nError while processing request %s: %s\nCouldn\'t connect to anki-connect, either it isn\'t running, not installed, or anki isn\'t running', action, err))
	end
	return utils.parse_json(r)
end

local function get_card()
	local res = anki_connect('findNotes', { query = 'added:1 is:new' })
	if res.error then error(string.format('\nget_card: %s', res.error)) end

	local cards = res.result
	if #cards == 0 then error('\nget_card: No new cards found') end

	table.sort(cards)
	return cards[#cards]
end

local function update_card(c, s, e)
	local x = anki_connect('updateNoteFields', {
		note = {
			id = c,
			fields = {
				[AUDIO_FIELD] = '[sound:' .. get_name(s, e) .. '.mp3]',
				[IMAGE_FIELD] = '<img src='.. get_name(s,e) ..'.png>'
			}
		}
	})
	if x.error then error(string.format('\nupdate_card, updatenotefields: %s', x.error)) end

	local y = anki_connect('addTags', {notes = {c}, tags = 'mpv-create'})
	if y.error then msg.warning(string.format('update_card, addtags: %s', y.error)) end
end

local s = 0
local e = 0

local function run()
	if s >= e then error('\nstart >= end') end
	if e - s < 1 then error('\nend - start < 1') end
	-- ^ not really needed i don't think, also i guess i can delete the if above it if i have this one

	local c = get_card() -- if there are no new cards, end execution early
	create_audio(s, e)
	create_screenshot(s, e)
	update_card(c, s, e)

	s = 0
	e = 0
end

local function cleanup()
	os.execute('sleep 1') -- have to wait a second otherwise the files don't get written for some reason? also lua doesn't have a sleep function? wtf?

	local audio = utils.join_path(prefix, get_name(s,e) .. '.mp3')
	local png = utils.join_path(prefix, get_name(s,e) .. '.png')
	local args = { 'rm' }

	if utils.file_info(audio) then table.insert(args, audio) end
	if utils.file_info(png)   then table.insert(args, png)   end

	if #args > 1 then utils.subprocess({ args = args }) end
end

local function ex()
	local status, ret = pcall(run)
	if not status then
		mp.osd_message(ret, 10)
		cleanup()
		msg.info('finished cleaning up')
	else
		mp.osd_message("updated card", 5)
	end
end

local function s_m(s)
	local hours = math.floor((s % 86400) / 3600)
	local minutes = math.floor((s % 3600) / 60)
	local seconds = math.floor((s % 60))
	return string.format('%02d:%02d:%02d', hours, minutes, seconds)
end

local function view() mp.osd_message(string.format('Start: %s\n End: %s', s_m(s), s_m(e))) end

local function set_start()
	s = mp.get_property_native('time-pos')
	view()
end

local function set_end()
	e = mp.get_property_native('time-pos')
	view()
end

mp.add_forced_key_binding('ctrl+n', 'create-card', ex)
mp.add_forced_key_binding('ctrl+s', 'sub-start', set_start)
mp.add_forced_key_binding('ctrl+e', 'sub-end',  set_end)
