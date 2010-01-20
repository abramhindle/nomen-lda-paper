import names

t = names.Taxonomy()
f = open( "categories", "w" )
for y in [x.lower() for x in t.get_signified()]:
    f.write( y + '\n' )
f.close()
