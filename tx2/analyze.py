#!/usr/bin/env python

import sys, re
import matplotlib.pyplot as plt

meanRex = re.compile (r'^mean: ([\d\.]+).*$')
def parse (filename):
    meanTime = 0
    with open (filename, 'r') as fdi:
        for line in fdi:
            m = meanRex.match (line)

            if m:
                meanTime = round (float (m.group (1)), 3)
                break

    if not meanTime:
        print '[ERROR] Processing time "0" in file: ', filename
        sys.exit (-1)

    return meanTime

def plotData (data):
    fig = plt.figure (figsize = (20, 10))

    # Absolute performance plot
    p = plt.subplot (2, 1, 1)
    xticks = sorted ([tick + 0.5 for key in data.keys () for tick in data [key]['ticks']])
    xtickNames = [tick for key in data.keys () for tick in range (6)]

    for key in data.keys ():
        plt.bar (data [key]['ticks'], data [key]['perf'], color = 'white',
                edgecolor = 'black', width = 1, lw = 2, hatch = data
                [key]['hatch'], label = data [key]['name'])

    plt.gca ().yaxis.grid (True, linestyle = '--')
    plt.ylabel ('Average Processing Time (msec)', fontweight = 'bold', fontsize = 'large')
    plt.xticks ([])
    plt.legend (ncol = 4, loc = 'upper center', fontsize = 'large')
    plt.xlim (0, max (xticks) + 0.5)
    plt.ylim (0, 100)

    # Normalized performance plot
    p = plt.subplot (2, 1, 2)
    for key in data.keys ():
        plt.bar (data [key]['ticks'], data [key]['norm'], color = 'white',
                edgecolor = 'black', width = 1, lw = 2, hatch = data
                [key]['hatch'], label = data [key]['name'])

    plt.gca ().yaxis.grid (True, linestyle = '--')
    plt.ylabel ('Normalized DNN Performance', fontweight = 'bold', fontsize = 'large')
    plt.xlabel ('Number of Bandwidth Corunners', fontweight = 'bold', fontsize = 'large')
    plt.suptitle ('Memory Interference Study\nJetson-TX2', fontsize = 'xx-large', fontweight = 'bold')
    plt.xticks (xticks, xtickNames)
    plt.xlim (0, max (xticks) + 0.5)
    plt.ylim (0, 5)
    fig.savefig ('tx2_bw.pdf', bbox_inches = 'tight')

    return

def main ():
    data = {'CR': {'perf': [], 'norm': [], 'name': 'CPU (Read)',  'ticks': range (0, 6),    'hatch': 'xx'},
            'CW': {'perf': [], 'norm': [], 'name': 'CPU (Write)', 'ticks': range (10, 16),  'hatch': '**'},
            'GR': {'perf': [], 'norm': [], 'name': 'GPU (Read)',  'ticks': range (20, 26),  'hatch': '--'},
            'GW': {'perf': [], 'norm': [], 'name': 'GPU (Write)', 'ticks': range (30, 36),  'hatch': '..'}}

    data ['CR']['files'] = ['CPU_bw%d_read.perf'    % x for x in range (6)]
    data ['CW']['files'] = ['CPU_bw%d_write.perf'   % x for x in range (6)]
    data ['GR']['files'] = ['GPU_bw%d_read.perf'    % x for x in range (6)]
    data ['GW']['files'] = ['GPU_bw%d_write.perf'   % x for x in range (6)]

    for scenario in data.keys ():
        for case in data [scenario]['files']:
            perf = parse (case)
            data [scenario]['perf'].append (perf)
        data [scenario]['norm'] = [x / data [scenario]['perf'][0] for x in data [scenario]['perf']]

    plotData (data)

    return

if __name__ == '__main__':
    main ()
