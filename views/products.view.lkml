view: products {
  sql_table_name: "PUBLIC"."PRODUCTS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}."BRAND" ;;
  }

  dimension: link_url {
    type: string
    sql:'https://www.google.com/search?q=' ;;
  }

 parameter: color_choice {
   type: unquoted
   allowed_value: {
     label: "blue"
    value: "0000FF"
   }
  allowed_value: {
    label: "gray"
    value: "808080"

  }
 }

  dimension: linked_brand {
    type: string
    sql: ${TABLE}."BRAND" ;;
  #   html: <a href="https://www.google.com/search?q={{ value }}"> {{ linked_brand._value }} </a> ;;

    html:
    {% if {{value}} contains "American" %}
    <div style="background-color: #{{color_choice._parameter_value}}"> <a href="{{link_url._value}}{{ value }}"; target="_blank";> {{ value }} </a> </div>
    {% else %}
    <div > <a href="{{link_url._value}}{{ value }}"; target="_blank";> {{ value }} </a> </div>
    {% endif %};;
  }



  dimension: category {
    type: string
    sql: ${TABLE}."CATEGORY" ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}."COST" ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}."DEPARTMENT" ;;
  }

  dimension: distribution_center_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."DISTRIBUTION_CENTER_ID" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}."RETAIL_PRICE" ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}."SKU" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, distribution_centers.name, distribution_centers.id, inventory_items.count]
  }
}
