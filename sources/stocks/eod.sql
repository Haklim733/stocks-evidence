select open,high,low,close,volume,count, bid_size,bid_exchange,bid,ask_size,ask_exchange,ask,
STRPTIME(CAST("date" AS CHAR(8)), '%Y%m%d') AS "date", symbol  from stocks.eod order by symbol