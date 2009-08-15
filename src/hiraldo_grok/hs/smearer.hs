data Window time word = EmptyWindow | TopicWindow time [[word]]

data Topic words = Topic words

isEmptyTopic EmptyWindow = True
isEmptyTopic _  = False                 

addTopic (TopicWindow topicTime wordwords) topicNumber words = 
    (TopicWindow topicTime (words:wordwords))

makeTopicWindow time number words  = (TopicWindow time [words])

emptyTopicWindow = EmptyWindow
getTopics (TopicWindow time words)
getTopics (TopicWindow time words) = words
getTime (TopicWindow time words) = words

getIDTopics (TopicWindow time words) = map (\x -> (time, x)) words
