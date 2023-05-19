resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "pageNumber" = {
                "default" = "1",
                "type" = "integer"
            }
        },
        "type" = "object"
    })
    contract_output = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "locationIds" = {
                "items" = {
                    "type" = "string"
                },
                "type" = "array"
            },
            "locationNames" = {
                "items" = {
                    "type" = "string"
                },
                "type" = "array"
            }
        },
        "type" = "object"
    })
    
    config_request {
        request_template     = "$${input.rawRequest}"
        request_type         = "GET"
        request_url_template = "/api/v2/locations?pageSize=100&pageNumber=$${input.pageNumber}"
    }

    config_response {
        success_template = "{ \"locationIds\": $${ids}, \"locationNames\": $${names} }"
        translation_map = { 
			ids = "$.entities..id"
			names = "$.entities..name"
		}
        translation_map_defaults = {       
			ids = "[]"
			names = "[]"
		}
    }
}