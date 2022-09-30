#!/bin/python
import os
from pathlib import Path
import json

home = str(Path.home())
cur_dir = os.getcwd()
config_file = cur_dir + '/safeeyes.json'

def getmes(image, name):
    mes = {}
    mes['image'] = cur_dir + '/images/' + image
    mes['name'] = name
    return mes

def getdefaulttext(data):
    long_data = [{}]
    long_data[0] = getmes('walk.gif','Walk for a while')
    long_data.append(getmes('relax.gif','Lean back at your seat and relax'))
    short_data = [{}]
    short_data[0] = getmes('tightly.gif','Tightly close your eyes')
    short_data.append(getmes('roll-lr.gif','Roll your eyes a few times to each side'))
    short_data.append(getmes('clockwise.gif','Rotate your eyes in clockwise direction'))
    short_data.append(getmes('counterclockwise.gif','Rotate your eyes in counterclockwise direction'))
    short_data.append(getmes('blink.gif','Blink your eyes'))
    short_data.append(getmes('window.png','Focus on a point in the far distance'))
    short_data.append(getmes('water.png','Have some water'))
    data['long_breaks'] = long_data
    data['short_breaks'] = short_data
    return data

with open(config_file) as config_json:
    data = json.load(config_json)
with open(config_file, 'w') as outfile:
    json.dump(getdefaulttext(data), outfile, indent=4)
