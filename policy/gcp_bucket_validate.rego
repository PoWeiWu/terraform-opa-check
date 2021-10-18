package terraform.gcp.bucket

import data.terraform.util.resources
import data.terraform.util.tfplan_resources

allowed_bucket_location := ["ASIA"]
rs := resources("google_storage_bucket")

deny[msg] {
	
	bucket_location := rs[_].values.location
    
    not valid_bucket_location(bucket_location, allowed_bucket_location)

	msg := sprintf("%v has an invalid machine type : %v", [
		rs[_].address,
		rs[_].values.location,
	])
}

#force destroy deny
deny[msg] {
	
	force_destroy := rs[_].values.force_destroy
    
    force_destroy != false

	msg := sprintf("%v force destroy must be false", [
		rs[_].address,
	])
}

valid_bucket_location(location, values) {
    location == values[_]
}
