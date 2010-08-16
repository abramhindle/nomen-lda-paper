""" Create a CSV of the project, period, topics, labels """
import check_validity as cv
import quality_map as Q
import get_exps
import lxml.etree
import datetime

""" Look something like this:
Project, Period, Topic-#, Labels
Mysql, 10343244, 2, Usability, Maintainability
"""
if __name__ == '__main__':
    maxdb_file = 'label-summary.csv'
    maxdb = open(maxdb_file,'w')
    
    exps = get_exps.get_exps() 
    # test_period = '1098931753'
    #     topics = load_period(test_period)
    for project in exps: #['name', 'dir', [periods]]
        str_write = project[0] + ',' # project name
        periods_map = {}
        for period in project[2]:
            p_date = datetime.datetime.fromtimestamp(float(period)).strftime("%Y-%m-%d")
            # maintain a list of qualities (counts) per period
            quality_map = {'none':0,'portability':0, 'efficiency':0, 'reliability':0, 'functionality':0, 'usability':0, 'maintainability':0}
            topics = cv.load_period(period, project[1])
            i = 0
            for topic in topics:
                annotations = []
                anno = topic.findall('Annotation') or topic.findall('annotation')
                for a in anno:
                    annotations.append(a.attrib['name'])
                    annotations2 = Q.annotations_to_qualities( annotations ) # a converted list of annotations in that topic
                    for q in annotations2:
                        if q in quality_map.keys():
                            quality_map[q] += 1
            periods_map[p_date] = quality_map
        for p in periods_map.keys():
           # print  str(p) + ',' + ','.join([str(x) for x in periods_map[p].values()])
            maxdb.write(project[0] + ',' + str(p) + ',' + ','.join([str(x) for x in periods_map[p].values()]) + '\n')
            

