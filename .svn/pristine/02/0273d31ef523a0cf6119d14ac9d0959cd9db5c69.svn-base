import numpy as np

def get_slope_from_points(p,x=[1,2,3],point=-1, degree = 2):
    assert(len(p)>=3)
    y=[]
    nb_data = len(x)
    for i in range(0, nb_data):
        y.append(p[-nb_data+i])
    a,b,c=np.polyfit(x,y,degree)
    return a*2*x[point]+b


if __name__ == "__main__":
    print get_slope_from_points([2,8,18])