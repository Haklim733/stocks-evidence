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
<p style="font-size: 14px;">
{symbols[0].symbol} belongs in the {stock_desc[0].sector} sector of the {stock_desc[0].industry}. The last known market capitalization was {fmt(stock_desc[0].marketcap, '$#,##0.0,,,"B"')} with a current stock price of {fmt(stock_desc[0].current_price, '$#,##1') }. The company has an EBITDA of {fmt(stock_desc[0].ebitda, '$#,##0.0,,,"B"')} and a revenue growth of {fmt(stock_desc[0].revenue_growth, 'pct1')}.</p> 

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

<DataTable data={filtered_query}> 
  <Column id=open/> 
	<Column id=high/> 
	<Column id=low/> 
	<Column id=close/> 
	<Column id=volume/> 
	<Column id=bid_size/> 
	<Column id=bid/> 
	<Column id=ask_size/> 
	<Column id=ask/> 
	<Column id=date/> 
</DataTable>

<LineChart
    data={filtered_query}
    x=date
    y=close
/>

## What's Next?
- Deploy your project with [Evidence Cloud](https://evidence.dev/cloud)