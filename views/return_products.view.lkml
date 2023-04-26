
view: return_products {
  sql_table_name: dbo.Return_Products ;;

  measure: sum_of_in_transit_glpii {
    type: sum
    sql: ${in_transit_glpii} ;;
    value_format_name: usd
  }

  measure: sum_of_return_glpii {
    type: sum
    sql: ${returns_glpii} ;;
    value_format_name: usd
  }

  measure: sum_of_total_glpii {
    type: number
    sql: ${sum_of_return_glpii}+${sum_of_in_transit_glpii} ;;
    value_format_name: usd
  }

  measure: sum_return_units {
    type: sum
    sql: ${returns_units} ;;
  }

  measure: sum_of_in_transit_unit {
    type: sum
    sql: ${in_transit_units} ;;
  }

  measure: total_return_units {
    type: number
    sql: ${sum_return_units}+${sum_of_in_transit_unit} ;;
  }

  measure: average_in_transit_glpii {
    type: average
    sql: ${in_transit_glpii} ;;
  }

  dimension: bu {
    type: string
    sql: ${TABLE}.BU ;;
  }

  dimension: product {
    type: string
    sql: case when ${bu}='Spine' or ${bu}='SPINE' then 'Spine'
              when ${bu}='Joint' or ${bu}='Joints' then 'Joints'
              else ${bu} end;;
  }

  dimension: cluster {
    type: string
    sql: ${TABLE}.Cluster ;;
  }

  dimension: destination {
    type: string
    sql: ${TABLE}.Destination ;;
  }

  dimension: destination_category {
    type: string
    sql: CASE WHEN ${TABLE}.Destination_Category = 'HUB' or ${TABLE}.Destination_Category = 'Hub' then 'Hub' else ${TABLE}.Destination_Category end ;;
  }

  dimension: flow_category {
    type: string
    sql: ${TABLE}.Flow_Category ;;
  }

  dimension: from_area {
    type: string
    sql: ${TABLE}.From_Area ;;
  }

  dimension: from_category {
    type: string
    sql: ${TABLE}.From_Category ;;
  }

  dimension: in_transit_glpii {
    type: number
    sql: ${TABLE}.InTransit_GLPII ;;
  }

  dimension: in_transit_units {
    type: number
    sql: ${TABLE}.InTransit_Units ;;
  }

  dimension: month {
    type: number
    sql: ${TABLE}.Month ;;
  }

  dimension: quarter {
    type: date_quarter
    sql: ${TABLE}.Quarter ;;
  }

  dimension: region_from {
    type: string
    sql: ${TABLE}.Region_From ;;
  }

  dimension: return_type {
    type: string
    sql: ${TABLE}.Return_Type ;;
  }

  dimension: new_return_type{
    type: string
    sql: case when ${return_type} = 'Not defined' and ${destination_category} = 'Field' then 'Pullback'
              when ${return_type} = 'Not defined' and ${destination_category} = 'Hub' or ${destination_category} = 'HUB' then 'Return'
              else ${return_type} end;;
  }

  dimension: returns_glpii {
    type: number
    sql: ${TABLE}.Returns_GLPII ;;
  }

  dimension: returns_std {
    type: number
    sql: ${TABLE}.Returns_Std ;;
  }

  dimension: returns_units {
    type: number
    sql: ${TABLE}.Returns_units ;;
  }

  dimension: sub_cluster {
    type: string
    sql: ${TABLE}.Sub_Cluster ;;
  }

  dimension: week {
    type: number
    sql: ${TABLE}.Week ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
