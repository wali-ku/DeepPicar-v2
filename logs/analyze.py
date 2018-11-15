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
    fig = plt.figure (figsize = (10, 8))
    tcks = data ['cna'] + data ['gna']
    axes = range (len (data ['cpu']) + len (data ['gpu']))
    cxes = axes [:len (data ['cpu'])]
    gxes = [x + 2 for x in axes [len (data ['cpu']):]]
    axes = cxes + gxes
    vals = data ['cpu'] + data ['gpu']

    plt.bar (cxes, data ['cpu'], color = 'white', edgecolor = 'black', width = 1, lw = 2, hatch = 'x')
    plt.bar (gxes, data ['gpu'], color = 'white', edgecolor = 'black', width = 1, lw = 2, hatch = '+')

    idx = 0
    for val in vals:
        plt.annotate (round (val, 2), xy = (axes [idx] - 0.35, val + 0.25), fontweight = 'bold', color = 'black')
        plt.annotate ('------', xy = (axes [idx] - 0.35, val + 0.45), fontweight = 'bold', color = 'silver')
        plt.annotate (int (1000/val), xy = (axes [idx] - 0.275, val + 0.65), fontweight = 'bold', color = 'grey')
        idx += 1

    plt.gca ().yaxis.grid (True, linestyle = '--')
    plt.xticks (axes, tcks, fontweight = 'bold', rotation = 90, fontsize = 'small')
    plt.ylabel ('Average Processing Time (msec)', fontweight = 'bold', fontsize = 'large')
    plt.title ('DNN Performance on Jetson-Xavier', fontsize = 'x-large', fontweight = 'bold')
    plt.ylim (0, 15)
    fig.savefig ('xavier.pdf', bbox_inches = 'tight')

    return

def main ():
    data = {}
    data ['cpu'] = []
    data ['cna'] = []
    data ['gpu'] = []
    data ['gna'] = []
    cpuCases = ['1n1c', '1n2c', '1n4c', '1n8c', '2n2c', '2n4c', '4n1c', '4n2c', '8n1c']
    gpuCases = ['1n1c', '1n2c', '1n4c', '1n8c']

    for case in cpuCases:
        filename = 'CPU_%s.perf' % (case)
        name = case.upper ()[:2] + 'x' + case.upper ()[2:] + '(C)'
        data ['cna'].append (name)
        data ['cpu'].append (parse (filename))

    for case in gpuCases:
        filename = 'GPU_%s.perf' % (case)
        name = case.upper ()[:2] + 'x' + case.upper ()[2:] + '(G)'
        data ['gna'].append (name)
        data ['gpu'].append (parse (filename))

    plotData (data)

    return

if __name__ == '__main__':
    main ()
