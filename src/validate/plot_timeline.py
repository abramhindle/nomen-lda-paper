"""
Plot timelines with no spaces. Input is a range of values per quality.
"""
import matplotlib.pyplot as plt
from matplotlib.dates import YearLocator, MonthLocator, DateFormatter
from matplotlib.patches import FancyBboxPatch, Rectangle

import datetime

def plot_timeline(proj, period_map):
    """ Plot a timeline view a la ConcernLines to show trends in topic occurrence """
    fig = plt.figure()
    ax = fig.add_subplot(111)
    # bar size
    barwidth = 5
    barheight = 5
    ax.set_ylim(0,40)
    ax.set_xlim(0,5*len(period_map.keys()))
    ax.set_xlabel('Date')
    ax.set_yticks([5,10,15,20,25,30,35])
    ax.set_xticks([x*5 for x in range(len(period_map.keys())+1)])
    ax.set_yticklabels(['None', 'Portability', 'Efficiency', 'Reliability', 'Functionality', 'Usability', 'Maintainability'])
    ax.set_xticklabels([period_map.keys()])
    ax.autoscale_view()
    
    # set intensity scale to 0-1 i.e. max-value is all out, the rest are in between
    # this gives intensity relative to the highest value of all qualities. But we should probably normalize for a specific quality.
    #max value is across all periods in that quality
    #i am personally offended by this code
    max_value_map = {'none':0,'portability':0, 'efficiency':0, 'reliability':0, 'functionality':0, 'usability':0, 'maintainability':0}
    for qm in period_map.values():
        #qm = period_map[p] # the quality map w/value
        for q in qm.keys():
            if qm[q] > max_value_map[q]: max_value_map[q] = qm[q]
            
    i = 0
    for period in period_map.keys():
        qm = period_map[period] # the quality map w/value
        none_rect = Rectangle((i,2.5), barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['none'])/float(max_value_map['none'])))
        port_rect = Rectangle((i,7.5), barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['portability'])/float(max_value_map['portability'])))
        effc_rect = Rectangle((i,12.5),barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['efficiency'])/float(max_value_map['efficiency'])))
        reli_rect = Rectangle((i,17.5),barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['reliability'])/float(max_value_map['reliability'])))
        func_rect = Rectangle((i,22.5),barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['functionality'])/float(max_value_map['functionality'])))
        usab_rect = Rectangle((i,27.5),barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['usability'])/float(max_value_map['usability'])))
        main_rect = Rectangle((i,32.5),barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['maintainability'])/float(max_value_map['maintainability'])))
        
        ax.add_patch(none_rect)
        ax.add_patch(port_rect)
        ax.add_patch(effc_rect)
        ax.add_patch(reli_rect)
        ax.add_patch(func_rect)
        ax.add_patch(usab_rect)
        ax.add_patch(main_rect)
        
        i += barwidth

    # ax.xaxis.set_major_locator(years)
    # ax.xaxis.set_major_formatter(yearsFmt)
    # ax.xaxis.set_minor_locator(months)
    # ax.grid(True)
    # ax.annotate('race interrupted', (61, 25),
    #             xytext=(0.8, 0.9), textcoords='axes fraction',
    #             arrowprops=dict(facecolor='black', shrink=0.05),
    #             fontsize=16,
    #             horizontalalignment='right', verticalalignment='top')
    # fig.autofmt_xdate()
    plt.show()