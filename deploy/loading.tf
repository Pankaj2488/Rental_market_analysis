
# # ####------------------------GLUE DATA-CATALOG & CRAWLER-------------------------------------------####

# defining database
# resource "aws_glue_catalog_database" "RentalMarket" {
#     name = "rental_market_database"
# }

resource "aws_glue_classifier" "csv_classifier" {
  name          = "CustomCSVClassifier-${random_id.random_id_generator.hex}"
  
  
  csv_classifier {

    allow_single_column    = false
    contains_header        = "UNKNOWN"  # Automatic detection of headers
    delimiter              = ","
    disable_value_trimming = false
    quote_symbol           = "'"
    
  
  }
}


resource "aws_glue_crawler" "rental_market_analysis" {
    name = "RMA_crawler-${random_id.random_id_generator.hex}"
    role = "arn:aws:iam::436625658564:role/LabRole"                 # change
    database_name = "rental_market_database"

    s3_target {
      path = "s3://airbnbclean/cleandata2/"        # change
    }
    tags = {
        product_type = "rental_market_analysis"
    }
    classifiers = [aws_glue_classifier.csv_classifier.name]
    
}

####-------------------------------- Athena ------------------------------------------####
resource "aws_athena_workgroup" "rental_market_analysis_workgroup" {
  name = "RMA-workgroup-${random_id.random_id_generator.hex}"
  force_destroy = true

configuration {
    result_configuration {
        output_location = "s3://airbnbclean/queryresults/"     # change
    }
  }
}
