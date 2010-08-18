"""
Plot timelines with no spaces. Input is a range of values per quality.
"""
# import matplotlib.pyplot as plt
import matplotlib
matplotlib.use('pdf')

from matplotlib.dates import YearLocator, MonthLocator, DateFormatter
from matplotlib.patches import Rectangle
from matplotlib.lines import Line2D     
import matplotlib.pylab as pylab
import matplotlib.font_manager as fm
from pylab import rc                  

import datetime


def plot_timeline(proj, period_map):
    """ Plot a timeline view a la ConcernLines to show trends in topic occurrence """
    
    fig_dir = '/Users/nernst/Dropbox/research/abram/papers/naming-paper/icse/figures/'
    #configure the figure
    width = 17
    height = 6
    #rc("font", family="serif")
    #rc("font", size=10)
    # fractions of figure width
    rc("figure.subplot", left=0.1)
    rc("figure.subplot", right=0.98)
    rc("figure.subplot", bottom=0.1) #no idea what the practical impact of this is ..
    rc("figure.subplot", top=0.99)
    fig = pylab.figure(figsize=(width, height))
    #font = fm.FontProperties(fname = '/Library/Fonts/Helvetica.ttc')
    ax = fig.add_subplot(111)
    years    = YearLocator()   # every year
    months   = MonthLocator()  # every month
    yearsFmt = DateFormatter('%Y')
    months    = MonthLocator(range(1,13), bymonthday=1, interval=4)
    monthsFmt = DateFormatter("%b %Y")
    
    # bar size
    barwidth = 30#datetime.date()
    barheight = 5
    ax.set_ylim(0,35)
    if proj == 'mysql':
        ax.set_xlim(datetime.date(2000,07,31),datetime.date(2004,8,9))#5*len(period_map.keys()
    else:
        ax.set_xlim(datetime.date(2004,06,29),datetime.date(2006,6,19))#5*len(period_map.keys()
    #ax.set_xlabel('Date')
    ax.set_yticks([2.5,7.5,12.5,17.5,22.5,27.5,32.5])
    ax.set_yticklabels(['None', 'Portability', 'Efficiency', 'Reliability', 'Functionality', 'Usability', 'Maintainability'])#,fontproperties = font)
    ax.xaxis_date()
    ax.xaxis.set_major_locator(months)
    ax.xaxis.set_major_formatter(monthsFmt)
    #ax.xaxis.set_minor_locator(months)
    ax.grid(True)

    fig.autofmt_xdate()
    ax.autoscale_view()
    
    # set intensity scale to 0-1 i.e. max-value is all out, the rest are in between
    # this gives intensity relative to the highest value of all qualities. But we should probably normalize for a specific quality.
    #max value is across all periods in that quality
    #i am personally offended by this code
    max_value_map = {'none':0,'portability':0, 'efficiency':0, 'reliability':0, 'functionality':0, 'usability':0, 'maintainability':0}
    for qm in period_map.values():
        for q in qm.keys():
            if qm[q] > max_value_map[q]: max_value_map[q] = qm[q]
            
    i = 0
    for period in period_map.keys():
        qm = period_map[period] # the quality map w/value
        y, m, d = period.split('-') # why I have to re create the datetime instance ... 
        date = datetime.date(int(y), int(m), int(d))
        
        #now we draw a box with a transparent red fill. The transparency can be set based on several factors:
        # - the ratio between that NFR's highest value and the current value (relative to self)
        # - the ratio between the overall highest value and the current NFRs value (relative to all)
        # - set the average topic number as a midpoint, and color based on distance from this average.
        denominator = max(max_value_map.values())
        # relative to all
        none_rect = Rectangle((date,0), barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['none'])/float(denominator)))
        port_rect = Rectangle((date,5), barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['portability'])/float(denominator)))
        effc_rect = Rectangle((date,10),barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['efficiency'])/float(denominator)))
        reli_rect = Rectangle((date,15),barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['reliability'])/float(denominator)))
        func_rect = Rectangle((date,20),barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['functionality'])/float(denominator)))
        usab_rect = Rectangle((date,25),barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['usability'])/float(denominator)))
        main_rect = Rectangle((date,30),barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['maintainability'])/float(denominator)))
        
        #relative to self
        # none_rect = Rectangle((date,0), barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['none'])/float(max_value_map['none'])))
        #         port_rect = Rectangle((date,5), barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['portability'])/float(max_value_map['portability'])))
        #         effc_rect = Rectangle((date,10),barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['efficiency'])/float(max_value_map['efficiency'])))
        #         reli_rect = Rectangle((date,15),barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['reliability'])/float(max_value_map['reliability'])))
        #         func_rect = Rectangle((date,20),barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['functionality'])/float(max_value_map['functionality'])))
        #         usab_rect = Rectangle((date,25),barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['usability'])/float(max_value_map['usability'])))
        #         main_rect = Rectangle((date,30),barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm['maintainability'])/float(max_value_map['maintainability'])))
        
        
        ax.add_patch(none_rect)
        ax.add_patch(port_rect)
        ax.add_patch(effc_rect)
        ax.add_patch(reli_rect)
        ax.add_patch(func_rect)
        ax.add_patch(usab_rect)
        ax.add_patch(main_rect)
        
        #add text numbers to debug
        delta = datetime.timedelta(days=5)
        ax.annotate(str(qm['none']),           (date+delta, 2.5) , color='black', size='small')
        ax.annotate(str(qm['portability']),    (date+delta, 7.5),  color='black', size='small' )
        ax.annotate(str(qm['efficiency']),     (date+delta, 12.5), color='black', size='small'  )
        ax.annotate(str(qm['reliability']),    (date+delta, 17.5), color='black', size='small'  )
        ax.annotate(str(qm['functionality']),  (date+delta, 22.5), color='black', size='small'  )
        ax.annotate(str(qm['usability']),      (date+delta, 27.5), color='black', size='small'  )
        ax.annotate(str(qm['maintainability']),(date+delta, 32.5), color='black', size='small'  )
        
        i += barwidth
        
    for i in range(len(period_map.keys()[0])):
        if proj == 'mysql':
             l = Line2D([datetime.date(2000,07,31),datetime.date(2004,8,9)],[5*i,5*i]  , lw = 0.5, color='black')#5*len(period_map.keys()
        else:                                                                            
             l = Line2D([datetime.date(2004,06,29),datetime.date(2006,6,19)],[5*i,5*i]  ,lw = 0.5,  color='black')#5*len(period_map.keys()
        ax.add_line(l)                              

    # ax.annotate('race interrupted', (61, 25),
    #             xytext=(0.8, 0.9), textcoords='axes fraction',
    #             arrowprops=dict(facecolor='black', shrink=0.05),
    #             fontsize=16,
    #             horizontalalignment='right', verticalalignment='top')
    #plt.show()
    pylab.savefig(fig_dir + proj + '-timeline-all.pdf')
    
