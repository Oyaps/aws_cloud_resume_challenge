
resource "aws_dynamodb_table" "VisitorCount" {
  name           = "GuestCount"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "VisitID"


  attribute {
    name = "VisitID"
    type = "S"
  }


  tags = {
        Name = "${var.tag_name_pfx}-database"

    }
}


resource "aws_dynamodb_table_item" "number_of_visitors" {
  table_name = aws_dynamodb_table.VisitorCount.name
  hash_key   = aws_dynamodb_table.VisitorCount.hash_key

  item = <<ITEM
{
  "VisitID": {"S": "count"},
  "visitor_count": {"N": "1"}
 
}
ITEM
  lifecycle {
    ignore_changes = [
      item
    ]
  }


}
