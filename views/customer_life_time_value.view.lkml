

# If necessary, uncomment the line below to include explore_source.
# include: "Sample_Usecases.model.lkml"

  view: customer_life_time_value {
    derived_table: {
      explore_source: order_items {
        column: user_id {}
        column: count {}
        column: order_count {}
      }
    }
    dimension: user_id {
      type: number
    }
    dimension: lifetime_items {
      type: number
      sql: ${TABLE}.count ;;
    }
    dimension: lifetime_order_count {
      description: "Disctinct Order Count"
      type: number
      sql: ${TABLE}.order_count ;;
    }
  }
