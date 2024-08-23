---
title: End of Day Stocks Page
---

<Details title='Explore Stocks End of Day Information'>
  This page utitlizes end of day stock information from ThetaData
</Details>

```sql symbols 
  select
     symbol 
  from stocks
```

<Dropdown data={symbols} name=ticker value=symbol title="select a ticker" defaultValue="AAPL">
</Dropdown>

```sql stock_desc
  select
    exchange, long_name, sector, industry, current_price, marketcap, ebitda, revenue_growth,
    "description", "weight"
  from stocks
  where symbol = '${inputs.ticker.value}'
```

## Description
<!-- <p style="font-size: 14px;"> -->
{inputs.ticker.value} belongs in the {stock_desc[0].sector} sector of the {stock_desc[0].industry}. The last known market capitalization was {fmt(stock_desc[0].marketcap, '$#,##0.0,,,"B"')} with a current stock price of {fmt(stock_desc[0].current_price, '$#,##1') }. The company has an EBITDA of {fmt(stock_desc[0].ebitda, '$#,##0.0,,,"B"')} and a revenue growth of {fmt(stock_desc[0].revenue_growth, 'pct1')}.

<Accordion>
  <AccordionItem title="Company Description">
    <p style="font-size: 14px;"> {stock_desc[0].description}</p>
  </AccordionItem>
</Accordion>


## End of Day Stock Price
```sql eod 
  select 
   open,high,low,close,volume,count, bid_size,bid_exchange,bid,ask_size,ask_exchange,ask,
    symbol, date 
  from eod
  where symbol = '${inputs.ticker.value}'
```

```sql dates
select 
    distinct(date) as date
from eod
where symbol = '${inputs.ticker.value}'
```
<DateRange
    name=range_filtering_a_query
    data={dates}
    dates=date
/>

```sql filtered_query
select 
    *
from eod
where date between '${inputs.range_filtering_a_query.start}' and '${inputs.range_filtering_a_query.end}'
AND symbol = '${inputs.ticker.value}'
```

```sql priceDelta
WITH first_last AS (
    SELECT 
        date,
        close,
        FIRST_VALUE(close) OVER (PARTITION BY symbol ORDER BY date) AS first_close,
        LAST_VALUE(close) OVER (PARTITION BY symbol ORDER BY date) AS last_close
    FROM eod
    WHERE symbol = '${inputs.ticker.value}'
    AND date between '${inputs.range_filtering_a_query.start}' and '${inputs.range_filtering_a_query.end}'
)
SELECT 
    last_close,
    first_close,
    CAST((last_close - first_close) / first_close AS DECIMAL(10, 5)) AS pct_change
from first_last
order by date desc
LIMIT 1
```
### Price Change Over the Selected Period
<Delta data={priceDelta} column=pct_change fmt=pct1 />

<LineChart
    data={filtered_query}
    x=date
    y=close
/>

<DataTable data={filtered_query}> 
  <Column id=open fmt='$#,##0.00' /> 
	<Column id=high fmt='$#,##0.00'/> 
	<Column id=low fmt='$#,##0.00'/> 
	<Column id=close fmt='$#,##0.00'/> 
	<Column id=volume/> 
	<Column id=bid_size/> 
	<Column id=bid fmt='$#,##0.00'/> 
	<Column id=ask_size/> 
	<Column id=ask fmt='$#,##0.00'/> 
	<Column id=date/> 
</DataTable>

### Price Change Comparison Over the Selected Period
#### Select a Peer(s)
<Dropdown
    data={symbols} 
    name=peers
    value=symbol
    title="Select peers"
    multiple=true
    selectAllByDefault=false
/>

```sql priceDeltaPeers
SELECT * FROM pct_change
WHERE symbol = '${inputs.ticker.value}' OR symbol IN ${inputs.peers.value}
  AND date between '${inputs.range_filtering_a_query.start}' and '${inputs.range_filtering_a_query.end}'
```
<LineChart 
    data={priceDeltaPeers}
    x=date
    y=pct_change 
    yFmt='#,##0.0%'
    yAxisTitle="Percent Change over Period"
    series=symbol
/>