#!/usr/bin/python2.7
#
# Assignment2 Interface
#

import psycopg2
import os
import sys
# Donot close the connection inside this file i.e. do not perform openconnection.close()

def RangeQuery(ratingsTableName, ratingMinValue, ratingMaxValue, openconnection):
    output = []
    cursor = openconnection.cursor()

    # query : range tables

    query_partition = '''SELECT partitionnum FROM rangeratingsmetadata WHERE maxrating>={0} AND minrating<={1};'''.format(ratingMinValue, ratingMaxValue)
    cursor.execute(query_partition)
    partitions = cursor.fetchall()
    partitions = [partition[0] for partition in partitions]

    query_range_select = '''SELECT * FROM rangeratingspart{0} WHERE rating>={1} and rating<={2};'''
    for partition in partitions:
        cursor.execute(query_range_select.format(partition, ratingMinValue, ratingMaxValue))
        sql_output = cursor.fetchall()

        for q in sql_output:
            q = list(q)
            q.insert(0, 'RangeRatingsPart{}'.format(partition))
            output.append(q)
    
    # query : round robin

    query_round_robin_count = '''SELECT partitionnum FROM roundrobinratingsmetadata;'''
    cursor.execute(query_round_robin_count)
    round_robin_partitions = cursor.fetchall()[0][0]

    query_round_robin_select = '''SELECT * FROM roundrobinratingspart{0} WHERE rating>={1} and rating<={2};'''

    for partition in xrange(0, round_robin_partitions):
        cursor.execute(query_round_robin_select.format(partition, ratingMinValue, ratingMaxValue))
        sql_output = cursor.fetchall()

        for q in sql_output:
            q = list(q)
            q.insert(0, 'RoundRobinRatingsPart{}'.format(partition))
            output.append(q)

    writeToFile('RangeQueryOut.txt', output)
        

def PointQuery(ratingsTableName, ratingValue, openconnection):
    range_output = []
    round_robin_output = []
    c = openconnection.cursor()

    c.execute("SELECT COUNT(*) FROM RangeRatingsMetadata;")
    partitions = c.fetchone()[0]

    
    for item in range(partitions):
        c.execute("SELECT 'RangeRatingsPart" + str(
            item) + "' AS PartitionNum, UserID, MovieID, Rating FROM RangeRatingsPart" + str(item) +
                  " WHERE Rating=" + str(ratingValue) + ";")
        for i in c.fetchall():
            range_output.append(i)

    c.execute("SELECT PartitionNum FROM RoundRobinRatingsMetadata;")
    partitions = c.fetchone()[0]

    for item in range(partitions):
        c.execute("SELECT 'RoundRobinRatingsPart" + str(item) + "' AS PartitionNum, UserID, MovieID, Rating FROM RoundRobinRatingsPart" + str(item) +
                  " WHERE Rating=" + str(ratingValue) + ";")
        for i in c.fetchall():
            round_robin_output.append(i)

    if os.path.exists('PointQueryOut.txt'):
        os.remove('PointQueryOut.txt')
    writeToFile('PointQueryOut.txt', range_output + round_robin_output)


def writeToFile(filename, rows):
    f = open(filename, 'w')
    for line in rows:
        f.write(','.join(str(s) for s in line))
        f.write('\n')
    f.close()
