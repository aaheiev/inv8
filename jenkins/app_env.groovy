#!/usr/bin/env groovy

import groovy.json.*
import org.boon.Boon;

def appEnvFormJsonEditorJsonTemplate = """
{
  "disable_array_add"             : false,
  "disable_array_delete"          : false,
  "disable_array_repropertyOrder" : true,
  "disable_collapse"              : true,
  "disable_edit_json"             : true,
  "disable_properties"            : true,
  "theme"                         : "bootstrap3",
  "iconlib"                       : "fontawesome4",
  "no_additional_properties"      : true,
  "schema"                        : {
    "title"                       : "Target Environment",
    "type"                        : "object",
    "format"                      : "grid",
    "properties"                  : {
      "app_env"                   : {
        "propertyOrder"           : 1,
        "type"                    : "string",
        "format"                  : "select",
        "uniqueItems"             : true,
        "enum"                    : ["dev", "qa", "stg"
        ],
        "default"                 : "dev"
      }
    }
  }
}

"""
def appEnvFormJsonEditorOptions = new JsonSlurper().parseText(appEnvFormJsonEditorJsonTemplate)

//println new JsonBuilder( jsonEditorOptions ).toPrettyString()
return appEnvFormJsonEditorOptions
