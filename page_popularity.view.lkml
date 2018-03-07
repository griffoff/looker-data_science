# If necessary, uncomment the line below to include explore_source.

# include: "data_mining.model.lkml"

view: page_popularity {
  derived_table: {
    explore_source: page_reads {
      column: coretextisbn {}
      column: pages_in_book {}
      column: page_no {}
      column: avg_read_time {}
      column: earliest_read {}
      column: latest_read {}
      column: max_read_time {}
      column: median_read_time {}
      column: page_duration_rank {}
      column: page_re_read_popularity {}
      column: page_read_popularity {}
      column: pages_with_events {}
      column: reads_per_user {}
      column: stdev_read_time {}
      column: times_read {}
      column: users_read {}
      column: versions {}
    }
  }
  dimension: coretextisbn {}
  dimension: pages_in_book {
    type: number
  }
  dimension: page_no {
    type: number
  }
  dimension: avg_read_time {
    type: number
  }
  dimension: earliest_read {
    type: number
  }
  dimension: latest_read {
    type: number
  }
  dimension: max_read_time {
    type: number
  }
  dimension: median_read_time {
    type: number
  }
  dimension: page_duration_rank {
    type: number
  }
  dimension: page_re_read_popularity {
    type: number
  }
  dimension: page_read_popularity {
    type: number
  }
  dimension: pages_with_events {
    type: number
  }
  dimension: reads_per_user {
    type: number
  }
  dimension: stdev_read_time {
    type: number
  }
  dimension: times_read {
    type: number
  }
  dimension: users_read {
    type: number
  }
  dimension: versions {
    type: number
  }
}
