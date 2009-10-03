in_file = 'data/maxdb-lda.report2.xml'
out_file = 'data/split/'
xsl_file = 'split.xsl'
        
import lxml.etree
styledoc = lxml.etree.parse(xsl_file)
transform = lxml.etree.XSLT(styledoc)
doc = lxml.etree.parse(in_file)
result_tree = transform(doc)
result_tree.write(out_file+, encoding='UTF-8')  