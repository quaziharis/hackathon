
view: return_products {
  sql_table_name: dbo.Return_Product_Analysis ;;

    parameter: Metrics {
      type: unquoted
      allowed_value: {
        label: "Units"
        value: "Units"
      }


      allowed_value: {
        label: "Cost ($)"
        value: "Dollar_Cost"
      }
      default_value: "Units"
    }


  measure: dynamic_measure {
    label_from_parameter: Metrics
    value_format: "0.000,,\" M\""
    type: number
    sql: {% if Metrics._parameter_value == 'Units' %}
            ${total_return_units}
         {% else %}
            ${sum_of_total_glpii}
         {% endif %};;
    drill_fields: [product,from_area,from_category,flow_category,destination_category,new_return_type,sum_return_units,sum_of_return_glpii,sum_of_in_transit_unit,sum_of_in_transit_glpii]
 }

  measure: dynamic_measure_1 {
    label_from_parameter: Metrics
    value_format: "0.000,,\" M\""
    type: number
    sql: {% if Metrics._parameter_value == 'Units' %}
            ${total_return_units}
         {% else %}
            ${sum_of_total_glpii}
         {% endif %};;
    drill_fields: [product,from_area,from_category,flow_category,destination_category,new_return_type,sum_return_units,sum_of_return_glpii,sum_of_in_transit_unit,sum_of_in_transit_glpii]
  }

  measure: dynamic_measure_2 {
    label_from_parameter: Metrics
    value_format: "0.000,,\" M\""
    type: number
    sql: {% if Metrics._parameter_value == 'Units' %}
            ${total_return_units}
         {% else %}
            ${sum_of_total_glpii}
         {% endif %};;
    drill_fields: [product,from_area,from_category,flow_category,destination_category,new_return_type,sum_return_units,sum_of_return_glpii,sum_of_in_transit_unit,sum_of_in_transit_glpii]
  }


  measure: sum_of_in_transit_glpii {
    label: "In-transist GLPII Amount"
    type: sum
    sql: ${in_transit_glpii} ;;
    drill_fields: [product,from_area,from_category,flow_category,destination_category,new_return_type,sum_return_units,sum_of_return_glpii,sum_of_in_transit_unit,sum_of_in_transit_glpii]
     value_format: "$0.000,,\" M\""
  }

  measure: sum_of_return_glpii {
    label: "Return GLPII Amount"
    type: sum
    sql: ${returns_glpii} ;;
    drill_fields: [product,from_area,from_category,flow_category,destination_category,new_return_type,sum_return_units,sum_of_return_glpii,sum_of_in_transit_unit,sum_of_in_transit_glpii]
     value_format: "$0.000,,\" M\""
  }

  measure: sum_of_total_glpii {
    label: "Total Return Amount"
    type: number
    sql: ${sum_of_return_glpii}+${sum_of_in_transit_glpii} ;;
    # value_format: "$0.000,,\" M\""
    drill_fields: [product,from_area,from_category,flow_category,destination_category,new_return_type,sum_return_units,sum_of_return_glpii,sum_of_in_transit_unit,sum_of_in_transit_glpii]
    value_format: "$0.000,,\" M\""

  }

  measure: sum_return_units {
    type: sum
    sql: ${returns_units} ;;
    # value_format: "0.000,,\" M\""
    drill_fields: [product,from_area,from_category,flow_category,destination_category,new_return_type,sum_return_units,sum_of_return_glpii,sum_of_in_transit_unit,sum_of_in_transit_glpii]
    value_format: "0.000,,\" M\""
  }

  measure: sum_of_in_transit_unit {
    type: sum
    sql: ${in_transit_units} ;;
    # value_format: "0.000,,\" M\""
    drill_fields: [product,from_area,from_category,flow_category,destination_category,new_return_type,sum_return_units,sum_of_return_glpii,sum_of_in_transit_unit,sum_of_in_transit_glpii]
    value_format: "0.000,,\" M\""
  }

  measure: total_return_units {
    type: number
    sql: ${sum_return_units}+${sum_of_in_transit_unit} ;;
    # value_format: "0.000,,\" M\""
    drill_fields: [product,from_area,from_category,flow_category,destination_category,new_return_type,sum_return_units,sum_of_return_glpii,sum_of_in_transit_unit,sum_of_in_transit_glpii]
    value_format: "0.000,,\" M\""

  }

  measure: average_in_transit_glpii {
    type: average
    sql: ${in_transit_glpii} ;;
    drill_fields: [product,from_area,from_category,flow_category,destination_category,new_return_type,sum_return_units,sum_of_return_glpii,sum_of_in_transit_unit,sum_of_in_transit_glpii]
  }

  measure: average_total_amount {
    type: average
    sql: ${returns_glpii}+${in_transit_glpii} ;;
    drill_fields: [product,from_area,from_category,flow_category,destination_category,new_return_type,sum_return_units,sum_of_return_glpii,sum_of_in_transit_unit,sum_of_in_transit_glpii]
  }

  dimension_group: date {
    type: time
    sql:
        DATEADD(wk, ${week}, DATEFROMPARTS(2021, 12, 1))
  ;;
  }

  dimension_group: Return {
    type: time
    sql: DATEADD(mm, ${month}, DATEFROMPARTS(2021, 12, 1))
  ;;
  }

  dimension: source_WH {
    type: string
    sql: case when ${flow_category} like '%->%' then
                    (LEFT(${flow_category}, CHARINDEX(' -> ', ${flow_category})))
              when ${flow_category} like '%-%' then
                    (LEFT(${flow_category}, CHARINDEX(' - ', ${flow_category})))
              else ${flow_category} end;;

  }

  dimension: destination_WH {
    type: string
    sql: case when ${flow_category} like '%->%' then
                    (RIGHT(${flow_category}, LEN(${flow_category}) - CHARINDEX(' -> ', ${flow_category})-3))
              when ${flow_category} like '%- %' then
                   (RIGHT(${flow_category},LEN(${flow_category}) -  CHARINDEX(' - ', ${flow_category})-1))
              else ${flow_category} end;;
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
    sql: CASE WHEN ${TABLE}.Destination_Category = 'HUB' or ${TABLE}.Destination_Category = 'Hub' then 'Hub'
              When ${TABLE}.Destination_Category = 'FIeld' then 'Field' else ${TABLE}.Destination_Category end ;;
  }

  dimension: flow_category {
    type: string
    sql: replace(${TABLE}.Flow_Category,'>','') ;;
  }

  dimension: from_area {
    type: string
    map_layer_name: countries
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
