#!/usr/bin/env python

# Credits: Anacreon, I just made it usable on linux

import os
import subprocess
import sys
import json
import os.path
import time
import re
from pprint import pprint
from multiprocessing import Pool
from collections import defaultdict
import chardet

class mopen:
    def __init__(self, filename, mode='r', **kwargs):
        self.real_encoding = chardet.detect(open(filename, 'rb').read())['encoding'].lower()
        self.file_o = open(filename, mode, encoding=self.real_encoding)
    def __getattr__(self, name):
        return getattr(self.file_o, name)
    def __enter__(self):
         return self.file_o
    def __exit__(self, type, value, traceback):
         self.file_o.close()


def get_lib_folder():
    return "auto-sub-retimer"

def remove_styles(lines, styles):
    res = []
    for line in lines:
        if line.startswith("Dialogue: "):
            style = line.split(',')[3]
            if style not in styles:
                continue
        res.append(line)
    return res

def count_style_occurences(lines, style):
    res = 0
    for line in lines:
        if line.startswith("Dialogue: "):
            line_style = line.split(',')[3]
            if style == line_style:
                res += 1
    return res

def get_example_lines(lines, style, sample=5):
    res = []
    for line in lines:
        if line.startswith("Dialogue: "):
            line_style = line.split(',')[3]
            if style == line_style:
                res.append(line)
                sample -= 1
                if sample == 0:
                    return res
    return res

def get_styles(lines):
    res = []
    for line in lines:
        if line.startswith('Style: '):
            res.append(line[7:].split(',')[0])
    return res

def select_keep_styles(all_styles, lines):
    styles_occ = sorted([(s, count_style_occurences(lines, s)) for s in all_styles], key=lambda x: x[1], reverse=True)
    for i, s in enumerate(styles_occ):
        print("[{}] {} ({} lines use this style)".format(i, s[0], s[1]))
        if i < 3:
            print(''.join(get_example_lines(lines, s[0])))
    keep_indices = input("Which sub styles to keep? Enter numbers separated by spaces or leave blank for all: ").split()
    if not keep_indices:
        return all_styles
    return [s[0] for i, s in enumerate(styles_occ) if str(i) in keep_indices]

def extract_eng_subs(mkv, index=None):
    print("\nExtracting english subtitles, this may take a while...\n")
    print([
                # os.path.join(get_lib_folder(), "ffmpeg\\bin\\ffprobe.exe"),
                "ffmpeg",
                "-v",
                "quiet",
                "-print_format",
                "json",
                "-show_streams",
                "-select_streams",
                "s",
                mkv,
            ])
    mkv_json = json.loads(
        subprocess.run(
            [
                # os.path.join(get_lib_folder(), "ffmpeg\\bin\\ffprobe.exe"),
                "ffprobe",
                "-v",
                "quiet",
                "-print_format",
                "json",
                "-show_streams",
                "-select_streams",
                "s",
                mkv,
            ],
            capture_output=True,
            universal_newlines=True,
        ).stdout
    )

    # Use the subtitle track as provided. If there is not one,
    # ask instead.
    all_streams = {s["index"]: s for s in mkv_json["streams"]}
    if index not in all_streams:
        index = None
    if index is None:
        if not mkv_json.get("streams"):
            raise Exception("No subtitle streams to extract? Can't do any syncing. {}".format(mkv))
        elif len(mkv_json["streams"]) == 1:
            index = mkv_json["streams"][0]["index"]
        else:
            print("[id]: Tag Information")
            for s in mkv_json["streams"]:
                tags = 'Unknown'
                try:
                    tags = str(s['tags'])
                except:
                    pass
                print(f"[{s['index']}]: {tags}")
            index = int(input("Pick the stream to retime against: "))

    # Extract
    stream = all_streams[index]
    codec_name = stream['codec_name']
    if codec_name == "subrip": codec_name = "srt"
    extracted = mkv.replace(".mkv", f".EXTRACTED.{codec_name}")
    # subprocess.run([os.path.join(get_lib_folder(), "mkvtoolnix\\mkvextract.exe"), "tracks", mkv, f"{index}:{extracted}"])
    subprocess.run(["mkvextract", "tracks", mkv, f"{index}:{extracted}"])
    return index

def fix_styling():
    extracted_subs = [f for f in os.listdir() if '.EXTRACTED.' in f]
    if extracted_subs[0].split('.')[-1] != 'ass':
        print("Extracted subs are not .ASS format. Skipping style removal.")
        return
    all_lines = sum([mopen(f, encoding="utf-8").readlines() for f in extracted_subs], [])
    all_styles = list(set(get_styles(all_lines)))
    keep_styles = select_keep_styles(all_styles, all_lines)
    for sub in extracted_subs:
        with mopen(sub, encoding="utf-8") as ass:
            lines = ass.readlines()
        lines = remove_styles(lines, keep_styles)
        with open(sub, 'w', encoding="utf-8") as ass:
            ass.write('\r\n'.join(lines))

def retime_based_on_audio(mkv, srt, conf):
    retimed = mkv.replace(".mkv", ".jp.RETIMED.{}".format(conf['ext']))
    # subprocess.run([os.path.join(get_lib_folder(), "alass\\alass.bat"), "--split-penalty", conf['split_pen'], mkv, srt, retimed])
    subprocess.run(["alass", "--split-penalty", conf['split_pen'], mkv, srt, retimed])
    os.remove(srt)
    os.rename(retimed, mkv.replace(".mkv", ".jp.{}".format(conf['ext'])))

def retime(mkv, srt, conf):
    retimed = mkv.replace(".mkv", ".jp.RETIMED.{}".format(conf['ext']))
    extracted = [f for f in os.listdir() if mkv.replace(".mkv", ".EXTRACTED.") in f][0]
    print([os.path.join(get_lib_folder(), "alass\\alass.bat"), "--split-penalty", conf['split_pen'], extracted, srt, retimed])
    # subprocess.run([os.path.join(get_lib_folder(), "alass\\alass.bat"), "--split-penalty", conf['split_pen'], extracted, srt, retimed])
    subprocess.run(["alass", "--split-penalty", conf['split_pen'], extracted, srt, retimed])
    os.remove(srt)
    os.rename(retimed, mkv.replace(".mkv", ".jp.{}".format(conf['ext'])))
    os.remove(extracted)

def fix_common_errors(srt):
    lines = mopen(srt, encoding='utf-8').readlines()
    lines = [x for i, x in enumerate(lines) if not (x.strip() == "" and i+1 < len(lines) and not lines[i+1].strip().isdigit())]
    with open(srt, 'w', encoding="utf-8") as subfile:
        subfile.write(''.join(lines))

def tryint(s):
    try:
        return int(s)
    except:
        return s

def alphanum_key(s):
    return [ tryint(c) for c in re.split('([0-9]+)', s) ]

if __name__ == '__main__':
    # Guess the local mkv/srt pairs that need syncing
    files = os.listdir()
    CONF = {}
    print('[1] .srt files (Default)')
    print('[2] .ass files')
    choice = input("What file type are your Japanese subs? ")
    if choice.strip() == "":
        choice = 1
    CONF['ext'] = ["", "srt", "ass"][int(choice)]
    srts = sorted([f for f in files if f.endswith(f".{CONF['ext']}")], key=alphanum_key)
    mkvs = [f for f in files if f.endswith(".mkv")]
    while len(mkvs) > len(srts):
        print(f"Found more .mkv files than .{CONF['ext']} files. This can occur when OP/ED/extras are in the same folder as episodes.")
        print("Please enter a pattern to filter out of mkv results. (e.g. OP)")
        pattern = input(">>> Pattern: ")
        removed = [m for m in mkvs if pattern in m]
        mkvs = [m for m in mkvs if pattern not in m]
        print("Ignoring filtered mkv files:\n{}".format("\n".join(removed)))
    mkvs = sorted([f for f in mkvs], key=alphanum_key)
    if len(mkvs) == 0 or len(mkvs) != len(srts):
        print(f"ERROR: Some .{CONF['ext']} files don't have a matching .mkv!")
        print(f"{len(srts)} {CONF['ext']} files found. {len(mkvs)} mkv files found")
        print(f"Ensure auto-sub-retimer folder is in same folder as your .mkv and .{CONF['ext']} files.")
        print(f"Ensure you have an equal number of .mkv and .{CONF['ext']} files!")
        input("press enter to exit...")
        exit(1)
    if len(sys.argv) > 1 and sys.argv[1] == "rename_only":
        for srt, mkv in zip(srts, mkvs):
            os.rename(srt, mkv.replace('.mkv', ".jp.{}".format(CONF['ext'])))
        input("Rename finished!")
        sys.exit(0)
    pool = Pool()
    print("[1] Retime using embedded subs. (Default)")
    print("[2] Retime using audio.")
    retime_choice = input("Enter desired option number: ")
    SPLIT_PEN = input("Split Penalty? Only change this if default resulted in mis-timed subs. (Default 7): ").strip()
    if not SPLIT_PEN:
        SPLIT_PEN = "7"
    CONF['split_pen'] = SPLIT_PEN
    for srt in srts:
        fix_common_errors(srt)
    if "2" in retime_choice:
        pool.starmap(retime_based_on_audio, zip(mkvs, srts, [CONF]*len(mkvs)))
    else:
        index = None
        for mkv in mkvs:
            index = extract_eng_subs(mkv, index)
        #index = extract_eng_subs(mkvs[0])
        #pool.starmap(extract_eng_subs, [(x, index) for x in mkvs])
        print("English Sub Extraction Complete.")
        fix_styling()
        pool.starmap(retime, zip(mkvs, srts, [CONF]*len(mkvs)))
    print("\nSuccess!\n")
    time.sleep(3)
