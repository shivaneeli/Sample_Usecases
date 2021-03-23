connection: "snowlooker"

label: " Sample Usecases"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#

explore: order_items {

  cancel_grouping_fields: [users.first_name]


  join: users {
    relationship: many_to_one
    type: inner
    sql_on: ${users.id} = ${order_items.user_id};;
  }
  join: inventory_items {
    relationship: many_to_one
    type: inner
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }
  join: customer_life_time_value {
    relationship: one_to_one
    type: inner
    sql_on: ${users.id} = ${customer_life_time_value.user_id} ;;
  }
  join: usercounts_by_signup_duration {
    relationship:one_to_one
    type: inner
    sql_on: ${usercounts_by_signup_duration.months_since_joined} =  ${users.months_since_joined};;
    }
  join: order_sequence {
    relationship: one_to_one
    type: left_outer
    sql_on: ${order_items.order_id} = ${order_sequence.order_id} and ${order_items.user_id} = ${order_sequence.user_id} ;;
  }
  }
