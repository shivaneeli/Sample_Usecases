
    view: usercounts_by_signup_duration {

    derived_table: {
sql: SELECT
  datediff(month, (TO_CHAR(TO_DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', CAST(users."CREATED_AT"  AS TIMESTAMP_NTZ))), 'YYYY-MM-DD')), current_date)  AS months_since_joined,
  COUNT(DISTINCT users."ID" ) AS user_count
FROM  "PUBLIC"."USERS"
GROUP BY 1 ;;

     }

    dimension: months_since_joined {
      type: number
      primary_key:  yes
    }
    dimension: user_count {
      type: number
    }
  }
