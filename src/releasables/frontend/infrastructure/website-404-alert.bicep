param alertRuleName         string
param webAppResourceId      string
param actionGroupResourceId string

resource website_404_alert 'microsoft.insights/metricalerts@2018-03-01' = {
  name:     alertRuleName
  location: 'global'
  properties: {
    severity:             2
    enabled:              true
    scopes:               [
                            webAppResourceId
                          ]
    evaluationFrequency:  'PT1M'
    windowSize:           'PT5M'
    criteria:             {
                            allOf: [
                              {
                                threshold:        0
                                name:             'HTTP 404'
                                metricNamespace:  'Microsoft.Web/sites'
                                metricName:       'Http404'
                                operator:         'GreaterThan'
                                timeAggregation:  'Total'
                                criterionType:    'StaticThresholdCriterion'
                              }
                            ]
                            'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
                          }
    autoMitigate:         true
    targetResourceType:   'Microsoft.Web/sites'
    actions:              [
                            {
                              actionGroupId:      actionGroupResourceId
                              webHookProperties:  {}
                            }
                          ]
  }
}
