resource "aws_kinesis_analytics_application" "ticker_analytics" {
  name = "ticker_analytics"
  tags = var.tags


  inputs {
    name_prefix = "SOURCE_SQL_STREAM"

    kinesis_firehose {
      resource_arn = aws_kinesis_firehose_delivery_stream.ticker_demo.arn
      role_arn     = aws_iam_role.kinesis_analytics_role.arn
    }

    parallelism {
      count = 1
    }

    schema {
      record_columns {
        mapping  = "$.ticker_symbol"
        name     = "ticker_symbol"
        sql_type = "VARCHAR(4)"
      }
      record_columns {
        mapping  = "$.sector"
        name     = "sector"
        sql_type = "VARCHAR(16)"
      }

      record_columns {
        mapping  = "$.change"
        name     = "change"
        sql_type = "REAL"
      }

      record_columns {
        mapping  = "$.price"
        name     = "price"
        sql_type = "REAL"
      }

      record_encoding = "UTF-8"

      record_format {
        mapping_parameters {
          json {
            record_row_path = "$"
          }
        }
      }
    }
  }

  code = <<EOF
CREATE OR REPLACE STREAM "DESTINATION_SQL_STREAM" ("ticker_symbol" VARCHAR(4), ticker_symbol_count INTEGER);

CREATE OR REPLACE PUMP "STREAM_PUMP" AS INSERT INTO "DESTINATION_SQL_STREAM"
SELECT STREAM "ticker_symbol", COUNT(*) OVER TEN_SECOND_SLIDING_WINDOW AS ticker_symbol_count
FROM "SOURCE_SQL_STREAM_001"
WINDOW TEN_SECOND_SLIDING_WINDOW AS (
  PARTITION BY "ticker_symbol"
  RANGE INTERVAL '10' SECOND PRECEDING);
EOF

  outputs {
    name = "DESTINATION_SQL_STREAM"

    kinesis_firehose {
      resource_arn = aws_kinesis_firehose_delivery_stream.ticker_analytics_demo.arn
      role_arn     = aws_iam_role.kinesis_analytics_role.arn
    }

    schema {
      record_format_type = "JSON"
    }
  }
}

resource "aws_kinesis_firehose_delivery_stream" "ticker_analytics_demo" {
  name        = "ticker_analytics_demo"
  destination = "extended_s3"
  tags        = var.tags

  extended_s3_configuration {
    role_arn            = aws_iam_role.firehose_role.arn
    bucket_arn          = var.bucket_arn
    prefix              = "ticker_analytics_demo/"
    error_output_prefix = "ticker_analytics_demo_error/"
    buffer_size         = 1
    buffer_interval     = 60

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.kinesis_logs.name
      log_stream_name = aws_cloudwatch_log_stream.kinesis_logs.name
    }
  }
}
