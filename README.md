# (Datafiles) Update Notes


##  Top Clubs (11) via fbdat

leagues incl:
- eng.1, eng.2  2024/25
- es.1   2024/25
- fr.1   2024/25
- it.1   2024/25
- de.1   2024/25
- nl.1   2024/25
- pt.1   2024/25
- uefa.cl   2024/25
- br.1   2024
- copa.l  2024


Step 1 - Get Match Data via fbdat (api)

    $ fbdat -f fbdat_clubs.csv


Optional Step 2.a - Try (test) generate Football.TXT

    $ fbgen -f fbdat_clubs.csv



Step 2 - Generate Football.TXT datafiles and sync / update online

    $ fbup -f fbdat_clubs.csv --push

or use the built-in (local) version

    $ ruby -I fbup/lib fbup/bin/fbup -f fbdat_clubs.csv --push



---

##  World & Co via wfb


**World**

Step 1 - Get match data

    $ wfbsync -f world.csv

Step 2 - Generate Football.TXT datafiles and sync / update online

    $ fbup -f world.csv --v2 --flat

or use the local version 

    $ ruby -I fbup/lib fbup/bin/fbup -f world.csv --v2 --flat 


Note - use `v2` option for the new match schedule format and
`flat` for the "flat" naming convetion for file names 
(the season gets encoded in the basename NOT in a directory)
e.g. `./2024-25/at1.txt`  => `./2024-25_at1.txt`.





