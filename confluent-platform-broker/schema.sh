 curl -k --location --request POST 'https://schema-registry-1:8081/subjects/order/versions' --header 'Accept: application/vnd.schemaregistry.v1+json, application/vnd.schemaregistry+json, application/json' --header 'Content-Type: application/json' --data-raw '{
  "schema":
    "{\"name\": \"Order\", \"type\": \"record\", \"fields\": [{\"name\": \"id\", \"type\": \"long\"}, {\"name\": \"customer_id\", \"type\": \"long\"}, {\"name\": \"items\", \"type\": {\"type\": \"array\", \"items\": {\"name\": \"item\", \"type\": \"record\", \"fields\": [{\"name\": \"product_name\", \"type\": \"string\"}, {\"name\": \"product_quantity\", \"type\": \"int\"}, {\"name\": \"product_price\", \"type\": \"float\"}]}}}, {\"name\": \"total\", \"type\": \"double\"}, {\"name\": \"currency\", \"type\": \"string\"}, {\"name\": \"create_date\", \"type\": \"long\"}, {\"name\": \"shipping_address\", \"type\": \"string\"}, {\"name\": \"shipping_city\", \"type\": \"string\"}, {\"name\": \"shipping_state\", \"type\": \"string\"}, {\"name\": \"shipping_zip\", \"type\": \"string\"}]}",
  "schemaType": "AVRO"
}'


curl -k -X GET https:/schema-registry-1:8081/subjects/order/versions/latest