# Hogia Business Manager Reporting Script

Shell script for reporting to Hogia Business Manager

```
./hogia.sh --email=<email> --password=<password> --event_id=1 \
    [--start_date=2018-03-01] [--end_date=2018-03-31] [--verbose]
```

## Events
Event ID | Description
--|--
1|Tidrapport klar (1)
2|Betald semester Tjm (510)
3|Sjukdom månadsavlönad Tjm (600)
4|Sjukdom hel månad Tjm (612)
5|Tjänstledighetsdagar (620)
6|Tjänstledig hel månad Tjm (622)
7|Tillf vård av barn Tjm (655)
8|Pappadagar (658)
9|Uttag av föräldradagar (660)
10|Föräldraledig hel mån Tjm (662)
