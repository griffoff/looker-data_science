view: page_reads {
  derived_table: {
    sql:
      select
        ga_data_parsed_id
        ,coursekey
        ,userssoguid
        ,activityuri
        ,coretextisbn
        ,datalayer_json
        ,nullif(ri_events_from_ga.DATALAYER_JSON:readingPageCount::string,'') as pages_in_book
        ,nullif(ri_events_from_ga.DATALAYER_JSON:readingPageView::string, '')::int+1 as page_no
        ,hit_time
        ,timestampdiff(second, hit_time, lead(hit_time) over (order by hit_time)) as duration_to_next_page_secs
      from DEV.RAW_GA.ga_data_parsed ri_events_from_ga
      where eventCategory = 'READING'
      and eventAction = 'VIEW'
      and coretextisbn is not null
      ;;

      datagroup_trigger: ga_events_datagroup
  }

  dimension: ga_data_parsed_id {primary_key:yes hidden:yes}
  dimension: coursekey {}
  dimension: userssoguid {}
  dimension: activityuri {}
  dimension: coretextisbn {}
  dimension: datalayer_json {}
  dimension: pages_in_book {type:number}
  dimension: page_no {type:number}
  dimension_group: hit_time {
    group_label: "Page Read Time"
    label: "Page Read"
    type: time
    timeframes: [raw,time,minute,hour,hour_of_day, date,month,year]
  }

  dimension: duration_to_next_page_secs  {
    label: "Time to next page"
    type:number
    sql: duration_to_next_page_secs::float / 60 / 60 / 24 ;;
    value_format_name: duration_hms
  }

  measure: pages_with_events {
    type: number
    sql: count(distinct ${page_no}) over (partition by ${coretextisbn}, ${pages_in_book})  ;;
  }

  measure: versions {
    type: number
    sql: count(distinct ${pages_in_book}) over (partition by ${coretextisbn}) ;;
  }

  measure: earliest_read {
    type: min
    sql: ${hit_time_raw} ;;
  }

  measure: latest_read {
    type: max
    sql: ${hit_time_raw} ;;
  }

  measure: avg_read_time {
    type: average
    sql: ${duration_to_next_page_secs} ;;
  }

  measure: max_read_time {
    type: max
    sql: ${duration_to_next_page_secs} ;;
  }

  measure: stdev_read_time {
    type: number
    sql: stddev(${duration_to_next_page_secs}) ;;
  }

  measure: median_read_time  {
    type: number
    sql:  median(${duration_to_next_page_secs}) ;;
  }

  measure: times_read  {
    type: count
  }

  measure: users_read {
    type: count_distinct
    sql: ${userssoguid}  ;;
  }

  measure:reads_per_user {
    type: number
    sql: ${times_read} / nullif(${users_read}, 0)  ;;
  }

  measure: page_read_popularity  {
    type: number
    sql: dense_rank() over (partition by ${coretextisbn}, ${pages_in_book} order by ${times_read} desc) ;;
  }

  measure: page_re_read_popularity  {
    type: number
    sql: dense_rank() over (partition by ${coretextisbn}, ${pages_in_book} order by ${reads_per_user} desc)  ;;
  }

  measure: page_duration_rank {
    type: number
    sql: dense_rank() over (partition by ${coretextisbn}, ${pages_in_book} order by ${median_read_time} desc, ${avg_read_time} desc) ;;
  }

}
