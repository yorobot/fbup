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


