#!/usr/bin/python
import psycopg2
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
import math

"""
This is a python code for problem 5.
Histogram of number of publications, histogram of number of collaborators.
According to the graph, both seem log y propotional to 1/x.
"""

def main():
	try:
	    conn = psycopg2.connect("dbname='dblp' user='postgres' host='localhost' password='db544'")
	except psycopg2.Error, e:
	    print e
	    print "I am unable to connect to the database"

	cur = conn.cursor()

	# Fetch Coauthor number frequency
	queries = {
	'number of collaborators' : "with CoAuthor as (select a1.id as id1, a2.id as id2 " \
			"from Authored a1 inner join Authored a2 on a1.pubid = a2.pubid " \
			"where not a1.id = a2.id) " \
		"select num, count(*) " \
		"from (select id1, count(*) as num from CoAuthor group by id1) as CollaboNum " \
		"group by num order by num;",
	'number of publications' : "select num, count(*) " \
		"from (select id, count(*) as num from Authored group by id) as PubNum " \
		"group by num order by num;"
	}
	
	plt.figure()

	for i, (name, query) in enumerate(queries.items()):
	    cur.execute(query)
	    rows = cur.fetchall()

	    x = [row[0] for row in rows]
	    log_y = [math.log(row[1]) for row in rows]

	    plt.subplot(211 + i)
	    plt.plot(x, log_y)
	    plt.title(name+' (log scale)')
	    plt.xlabel(name.lower())
	    plt.ylabel('log number of corresponding authors')

	fileName = 'graph.pdf'
	plt.savefig(fileName)
	print "Save histogram as %s" %(fileName)

if __name__ == "__main__":
	main()


