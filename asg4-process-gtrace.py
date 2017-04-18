#!/usr/bin/env python

from mpi4py import MPI
import os
import gzip
import numpy
import sys

finished = 0
idList = []
fileList = []
mainList = []
#taskList = []
main_dict = {}
ESPNTop20 = []
APTop20 = []
topJobs = []


def insertAPTop20(data):
    if len(APTop20) < 20:
        APTop20.append(data)
        APTop20.sort(key=lambda l:l[1], reverse=True)
    else:
        if data[1] > APTop20[19][1]:
            del APTop20[19]
            APTop20.append(data)
            APTop20.sort(key=lambda l:l[1], reverse=True)
        else: pass



def parse_tarfile(fname):
#for filename in os.listdir(path):
    with gzip.open(fname, 'rt') as fin:
        for line in fin:
            fields = line.strip().split(',')
            #print(fields)
            if fields[2] not in idList:
                idList.append(fields[2])
            mainList.append([fields[2],fields[0], int(fields[3])])

def parse_taskFile(fname):
    with gzip.open(fname, 'rt') as fin:
        for line in fin:
            fields = line.strip().split(',')
            #print(fields)
            if fields[2] in topJobs:
                for entry in ESPNTop20:
                    if entry[0] == fields[2]:
                        entry[3] = entry[3] + 1
            insertAPTop20([fields[2], float( fields[5]) * 300.0, 0])
            #taskList.append( [fields[2], float( fields[5]) * 300.0 ] )


def unique_list(somelist):
    temp = set()
    for item in somelist:
        if item in temp:
            return False
        temp.add(item)
    return True

def merge_list(somelist):
    temp = set()
    for item in somelist:
        if item not in temp:
            temp.add(item)
    return(temp)


def create_main_dict(mainList):

    for i in mainList:
        if i[0] not in main_dict:
            main_dict[i[0]] = {}
            main_dict[i[0]][i[2]] = [i[1]]
        elif i[2] not in main_dict[i[0]]:
            main_dict[i[0]][i[2]] = [i[1]]
        else:
            main_dict[i[0]][i[2]].append(i[1])


def insertTop20(data):
    if len(ESPNTop20) < 20:
        ESPNTop20.append(data)
        ESPNTop20.sort(key=lambda l:l[1], reverse=True)
    else:
        if data[1] > ESPNTop20[19][1]:
            del ESPNTop20[19]
            ESPNTop20.append(data)
            ESPNTop20.sort(key=lambda l:l[1], reverse=True)
        else: pass



comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()
root = 0


data = []
path = "/scratch3/ggettin/asg4/job_events"
for filename in os.listdir(path):
    data.append(os.path.join(path,filename))

for i,gzfile in enumerate(data):
    if i%size!=rank: continue
    parse_tarfile(gzfile)


l = comm.gather(idList, root=0)
if l is not None:
    for n in l:
        for x in n:
            idList.append(x)
idList = merge_list(idList)

ll = comm.gather(mainList, root=0)
if ll is not None:
    for nn in ll:
        for xx in nn:
            mainList.append(xx)


if rank == 0:
    pass
else:
    idList = []

comm.barrier()

if rank == 0:
    create_main_dict(mainList)

"""
    Array of size 20 contains jobID, runtime and eventType



    For each unique job id, (idList)
        calculate the time (using dictionary indexed by idList):
            if 0 or 300, ignore
             if among 20 longest, throw all data in array


"""
l = comm.gather(idList, root=0)
ll = comm.gather(mainList, root=0)
lll = comm.gather(main_dict, root=0)
op = -1
op2 = -1
for job in idList:
    for eventType in main_dict[job]:
        if eventType == 0:
            op = int(main_dict[job][eventType][0])
            #print(op)
        elif eventType >= 2 or eventType <= 6:
            op2 = int(main_dict[job][eventType][0])
            #print(op2)
            newEvent = eventType
    if op == 0 or op == sys.maxsize or op2 == 0 or op2 == sys.maxsize:
        continue
    else:
        convTime = op2 - op
        insertTop20([job, convTime, newEvent, 0])
    continue


comm.barrier()

v = comm.gather(ESPNTop20, root=0)

if rank == 0:
    for entry in ESPNTop20:
        topJobs.append(entry[0])


vl = comm.gather(topJobs, root = 0)


path2 = "/scratch3/ggettin/asg4/task_usage"
data2 = []

for filename in os.listdir(path2):
    data2.append(os.path.join(path2,filename))

for i,gzfile in enumerate(data2):
    if i%size!=rank: continue
    parse_taskFile(gzfile)


lv = comm.gather(APTop20, root=0)


if rank == 0:

    APTop20.sort(key=lambda l:l[1], reverse=True)

    for i in range(0, 20):
        for eventType in main_dict[APTop20[i][0]]:
            if eventType >= 2 and eventType <= 6:
                if eventType > APTop20[i][2]:
                    APTop20[i][2] = eventType


if rank == 0:
    print("\n")

    print("JobID\t\tTime\t\t\tEvent\tCount")
    for i in range(0,20):
        print("%s\t%s\t\t%s\t%s"%(ESPNTop20[i][0], ESPNTop20[i][1], ESPNTop20[i][2], ESPNTop20[i][3]))


    print("\n")

    print("JobID\t\tCPUTime\t\tFinalStat")
    for i in range(0,20):
        if APTop20[i][2] == 0:
            print("%s\t%.1f\t\t%s"%(APTop20[i][0], APTop20[i][1], "None"))
        else:
            print("%s\t%.1f\t\t%s"%(APTop20[i][0], APTop20[i][1], APTop20[i][2]))

comm.barrier()

if rank == 0:
    print("\nExecution Time:")
