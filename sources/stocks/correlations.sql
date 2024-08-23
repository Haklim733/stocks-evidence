WITH eod AS (
    SELECT 
        open, high, low, close, volume, count, bid_size, bid_exchange, bid, ask_size, ask_exchange, ask,
        STRPTIME(CAST("date" AS CHAR(8)), '%Y%m%d') AS "date", symbol
    FROM stocks.eod
),
daily_returns AS (
    SELECT 
        symbol,
        date,
        (close - LAG(close) OVER (PARTITION BY symbol ORDER BY date)) / LAG(close) OVER (PARTITION BY symbol ORDER BY date) AS daily_return
    FROM eod
),
mean_returns AS (
    SELECT 
        symbol,
        AVG(daily_return) AS mean_return
    FROM daily_returns
    GROUP BY symbol
),
covariance AS (
    SELECT 
        dr1.symbol AS symbol1,
        dr2.symbol AS symbol2,
        AVG((dr1.daily_return - mr1.mean_return) * (dr2.daily_return - mr2.mean_return)) AS covar
    FROM daily_returns dr1
    JOIN daily_returns dr2 ON dr1.date = dr2.date
    JOIN mean_returns mr1 ON dr1.symbol = mr1.symbol
    JOIN mean_returns mr2 ON dr2.symbol = mr2.symbol
    GROUP BY dr1.symbol, dr2.symbol
),
variance AS (
    SELECT 
        symbol,
        AVG((daily_return - mean_return) * (daily_return - mean_return)) AS var
    FROM daily_returns
    JOIN mean_returns USING (symbol)
    GROUP BY symbol
),
correlation AS (
    SELECT 
        c.symbol1,
        c.symbol2,
        CAST(c.covar / SQRT(v1.var * v2.var) AS FLOAT) AS correlation
    FROM covariance c
    JOIN variance v1 ON c.symbol1 = v1.symbol
    JOIN variance v2 ON c.symbol2 = v2.symbol
    ORDER BY c.symbol1, c.symbol2
)
SELECT * FROM correlation where symbol1 != symbol2