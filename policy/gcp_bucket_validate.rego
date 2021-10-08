package terraform.gcp.bucket

import data.terraform.util.resources
import data.terraform.util.tfplan_resources

allowed_bucket_location := ["ASIA"]

deny[msg] {
	
	rs := resources("google_storage_bucket")
	bucket_location := rs[_].values.location
    
    # valid_machine_type(machine_type, allowed_machine_type)
    # result := valid_machine_type(machine_type, allowed_machine_type)
    # trace(sprintf("RESULT!!!! %v", [result]))

    not valid_bucket_location(bucket_location, allowed_bucket_location)

	msg := sprintf("%v has an invalid machine type : %v", [
		rs[_].address,
		rs[_].values.location,
	])
}

valid_bucket_location(location, values) {
    location == values[_]
}
