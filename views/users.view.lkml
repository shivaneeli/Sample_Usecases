view: users {
  sql_table_name: "PUBLIC"."USERS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}."AGE" ;;
  }
  dimension: age_group {
    type: tier
    tiers: [15,26,36,51,65]
    style: integer
    sql: ${age} ;;
  }
  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      day_of_month,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }
  dimension: is_mtd {
    type: yesno
    sql: extract(day from ${created_raw})<= extract(day from CURRENT_DATE)  ;;
  }
  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: first_name {
    type: string
    sql: initcap(${TABLE}."FIRST_NAME") ;;
  }

  dimension: gender {
    type: string
    sql: initcap(${TABLE}."GENDER") ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."LAST_NAME" ;;
  }

  dimension: full_name {
    type: string
    sql: ${first_name}||' '||${last_name} ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}."LATITUDE" ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}."LONGITUDE" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}."TRAFFIC_SOURCE" ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}."ZIP" ;;
  }

  dimension_group: since_signup {
    type: duration
    intervals: [day,month,year]
    sql_start: ${users.created_date}  ;;
    sql_end: current_date ;;
  }

  dimension: months_since_joined {
    type: number
    sql: datediff(month, ${created_date}, current_date) ;;
  }

measure: average_days_since_signup {
  type: average
  sql: ${days_since_signup} ;;

 }
# measure: months_since_signup {
#   type: average
#   sql: ${months_since_signup} ;;
# }
  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }
}
