

# If necessary, uncomment the line below to include explore_source.
# include: "Sample_Usecases.model.lkml"

  view: customer_life_time_value {
    derived_table: {
      explore_source: order_items {
        column: user_id {}
        column: lifetime_order_count {
          field:  order_items.order_count
        }
        column:  lifetime_Items{
          field: order_items.count
        }
        column: lifetime_revenue {
          field: order_items.total_gross_revenue
        }
        column: first_order_date {}
        column: latest_order_date {}
        derived_column: average_customer_order{
          sql: lifetime_revenue/ lifetime_order_count ;;
        }
      }
    }

    dimension: user_id {
      primary_key: yes
      type: number
    }
    dimension: lifetime_items {
      type:  number
    }
    dimension: lifetime_order_count {
      type: number
    }

    dimension: lifetime_revenue {
    type: number
  #  value_format_name: usd
      }
    dimension: first_order_date {
    type: date
    }
    dimension: latest_order_date {
    type: date
  }

    dimension: lifetime_revenue_tier {
      alpha_sort: yes

      case: {
        when: {
          sql: ${lifetime_revenue} < 5 ;;
          label: "$0.00 - $4.99"
        }
        when: {
          sql: ${lifetime_revenue} >= 5 and ${lifetime_revenue} <  20;;
          label: "$5.00 - $19.99"
        }
        when: {
          sql: ${lifetime_revenue} >= 20 and ${lifetime_revenue} <  50;;
          label: "$5.00 - $19.99sf"
        }
        when: {
          sql: ${lifetime_revenue} >= 50 and ${lifetime_revenue} <  100;;
          label: "$50.00 - $99.99"
        }
        when: {
          sql: ${lifetime_revenue} >= 100 and ${lifetime_revenue} <  500;;
          label: "$100.00 - $499.99"
        }
        when: {
          sql: ${lifetime_revenue} >= 500 and ${lifetime_revenue} <  1000;;
          label: "$500.00 - $999.99"
        }
        when: {
          sql: ${lifetime_revenue} >= 1000.00;;
          label: "$1000.00 +"
        }
        else:"Unknown"
      }
      }

      dimension:  order_tier{
      type: tier
      style: integer
      tiers: [1,2,3,5,7,10]
      sql: ${lifetime_order_count} ;;
    }

    # dimension: revenue_tier {
    #   type: tier
    #   style: integer
    #   tiers: [0,5,20,50,100,500,1000]
    #   sql: ${lifetime_revenue} ;;
    #   value_format: "$#,##0"
    # }

    dimension: is_active {
      type: yesno
      sql: datediff(day,${latest_order_date},current_date) <= 90  ;;
    }

    dimension: is_repeat {
      type: yesno
      sql: ${lifetime_order_count} > 1 ;;
    }
    dimension: days_since_last_order {
      type: number
      sql: datediff(day, ${latest_order_date},current_date)  ;;
    }


    measure: user_count {
      type: count_distinct
      sql: ${user_id} ;;
    }

    measure: average_lifetime_orders {
      type: average
      sql: ${lifetime_order_count} ;;
    }

    measure: average_lifetime_revenue {
      type: average
      sql: ${lifetime_revenue} ;;
    }

    measure: avg_days_since_last_order {
      type: average
      sql:  ${days_since_last_order};;
    }
}
