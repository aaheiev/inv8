#!/usr/bin/env groovy

import groovy.json.*

//def apiUrl = "http://192.168.117.113:8888/models_form/edd/ind".toURL()
//def apiUrl = "https://ptn-inv8.fdr.pitneycloud.com/models_form/edd/ind".toURL()
//def jsonEditorOptions = new JsonSlurper().parse(apiUrl)

def inputFile = new File("/devops/example_view.json")

def jsonEditorOptions = new JsonSlurper().parseText(inputFile.text)

//println new JsonBuilder( jsonEditorOptions ).toPrettyString()
return jsonEditorOptions
