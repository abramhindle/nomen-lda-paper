# This program takes all of the experimental data and produced new lda.report.xml
# files stripped of the previous annotations and annotated solely with our quality mapping


import quality_map as Q
import count_annotations as C
import get_exps as G
from lxml.builder import E
import lxml.etree as etree

if __name__ == '__main__':
    exps = G.get_exps()
    for e in exps:
        print ("Dealing with " + e[0])
        name = e[0]
        ndir = e[1]
        periods = e[2]
        xperiods = C.load_periods( ndir, periods )
        for period in xperiods:
            # get  topics
            topics = C.get_topics( period )
            for topic in topics:
                # get annotations
                # get simple annotations
                qualities = C.get_simple_annotations( topic )
                annotations = C.get_annotations( topic )
                for annotation in annotations:
                    topic.remove( annotation )
                # add the annotation back
                for quality in qualities:
                    elm = etree.Element ( "Annotation", name=quality )
                    topic.append(elm)
        periods = etree.Element( "Periods" )
        for period in xperiods:
            periods.append( period.getroot() )
        stri = etree.tostring( periods, pretty_print=True)
        FILE = open( "output/"+name+".lda.report.clean.xml" , "w" )
        FILE.write( stri )
        FILE.close()

