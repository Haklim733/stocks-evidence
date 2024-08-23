WITH eod AS (
    SELECT 
        open, high, low, close, volume, count, bid_size, bid_exchange, bid, ask_size, ask_exchange, ask,
        STRPTIME(CAST("date" AS CHAR(8)), '%Y%m%d') AS "date", symbol
    FROM stocks.eod
),
change AS (
    SELECT 
        symbol,
        date,
        close,
        LAG(close) OVER (PARTITION BY symbol ORDER BY date) AS previous_close
    FROM eod
)
SELECT  
    symbol,
    date,
    close, 
    previous_close,
    CAST((close - previous_close) / previous_close AS DECIMAL(10, 5)) AS pct_change
from change 
WHERE previous_close IS NOT NULL
order by symbol, date asc