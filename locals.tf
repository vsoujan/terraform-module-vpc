locals {
  #subnet
  public_subnet_id = [for k, v in lookup(lookup(module.subnets, "public" null), "subnet_ids", null) : v.id]
  app_subnet_id = [for k, v in lookup(lookup(module.subnets, "app" null), "subnet_ids", null) : v.id]
  db_subnet_id = [for k, v in lookup(lookup(module.subnets, "db" null), "subnet_ids", null) : v.id]
  private_subnet_id= concat(local.app_subnet_id, local.db_subnet_id)

  #route_table
  public_routetable_id= [for k, v in lookup(lookup(module.subnets, "public" null), "route_table_ids", null) : v.id ]
  app_routetable_id= [for k, v in lookup(lookup(module.subnets, "app" null), "route_table_ids", null) : v.id ]
  db_routetable_id= [for k, v in lookup(lookup(module.subnets, "db" null), "route_table_ids", null) : v.id ]
  private_routetable_id= concat(local.app_routetable_id, local.db_routetable_id)


}