view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_sale_price {
    type: sum
    description: "Total sales from items sold"
    sql: ${sale_price} ;;
  }

  measure: average_sale_price {
    type: average
    description: "Average sales from items sold"
    sql: ${sale_price} ;;
  }

  measure: cumulative_total_sales {
    type: number
    description: "Cumulative Total Sales"
    sql: ${sale_price} ;;

    #running_total(${sale_price})+ coalesce(sum(pivot_offset_list((offset_list(${sale_price},1-row(),max(row())),1-pivot_column(),pivot_column()-1)),0);;

  }

  measure: total_gross_revenue {
    type: sum
    description: "Total Gross Revenue"
    sql: case when ${status} not in ('Cancelled', 'Returned') then ${sale_price} end;;
    value_format_name: usd
  }

  measure: total_gross_margin_amount{
    type: sum
    description: "Total difference between the total revenue from completed sales and the cost of the goods that were sold"
    sql: (${sale_price} - ${inventory_items.cost})  ;;
  }
  measure: average_gross_margin {
    type: average
    sql: ${sale_price} - ${inventory_items.cost} ;;
  }

  measure: gross_margin_percent {
    type: number
    sql: ${total_gross_margin_amount}/nullif(${total_gross_revenue},0) ;;
  }

  measure: number_of_items_returned {
    type: number
    description: "Number of items that were returned by dissatisfied customers"
    sql: case when ${status} in ('Returned') then ${count} end;  ;;
  }

  measure: item_return_rate {
    type: number
    description: "Number of Items Returned / total number of items sold"
    sql: ${number_of_items_returned}/nullif(${count},0) ;;
  }

  measure: number_of_customers_returning_items {
    type: count_distinct
    description: "Number of users who have returned an item at some point"
    sql: case when ${status} in ('Returned') then ${user_id} end;;
  }

  measure: percent_of_users_with_returns {
    type: number
    description: "Number of Customer Returning Items / total number of customers"
    sql: ${number_of_customers_returning_items}/nullif(${users.count},0) ;;
  }

  measure: average_spend_per_customer {
    type: number
    description: "Total Sale Price / total number of customers"
    sql: ${total_sale_price}/nullif(${users.count},0) ;;
  }

   measure: order_count  {
     type: count_distinct
    description: "Disctinct Order Count"
    sql: ${order_id} ;;
   }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.first_name,
      users.last_name,
      users.id,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
