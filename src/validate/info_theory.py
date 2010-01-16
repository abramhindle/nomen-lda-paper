def precision(tp,fp):
    return tp / (1.0 * tp + fp)
def recall(tp,fn):
    return tp / (1.0 * tp + fn)
def true_negative_rate(tn,fp):
    return tn / (1.0 * tn + fp)
def specificity(tn,fp):
    return true_negative_rate(tn,fp)
def false_positive_rate(fp,tn)
    return fp / (1.0*(fp + tn))
def accuracy(tp,tn,fp,fn):
    return tp + tn / (1.0 * tp + tn + fp + fn)
def true_positive_rate(tp,fn):
    return tp /(1.0 * ( tp + fn))
def sensitivity(tp,fn):
    return true_positive_rate(tp,fn)
def fmeasure(precision,recall):
    return 2.0 * (precision * recall) / (1.0 * (precision + recall))

def matthews_correlation(tp,tn,fp,fn):
    """ http://en.wikipedia.org/wiki/Matthews_correlation_coefficient """
    P = tp + fn
    N = fp + tn
    P1 = tp + fp
    N1 = fn + tn
    return (tp * tn - fp * fn)/sqrt(P*N*P1*N1)
    
def roc_area(tp,fn,fp,fn):
    """
    Area under ROC Curve. The curve is plotted by FPR X TPR
    We want the area under it
    |     ___----|
    |  p*=____t2_| p is the point of (FPR,TPR)
    |  /|        | 
    | / |  rect  |
    |/t1|_________
    area = area of t1 + area of t2 + area of rect
    
    """
    tpr = true_positive_rate(tp,fn)
    fpr = false_positive_rate(fp,tn)
    x = fpr
    y = tpr
    rect_area = (1.0 - x) * y
    triangle1_area = ( x * y  ) / 2.0
    triangle2_area = (1.0 - x)*(1.0 - y) / 2.0
    roc_a = rect_area + triangle1_area + triangle2_area
    return roc_a
    

def info_measures(tp,tn,fp,fn):
    pre = precision(tp,fp)
    rec = recall(tp,fn)
    acc = accuracy(tp,tn,fp,fn)
    f1 = fmeasure(pre,rec)
    tnr = true_negative_rate(tn,fp)
    mcc = matthews_correlation(tp,tn,fp,fn)
    roca = roc_area(tp,fn,fp,tn)
    out = {}
    out['precision'] = pre
    out['recall'] = rec
    out['accuracy'] = acc
    out['f1'] = f1
    out['tnr'] = tnr
    out['tn'] = tn
    out['tp'] = tp
    out['fn'] = fn
    out['fp'] = fp
    out['mcc'] = mcc
    out['roca'] = roca
    return out





