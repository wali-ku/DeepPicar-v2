#!/usr/bin/env python

import os, re, sys
import numpy as np
from matplotlib import pyplot as plt

def analyze (filename):
    inferTime = []
    regex = '^.*took: ([\d.]+) ms.*$'
    with open (filename, 'r') as fdi:
        for line in fdi:
            match = re.match (regex, line)

            if match:
                time = float (match.group (1))
                inferTime.append (time)

    sortedTimes = sorted (inferTime)
    cutoff = np.percentile (sortedTimes, 98)
    filteredTimes = [t for t in sortedTimes if t < cutoff]
    return (filteredTimes)

def plotData (data, platform, nn):
    num_bins = 1000
    lineType = {'ltimes': 'b', 'utimes': 'r', 'stimes': 'y^'}
    lineLabels = {'ltimes': 'Gang', 'utimes': 'CoSched', 'stimes': 'Solo'}
    fontSizeLabels = 'x-large'
    fontWeightLabels = 'bold'
    margins = 0.15
    xLimLeft = min ([min (x) for x in data.values ()])
    xLimRight = max ([max (x) for x in data.values ()])
    xRange = xLimRight - xLimLeft
    xLimLeft = 0 if platform == 'pi' else 5#xLimLeft - margins * xRange
    xLimRight = 850 if platform == 'pi' else 40#xLimRight + margins * xRange

    for exp in data:
        counts, bin_edges = np.histogram (data [exp], bins = num_bins, normed = True)
        cdf = np.cumsum (counts)
        plt.plot (bin_edges [1:], cdf/cdf[-1], lineType [exp], lw = 2.5, label = lineLabels [exp])
    plt.plot ([xLimLeft, xLimRight], [0.95, 0.95], 'k--', lw = 1)
    plt.xlim (xLimLeft, xLimRight)
    plt.ylim (0, 1.15)
    plt.xticks (fontsize = 'large', fontweight = 'bold')
    plt.yticks (fontsize = 'large', fontweight = 'bold')
    plt.ylabel ('CDF', fontsize = fontSizeLabels, fontweight = fontWeightLabels)
    plt.xlabel ('DNN Inference Time (msec)', fontsize = fontSizeLabels, fontweight = fontWeightLabels)
    plt.legend (loc = 'upper center', ncol = 3, fontsize = 'large')
    plt.grid ()
    plt.savefig ('%s_nn%s.pdf' % (platform, nn), bbox_inches = 'tight')

    return

def main ():
    data = {}
    platform = sys.argv [1]
    nn = sys.argv [2]
    cc = 3
    data ['ltimes'] = analyze ('%s/nn%s_%s%d' % (platform, nn, 'locked.corun', cc))
    data ['utimes'] = analyze ('%s/nn%s_%s%d' % (platform, nn, 'unlocked.corun', cc))
    data ['stimes'] = analyze ('%s/nn%s_%s' % (platform, nn, 'unlocked.solo'))

    plotData (data, platform, nn)

    return

if __name__ == "__main__":
    main ()
