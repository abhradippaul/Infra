Terraform Notes

Terraform State Locking
Terraform tfstate
Terraform Remote Backend
Terraform Variable -> Input, Output, Local
Terraform Variable Precedence -> least to most
Environment Variable -> terraform.tfvars -> terraform.tfvars.json -> \*.auto.tfvars / \*.auto.tfvars.json -> -var / -var-file

Variable Type Constraints -> STRING, NUMBER, BOOL, LIST, SET, MAP, OBJECT, TUPLE
List is one type of array only support one type of datatype and support duplicate value also.
Tuple is one type of array but can contains any datatype in a tuple.
Set is one type of array but does not support duplicate value.

Meta Arguments -> depends.on, count, for_each, provider, lifecycle
for_each will not work with list because it has duplicate value.

Lifecycle -> Create before destory, Prevent destroy, Ignore changes, Replace triggered by, Custom condition
Terraform dynamic expression

Terraform Function -> max, min, trim, chomp, reverse, lower, replace, merge, substr
