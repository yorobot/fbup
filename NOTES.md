# Notes

## todos/fixes


- [ ] fix fifa country missing

```
{:name=>"Club Aurora",
 :long_name=>"Club Aurora Cochabamba",
 :country=>"Bolivien",
 :founded=>"27.05.1935",
 :ground=>"Félix Capriles"}
!! ERROR - no country found for Bolivien
```


- [ ] check austria, brazil, etc. for team ref with different names
- [ ] add copa.s (sudamerican)

```
  parsing aut-regionalliga-ost-2017-2018...  title=>Regionalliga Ost 2017/2018 » Spielplan<...
!! ASSERT ERROR - team ref with differet names; expected FC Karabakh Wien - got FC Mauerwerk

  parsing bra-serie-b-2011...  title=>Série B 2011 » Spielplan<...
!! ASSERT ERROR - team ref with differet names; expected Grêmio Prudente - got Grêmio Barueri SP
```



- [ ] add support for PAUSED match status in fbdat!!!

```
FINISHED  Sun Oct 06 2024 14:45         AFC Ajax (AJA) - FC Groningen (GRO)       8 - REGULAR_SEASON
  REGULAR                                     3-1 (1-0)
!!! assert failed - unknown status - PAUSED
```


