name: "stormychecker"

includes:
    - resource: true
      file: "/crawler-default.yaml"
      override: false

    - resource: false
      file: "/app/stormychecker/crawler-conf.yaml"
      override: true

spouts:
  - id: "spout"
    className: "at.ac.oeaw.acdh.stormychecker.spout.SQLSpout"
    parallelism: 1

bolts:
  - id: "partitioner"
    className: "at.ac.oeaw.acdh.stormychecker.bolt.URLPartitionerBolt"
    parallelism: 1
  - id: "fetcher"
    className: "at.ac.oeaw.acdh.stormychecker.bolt.FetcherBolt"
    parallelism: 10
  - id: "status"
    className: "at.ac.oeaw.acdh.stormychecker.bolt.StatusUpdaterBolt"
    parallelism: 1

streams:
  - from: "spout"
    to: "partitioner"
    grouping:
      type: SHUFFLE

  - from: "partitioner"
    to: "fetcher"
    grouping:
      type: FIELDS
      args: ["key"]

  - from: "fetcher"
    to: "status"
    grouping:
      type: FIELDS
      args: ["url"]
      streamId: "status"

  - from: "fetcher"
    to: "partitioner"
    grouping:
      type: SHUFFLE
      streamId: "redirect"


