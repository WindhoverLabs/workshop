#!/bin/python

import json
from optparse import OptionParser
import copy

parser = OptionParser()
parser.add_option("-f", "--json_file", dest="json_file", help="input/output json file")
parser.add_option("-u", "--url", dest="url", help="file URL, i.e. 'http://mysite/vbox/box_0.1.0.box")
parser.add_option("-c", "--checksum", dest="checksum", help="checksum.  Use the following command to get the sha1... openssl sha1 <box_file>")
parser.add_option("-v", "--version", dest="version", help="version, i.e. '0.1.0'")

(options, args) = parser.parse_args()

with open(options.json_file) as data_file:
    data = json.load(data_file)

new_version = {"version":options.version, "providers":[{"name":"virtualbox", "url":options.url, "checksum_type":"sha1", "checksum":options.checksum}]}

found = False
for version in data["versions"]:
    if version['version'] == options.version:
        version['providers'] = new_version['providers']
        found = True

if found == False:
    data["versions"].append(new_version)


with open(options.json_file, 'wt') as out:
    res = json.dump(data, out, sort_keys=True, indent=4, separators=(',', ': '))
