provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.bucket_name}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

## =============================================================================
##  <3장> 상태 파일 공유하기
##  Note: S3 버킷이 생성된 후에 아래 코드 주석을 해제 하고 terraform init을 수행
##        백엔드는 채움 참조 구문을 지원하지 않기 때문에 직접 입력
##        dynamodb_table 값은 아래 "상태 파일 잠금" 수행 후 주석 해제 및 init 수행
##        terraform.backend: configuration cannot contain interpolations
##        참조 - https://www.terraform.io/docs/backends/config.html
## =============================================================================

#terraform {
#  backend "s3" {
#    bucket = "(생성한 버킷 이름)"
#    key    = "terraform.tfstate"
#    region = "ap-northeast-1"
#    encrypt = true
##   dynamodb_table = "(아래에서 생성한 테이블 이름)"
#  }
#}

## =============================================================================
##  <3장> 상태 파일 잠금
##  Note: 잠금 설정을 위한 DynamoDB 리소스 생성
##        위의 상태 파일 공유를 위한 S3 리소스가 생성된 이후에 아래 코드 주석 해제
##        하고 apply 명령어 수행
##        참조 - https://www.terraform.io/docs/backends/types/index.html)
## =============================================================================

#resource "aws_dynamodb_table" "terraform_lock" {
##   var.tf 파일에 dynamodb_name에 대한 주석 해제  
#    name = "${var.dynamodb_name}"
#    hash_key = "LockID"
#    read_capacity  = 1
#    write_capacity = 1

#    attribute {
#      name = "LockID"
#      type = "S"
#    }
#}