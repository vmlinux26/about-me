#!/usr/bin/python3

import random
import subprocess
import time

'''if you want to run this against only one computer to test out your ssh then
change the ADDRESSES to what you want to go against'''

names = ('Carol Adams\n', 'Fred Stewart\n', 'Frances Powell\n', 'Henry Barnes\n', 'George Wood\n', 'Bonnie Simmons\n', 'Helen Moore\n', 'Anne Ross\n', 'Robert Cook\n', 'Cheryl Robinson\n', 'Willie Gonzales\n', 'Donald Walker\n', 'Christina Edwards\n', 'Tammy Hall\n', 'Kathy Nelson\n', 'Shawn Lee\n', 'Billy Carter\n', 'Nicholas Harris\n', 'Marilyn Gray\n', 'Martha Rivera\n', 'David Flores\n', 'Andrea Jenkins\n', 'Thomas Kelly\n', 'Patricia Coleman\n', 'Doris Patterson\n', 'Alan Long\n', 'Albert Phillips\n', 'Willie Adams\n', 'Andrew Jackson\n', 'Jason Murphy\n', 'Benjamin Sanders\n', 'Harry Butler\n', 'Joan Henderson\n', 'Lisa Parker\n', 'Deborah Hernandez\n', 'Brian Johnson\n', 'Phyllis White\n', 'Peter Mitchell\n', 'Janice Green\n', 'Kathryn Clark\n', 'Elizabeth Wood\n', 'Joyce Edwards\n', 'Billy Flores\n', 'Anna Rodriguez\n', 'Robert Anderson\n', 'Eric Alexander\n', 'James Martin\n', 'Jose Martinez\n', 'Nicole Morris\n', 'Jessica Lopez\n')

Y = [i.split() for i in (line.rstrip() for line in names)]
random.shuffle(Y)
N = Y[:10]
A = Y[10:20]
M = Y[20:30]
E = Y[30:40]
S = Y[40:50]

First = (N[x][0] for x in range(len(N)))
first = (((A[x][0]).lower()) for x in range(len(A)))
First_Li = ((M[x][0])+(M[x][1][0]) for x in range(len(M)))
first_li = (((E[x][0])+(E[x][1][0])).lower() for x in range(len(E)))
First_Last = ((S[x][0])+(S[x][1]) for x in range(len(E)))

name_list = [list(First), list(first), list(First_Li), list(first_li),\
        list(First_Last)]
random.shuffle(name_list)

ADDRESSES = ['192.168.122.1']
#ADDRESSES = ['192.168.122.10', '192.168.122.15', '192.168.122.16',\
#        '192.168.122.25', '192.168.122.17', '192.168.122.11']
random.shuffle(ADDRESSES)

for x in range(5):
    for y in range(10):
        User = (LIST[x][y])
        Address = (ADDRESSES[x])
        subprocess.Popen(['ssh', '{0}@{1}'.format(User, Address)],
                shell=False)
        time.sleep(1)
