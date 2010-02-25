
#in_file = 'data/maxdb-lda.report2.xml'
in_file = 'annotations/postgresql/postgresql.lda.report.xml'
#out_file = 'data/split/'
out_file = 'data/postgresql-tagged'
#xsl_file = 'split.xsl'
        
import lxml.etree
doc = lxml.etree.parse(in_file)
periods = doc.findall('Period')
for period in periods:
    time = period.attrib['time']
    time_file = out_file + "/" + time + "xml"
    # period.write( time_file, encoding='UTF-8' )
    tfile = open( time_file,"w" )
    tfile.write( lxml.etree.tostring( period, pretty_print = True ) )
    tfile.close()

exit(0)






# for mysql

#in_file = 'data/maxdb-lda.report2.xml'
in_file = 'annotations/mysql-3.23/mysql-3.23.lda.report.xml'
#out_file = 'data/split/'
out_file = 'data/mysql-tagged'
#xsl_file = 'split.xsl'
        
import lxml.etree
doc = lxml.etree.parse(in_file)
periods = doc.findall('Period')
for period in periods:
    time = period.attrib['time']
    time_file = out_file + "/" + time + "xml"
    # period.write( time_file, encoding='UTF-8' )
    tfile = open( time_file,"w" )
    tfile.write( lxml.etree.tostring( period, pretty_print = True ) )
    tfile.close()

exit(0)

in_file = 'data/maxdb-lda.report2.xml'
#in_file = 'annotations/mysql-3.23/mysql-3.23.lda.report.xml'
out_file = 'data/split/'
#out_file = 'data/mysql-tagged'
xsl_file = 'split.xsl'
        


# ok look I think I'm missing the XSLT for this
styledoc = lxml.etree.parse(xsl_file)
transform = lxml.etree.XSLT(styledoc)
doc = lxml.etree.parse(in_file)
result_tree = transform(doc)
#result_tree.write(out_file+, encoding='UTF-8')  
