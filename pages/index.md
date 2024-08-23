---
title: Welcome to Evidence
---

<Details title='How to edit this page'>

  This page can be found in your project at `/pages/index.md`. Make a change to the markdown file and save it to see the change take effect in your browser.
</Details>

```sql symbols 
  select
     symbol 
  from stocks.tickers
```

<Dropdown data={symbol} name=ticker value=symbol>
    <DropdownOption value="%" valueLabel="All Stocks"/>
</Dropdown>

<Dropdown name=year>
    <DropdownOption value=% valueLabel="All Years"/>
    <DropdownOption value=2020/>
    <DropdownOption value=2021/>
    <DropdownOption value=2022/>
    <DropdownOption value=2023/>
    <DropdownOption value=2024/>
</Dropdown>

```sql orders_by_category
  select 
      date_trunc('month', date) as month,
  from stocks.eod
  where symbol like '${inputs.ticker.value}'
  and date_part('year', date) like '${inputs.year.value}'
```

<!-- <BarChart
    data={orders_by_category}
    title="Sales by Month, {inputs.category.label}"
    x=month
    y=sales_usd
    series=category
/> -->

## What's Next?
- [Connect your data sources](settings)
- Edit/add markdown files in the `pages` folder
- Deploy your project with [Evidence Cloud](https://evidence.dev/cloud)

## Get Support
- Message us on [Slack](https://slack.evidence.dev/)
- Read the [Docs](https://docs.evidence.dev/)
- Open an issue on [Github](https://github.com/evidence-dev/evidence)
