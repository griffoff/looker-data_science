connection: "snowflake_prod"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project
include: "/core/common.lkml"
include: "/cube/dims.model.lkml"
#include: "/cube/source.model.lkml"
#include: "/cube/ga_data_parsed.view.lkml"
include: "/cube/dim_*.view.lkml"

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

# explore: ga_data_parsed2 {
#   extends: [ga_data_parsed]
#   from: ga_data_parsed
#   view_label: "Google Analytics Data"
#
# }

explore: ga_data_parsed {
  label: "Google Analytics Data"
  extends: [dim_course]
  join: user_facts {
    relationship: many_to_one
    sql_on: ${ga_data_parsed.userssoguid} = ${user_facts.guid} ;;
  }
  join: dim_course {
    relationship: many_to_one
    sql_on: ${ga_data_parsed.coursekey} = ${dim_course.coursekey} ;;
  }
  join: dim_relative_to_start_date {
    relationship: many_to_one
    sql_on: datediff(days, ${olr_courses.begin_date_date}, ${ga_data_parsed.hit_date}) = ${dim_relative_to_start_date.days} ;;
  }
}


explore: flat_studentinteractions_4m_ga
{
  label: "Flat Student Interactions"
  extends: [dim_course]
  join: dim_course {   # we need the dim_start_date join from the dim_course explore
    relationship: many_to_one
    sql_on: ${flat_studentinteractions_4m_ga.coursekey} = ${dim_course.coursekey} ;;
  }

}
