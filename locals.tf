locals {
  all_private_route_ids = concat(module.subnets["app"].route_ids,module.subnets["web"].route_ids,module.subnets["db"].route_ids)
}