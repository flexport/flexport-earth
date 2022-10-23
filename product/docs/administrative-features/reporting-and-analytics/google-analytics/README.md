# How to use Google Analytics

Earth has integrated Google Analytics to allow Flexport to understand its user traffic. This doc walks through how to access and use it.

## How to access

The Flexport Earth Production Environment Google Analytics account can be accessed [here](https://analytics.google.com/analytics/web/#/p338490015).

If you do not have access, you will need to request it by contacting the Earth Engineering team.

## How to give access

If you are an Administrator for an Earth Google Analytics account and need to allow a new user to access, [follow these steps](https://support.google.com/analytics/answer/1009702).

## How to find / configure GA Tracking ID for a DevOps / Pipeline managed environment

The Google Analytics measurement tracking IDs are configured on a per environment basis.

The IDs are stored in the `GoogleAnalyticsMeasurementId` variable in the [Azure DevOps variables](https://dev.azure.com/flexport-earth/Earth/_library?itemType=VariableGroups) and injected into the website services at deploy-time.

## How to provision a new Google Analytics account for a new Earth environment

1. Create a new [Google Tag Manager account](https://tagmanager.google.com/)
2. Create a new [Google Analytics account](https://analytics.google.com/)
3. [Configure the Google Analytics Measurement ID in Google Tag Manager](https://support.google.com/tagmanager/answer/9442095)
4. Configure the Google Analytics Measurement ID in the new Earth Environment
- For DevOps / Pipeline managed environments, continue [here](#how-to-find-/-configure-ga-tracking-id-for-a-devops-/-pipeline-managed-environment).
- For developer personal environments, continue [here](/dev/docs/GettingStarted.md#google-analytics).