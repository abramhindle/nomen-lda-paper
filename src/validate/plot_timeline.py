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
# from matplotlib.axes.Axes import avxline
from pylab import rc                  

import datetime


def plot_timeline(proj, period_map):
    """ Plot a timeline view a la ConcernLines to show trends in topic occurrence """
    
    fig_dir = './output/' # /Users/nernst/Dropbox/research/abram/papers/naming-paper/icse/figures/'
    #configure the figure
    width = 22
    height = 6
    #rc("font", family="serif")
    #rc("font", size=10)
    #set default font size
    matplotlib.rcParams['font.size'] = 24
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
    months    = MonthLocator(range(1,13), bymonthday=1, interval=3)
    monthsFmt = DateFormatter("%b %Y")
    
    # bar size
    barwidth = 30#datetime.date()
    barheight = 5
    ax.set_ylim(0,40)#35)
    if proj == 'mysql':
        ax.set_xlim(datetime.date(2000,07,31),datetime.date(2004,8,9))#5*len(period_map.keys()
    if proj == 'maxdb':
        ax.set_xlim(datetime.date(2004,06,29),datetime.date(2006,6,19))#5*len(period_map.keys()
    if proj == 'pgsqln' or proj == 'pgsqla':
        ax.set_xlim(datetime.date(2002,02,1),datetime.date(2004,6,28))

    #ax.set_xlabel('Date')
    ax.tick_params(axis='both',direction='in',length=8,width=3,top=False,right=False,zorder=15)
    ax.set_yticks([2.5,7.5,12.5,17.5,22.5,27.5,32.5,37.5])
    ax.set_yticklabels(['None', 'Portability', 'Efficiency', 'Reliability', 'Functionality', 'Usability', 'Maintainability','*Key Events*'], rotation=30,rotation_mode='anchor')#,fontproperties = font)
    ax.xaxis_date()
    ax.xaxis.set_major_locator(months)
    ax.xaxis.set_major_formatter(monthsFmt)
    #ax.xaxis.set_minor_locator(months)
    #ax.grid(True)

    fig.autofmt_xdate()
    ax.autoscale_view()
    
    # set intensity scale to 0-1 i.e. max-value is all out, the rest are in between
    # this gives intensity relative to the highest value of all qualities. But we should probably normalize for a specific quality.
    #max value is across all periods in that quality
    #i am personally offended by this code
    max_value_map = {'none':0,'portability':0, 'efficiency':0, 'reliability':0, 'functionality':0, 'usability':0, 'maintainability':0}

    # the order of display
    value_order = [ 'none' , 'portability' , 'efficiency' , 'reliability' , 'functionality' , 'usability' , 'maintainability' ]
    value_start = {}
    # the y values of value
    vo = 0
    for value_name in value_order:
        value_start[ value_name ] = vo
        vo += 5

    for qm in period_map.values():
        for q in qm.keys():
            if qm[q] > max_value_map[q]: max_value_map[q] = qm[q]
            
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
        # loop over it instead of copy and paste 
        #HAHAHA! Copy and paste rules. Code clones rule. Code smells rule.
        delta = datetime.timedelta(days=5)
        i = 0
        for value in value_order:
            #rect = Rectangle((date,value_start[value]), barwidth,barheight,fill=True,lw=0, fc='red',alpha=(float(qm[ value ])/float(max_value_map[ value ])))
            intensity = (float(qm[ value ])/float(denominator))
            # if intensity > 0:
            #     pass#intensity = intensity + 0.2 # the lowest alpha possible
            # if intensity >= 1: intensity = 1 
            rect = Rectangle((date,value_start[value]), barwidth,barheight,zorder=2,fill=True,lw=0, fc='red',alpha=intensity)
            ax.add_patch( rect )
            # now draw the boxes relative the stream itself
            # 0.49 is for half height
            h = 0.49 * barheight * float(qm[ value ]) / float( max_value_map[ value ])
            vrect = Rectangle((date,value_start[value]), barwidth, h,fill=True,zorder=3,lw=1, ec='gray',fc='gray',)#alpha=(float(qm[ value ])/float(max_value_map[ value ])))
            ax.add_patch( vrect )
        
            #add text numbers to debug
            #ax.annotate("%.2f" % intensity,  (date+delta, 2.5+5*i) , color='black', size='small') #qm[value]
            i += 1
        
    for i in range(len(period_map.keys()[0])):
        if proj == 'mysql':
            l = Line2D([datetime.date(2000,07,31),datetime.date(2004,8,9)],[5*i,5*i]  , lw = 0.5, color='black')#5*len(period_map.keys()
        if proj == 'maxdb':                                                                            
            l = Line2D([datetime.date(2004,06,29),datetime.date(2006,6,19)],[5*i,5*i]  ,lw = 0.5,  color='black')#5*len(period_map.keys()
        if proj == 'pgsqln' or proj == 'pgsqla':
            l = Line2D([datetime.date(2002,02,1),datetime.date(2004,6,28)],[5*i,5*i]  ,lw = 0.5,  color='black')#5*len(period_map.keys()
        ax.add_line(l)                              

    # label the model with key events
    if proj == 'mysql':        
        events_dates = [datetime.date(2000,8,18), datetime.date(2001,1,18), datetime.date(2001,5,11), \
                        datetime.date(2002,8,16), datetime.date(2001,10,16), datetime.date(2003,3,18),datetime.date(2003,12,24),\
                         datetime.date(2003,9,15)]
        events_rel = ["3.23 GPL","3.23 prod.","3.23.38", "3.23.52", "4.0 alpha", \
                        "4.0 production", "5.0 alpha", "3.23.58"]
    if proj == 'maxdb':#                     2005-01-11,7.5.00.23
        events_dates = [datetime.date(2004,7,2), datetime.date(2005,1,11),datetime.date(2005,3,8),datetime.date(2005,6,10),datetime.date(2006,03,01)]
        events_rel = ["7.5.00.15", "7.5.00.23", "7.5.00.24 PHP","7.6.00 prod.","7.5.00.34"]
    if proj == 'pgsqln' or proj == 'pgsqla':
         events_dates = [datetime.date(2002,02,04), datetime.date(2002,11,27), datetime.date(2003,11,17), datetime.date(2004,6,1) ]
         events_rel = ["7.2", "7.3", "7.4", "7.5/8"]
        
    l = Line2D(events_dates,[37.5],ls=' ',marker='o')
    ax.add_line(l)
    for i in range(len(events_rel)):
        ax.annotate(events_rel[i], (events_dates[i],38.5),fontsize=16)
        ax.axvline(x=events_dates[i],zorder=10,ls='--',lw=0.8)
        
    filename = fig_dir + proj + '-timeline.pdf'
    print filename
    pylab.savefig( filename )
    matplotlib.pyplot.show()   
