

 view: order_sequence {
#   # Or, you could make this view a derived table, like this:
   derived_table: {
     sql: select user_id, order_id, created_at, count(id) item_count,
          row_number() over (partition by User_ID Order by created_at asc) order_sequence_number,
          lead(created_at) over (partition by User_ID Order by created_at asc) next_order_created_at
          from ORDER_ITEMS
            group by 1,2,3 ;;
   }

   # Define your dimensions and measures here, like this:
  dimension: user_id {
    description: "Unique ID for each user that has ordered"
    type: number
    sql: ${TABLE}.user_id ;;
   }

  dimension: order_id {
    description: "Unique ID for each user that has ordered"
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension:  order_sequence_number{
    type: number
    sql: ${TABLE}.order_sequence_number ;;
  }

  dimension: days_between_orders {
    type: number
    sql: datediff(day, ${TABLE}.created_at, ${TABLE}.next_order_created_at ) ;;
  }

  dimension: is_first_purchase_dt {
    type: yesno
    sql:  ${order_sequence_number} =1  ;;
  }

  dimension: has_subsequent_order {
    type: yesno
    sql: ${TABLE}.next_order_created_at is not null ;;
  }
  measure: average_days_between_orders {
    type: average
    sql: ${days_between_orders} ;;
  }

}
