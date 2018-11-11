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
    tcks = data ['cna']
    axes = range (len (data ['cpu']))
    vals = data ['cpu']

    plt.bar (axes, data ['cpu'], color = 'white', edgecolor = 'black', width = 1, lw = 2, hatch = 'x')

    idx = 0
    for val in vals:
        plt.annotate (round (val, 1), xy = (axes [idx] + 0.15, val + 0.25), fontweight = 'bold', color = 'black')
        plt.annotate ('------', xy = (axes [idx] + 0.15, val + 0.65), fontweight = 'bold', color = 'silver')
        plt.annotate (int (1000/val), xy = (axes [idx] + 0.25, val + 0.95), fontweight = 'bold', color = 'grey')
        idx += 1

    plt.gca ().yaxis.grid (True, linestyle = '--')
    plt.xticks ([x + 0.5 for x in axes], tcks, fontweight = 'bold', rotation = 90, fontsize = 'small')
    plt.ylabel ('Average Processing Time (msec)', fontweight = 'bold', fontsize = 'large')
    plt.title ('DNN Performance on Jetson-TX2', fontsize = 'x-large', fontweight = 'bold')
    plt.xlim (axes [0] - 1, axes [-1] + 2)
    plt.ylim (0, 25)
    fig.savefig ('tx2.pdf', bbox_inches = 'tight')

    return

def main ():
    data = {}
    data ['cpu'] = []
    data ['cna'] = []
    cpuCases = ['1n1c_cx', '1n1c_dv', '1n2c_cx', '1n2c_dv', '1n4c_cx',
                '1n6c',    '2n2c_cx', '2n2c_dv', '2n2c_hm', '2n3c_cd',
                '2n3c_cx', '4n1c_cx', '6n1c_cx', '6n1c_dv']

    for case in cpuCases:
        filename = 'CPU_%s.perf' % (case)
        try:
            name = case.split ('_')[0].upper ()[:2] + 'x' + case.split\
               ('_')[0].upper ()[2:] + ' (%s)' % case.split ('_')[1].upper ()
        except:
            name = case.upper ()[:2] + 'x' + case.upper ()[2:]
        data ['cna'].append (name)
        data ['cpu'].append (parse (filename))

    plotData (data)

    return

if __name__ == '__main__':
    main ()
