#1
SELECT
    FIRST_VALUE(cpu_number) OVER (
    PARTITION BY cpu_number
    ORDER BY
      total_mem DESC
  ),
    id,
    total_mem
FROM
    host_info;


//2
SELECT
  host_id,
  hostname,
 date_trunc('hour', host_usage.timestamp) + date_part('minute', host_usage.timestamp):: int / 5 * interval '5 min',
  ROUND(AVG(((total_mem/1000) - memory_free) * 100 / (total_mem/1000)))
FROM
  host_usage, host_info
WHERE
    host_usage.host_id=host_info.id
GROUP BY
  host_id,hostname,
  date_trunc('hour', host_usage.timestamp) + date_part('minute', host_usage.timestamp):: int / 5 * interval '5 min';

//3
SELECT
  host_id,
  date_trunc('hour', timestamp) + date_part('minute', timestamp):: int / 5 * interval '5 min',
  COUNT(timestamp) AS num_data_points
FROM
  host_usage
GROUP BY
  host_id,
  date_trunc('hour', timestamp) + date_part('minute', timestamp):: int / 5 * interval '5 min'
HAVING
  COUNT(timestamp) < 3;