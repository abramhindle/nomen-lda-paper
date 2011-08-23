import names as T

t = T.Taxonomy()

def quality_map():
    quality_map = {'none':[], 'portability':[], 'efficiency':[], 'reliability':[], 'functionality':[], 'usability':[], 'maintainability':[]}
    return quality_map


    
#    ( "functionality" 0, "correctness" 1, "portability" 2, "maintainability" 3, "documentation" 4, "reliability" 5, "bug" 6, "testability" 7, "cleanup" 8, "unknown" 9, "optimization" 10, "efficiency" 11, "usability" 12, "ui" 13, "version control" 14, "feature" 15, "build" 16, "logging" 17, "modular" 18, "error" 19, "license" 20, "security" 21, "token replacement" 22, "version" 23, "integrity" 24, "concurrency" 25, "conformance" 26, "test" 27, "rename" 28, "distribution" 29, "compliance" 30, "standardized" 31, "standard" 32, "stability" 33, "specificiation" 34, "patch" 35, "interoperability" 36, "internationalization" 37, "interface" 38, "fault tolerance" 39, "external" 40, "accuracy" 41, "Understandability" 42 )

""" Handle some of Abram's unorthodox annotations """ 
def ext_annotation_map():
    am = {}
    am["cleanup"] = "maintainability"
    am["unknown"] = "none"
    am["version control"] = "maintainability"
    am["logging"] ="reliability"
    am["license"] = "maintainability"
    am["token replacement"] = ""
    am["version"] = "maintainability"
    am["integrity"] = "reliability"
    am["concurrency"] = "efficiency"
    am["test"] = "reliability"
    am["testing"] = "reliability"
    am["rename"] = "" #not sure here
    am["distribution"] = "maintainability"
    am["patch"] = "reliability"
    am["external"] = "none"
    am["accuracy"] = "functionality",
    am["Understandability"] = "understandability"
    am["build"] = "maintainability"
    am["none"] = "none"
    am["licenseing"] = "" #hmmm and it is mispelled that's sorta pathetic come on man
    am["specificiation"] = "portability" #misspelling
    am["fault tolerance"] = "reliability"
    return am


e_a_m = ext_annotation_map()        

def annotation_to_quality( annotation_name ):
    ann = annotation_name.lower()
    try:
        return t.find_signifier( ann ).lower()
    except NameError:
        if ann in e_a_m:
            return e_a_m[ann].lower()
        else:
            raise NameError("I don't know the annotation ["+annotation_name+"]")

def annotations_to_qualities( annotations ):
    """ This cuts down the total annoations """
    ann = [x.lower() for x in annotations]
    l = [ annotation_to_quality(x) for x in ann ]
    d = {}
    for k in l:
        if (not (k == "")):
            d[k] = True
    return d.keys()
