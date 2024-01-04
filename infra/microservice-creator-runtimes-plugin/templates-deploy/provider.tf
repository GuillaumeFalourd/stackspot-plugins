provider "aws" {
  region = "{{ inputs.region }}"

  default_tags {
    tags = {
      Tribe = "Customer-Success"
    }
  }

}