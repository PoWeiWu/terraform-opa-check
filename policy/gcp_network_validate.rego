package terraform.gcp.network

import data.terraform.util.resources
import data.terraform.util.tfplan_resources

allowed_region := ["asia-east1"]

rs := resources("google_compute_subnetwork")

# validate subnet located region.
deny[msg] {
	
    region := rs[_].values.region
	not valid_region(region, allowed_region)

	msg := sprintf("%v has an invalid region : %v", [
		rs[_].address,
		rs[_].values.region,
	])
}

# validate vpc flow log enable
deny[msg] {
	
    rs[_].values.log_config == []

	msg := sprintf("%v not enable vpc flow log", [
		rs[_].address,
	])
}

# validate enable private google access
deny[msg] {
	
    rs[_].values.private_ip_google_access != true

	msg := sprintf("%v not enable private google access", [
		rs[_].address,
	])
}

valid_region(region, values) {
    region == values[_]
}