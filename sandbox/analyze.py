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
    cutoff = np.percentile (sortedTimes, 99.5)
    filteredTimes = [t for t in sortedTimes if t < cutoff]
    return (filteredTimes)

def plotData (data, platform):
    num_bins = 1000
    lineType = {'hp': 'b--', 'hpr': 'b', 'lp': 'r--', 'lpr': 'r'}
    lineLabels = {'hp': 'HP', 'hpr': 'HP (RTG)', 'lp': 'LP', 'lpr': 'LP (RTG)'}
    fontSizeLabels = 'x-large'
    fontWeightLabels = 'bold'
    margins = 0.15
    xLimLeft = min ([min (x) for x in data.values ()])
    xLimRight = max ([max (x) for x in data.values ()])
    xRange = xLimRight - xLimLeft
    xLimLeft = 0 if 'pi' in platform else 5#xLimLeft - margins * xRange
    xLimRight = 850 if 'pi' in platform else 15#xLimRight + margins * xRange

    for exp in data:
        counts, bin_edges = np.histogram (data [exp], bins = num_bins, normed = True)
        cdf = np.cumsum (counts)
        plt.plot (bin_edges [1:], cdf/cdf[-1], lineType [exp], lw = 2.0, label = lineLabels [exp])
    plt.plot ([xLimLeft, xLimRight], [1, 1], 'k--', lw = 1)
    plt.xlim (xLimLeft, xLimRight)
    plt.ylim (0, 1.15)
    plt.xticks (fontsize = 'large', fontweight = 'bold')
    plt.yticks (fontsize = 'large', fontweight = 'bold')
    plt.ylabel ('CDF', fontsize = fontSizeLabels, fontweight = fontWeightLabels)
    plt.xlabel ('DNN Inference Time (msec)', fontsize = fontSizeLabels, fontweight = fontWeightLabels)
    plt.title ('DNN Performance (1N x 6C) | 2 Gangs', fontweight = 'bold', fontsize = 'x-large')
    plt.legend (loc = 'upper center', ncol = 4, fontsize = 'large')
    plt.grid ()
    plt.savefig ('%s_2n6c.pdf' % platform, bbox_inches = 'tight')

    return

def main ():
    data = {}
    platform = sys.argv [1]
    data ['hp']  = analyze ('x2_n1c6_hp.perf')
    data ['hpr'] = analyze ('x2_n1c6_hp_rg.perf')
    data ['lp']  = analyze ('x2_n1c6_lp.perf')
    data ['lpr'] = analyze ('x2_n1c6_lp_rg.perf')

    plotData (data, platform)

    return

if __name__ == "__main__":
    main ()
